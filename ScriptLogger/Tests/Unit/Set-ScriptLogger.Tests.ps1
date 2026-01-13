[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Pester BeforeAll block')]
param ()

BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Set-ScriptLogger' {

    BeforeAll {

        $defaultEnabled  = $true
        $defaultPath     = 'TestDrive:\test.log'
        $defaultFormat   = '{0:yyyy-MM-dd HH:mm:ss}   {1}   {2}   {3}   {4}'
        $defaultLevel    = 'Information'
        $defaultEncoding = 'UTF8'
        $defaultLogFile  = $true
        $defaultEventLog = $true
        $defaultConsole  = $true
    }

    BeforeEach {

        Start-ScriptLogger -Path $defaultPath -Format $defaultFormat -Level $defaultLevel
    }

    It 'should update the logger path' {

        # Arrange
        $expectedPath = 'TestDrive:\testnew.log'

        # Act
        Set-ScriptLogger -Path $expectedPath

        # Assert
        $scriptLogger = Get-ScriptLogger

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

    It 'should update the logger format' {

        # Arrange
        $expectedFormat = '{4} {3} {2} {1} {0}'

        # Act
        Set-ScriptLogger -Format $expectedFormat

        # Assert
        $scriptLogger = Get-ScriptLogger
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

    It 'should update the logger log level' {

        # Arrange
        $expectedLevel = 'Error'

        # Act
        Set-ScriptLogger -Level $expectedLevel

        # Assert
        $scriptLogger = Get-ScriptLogger
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

    It 'should update the logger encoding' {

        # Arrange
        $expectedEncoding = 'UTF8'

        # Act
        Set-ScriptLogger -Encoding $expectedEncoding

        # Assert
        $scriptLogger = Get-ScriptLogger
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

    It 'should update the logger no log file option' {

        # Act
        Set-ScriptLogger -LogFile (-not $defaultLogFile)

        # Assert
        $scriptLogger = Get-ScriptLogger
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Not -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should update the logger no event log option' {

        # Act
        Set-ScriptLogger -EventLog (-not $defaultEventLog)

        # Assert
        $scriptLogger = Get-ScriptLogger
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Not -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
    }

    It 'should update the logger no console option' {

        # Act
        Set-ScriptLogger -ConsoleOutput (-not $defaultConsole)

        # Assert
        $scriptLogger = Get-ScriptLogger
        $scriptLogger               | Should -Not -BeNullOrEmpty
        $scriptLogger.Enabled       | Should -Be $defaultEnabled
        $scriptLogger.Path          | Should -Be $defaultPath
        $scriptLogger.Format        | Should -Be $defaultFormat
        $scriptLogger.Level         | Should -Be $defaultLevel
        $scriptLogger.Encoding      | Should -Be $defaultEncoding
        $scriptLogger.LogFile       | Should -Be $defaultLogFile
        $scriptLogger.EventLog      | Should -Be $defaultEventLog
        $scriptLogger.ConsoleOutput | Should -Not -Be $defaultConsole
    }

    AfterEach {

        Stop-ScriptLogger
    }
}
