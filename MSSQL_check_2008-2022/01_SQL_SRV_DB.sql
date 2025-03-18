--mihessel
DECLARE @versionCheck1 NVARCHAR(MAX)
DECLARE @versionCheck2 NVARCHAR(MAX)

SET @versionCheck1 = '
    --Using query to identify MSSQL Server versions 2008, 2012
    SELECT DISTINCT
        t1.name AS [Database_Name],
        @@VERSION AS [SQL_Version_Name],
        SERVERPROPERTY(''Edition'') AS [Edition_Name],
        @@SERVERNAME AS [SQL_Server_Name],
        SERVERPROPERTY(''is_Clustered'') AS [Is_Clustered_Name],
        t2.NodeName AS [NodeName],
        t3.backup_directory AS [Log_Shipping_Backup_Dir_Name],
        t3.backup_share AS [Log_Shipping_Share_Name],
        SERVERPROPERTY(''IsHadrEnabled'') AS [Is_AlwaysOn_availability_groups_Enabled_Name],
        t6.name AS [LinkedServer_Name],
        t6.product AS [Product_Name],
        t6.provider AS [Provider_Name],
        t6.data_source AS [DataSource_Name],
        t6.is_linked AS [IsLinkedServer_Name],
        SERVERPROPERTY(''IsIntegratedSecurityOnly'') AS [Mixed_Mode_Authentication_If_0],
        t1.recovery_model_desc AS [Recovery_Model_Name],
        t1.compatibility_level AS [compatibility_level_Name],
        t7.size * 8. / 1024 AS [Database_Size_MB],
        t1.state_desc AS [State_Description],
        t1.collation_name AS [Collation_Name],
        t1.recovery_model AS [Recovery_Model],
        t6.is_remote_login_enabled AS [Is_Remote_Login_Enabled]
    FROM sys.databases AS t1
    LEFT JOIN sys.dm_os_cluster_nodes AS t2 ON t1.name = t2.NodeName
    LEFT JOIN [msdb].dbo.log_shipping_primary_databases AS t3 ON t1.name = t3.primary_database
    LEFT JOIN sys.servers AS t6 ON @@SERVERNAME = t6.name
    LEFT JOIN sys.master_files AS t7 ON t1.database_id = t7.database_id
    WHERE LEN(t1.owner_sid) > 1;'

SET @versionCheck2 = '
    -- Using query to identify MSSQL Server versions 2014, 2016, 2017, 2019, 2022
    SELECT DISTINCT
        t1.name AS [Database_Name],
        t7.size * 8. / 1024 AS [Database_Size_MB],
        @@VERSION AS [SQL_Version_Name],
        SERVERPROPERTY(''Edition'') AS [Edition_Name],
        @@SERVERNAME AS [SQL_Server_Name],
        SERVERPROPERTY(''is_Clustered'') AS [Is_Clustered_Name],
        t2.NodeName AS [NodeName_Name],
        t3.backup_directory AS [Log_Shipping_Backup_Dir_Name],
        t3.backup_share AS [Log_Shipping_Share_Name],
        SERVERPROPERTY(''IsHadrEnabled'') AS [Is_AlwaysOn_availability_groups_Enabled],
        t6.name AS [LinkedServer_Name],
        t6.product AS [Product_Name],
        t6.provider AS [Provider_Name],
        t6.data_source AS [DataSource_Name],
        t6.is_linked AS [Is_Linked_Server],
        SERVERPROPERTY(''IsIntegratedSecurityOnly'') AS [Mixed_Mode_Authentication_If_0],
        t1.recovery_model_desc AS [Recovery_Model_Description],
        t1.compatibility_level AS [Compatibility_Level],
        t1.state_desc AS [State_Description],
        t1.collation_name AS [Collation_Name],
        t1.recovery_model AS [Recovery_Model],
        t2.status AS [Status_Name],
        t2.status_description AS [Status_Description_Name],
        t2.is_current_owner AS [Is_Current_Owner_Name],
        t4.name AS [Availability_Group_Name],
        t4.is_distributed AS [Is_Distributed_AG_Name],
        t5.replica_server_name AS [Replica_Server_Name],
        t5.availability_mode_desc AS [Availability_Mode_Description],
        t5.failover_mode_desc AS [Failover_Mode_Description],
        t5.secondary_role_allow_connections_desc AS [Secondary_Role_Connections_Description],
        t6.is_remote_login_enabled AS [Is_Remote_Login_Enabled]
    FROM sys.databases AS t1
    LEFT JOIN sys.dm_os_cluster_nodes AS t2 ON t1.name = t2.NodeName
    LEFT JOIN [msdb].dbo.log_shipping_primary_databases AS t3 ON t1.name = t3.primary_database
    LEFT JOIN sys.availability_groups AS t4 ON t1.name = t4.name
    LEFT JOIN sys.availability_replicas AS t5 ON t4.group_id = t5.group_id
    LEFT JOIN sys.servers AS t6 ON @@SERVERNAME = t6.name
    LEFT JOIN sys.master_files AS t7 ON t1.database_id = t7.database_id
    WHERE LEN(t1.owner_sid) > 1;'

DECLARE @version NVARCHAR(128);
SET @version = CONVERT(NVARCHAR(128), SERVERPROPERTY('productversion'));
PRINT 'SQL Server Version: ' + @version; 

IF @version LIKE '10.0%' OR @version LIKE '11.0%'
BEGIN
   PRINT @versionCheck1
   EXEC sp_executesql @versionCheck1
END
ELSE IF @version LIKE '12.0%' OR @version LIKE '13.0%' OR @version LIKE '14.0%' OR @version LIKE '15.0%' OR @version LIKE '16.0%'
BEGIN
   PRINT @versionCheck2
   EXEC sp_executesql @versionCheck2
END