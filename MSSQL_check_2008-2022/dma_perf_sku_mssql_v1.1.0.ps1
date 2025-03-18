#   Vversion version 1.1.0 date 18032025/Michael Hesselberg/Aaahish Jain
#   PowerShell Script Documentation
#   Support MSSQL versions 2012, 2016, 2017 (to be tested 2008R2, 2014, 2019, 2022)
#   Changelog date/change/changed by
#   270225/Include DMA SKU recommendations for both MSQL shared instance and dedicated instance/Michael Hesselberg
#   STEP1, DMA Performance counter on MSSQL server Instance/Databases and Azure SKU 
#   STEP2, DMA Azure SKU recommendation for both MSSQL shared instance and dedicate imstance
#   STEP3, DMA report with target as AzureVM (IaaS)
#   STEP4, MSSQL server instance/database configuration information
#   STEP5, Collect all infromation in .zip file
#   When running the PerfDataCollectionSqlAssessment.exe
#   --numberOfIterations, default is 20, 2 is minimum
#   --perfQueryIntervalInSec, default 30
#Prerequisites
#   1. PowerShell: Ensure you have PowerShell installed on your machine.
#   2. ImportExcel Module: Install the ImportExcel module if you haven't already. You can install it using the following command:
#   Install-Module -Name ImportExcel -Scope CurrentUser
#   Install-Module sqlserver    
#   Install-Module -Name SqlServer -AllowClobber -Force
#   Install https://aka.ms/dotnet-core-applaunch?missing_runtime=true&arch=x64&rid=win10-x64&apphost_version=6.0.11
#  PowerShell ports TCP/5985 for HTTP, TCP/5986 for HTTPS
## STEP 1 DMA Performance counter on MSSQL server Instance/Databases and Azure SKU
# Define paths using environment variables
cls
$systemDrive = $env:SystemDrive
$programFiles = $env:ProgramFiles
# DMA Perf Counter settings Define Number Of Iterations, default=20
$numberOfIterations = 20
# DMA Perf Counter settings Number Of Query Interval In Sec Of Interactions, default=20
$numberOfQueryIntervalInSecOfIterations = 20
# Ask which SQL Server instance to use
# Prompt for the SQL server shared or dedicated SQL instance name
$serverInstance = Read-Host -Prompt "Enter MSSQL Server instance Name were to run DMA Performance Counter"
$database = "master"
# Define the path to the directory containing DMA Perfmon file
$dmaPerfmonPath = "$systemDrive\Program Files\Microsoft Data Migration Assistant\SqlAssessmentConsole"
# Define the path to the directory containing DMA Output files
$dmaOutputPath = "$systemDrive\MSSQL_check_2008-2022\$serverInstance" + "_DMA_MSSQL_Output\"
# Define the root path to the directory containing .zip files
$zipOutputPath = "$systemDrive\MSSQL_check_2008-2022\"
# Get all .zip files in the folder
$zipFiles = Get-ChildItem -Path $zipOutputPath -Filter *.zip

