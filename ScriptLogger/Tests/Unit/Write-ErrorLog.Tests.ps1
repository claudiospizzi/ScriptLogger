
BeforeAll {

    $modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
    $moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$modulePath\$moduleName" -Force
}

Describe 'Write-ErrorLog' {

    Context 'Ensure mocked Write-ScriptLoggerLog is invoked' {

        BeforeAll {

            InModuleScope 'ScriptLogger' {

                Mock Write-ScriptLoggerLog -ModuleName 'ScriptLogger' -ParameterFilter { $Level -eq 'Error' } -Verifiable
            }
        }

        It 'should invoke the mock one for a simple message' {

            InModuleScope $moduleName {

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
            }
        }

        It 'should invoke the mock one for a simple error record' {

            InModuleScope $moduleName {

                # Act
                try
                {
                    0/0
                }
                catch
                {
                    Write-ErrorLog -ErrorRecord $_
                }

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
            }
        }
        It 'should invoke the mock twice for an array of 2 messages' {

            InModuleScope $moduleName {

                # Act
                Write-ErrorLog -Message 'My Error', 'My Error'

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock twice for an array of 2 error records' {

            InModuleScope $moduleName {

                # Arrange
                $errorRecord = $(try { 0 / 0 } catch { $_ })

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord, $errorRecord

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 messages' {

            InModuleScope $moduleName {

                # Act
                'My Error', 'My Error', 'My Error' | Write-ErrorLog

                # Assert
                Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerLog' -Times 3 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 error records' {

            InModuleScope $moduleName {

                # Arrange
                $errorRecord = $(try { 0 / 0 } catch { $_ })

                # Act
                $errorRecord, $errorRecord, $errorRecord | Write-ErrorLog

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
                $callerLine = 124

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                $logFile = Get-Content -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log')
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         [Write-ErrorLog.Tests.ps1:$callerLine] My Error"
            }

            It 'should write a valid error record to the log file' {

                # Arrange
                Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoEventLog -NoConsoleOutput
                $callerLine = 144

                # Act
                try
                {
                    0 / 0
                }
                catch
                {
                    Write-ErrorLog -ErrorRecord $_
                }

                # Assert
                $logFile = Get-Content -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log')
                $logFile | Should -BeLike "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         ``[Write-ErrorLog.Tests.ps1:$callerLine``] Attempted to divide by zero. (RuntimeException: *Write-ErrorLog.Tests.ps1:* char:*)"
            }

            It 'should write a valid message with stack trace to the log' {

                # Arrange
                Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoEventLog -NoConsoleOutput
                $callerLine = 165

                # Act
                try
                {
                    0 / 0
                }
                catch
                {
                    Write-ErrorLog -ErrorRecord $_ -IncludeStackTrace
                }

                # Assert
                $logFile = Get-Content -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log')
                $logFile[0] | Should -BeLike "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         ``[Write-ErrorLog.Tests.ps1:$callerLine``] Attempted to divide by zero. (RuntimeException: *Write-ErrorLog.Tests.ps1:* char:*)"
                $logFile[1] | Should -BeLike "at <ScriptBlock>, *ScriptLogger*Tests*Unit*Write-ErrorLog.Tests.ps1:*"
            }
        }

        Context 'Event Log' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Write-ScriptLoggerPlatformLog' -ModuleName 'ScriptLogger' -ParameterFilter { $Level -eq 'Error' -and ($Message -like '`[Write-ErrorLog.Tests.ps1:*`] My Error' -or $Message -like '`[Write-ErrorLog.Tests.ps1:*`] Attempted to divide by zero. (RuntimeException: *Write-ErrorLog.Tests.ps1:* char:*)') } -Verifiable
                }
            }

            It 'should write a valid message to the event log' {

                InModuleScope 'ScriptLogger' {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoConsoleOutput

                    # Act
                    Write-ErrorLog -Message 'My Error'

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerPlatformLog' -Times 1 -Exactly
                }
            }

            It 'should write a valid error record to the event log' {

                InModuleScope 'ScriptLogger' {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoConsoleOutput

                    # Act
                    try
                    {
                        0 / 0
                    }
                    catch
                    {
                        Write-ErrorLog -ErrorRecord $_
                    }

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-ScriptLoggerPlatformLog' -Times 1 -Exactly
                }
            }
        }

        Context 'Console Output' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Write-Error' -ModuleName 'ScriptLogger' -ParameterFilter { $Message -eq 'My Error' -or $Message -like 'Attempted to divide by zero. (RuntimeException: *Write-ErrorLog.Tests.ps1:* char:*)' } -Verifiable
                }
            }

            It 'should write a valid message to the console' {

                InModuleScope $moduleName {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoEventLog

                    # Act
                    Write-ErrorLog -Message 'My Error'

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-Error' -Times 1 -Exactly
                }
            }

            It 'should write a valid error record to the console' {

                InModuleScope $moduleName {

                    # Arrange
                    Start-ScriptLogger -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -NoLogFile -NoEventLog

                    # Act
                    try
                    {
                        0 / 0
                    }
                    catch
                    {
                        Write-ErrorLog -ErrorRecord $_
                    }

                    # Assert
                    Assert-MockCalled -Scope 'It' -CommandName 'Write-Error' -Times 1 -Exactly
                }
            }
        }

        AfterEach {

            Remove-Item -Path (Join-Path -Path 'TestDrive:' -ChildPath 'test.log') -ErrorAction 'SilentlyContinue'
            Stop-ScriptLogger
        }
    }
}
