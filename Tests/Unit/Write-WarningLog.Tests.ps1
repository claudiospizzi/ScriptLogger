
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

InModuleScope ScriptLogger {

    Describe 'Write-WarningLog' {

        Context 'MockInnerCall' {

            Mock Write-Log -ModuleName ScriptLogger -ParameterFilter { $Level -eq 'Warning' }

            It 'InnerLevel' {

                Write-WarningLog -Message 'My Warning'

                Assert-MockCalled Write-Log -Times 1
            }
        }

        Context 'Output' {

            Mock Get-Date -ModuleName ScriptLogger { [DateTime] '2000-12-31 01:02:03' }

            Mock Show-WarningMessage -ModuleName ScriptLogger -ParameterFilter { $Message -eq 'My Warning' }

            BeforeAll {

                $Path = 'TestDrive:\test.log'
            }

            It 'LogFile' {

                Start-ScriptLogger -Path $Path -NoEventLog -NoConsoleOutput

                Write-WarningLog -Message 'My Warning'

                $Content = Get-Content -Path $Path
                $Content | Should Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Warning       My Warning"
            }

            It 'EventLog' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoConsoleOutput

                $Before = Get-Date

                Write-WarningLog -Message 'My Warning'

                $Event = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Warning -After $Before -Newest 1

                $Event | Should Not Be $null
                $Event.EventID        | Should Be 0
                $Event.CategoryNumber | Should Be 0
                $Event.EntryType      | Should Be 'Warning'
                $Event.Message        | Should Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'My Warning'"
                $Event.Source         | Should Be 'PowerShell'
                $Event.InstanceId     | Should Be 0
            }

            It 'ConsoleOutput' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoEventLog

                $Before = Get-Date

                Write-WarningLog -Message 'My Warning'

                Assert-MockCalled -CommandName 'Show-WarningMessage' -Times 1 -Exactly
            }

            AfterEach {

                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }
    }
}
