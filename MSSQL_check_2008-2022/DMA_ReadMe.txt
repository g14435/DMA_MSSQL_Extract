https://learn.microsoft.com/en-us/sql/dma/dma-commandline?view=sql-server-ver16

c:\Program Files\Microsoft Data Migration Assistant>dmacmd.exe /help
dmacmd.exe Information: 0 : The workflow host has started with assembly 'WorkflowHostProgram' and version '5.8.5973.1'
dmacmd.exe Information: 0 : Activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' has started. Category Name: 'RunWorkflow'
dmacmd.exe Information: 0 : Running Action: Sequence
dmacmd.exe Information: 0 : Running Action: BOOTSTRAP_CMD
dmacmd.exe Information: 0 : Activity 'd539f897-a26d-405e-8b08-157521801437' has started. Category Name: 'RunWorkflow'
dmacmd.exe Information: 0 : Running Action: Sequence
dmacmd.exe Information: 0 : Running Action: DisplayHelpTextAction
dmacmd.exe Information: 0 : ---------------------------------------------------------------------------------------------------------------------------------

For assessment of a particular target database type:
    DmaCmd.exe /AssessmentName="string" /AssessmentDatabases="connectionString1" ["connectionString2"] [/AssessmentTargetPlatform="TargetPlatform"] /AssessmentEvaluateCompatibilityIssues) (/AssessmentResultDma="file"|/AssessmentResultJson="file"|/AssessmentResultCsv="file") [/AssessmentOverwriteResult]

To get a recommendation for target SKU, standalone:
    DmaCmd.exe /Action=SkuRecommendation /SkuRecommendationInputDataFilePath=file (/SkuRecommendationTsvOutputResultsFilePath=file | /SkuRecommendationJsonOutputResultsFilePath=file | /SkuRecommendationOutputResultsFilePath=file) (/SkuRecommendationPreventPriceRefresh=true | /SkuRecommendationOfferName=offer /SkuRecommendationRegionName=region /SkuRecommendationSubscriptionId=subscriptionid /AzureAuthenticationTenantId=id /AzureAuthenticationClientId=id (/AzureAuthenticationInteractiveAuthentication=true | /AzureAuthenticationCertificateStoreLocation=location /AzureAuthenticationCertificateThumbprint=thumbprint | /AzureAuthenticationToken=token) ) [/SkuRecommendationServerName=name] [/SkuRecommendationTelemetryOptOut] [/SkuRecommendationCurrencyCode] [/SkuRecommendationHasSqlServerLicense]

For target readiness assessment of a server using configuration file:
    DmaCmd.exe  /Action=AssessTargetReadiness /TargetReadinessConfiguration="file"

