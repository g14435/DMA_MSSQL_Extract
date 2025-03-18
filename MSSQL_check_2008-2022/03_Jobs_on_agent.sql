--Query section list all the jobs scheduled on agent.
--Version 1.0
SELECT job_id, name, enabled, description, date_created, date_modified
FROM msdb.dbo.sysjobs
ORDER BY name