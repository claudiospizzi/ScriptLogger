
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

InModuleScope ScriptLogger {

    Describe 'Write-ErrorLog' {

        Context 'MockInnerCall' {

            Mock Write-Log -ModuleName ScriptLogger -ParameterFilter { $Level -eq 'Error' }

            It 'InnerLevel' {

                Write-ErrorLog -Message 'My Error'

                Assert-MockCalled Write-Log -Times 1
            }
        }

        Context 'MockInnerCallErrorRecord' {

            Mock Write-Log -ModuleName ScriptLogger -ParameterFilter { $ErrorRecord.CategoryInfo.Reason -eq 'RuntimeException' }

            It 'InnerLevel' {

                Write-ErrorLog -ErrorRecord $(try { 0 / 0 } catch { $_ })

                Assert-MockCalled Write-Log -Times 1
            }
        }

        Context 'Output' {

            Mock Get-Date -ModuleName ScriptLogger { [DateTime] '2000-12-31 01:02:03' }

            Mock Show-ErrorMessage -ModuleName ScriptLogger -ParameterFilter { $Message -eq 'My Error' }

            BeforeAll {

                $Path = 'TestDrive:\test.log'
            }

            It 'LogFile' {

                Start-ScriptLogger -Path $Path -NoEventLog -NoConsoleOutput

                Write-ErrorLog -Message 'My Error'

                $Content = Get-Content -Path $Path
                $Content | Should Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         My Error"
            }

            It 'EventLog' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoConsoleOutput

                $Before = Get-Date

                Write-ErrorLog -Message 'My Error'

                $Event = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $Before -Newest 1

                $Event | Should Not Be $null
                $Event.EventID        | Should Be 0
                $Event.CategoryNumber | Should Be 0
                $Event.EntryType      | Should Be 'Error'
                $Event.Message        | Should Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'My Error'"
                $Event.Source         | Should Be 'PowerShell'
                $Event.InstanceId     | Should Be 0
            }

            It 'ConsoleOutput' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoEventLog

                $Before = Get-Date

                Write-ErrorLog -Message 'My Error'

                Assert-MockCalled -CommandName 'Show-ErrorMessage' -Times 1 -Exactly
            }

            AfterEach {

                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }

        Context 'OutputErrorRecord' {

            Mock Get-Date -ModuleName ScriptLogger { [DateTime] '2000-12-31 01:02:03' }

            Mock Show-ErrorMessage -ModuleName ScriptLogger -ParameterFilter { $Message -like 'Attempted to divide by zero.*' }

            BeforeAll {

                $Path = 'TestDrive:\test.log'
            }

            It 'LogFile' {

                Start-ScriptLogger -Path $Path -NoEventLog -NoConsoleOutput

                Write-ErrorLog -ErrorRecord $(try { 0 / 0 } catch { $_ })

                $Content = Get-Content -Path $Path
                $Content | Should Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Error         Attempted to divide by zero. (RuntimeException: $Global:TestRoot\Unit\Write-ErrorLog.Tests.ps1:109 char:53)"
            }

            It 'EventLog' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoConsoleOutput

                $Before = Get-Date

                Write-ErrorLog -ErrorRecord $(try { 0 / 0 } catch { $_ })

                $Event = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Error -After $Before -Newest 1

                $Event | Should Not Be $null
                $Event.EventID        | Should Be 0
                $Event.CategoryNumber | Should Be 0
                $Event.EntryType      | Should Be 'Error'
                $Event.Message        | Should Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'Attempted to divide by zero. (RuntimeException: $Global:TestRoot\Unit\Write-ErrorLog.Tests.ps1:121 char:53)'"
                $Event.Source         | Should Be 'PowerShell'
                $Event.InstanceId     | Should Be 0
            }

            It 'ConsoleOutput' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoEventLog

                $Before = Get-Date

                try
                {
                    0 / 0
                }
                catch
                {
                    Write-ErrorLog -ErrorRecord $_
                }

                Assert-MockCalled -CommandName 'Show-ErrorMessage' -Times 1 -Exactly
            }

            AfterEach {

                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }
    }
}
