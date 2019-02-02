
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

Describe 'Stop-ScriptLogger' {

    It 'CleanUp' {

        Start-ScriptLogger -Path 'TestDrive:\test.log'

        Get-ScriptLogger | Should -Not -BeNullOrEmpty

        Stop-ScriptLogger

        Get-ScriptLogger | Should -BeNullOrEmpty
    }
}
