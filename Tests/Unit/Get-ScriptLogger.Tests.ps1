
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

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
