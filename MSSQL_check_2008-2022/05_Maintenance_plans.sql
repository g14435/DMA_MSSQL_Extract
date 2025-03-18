--Query section list all the maintenance plans.
--Version 1.0
USE msdb;
GO

SELECT 
    name AS MaintenancePlanName,
    description AS PlanDescription
   
FROM 
    sysmaintplan_plans
ORDER BY 
    name;


