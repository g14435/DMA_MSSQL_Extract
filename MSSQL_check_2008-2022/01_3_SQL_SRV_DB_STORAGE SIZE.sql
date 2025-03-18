 -- Database storage sizes .mdf, .ldf
 with fs
    as
    (
        select database_id, type, size * 8.0 / 1024 size, physical_name
        from sys.master_files
        where state_desc = 'ONLINE' -- ONLINE,RESTORING,RECOVERING,RECOVERY_PENDING,SUSPECT,,OFFLINE, DEFUNCT
    )
    select 
        name,
        (select sum(size) from fs where type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
        (select sum(size) from fs where type = 1 and fs.database_id = db.database_id) LogFileSizeMB,
        (select sum(size) from fs where fs.database_id = db.database_id) TotalFileSizeMB
    from sys.databases db
    --order by database_id
    order by TotalFileSizeMB desc