# Cleanup files & folders
# Check if the file exists
if (Test-Path $dmaOutputPath) {
    # Delete the file
    Remove-Item $dmaOutputPath -Recurse -Force
    Remove-Item -Path $zipFiles.FullName -Recurse -Force
    Write-Output "Files deleted successfully."
} else {
    Write-Output "No Files exist."
}
## STEP2, DMA Azure SKU recommendation for both MSSQL shared instance and dedicated imstance
# Get DMA MSSQL server instance Perf Counters and get proposed Azure SKU/Tiers and Storage sizes
# Display the menu
Write-Host ""
Write-Host "Select the MSSQL instance where to run DMA Performance Counter:" -ForegroundColor Green
Write-Host "1. Application MSSQL database(s) running on SHARED instance " -ForegroundColor Green
Write-Host "2. Application MSSQL database(s) running on DEDICATED instance" -ForegroundColor Green
Write-Host ""
# Get the user's choice
$choice = Read-Host -Prompt "Enter your choice (1 or 2)"
# Execute the appropriate command based on the user's choice
if ($choice -eq '1') {
    Write-Host "Running DMA Performance Counter on shared instance..." -ForegroundColor Green
    Write-Host "Iterations set to:" $numberOfIterations -ForegroundColor Green 
    Write-Host "Query Interval In Sec Of Interactions set to:" $numberOfQueryIntervalInSecOfIterations -ForegroundColor Green 
    Write-Host ""
    & $dmaPerfmonPath"\SqlAssessment.exe" PerfDataCollection --sqlConnectionStrings `
    "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=True;" `
    --outputFolder $dmaOutputPath --numberOfIterations $numberOfIterations --perfQueryIntervalInSec $numberOfQueryIntervalInSecOfIterations
    & $dmaPerfmonPath"\SqlAssessment.exe" GetSkuRecommendation --outputFolder $dmaOutputPath --targetPlatform AzureSqlDatabase AzureSqlVirtualMachine
} elseif ($choice -eq '2') {
    Write-Host "Running DMA Performance Counter on dedicated instance..." -ForegroundColor Green 
    Write-Host "Iterations set to:" $numberOfIterations -ForegroundColor Green 
    Write-Host "Query Interval In Sec Of Interactions set to:" $numberOfQueryIntervalInSecOfIterations -ForegroundColor Green 
    Write-Host ""
    # Replace with the actual command for the dedicated instance
    & $dmaPerfmonPath"\SqlAssessment.exe" PerfDataCollection --sqlConnectionStrings `
    "Data Source=$serverInstance;Initial Catalog=master;Integrated Security=True;" `
    --outputFolder $dmaOutputPath --numberOfIterations $numberOfIterations --perfQueryIntervalInSec $numberOfQueryIntervalInSecOfIterations
    & $dmaPerfmonPath"\SqlAssessment.exe" GetSkuRecommendation --outputFolder $dmaOutputPath --targetPlatform AzureSqlVirtualMachine
} else {
    Write-Host "Invalid choice. Please enter 1 or 2." -ForegroundColor Red
}
## STEP3, DMA report with target as AzureVM (IaaS)
# Define the path to the DMA executable
Write-Host "Create DMA report files for AzureVM(IaaS) migration proposal" -ForegroundColor Green 
$dmaPath = "$systemDrive\Program Files\Microsoft Data Migration Assistant\dmacmd.exe"
# Define the parameters for the assessment
$assessmentName1 = "DMA_Assessment1"
$assessmentName2 = "DMA_Assessment2"
$assessmentName3 = "DMA_Assessment3"
$sourcePlatform = "SqlOnPrem"

$targetPlatformSQLVM = "SqlServerWindows2022"
$targetPlatformSQLDB = "AzureSqlDatabase"
$targetPlatformSQLMI = "ManagedSqlServer"

$database1 = "Server=$serverInstance;Integrated Security=true;AdHocQueryFolderPath=FolderPath"
$database2 = "Server=$serverInstance;Integrated Security=true;AdHocQueryFolderPath=FolderPath"

$resultSQLVMJson = "$dmaOutputPath\DMA_AzureSQLVM_Assessment_Report.json"
$resultSQLDBJson = "$dmaOutputPath\DMA_AzureSQLDB_Assessment_Report.json"
$resultSQLMIJson = "$dmaOutputPath\DMA_AzureSQLMI_Assessment_Report.json"

#$resultSQLVMDma = "$dmaOutputPath\DMA_AzureSQLVM_Assessment_Report.dma"
#$resultSQLDBDma = "$dmaOutputPath\DMA_AzureSQLDB_Assessment_Report.dma"
#$resultSQLMIDma = "$dmaOutputPath\DMA_AzureSQLMI_Assessment_Report.dma"

$resultSQLVMCsv = "$dmaOutputPath\DMA_AzureSQLVM_Assessment_Report.csv"
$resultSQLDBCsv = "$dmaOutputPath\DMA_AzureSQLDB_Assessment_Report.csv"
$resultSQLMICsv = "$dmaOutputPath\DMA_AzureSQLMI_Assessment_Report.csv"

# Construct the command to create DMA output for Azure SQLVM as Target 
Write-Host "Construct the command to create DMA output for Azure SQLVM as Target" -ForegroundColor Green
$commandSQLVM = "& `"$dmaPath`" /AssessmentName=`"$assessmentName1`" /AssessmentSourcePlatform=`"$sourcePlatform`" /AssessmentTargetPlatform=`"$targetPlatformSQLVM`" /AssessmentDatabases=`"$database1`" /AssessmentDatabases=`"$database2`" /AssessmentEvaluateCompatibilityIssues /AssessmentOverwriteResult /AssessmentResultJson=`"$resultSQLVMJson`" /AssessmentResultDma=`"$resultSQLVMDma`" /AssessmentResultCsv=`"$resultSQLVMCsv`""
Write-Host $commandSQLVM -ForegroundColor Green
# Execute the command
Invoke-Expression $commandSQLVM

