
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

InModuleScope $moduleName {

    Describe 'Write-ErrorLog' {

        Context 'Ensure mocked Write-Log is invoked' {

            $errorRecord = $(try { 0 / 0 } catch { $_ })

            Mock Write-Log -ModuleName $moduleName -ParameterFilter { $Level -eq 'Error' } -Verifiable

            It 'should invoke the mock one for a simple message' {

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 1 -Exactly
            }

            It 'should invoke the mock one for a simple error record' {

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 1 -Exactly
            }
            It 'should invoke the mock twice for an array of 2 messages' {

                # Act
                Write-ErrorLog -Message 'My Error', 'My Error'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 2 -Exactly
            }

            It 'should invoke the mock twice for an array of 2 error records' {

                # Act
                Write-ErrorLog -Message $errorRecord, $errorRecord

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 2 -Exactly
            }

            It 'should invoke the mock three times for a pipeline input of 3 messages' {

                # Act
                'My Error', 'My Error', 'My Error' | Write-ErrorLog

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 3 -Exactly
            }

            It 'should invoke the mock three times for a pipeline input of 3 error records' {

                # Act
                $errorRecord, $errorRecord, $errorRecord | Write-ErrorLog

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 3 -Exactly
            }
        }

        Context 'Ensure valid output' {

            $logPath = 'TestDrive:\test.log'

            $errorRecord = $(try { 0 / 0 } catch { $_ })

            Mock Get-Date -ModuleName $moduleName { [DateTime] '2000-12-31 01:02:03' }

            It 'should write a valid message to the log file' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoEventLog -NoConsoleOutput

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                $logFile = Get-Content -Path $logPath
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         My Error"
            }

            It 'should write a valid error record to the log file' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoEventLog -NoConsoleOutput

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord

                # Assert
                $logFile = Get-Content -Path $logPath
                $logFile | Should -BeLike "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)"
            }

            It 'should write a valid message to the event log' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoLogFile -NoConsoleOutput
                $filterTimestamp = Get-Date

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $filterTimestamp -Newest 1
                $eventLog                | Should -Not -BeNullOrEmpty
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Error'
                $eventLog.Message        | Should -Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'My Error'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }

            It 'should write a valid message to the event log' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoLogFile -NoConsoleOutput
                $filterTimestamp = Get-Date

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord

                # Assert
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $filterTimestamp -Newest 1
                $eventLog                | Should -Not -BeNullOrEmpty
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Error'
                $eventLog.Message        | Should -BeLike "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }

            It 'should write a valid message to the console' {

                # Arrange
                Mock Show-ErrorMessage -ModuleName $moduleName -ParameterFilter { $Message -eq 'My Error' }
                Start-ScriptLogger -Path $logPath -NoLogFile -NoEventLog

                # Act
                Write-ErrorLog -Message 'My Error'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Show-ErrorMessage' -Times 1 -Exactly
            }

            It 'should write a valid message to the console' {

                # Arrange
                Mock Show-ErrorMessage -ModuleName $moduleName -ParameterFilter { $Message -like 'Attempted to divide by zero. (RuntimeException: *\Unit\Write-ErrorLog.Tests.ps1:* char:*)' }
                Start-ScriptLogger -Path $logPath -NoLogFile -NoEventLog

                # Act
                Write-ErrorLog -ErrorRecord $errorRecord

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Show-ErrorMessage' -Times 1 -Exactly
            }

            AfterEach {

                # Cleanup logger
                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }
    }
}
