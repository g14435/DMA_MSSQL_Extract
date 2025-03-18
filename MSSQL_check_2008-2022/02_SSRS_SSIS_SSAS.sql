--Query section identfy if SSRS, SSIS and SSAS is installed on the SQL server.
--This create a TMP SQL table
--Version 1.0
SET NOCOUNT ON
IF (OBJECT_ID ('tempdb..#RegResult')) IS NOT NULL
DROP TABLE #RegResult
CREATE TABLE #RegResult (ResultValue NVARCHAR(4))
IF (OBJECT_ID ('tempdb..#ServicesServiceStatus')) IS NOT NULL
DROP TABLE #ServicesServiceStatus
CREATE TABLE #ServicesServiceStatus(RowID INT IDENTITY(1,1),ServerName NVARCHAR(128),ServiceName NVARCHAR(128),ServiceStatus VARCHAR(128),StatusDateTime DATETIME DEFAULT (GETDATE()),PhysicalSrverName NVARCHAR(128))
IF (OBJECT_ID ('tempdb..#Services')) IS NOT NULL
DROP TABLE #Services
CREATE TABLE #Services(RowID INT IDENTITY(1,1),ServiceName NVARCHAR(128),DefaultInstance NVARCHAR(128),NamedInstance NVARCHAR(128))
INSERT INTO #Services VALUES ('MS SQL Server Service','MSSQLSERVER','MSSQL'),('SQL Server Agent Service','SQLSERVERAGENT','SQLAgent'),
('Analysis Services','MSSQLServerOLAPService','MSOLAP'),('Full Text Search Service','MSFTESQL','MSSQLFDLauncher'),
('Reporting Service','ReportServer','ReportServer'),('SQL Browser Service - Instance Independent','SQLBrowser','SQLBrowser')
,('SSIS','MsDtsServer110','MsDtsServer110') /* change 'MsDtsServer110' to 'MsDtsServer100' for SQL 2008 and accordingly*/
DECLARE @ChkInstanceName NVARCHAR(128) /*Stores SQL Instance Name*/,@ChkSrvName NVARCHAR(128) /*Stores Server Name*/
,@REGKEY NVARCHAR(128) /*Stores Registry Key information*/
,@i INT=1 ,@Service NVARCHAR(128)
SET @ChkSrvName = CAST(SERVERPROPERTY('INSTANCENAME') AS VARCHAR(128))
/* ---------------------------------- SQL Server Service Section ----------------------------------------------*/
WHILE (@i<=(SELECT MAX(RowID) FROM #Services))
BEGIN
IF (@ChkSrvName IS NULL OR (SELECT Count(*) FROM #Services WHERE ServiceName in ('SQL Browser Service - Instance Independent','SSIS')AND RowID=@i)>0)
SELECT @Service= DefaultInstance FROM #Services WHERE RowID=@i
ELSE
SELECT @Service= NamedInstance+'$'+CAST(SERVERPROPERTY('INSTANCENAME') AS VARCHAR(128)) FROM #Services WHERE RowID=@i
SET @REGKEY = 'System\CurrentControlSet\Services\'+@Service
INSERT #RegResult ( ResultValue ) EXEC MASTER.sys.xp_regread @rootkey='HKEY_LOCAL_MACHINE', @key= @REGKEY
--PRINT @REGKEY
IF (SELECT ResultValue FROM #RegResult) = 1
BEGIN
INSERT INTO #ServicesServiceStatus (ServiceStatus) /*Detecting staus of SQL Sever service*/
EXEC xp_servicecontrol N'QUERYSTATE',@Service
END
ELSE
BEGIN
INSERT INTO #ServicesServiceStatus (ServiceStatus) VALUES ('NOT INSTALLED')
END
UPDATE #ServicesServiceStatus SET ServiceName = (SELECT ServiceName FROM #Services WHERE RowID=@i),ServerName=@@SERVERNAME , PhysicalSrverName=(Select CAST(ServerProperty('ComputerNamePhysicalNetBIOS')AS VARCHAR(128))) WHERE RowID = @@identity
TRUNCATE TABLE #RegResult
SET @i=@i+1;
END
SELECT *FROM #ServicesServiceStatus