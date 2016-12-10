
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'Stop-ScriptLogger' {

    It 'CleanUp' {

        Start-ScriptLogger -Path 'TestDrive:\test.log'

        $Global:ScriptLogger | Should Not Be $null

        Stop-ScriptLogger

        $Global:ScriptLogger | Should Be $null
    }
}
