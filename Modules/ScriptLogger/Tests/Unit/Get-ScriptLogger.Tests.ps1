
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

Describe 'Get-ScriptLogger' {

    It 'should throw an exception if the script logger was not started before' {

        # Act & Assert
        { Get-ScriptLogger } | Should Throw
    }

    It 'should return a valid object after starting' {

        # Act
        Start-ScriptLogger -Path 'TestDrive:\log.txt'
        $scriptLogger = Get-ScriptLogger

        # Assert
        $scriptLogger | Should -Not -BeNullOrEmpty
    }
}
