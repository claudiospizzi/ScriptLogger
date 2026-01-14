
BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Stop-ScriptLogger' {

    It 'should clean up the logger' {

        # Arrange
        Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -SkipStartStopMessage

        # Act
        Stop-ScriptLogger

        # Assert
        Get-ScriptLogger | Should -BeNullOrEmpty
    }
}
