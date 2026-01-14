[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Pester BeforeAll block')]
param ()

BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Start-ScriptLogger' {

    BeforeAll {

        Mock Get-Date { return [DateTime]::new(2010, 12, 06, 18, 20, 22) } -ModuleName $moduleName

        $defaultEnabled  = $true
        $defaultPath     = Join-Path -Path $PSScriptRoot -ChildPath 'Start-ScriptLogger.Tests.ps1.log'
        $defaultFormat   = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   [{5}] {4}'
        $defaultLevel    = 'Verbose'
        $defaultEncoding = 'UTF8'
        $defaultRotation = 'None'
        $defaultLogFile  = $true
        $defaultEventLog = $true
        $defaultConsole  = $true
    }

    Context 'Parameter Tests' {

        It 'should return default values without any specification' {

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter path' {

            # Arrange
            $expectedPath = Join-Path -Path 'TestDrive:' -ChildPath 'test.log'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Path $expectedPath -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $expectedPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter format' {

            # Arrange
            $expectedFormat = '{4} {3} {2} {1} {0}'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Format $expectedFormat -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $expectedFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter log level' {

            # Arrange
            $expectedLevel = 'Error'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Level $expectedLevel -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $expectedLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter encoding' {

            # Arrange
            $expectedEncoding = 'UTF8'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Encoding $expectedEncoding -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $expectedEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter rotation hourly' {

            # Arrange
            $expectedRotation = 'Hourly'
            $expectedPath     = Join-Path -Path $PSScriptRoot -ChildPath 'Start-ScriptLogger.Tests.ps1.2010120618.log'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Rotation $expectedRotation -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $expectedPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $expectedRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter rotation daily' {

            # Arrange
            $expectedRotation = 'Daily'
            $expectedPath     = Join-Path -Path $PSScriptRoot -ChildPath 'Start-ScriptLogger.Tests.ps1.20101206.log'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Rotation $expectedRotation -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $expectedPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $expectedRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter rotation monthly' {

            # Arrange
            $expectedRotation = 'Monthly'
            $expectedPath     = Join-Path -Path $PSScriptRoot -ChildPath 'Start-ScriptLogger.Tests.ps1.201012.log'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Rotation $expectedRotation -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $expectedPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $expectedRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter rotation yearly' {

            # Arrange
            $expectedRotation = 'Yearly'
            $expectedPath     = Join-Path -Path $PSScriptRoot -ChildPath 'Start-ScriptLogger.Tests.ps1.2010.log'

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -Rotation $expectedRotation -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $expectedPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $expectedRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter no log file' {

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -NoLogFile -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $false
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter no event log' {

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -NoEventLog -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $false
            $scriptLogger.ConsoleOutput | Should -Be $defaultConsole
        }

        It 'should return a valid value for the parameter no console output' {

            # Act
            $scriptLogger = Start-ScriptLogger -SkipStartStopMessage -NoConsoleOutput -PassThru

            # Assert
            $scriptLogger               | Should -Not -BeNullOrEmpty
            $scriptLogger.Enabled       | Should -Be $defaultEnabled
            $scriptLogger.Path          | Should -Be $defaultPath
            $scriptLogger.Format        | Should -Be $defaultFormat
            $scriptLogger.Level         | Should -Be $defaultLevel
            $scriptLogger.Encoding      | Should -Be $defaultEncoding
            $scriptLogger.Rotation      | Should -Be $defaultRotation
            $scriptLogger.LogFile       | Should -Be $defaultLogFile
            $scriptLogger.EventLog      | Should -Be $defaultEventLog
            $scriptLogger.ConsoleOutput | Should -Be $false
        }
    }

    Context 'Stream Override Tests' {

        It 'should create an override alias for <AliasName> when using StreamOverride' -ForEach @(
            @{ AliasName = 'Write-Verbose' }
            @{ AliasName = 'Write-Information' }
            @{ AliasName = 'Write-Warning' }
            @{ AliasName = 'Write-Error' }
        ) {

            # Act
            Start-ScriptLogger -SkipStartStopMessage -OverrideStream $ExecutionContext.SessionState -NoLogFile -NoEventLog

            # Assert
            $localAliases = Get-Alias -Scope 'Local'
            $localAliases.Name | Should -Contain $AliasName
        }
    }

    Context 'Built-In Log Message Test' {

        BeforeAll {

            InModuleScope $moduleName {

                Mock 'Write-ScriptLoggerLog' -Verifiable
            }
        }

        It 'should log the start messages automatically' {

            InModuleScope $moduleName {

                # Act
                Start-ScriptLogger -NoLogFile -NoEventLog

                # Assert
                Assert-MockCalled 'Write-ScriptLoggerLog' -ParameterFilter { $Level -eq 'Verbose' -and $Message -eq 'PowerShell log started' } -Times 1
            }
        }

        It 'should log the start messages automatically' {

            InModuleScope $moduleName {

                # Act
                Start-ScriptLogger -NoLogFile -NoEventLog
                Stop-ScriptLogger

                # Assert
                Assert-MockCalled 'Write-ScriptLoggerLog' -ParameterFilter { $Level -eq 'Verbose' -and $Message -eq 'PowerShell log stopped' } -Times 1
            }
        }
    }

    AfterEach {

        Get-ScriptLogger | Remove-Item -Force -ErrorAction 'SilentlyContinue'
        Stop-ScriptLogger
    }
}
