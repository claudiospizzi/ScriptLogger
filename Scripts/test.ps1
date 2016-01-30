
# Definition for test
$Module = 'ScriptLogger'
$Output = "C:\Projects\$Module\TestsResults.xml"
$Target = "C:\Program Files\WindowsPowerShell\Modules\$Module"

# Execute tests
$TestResults = Invoke-Pester -Path $Target -OutputFormat NUnitXml -OutputFile $Output -PassThru

# Upload test result
$WebClient = New-Object -TypeName 'System.Net.WebClient'
$WebClient.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $Output)

# Throw error if tests are failed
if ($TestResults.FailedCount -gt 0)
{
    throw "$($TestResults.FailedCount) tests failed." 
}