# Construct the command to create DMA output for Azure SQLDB as Target
Write-Host "Construct the command to create DMA output for Azure SQLDB as Target" -ForegroundColor Green
$commandSQLDB = "& `"$dmaPath`" /AssessmentName=`"$assessmentName2`" /AssessmentSourcePlatform=`"$sourcePlatform`" /AssessmentTargetPlatform=`"$targetPlatformSQLDB`" /AssessmentDatabases=`"$database1`" /AssessmentDatabases=`"$database2`" /AssessmentEvaluateCompatibilityIssues /AssessmentOverwriteResult /AssessmentResultJson=`"$resultSQLDBJson`" /AssessmentResultDma=`"$resultSQLDBDma`" /AssessmentResultCsv=`"$resultSQLDBCsv`""
Write-Host $commandSQLDB -ForegroundColor Green
# Execute the command
Invoke-Expression $commandSQLDB

# Construct the command to create DMA output for Azure SQLMI as Target
Write-Host  "Construct the command to create DMA output for Azure SQLMI as Target" -ForegroundColor Green
$commandSQLMI = "& `"$dmaPath`" /AssessmentName=`"$assessmentName3`" /AssessmentSourcePlatform=`"$sourcePlatform`" /AssessmentTargetPlatform=`"$targetPlatformSQLMI`" /AssessmentDatabases=`"$database1`" /AssessmentDatabases=`"$database2`" /AssessmentEvaluateCompatibilityIssues /AssessmentOverwriteResult /AssessmentResultJson=`"$resultSQLMIJson`" /AssessmentResultDma=`"$resultSQLMIDma`" /AssessmentResultCsv=`"$resultSQLMICsv`""
Write-Host $commandSQLM -ForegroundColor Green
# Execute the command
Invoke-Expression $commandSQLMI

## STEP4, MSSQL server instance/database configuration information
# Define the path to the directory containing .sql files
$sqlDirectoryPath = "$systemDrive\MSSQL_check_2008-2022\"
# Define the output file path
$outputFilePath = "$systemDrive\MSSQL_check_2008-2022\$serverInstance" + "_DMA_MSSQL_Output\" + $serverInstance + "_MSSQL" +"_OutputFile" + ".xlsx"
# Get all .sql files in the directory
$sqlFiles = Get-ChildItem -Path $sqlDirectoryPath -Filter *.sql
# Loop through each .sql file and run the query
foreach ($sqlFile in $sqlFiles) {
    # Read the SQL query from the .sql file
    $query = Get-Content -Path $sqlFile.FullName -Raw
    # Run the query using Invoke-Sqlcmd with TrustServerCertificate parameter
    $result = Invoke-Sqlcmd -ServerInstance $serverInstance -Database $database -Query $query -ConnectionTimeout 30 -TrustServerCertificate
    # Convert boolean values to integers
    $convertedResult = $result | ForEach-Object {
        $row = $_.PSObject.Copy()
        foreach ($property in $row.PSObject.Properties) {
            if ($property.IsSettable -and $property.Value -is [bool]) {
                $property.Value = [int]$property.Value
            }
        }
        $row
    }
    # Define the worksheet name
    $worksheetName = $sqlFile.BaseName
    # Check if the result contains data
    if ($convertedResult) {
        # Output the result to the .xlsx file
        $convertedResult | Export-Excel -Path $outputFilePath -WorksheetName $worksheetName
        Write-Host "Data successfully exported to $outputFilePath in worksheet $worksheetName" -ForegroundColor Green
    } else {
        # Create a DataTable with "No results" message
        $dataTable = New-Object System.Data.DataTable
        $dataTable.Columns.Add("Message", [string])
        $dataTable.Rows.Add("No results from SQL server")
        # Output the "No results" message to the .xlsx file
        $dataTable | Export-Excel -Path $outputFilePath -WorksheetName $worksheetName
        Write-Host "No data returned from the query in file $($sqlFile.Name). 'No results' message written to worksheet $worksheetName"        
    }
}
# STEP5, Collect all infromation in .zip file
# Define the source folder and destination zip file
$sourceFolder = "$systemDrive\MSSQL_check_2008-2022\$serverInstance" + "_DMA_MSSQL_Output\"
$destinationZip = "$systemDrive\MSSQL_check_2008-2022\" + $serverInstance + "_DMA_MSSQL_Output.zip"
# Load the necessary .NET assembly
Add-Type -AssemblyName System.IO.Compression.FileSystem
# Create DMA_SKU_MSSQL the zip file
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, $destinationZip)
Write-Host "MSSQL extract completed" -ForegroundColor Green
 