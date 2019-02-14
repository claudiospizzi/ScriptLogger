
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

InModuleScope $moduleName {

    Describe 'Write-VerboseLog' {

        Context 'Ensure mocked Write-Log is invoked' {

            Mock Write-Log -ModuleName $moduleName -ParameterFilter { $Level -eq 'Verbose' } -Verifiable

            It 'should invoke the mock one for a simple message' {

                # Act
                Write-VerboseLog -Message 'My Verbose'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 1 -Exactly
            }

            It 'should invoke the mock twice for an array of 2 messages' {

                # Act
                Write-VerboseLog -Message 'My Verbose', 'My Verbose'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 2 -Exactly
            }

            It 'should invoke the mock three times for a pipeline input of 3 messages' {

                # Act
                'My Verbose', 'My Verbose', 'My Verbose' | Write-VerboseLog

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Write-Log' -Times 3 -Exactly
            }
        }

        Context 'Ensure valid output' {

            $logPath = 'TestDrive:\test.log'

            Mock Get-Date -ModuleName $moduleName { [DateTime] '2000-12-31 01:02:03' }

            It 'should write a valid message to the log file' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoEventLog -NoConsoleOutput

                # Act
                Write-VerboseLog -Message 'My Verbose'

                # Assert
                $logFile = Get-Content -Path $logPath
                $logFile | Should -Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Verbose       My Verbose"
            }

            It 'should write a valid message to the event log' {

                # Arrange
                Start-ScriptLogger -Path $logPath -NoLogFile -NoConsoleOutput
                $filterTimestamp = Get-Date

                # Act
                Write-VerboseLog -Message 'My Verbose'

                # Assert
                $eventLog = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Information -After $filterTimestamp -Newest 1
                $eventLog                | Should -Not -BeNullOrEmpty
                $eventLog.EventID        | Should -Be 0
                $eventLog.CategoryNumber | Should -Be 0
                $eventLog.EntryType      | Should -Be 'Information'
                $eventLog.Message        | Should -Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'My Verbose'"
                $eventLog.Source         | Should -Be 'PowerShell'
                $eventLog.InstanceId     | Should -Be 0
            }

            It 'should write a valid message to the console' {

                # Arrange
                Mock Show-VerboseMessage -ModuleName $moduleName -ParameterFilter { $Message -eq 'My Verbose' }
                Start-ScriptLogger -Path $logPath -NoLogFile -NoEventLog

                # Act
                Write-VerboseLog -Message 'My Verbose'

                # Assert
                Assert-MockCalled -Scope It -CommandName 'Show-VerboseMessage' -Times 1 -Exactly
            }

            AfterEach {

                # Cleanup logger
                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }
    }
}
