# DMA_MSSQL_Extract
DMA MSSQL automated assessment report

This outlines the process for executing a MSSQL assessment report using PowerShell. The report includes DMA performance
counters, Azure SKU recommendations, and detailed configurations for SQL Server instances and databases. 
The DMA targets are automatically build reports that covers all 3 DMA target outputs, Azure SQLVM, Azure SQLDB, and 
Azure SQLMI.

Assessment Package (Version 1.1.0)
Upon completion of the assessment scripts, all data is stored in a zip file containing the following components:
•	DMA Perfcounter: Performance counters from MSSQL server instance using DMA.
•	Azure SKU Recommendations: Recommendations based on performance counters for MSSQL to generate 
Azure SKUs. There are two options for the engineer to choose.
•	1. Dedicated Application SQL Server Instance: SKU recommendation for dedicated SQL server
instances generated.
•	2. Application Databases on shared SQL Server Instance: SKU recommendation for each database
on the SQL server instance is generated.
•	Automated DMA Reports (.csv): Containing DMA reports with targets as SqlServer2022.
•	Azure SQLVM: Details on compatibility for Azure SQL Virtual Machines.
•	Azure DB: Details on compatibility for Azure Databases.
•	Azure MI: Details on compatibility for Azure Managed Instances.
•	MSSQL Server Instance/Databases Configuration Information (.xlsx): 
Excel files with configuration information, including server version, collations, SP, HA, cross-database dependencies,
SQL agent jobs, SSIS, SSRS, SSAS dependencies, SQL maintenance plans, SQL instance memory, storage sizes, 
and SQL DB mirroring information. Each SQL query results are generated into an Excel tap.

Automation and Efficiency
This process has now been automated, not only to streamline the extraction of DMA and MSSQL information, but also added
with DMA MSSQL performance counters and MSSQL Azure SKU recommendation, into a single script.
PowerShell Script Features
The PowerShell script supports remote execution, allowing it to be run from a Windows server Jump server without the need to
install DMA on the target MSSQL servers.

Command Line Options
The command line options are straightforward, simply add the MSSQL server instance name and choose whether the 
application databases are running on a dedicated or shared MSSQL server instance. 
   
Current DMA sample rates can be changed if required.

We want to optimize the way we get information from MSSQL servers with a click of a button.