For target readiness assessment of a server using configuration parameters:
    DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="string" /SourceConnections="connectionString 1" ["connectionString2"]  .. ["connectionStringN]" /AssessmentResultJson="file" [/AssessmentOverwriteResult] [/FeatureDiscoveryReportJson="file"]
/?                                               Get help
/help                                            Get help

/AssessmentName                                  Name of the assessment
/AssessmentDatabases                             Space delimited connection strings. Add 'AdHocQueryFolderPath' (optional) to the connection string to assess ad hoc queries. AdHocQueryFolderPath should be the path containing XEvent files.
/AssessmentSourcePlatform                        Source platform for the assessment:
   Supported values for Assessment: SqlOnPrem, RdsSqlServer (default)
   Supported values for Target Readiness Assessment: SqlOnPrem, RdsSqlServer (default), Cassandra (private preview)
/AssessmentTargetPlatform                        Target platform for the assessment:
   Supported values for Assessment: AzureSqlDatabase, ManagedSqlServer, SqlServer2012, SqlServer2014, SqlServer2016, SqlServerLinux2017, SqlServerWindows2017, SqlServerLinux2019 and SqlServerWindows2019 (default)
   Supported values for Target Readiness Assessment: ManagedSqlServer (default), CosmosDB (private preview)
/AssessmentEvaluateCompatibilityIssues           Run compatibility rules
/AssessmentEvaluateFeatureParity                 Run feature parity rules
/AssessmentOverwriteResult                       Overwrite the result file
/AssessmentResultDma                             Full path to the DMA assessment file
/AssessmentResultJson                            Full path to the JSON result file
/AssessmentResultCsv                             Full path to the CSV result file
/DmaFile                                         Full path to the DMA assessment file
/SourceConnections                               Space delimited list of connection strings. Database name (Initial Catalog) is optional. If no database name is provided, then all databases on the source are assessed.(Required)
/FeatureDiscoveryReportJson                      Path to the feature discovery JSON report. If this file is generated, then it can be used to run target readiness assessment again without connecting to source. (optional)
/ImportFeatureDiscoveryReportJson                Path to the feature discovery JSON report created earlier. Instead of source connections, this file will be used. (optional)
/TargetReadinessConfiguration                    XML file describing values for the name, source connections and result file.
/Action                                          Use SkuRecommendation to get SKU recommendations for SQL MI and SQL DB, use AssessTargetReadiness to perform target readiness assessment.
/SkuRecommendationInputDataFilePath              Path to the file produced by running the data collection script (SkuRecommendationDataCollectionScript.ps1 or SkuRecommendationDataCollectionScript-ScaleAssessment.ps1) [Required]
/SkuRecommendationInputAssessmentResultsFilePath If being performed with scale assessment, path to the json produced by scale assessment [Optional]
/SkuRecommendationTsvOutputResultsFilePath       Path to result for SQL MI and SQL DB predictions in .tsv format (this and/or /SkuRecommendationJsonOutputResultsFilePath and/or /SkuRecommendationOutputResultsFilePath is required)
/SkuRecommendationJsonOutputResultsFilePath      Path to result for SQL MI and SQL DB predictions in .json format (this and/or /SkuRecommendationTsvOutputResultsFilePath and/or /SkuRecommendationOutputResultsFilePath is required)
/SkuRecommendationOutputResultsFilePath          Path to the result for SQL MI and SQL DB predictions in .html format (this and/or /SkuRecommendationTsvOutputResultsFilePath and/or /SkuRecommendationJsonOutputResultsFilePath is required)
/SkuRecommendationServerName                     If scale assessment results contain information from multiple servers, the server from which the performance counters were collected. [Optional]
/SkuRecommendationTelemetryOptOut                Prevent telemetry from being sent [Optional]
/SkuRecommendationPreventPriceRefresh            If set to true, then the prices shown in the output will be a cached version of the prices collected as of February 28, 2019. [Optional]
/SkuRecommendationCurrencyCode                   The currency in which to display prices. This is only utilized if the SkuRecommendationPreventPriceRefresh parameter is set to false. Otherwise, US Dollars will be used. [Optional, default USD]
/SkuRecommendationOfferName                      The offer for which to retrieve prices. For example, "MS-AZR-0003P" corresponds to "Pay as you go." [Required if SkuRecommendationPreventPriceRefresh is not set]
/SkuRecommendationRegionName                     The region in which the databases will eventually be deployed. The prices in this region are used during recommendation. [Required if SkuRecommendationPreventPriceRefresh is not set]
/SkuRecommendationSubscriptionId                 The SubscriptionId hosting the AAD application used to authenticate with the billing API to retrieve prices. [Required if SkuRecommendationPreventPriceRefresh is not set]
/SkuRecommendationHasSqlServerLicense            If true, then the pricing will take into account that a SQL license is not needed. This will affect the pricing of some SKUs. [Optional, default value is false]
/SkuRecommendationDatabasesToRecommend           Specify which databases in the CSV to recommend for. Must be a string with comma-separated names and no spaces (e.g. "Database1,Database2,Database3"). [Optional, default is to recommend for all databases]
/AzureAuthenticationTenantId                     The TenantId hosting the AAD application used to authenticate with the billing API to retrieve prices. [Required if SkuRecommendationPreventPriceRefresh is not set]
/AzureAuthenticationClientId                     The ClientId of the AAD application used to authenticate with the billing API to retrieve prices. [Required if SkuRecommendationPreventPriceRefresh is not set]
/AzureAuthenticationInteractiveAuthentication    If set, then the interactive authentication window will be used for authentication. [Required if SkuRecommendationPreventPriceRefresh, AzureAuthenticationCertificateStoreLocation, AzureAuthenticationCertificateThumbprint, and AzureAuthenticationToken are not set]
/AzureAuthenticationCertificateStoreLocation     If using certificate based authentication, then the store location of the certificate for authentication. [Required if SkuRecommendationPreventPriceRefresh, AzureAuthenticationInteractiveAuthentication, and AzureAuthenticationToken are not set]
/AzureAuthenticationCertificateThumbprint        If using certificate based authentication, then the thumbprint of the certificate being used for authentication. [Required if SkuRecommendationPreventPriceRefresh, AzureAuthenticationInteractiveAuthentication, and AzureAuthenticationToken are not set]
/AzureAuthenticationToken                        If using token based authentication, the authentication token to use.  [Required if SkuRecommendationPreventPriceRefresh, AzureAuthenticationInteractiveAuthentication, AzureAuthenticationCertificateThumbprint, and AzureAuthenticationCertificateStoreLocation are not set]

Single-database assessment using Windows authentication and running compatibility rules:

DmaCmd.exe /AssessmentName="TestAssessment"  /AssessmentDatabases="Server=SQLServerInstanceName;Initial Catalog=DatabaseName;Integrated Security=true;AdHocQueryFolderPath=FolderPath" /AssessmentEvaluateCompatibilityIssues /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json" /AssessmentResultDma="C:\temp\Results\TestAssessment.dma"

Single-database assessment for target platform SQL Server 2012, outputting results in both CSV and JSON formats:

DmaCmd.exe /AssessmentName="TestAssessment"  /AssessmentDatabases="Server=SQLServerInstanceName;Initial Catalog=DatabaseName;Integrated Security=true"  /AssessmentTargetPlatform="SqlServer2012"  /AssessmentEvaluateCompatibilityIssues  /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json" /AssessmentResultCsv="C:\temp\Results\AssessmentReport.csv"

Multiple-database assessment:

DmaCmd.exe /AssessmentName="TestAssessment" /AssessmentDatabases="Server=SQLServerInstanceName1;Initial Catalog=DatabaseName1;Integrated Security=true;AdHocQueryFolderPath=FolderPath" "Server=SQLServerInstanceName1;Initial Catalog=DatabaseName2;Integrated Security=true" "Server=SQLServerInstanceName2;Initial Catalog=DatabaseName3;Integrated Security=true" /AssessmentTargetPlatform="SqlServer2016" /AssessmentEvaluateCompatibilityIssues /AssessmentOverwriteResult  /AssessmentResultCsv="C:\temp\Results\AssessmentReport.csv"  /AssessmentResultJson="C:\Results\test2016.json"

Single-database Target Readiness assessment using Windows authentication and running feature parity rules and code analysis rules:

DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="TestAssessment" /SourceConnections="Server=SQLServerInstanceName;Initial Catalog=DatabaseName;Integrated Security=true" /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json"

Single-database Target Readiness assessment using SQL Server authentication and running feature parity rules and code analysis rules:

DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="TestAssessment" /SourceConnections="Server=SQLServerInstanceName;Initial Catalog=DatabaseName;User Id=myUsername;Password=myPassword;" /AssessmentEvaluateFeatureParity /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json" /AssessmentSourcePlatform="SqlOnPrem" /AssessmentTargetPlatform="ManagedSqlServer"

Multiple-database Target Readiness assessment:

DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="TestAssessment" /SourceConnections="Server=SQLServerInstanceName1;Initial Catalog=DatabaseName1;Integrated Security=true" "Server=SQLServerInstanceName1;Initial Catalog=DatabaseName2;Integrated Security=true" "Server=SQLServerInstanceName2;Initial Catalog=DatabaseName3;Integrated Security=true" /AssessmentOverwriteResult  /AssessmentResultJson="C:\Results\test2016.json" /AssessmentSourcePlatform="SqlOnPrem" /AssessmentTargetPlatform="ManagedSqlServer"

Target Readiness assessment for all databases on a server using Windows authentication:

DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="TestAssessment" /SourceConnections="Server=SQLServerInstanceName;Integrated Security=true" /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json" /AssessmentSourcePlatform="SqlOnPrem" /AssessmentTargetPlatform="ManagedSqlServer"

Target Readiness assessment by importing feature collection report created earlier:

DmaCmd.exe /Action=AssessTargetReadiness /AssessmentName="TestAssessment" /ImportFeatureDiscoveryReportJson="c:\temp\feature_report.json" /AssessmentOverwriteResult /AssessmentResultJson="C:\temp\Results\AssessmentReport.json"


---------------------------------------------------------------------------------------------------------------------------------
dmacmd.exe Information: 0 : Completed Action: DisplayHelpTextAction
dmacmd.exe Information: 0 : Running Action: If
dmacmd.exe Information: 0 : Completed Action: If
dmacmd.exe Information: 0 : Completed Action: Sequence
dmacmd.exe Information: 0 : The step 'WorkflowCreated' in activity 'd539f897-a26d-405e-8b08-157521801437' had a final outcome of 'Success'
dmacmd.exe Information: 0 : Step named 'WorkflowCreated' for Activity 'd539f897-a26d-405e-8b08-157521801437' has completed
dmacmd.exe Information: 0 : The step 'ActionsRunning' in activity 'd539f897-a26d-405e-8b08-157521801437' had a final outcome of 'Success'
dmacmd.exe Information: 0 : Step named 'ActionsRunning' for Activity 'd539f897-a26d-405e-8b08-157521801437' has completed
dmacmd.exe Information: 0 : Activity 'd539f897-a26d-405e-8b08-157521801437' completed in '98.9898' milliseconds.
dmacmd.exe Information: 0 : Activity 'd539f897-a26d-405e-8b08-157521801437' completed with outcome 'Success'
dmacmd.exe Information: 0 : Completed Action: BOOTSTRAP_CMD
dmacmd.exe Information: 0 : Completed Action: Sequence
dmacmd.exe Information: 0 : The step 'WorkflowCreated' in activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' had a final outcome of 'Success'
dmacmd.exe Information: 0 : Step named 'WorkflowCreated' for Activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' has completed
dmacmd.exe Information: 0 : The step 'ActionsRunning' in activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' had a final outcome of 'Success'
dmacmd.exe Information: 0 : Step named 'ActionsRunning' for Activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' has completed
dmacmd.exe Information: 0 : Activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' completed in '146.4746' milliseconds.
dmacmd.exe Information: 0 : Activity 'd8b0c741-c97b-4d17-acc8-d3065542185c' completed with outcome 'Success'
dmacmd.exe Information: 0 : The workflow host has stopped with exit code 0 in assembly 'WorkflowHostProgram' and version '5.8.5973.1'

c:\Program Files\Microsoft Data Migration Assistant>^A