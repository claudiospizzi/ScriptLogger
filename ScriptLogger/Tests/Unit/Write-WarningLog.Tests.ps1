
BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Write-WarningLog' {

    Context 'Ensure mocked Write-ScriptLoggerLog is invoked' {

        BeforeAll {

            InModuleScope 'ScriptLogger' {

                Mock Write-ScriptLoggerLog -ModuleName 'ScriptLogger' -ParameterFilter { $Level -eq 'Warning' } -Verifiable
            }
        }

        It 'should invoke the mock one for a simple message' {

            InModuleScope $moduleName {

                # Act
                Write-WarningLog -Message 'My Warning'

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
            }
        }

        It 'should invoke the mock twice for an array of 2 messages' {

            InModuleScope $moduleName {

                # Act
                Write-WarningLog -Message 'My Warning', 'My Warning'

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 messages' {

            InModuleScope $moduleName {

                # Act
                'My Warning', 'My Warning', 'My Warning' | Write-WarningLog

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 3 -Exactly
            }
        }
    }

    Context 'Ensure valid output' {

        BeforeAll {

            Mock 'Get-Date' -ModuleName $moduleName { [DateTime] '2000-12-31 01:02:03' }
        }

        Context 'Log File' {

            It 'should write a valid message to the log file' {

                # Arrange
                Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoEventLog -NoConsoleOutput
                $callerLine = 76

                # Act
                Write-WarningLog -Message 'My Warning'

                # Assert
                $logFile = Get-Content -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log')
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Warning       [Write-WarningLog.Tests.ps1:$callerLine] My Warning"
            }
        }

        Context 'Event Log' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Write-EventLog' -ModuleName 'ScriptLogger' -ParameterFilter { $LogName -eq 'Windows PowerShell' -and $Source -eq 'PowerShell' -and $entryType -eq 'Warning' -and $Message -like '`[Write-WarningLog.Tests.ps1:*`] My Warning' } -Verifiable
                }
            }

            It 'should write a valid message to the event log' {

                InModuleScope 'ScriptLogger' {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoConsoleOutput

                    # Act
                    Write-WarningLog -Message 'My Warning'

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-EventLog' -Times 1 -Exactly
                }
            }
        }

        Context 'Console Output' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Write-Warning' -ModuleName 'ScriptLogger' -ParameterFilter { $Message -eq 'My Warning' } -Verifiable
                }
            }

            It 'should write a valid message to the console' {

                InModuleScope 'ScriptLogger' {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoEventLog

                    # Act
                    Write-WarningLog -Message 'My Warning'

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-Warning' -Times 1 -Exactly
                }
            }
        }

        AfterEach {

            Remove-Item -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -ErrorAction 'SilentlyContinue'
            Stop-ScriptLogger
        }
    }
}
