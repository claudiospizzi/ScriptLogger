
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

Describe 'Start-ScriptLogger' {

    $defaultEnabled  = $true
    $defaultPath     = "$PSScriptRoot\Start-ScriptLogger.Tests.ps1.log"
    $defaultFormat   = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}'
    $defaultLevel    = 'Verbose'
    $defaultEncoding = 'UTF8'
    $defaultLogFile  = $true
    $defaultEventLog = $true
    $defaultConsole  = $true

    It 'should return default values without any specification' {

        # Act
        $scriptLogger = Start-ScriptLogger -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter path' {

        # Arrange
        $expectedPath = 'TestDrive:\test.log'

        # Act
        $scriptLogger = Start-ScriptLogger -Path $expectedPath -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $expectedPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter format' {

        $expectedFormat = '{4} {3} {2} {1} {0}'

        # Act
        $scriptLogger = Start-ScriptLogger -Format $expectedFormat -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $expectedFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter log level' {

        $expectedLevel = 'Error'

        # Act
        $scriptLogger = Start-ScriptLogger -Level $expectedLevel -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $expectedLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter encoding' {

        $expectedEncoding = 'UTF8'

        # Act
        $scriptLogger = Start-ScriptLogger -Encoding $expectedEncoding -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $expectedEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no log file' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoLogFile -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $false
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no event log' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoEventLog -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $false
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should return a valid value for the parameter no console output' {

        # Act
        $scriptLogger = Start-ScriptLogger -NoConsoleOutput -PassThru

        # Assert
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $false
    }

    AfterEach {

        Get-ScriptLogger | Remove-Item -Force
        Stop-ScriptLogger
    }
}
