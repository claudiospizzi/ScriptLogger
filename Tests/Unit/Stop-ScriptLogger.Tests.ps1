
# Load module
if ($Env:APPVEYOR -eq 'True')
{
    $Global:TestRoot = (Get-Module ScriptLogger -ListAvailable | Select-Object -First 1).ModuleBase

    Import-Module ScriptLogger -Force
}
else
{
    $Global:TestRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path).Path

    Import-Module "$Global:TestRoot\ScriptLogger.psd1" -Force
}

# Execute tests
Describe 'Stop-ScriptLogger' {

    It 'CleanUp' {

        Start-ScriptLogger -Path 'TestDrive:\test.log'

        $Global:ScriptLogger | Should Not Be $null

        Stop-ScriptLogger

        $Global:ScriptLogger | Should Be $null
    }
}
