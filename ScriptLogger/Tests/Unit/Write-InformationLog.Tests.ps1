
BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Write-InformationLog' {

    Context 'Ensure mocked Write-ScriptLoggerLog is invoked' {

        BeforeAll {

            InModuleScope 'ScriptLogger' {

                Mock Write-ScriptLoggerLog -ModuleName 'ScriptLogger' -ParameterFilter { $Level -eq 'Information' } -Verifiable
            }
        }

        It 'should invoke the mock one for a simple message' {

            InModuleScope $moduleName {

                # Act
                Write-InformationLog -Message 'My Information'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
            }
        }

        It 'should invoke the mock twice for an array of 2 messages' {

            InModuleScope $moduleName {

                # Act
                Write-InformationLog -Message 'My Information', 'My Information'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 messages' {

            InModuleScope $moduleName {

                # Act
                'My Information', 'My Information', 'My Information' | Write-InformationLog

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 3 -Exactly
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
                Write-InformationLog -Message 'My Information'

                # Assert
                $logFile = Get-Content -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log')
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Information   [Write-InformationLog.Tests.ps1:$callerLine] My Information"
            }
        }

        Context 'Event Log' {

            It 'should write a valid message to the event log' {

                # Arrange
                Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoConsoleOutput
                $filterTimestamp = [System.DateTime]::Now.AddSeconds(-1)
                $callerLine = 94

                # Act
                Write-InformationLog -Message 'My Information'

                # Assert
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType 'Information' -After $filterTimestamp -Newest 1
                $eventLog                | Should -Not -BeNullOrEmpty
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Information'
                $eventLog.Message        | Should -Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'[Write-InformationLog.Tests.ps1:$callerLine] My Information'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }
        }

        Context 'Console Output' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Show-ScriptLoggerInformationMessage' -ModuleName 'ScriptLogger' -ParameterFilter { $Message -eq 'My Information' } -Verifiable
                }
            }

            It 'should write a valid message to the console' {

                InModuleScope 'ScriptLogger' {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoEventLog

                    # Act
                    Write-InformationLog -Message 'My Information'

                    # Assert
                    Assert-MockCalled -Scope It -CommandName 'Show-ScriptLoggerInformationMessage' -Times 1 -Exactly
                }
            }
        }

        AfterEach {

            Remove-Item -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -ErrorAction 'SilentlyContinue'
            Stop-ScriptLogger
        }
    }
}
