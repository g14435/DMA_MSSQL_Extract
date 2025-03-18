--Query section list all the SSIS package deployed on the SSISDB.
--Version 1.0
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SSISDB')
BEGIN
    PRINT 'I am from SSISDB';

    SELECT 
        folders.name AS FolderName,
        projects.name AS ProjectName,
        packages.name AS PackageName,
        packages.package_guid AS PackageGUID,
        projects.deployed_by_name AS DeployedBy,
        projects.last_deployed_time AS LastDeployedTime
    FROM 
        SSISDB.catalog.folders folders
    JOIN 
        SSISDB.catalog.projects projects ON folders.folder_id = projects.folder_id
    JOIN 
        SSISDB.catalog.packages packages ON projects.project_id = packages.project_id
    ORDER BY 
        FolderName, ProjectName, PackageName;
END
ELSE
BEGIN
    PRINT 'SSISDB database does not exist on this server.';
END