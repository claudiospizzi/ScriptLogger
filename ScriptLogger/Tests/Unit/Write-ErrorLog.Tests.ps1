
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
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
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
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 1 -Exactly
            }
        }
        It 'should invoke the mock twice for an array of 2 messages' {

            InModuleScope $moduleName {

                # Act
                Write-ErrorLog -Message 'My Error', 'My Error'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock twice for an array of 2 error records' {

            InModuleScope $moduleName {

                # Arrange
                $errorRecord = $(try { 0 / 0 } catch { $_ })

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord, $errorRecord

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 2 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 messages' {

            InModuleScope $moduleName {

                # Act
                'My Error', 'My Error', 'My Error' | Write-ErrorLog

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-ScriptLoggerLog' -Times 3 -Exactly
            }
        }

        It 'should invoke the mock three times for a pipeline input of 3 error records' {

            InModuleScope $moduleName {

                # Arrange
                $errorRecord = $(try { 0 / 0 } catch { $_ })

                # Act
                $errorRecord, $errorRecord, $errorRecord | Write-ErrorLog

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
                Start-ScriptLogger -Path 'TestDrive:\test.log' -NoEventLog -NoConsoleOutput
                $callerLine = 124

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                $logFile = Get-Content -Path 'TestDrive:\test.log'
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         [Write-ErrorLog.Tests.ps1:$callerLine] My Error"
            }

            It 'should write a valid error record to the log file' {

                # Arrange
                Start-ScriptLogger -Path 'TestDrive:\test.log' -NoEventLog -NoConsoleOutput
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
                $logFile = Get-Content -Path 'TestDrive:\test.log'
                $logFile | Should -BeLike "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         ``[Write-ErrorLog.Tests.ps1:$callerLine``] Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)"
            }

            It 'should write a valid message with stack trace to the log' {

                # Arrange
                Start-ScriptLogger -Path 'TestDrive:\test.log' -NoEventLog -NoConsoleOutput
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
                $logFile = Get-Content -Path 'TestDrive:\test.log'
                $logFile[0] | Should -BeLike "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         ``[Write-ErrorLog.Tests.ps1:$callerLine``] Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)"
                $logFile[1] | Should -BeLike "at <ScriptBlock>, *\ScriptLogger\Tests\Unit\Write-ErrorLog.Tests.ps1:*"
            }
        }

        Context 'Event Log' {

            It 'should write a valid message to the event log' {

                # Arrange
                Start-ScriptLogger -Path 'TestDrive:\test.log' -NoLogFile -NoConsoleOutput
                $filterTimestamp = [System.DateTime]::Now.AddSeconds(-1)
                $callerLine = 185

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $filterTimestamp -Newest 1
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Error'
                $eventLog.Message        | Should -Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'[Write-ErrorLog.Tests.ps1:$callerLine] My Error'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }

            It 'should write a valid error record to the event log' {

                # Arrange
                Start-ScriptLogger -Path 'TestDrive:\test.log' -NoLogFile -NoConsoleOutput
                $filterTimestamp = [System.DateTime]::Now.AddSeconds(-1)
                $callerLine = 211

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
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $filterTimestamp -Newest 1
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Error'
                $eventLog.Message        | Should -BeLike "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'``[Write-ErrorLog.Tests.ps1:$callerLine``] Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }
        }

        Context 'Console Output' {

            BeforeAll {

                InModuleScope 'ScriptLogger' {

                    Mock 'Show-ScriptLoggerErrorMessage' -ModuleName 'ScriptLogger' -ParameterFilter { $Message -eq 'My Error' -or $Message -like 'Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)' } -Verifiable
                }
            }

            It 'should write a valid message to the console' {

                InModuleScope $moduleName {

                    # Arrange
                    Start-ScriptLogger -Path 'TestDrive:\test.log' -NoLogFile -NoEventLog

                    # Act
                    Write-ErrorLog -Message 'My Error'

                    # Assert
                    Assert-MockCalled -Scope It -CommandName 'Show-ScriptLoggerErrorMessage' -Times 1 -Exactly
                }
            }

            It 'should write a valid error record to the console' {

                InModuleScope $moduleName {

                    # Arrange
                    Start-ScriptLogger -Path 'TestDrive:\test.log' -NoLogFile -NoEventLog

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
                    Assert-MockCalled -Scope It -CommandName 'Show-ScriptLoggerErrorMessage' -Times 1 -Exactly
                }
            }
        }

        AfterEach {

            Remove-Item -Path 'TestDrive:\test.log' -ErrorAction 'SilentlyContinue'
            Stop-ScriptLogger
        }
    }
}
