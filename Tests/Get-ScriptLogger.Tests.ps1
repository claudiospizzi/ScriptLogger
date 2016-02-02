
# Load module
if ($Env:APPVEYOR -eq 'True')
{
    $Global:TestRoot = (Get-Module ScriptLogger -ListAvailable).ModuleBase

    Import-Module ScriptLogger -Force
}
else
{
    $Global:TestRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path).Path

    Import-Module "$Global:TestRoot\ScriptLogger.psd1" -Force
}

# Execute tests
Describe 'Get-ScriptLogger' {

    It 'NotStarted' {

        { Get-ScriptLogger } | Should Throw
    }

    It 'ValidObject' {

        Start-ScriptLogger -Path 'TestDrive:\log.txt'

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null
    }
}
