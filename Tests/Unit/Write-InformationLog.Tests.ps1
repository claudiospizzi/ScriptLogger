
# Load module
if ($Env:APPVEYOR -eq 'True')
{
    $Global:TestRoot = (Get-Module ScriptLogger -ListAvailable | Select-Object -First 1).ModuleBase

    Import-Module ScriptLogger -Force
}
else
{
    $Global:TestRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path).Path

    Import-Module "$Global:TestRoot\ScriptLogger.psd1" -Force
}

# Execute tests
InModuleScope ScriptLogger {

    Describe 'Write-InformationLog' {

        Context 'MockInnerCall' {

            Mock Write-Log -ModuleName ScriptLogger -ParameterFilter { $Level -eq 'Information' }

            It 'InnerLevel' {

                Write-InformationLog -Message 'My Information'

                Assert-MockCalled Write-Log -Times 1
            }
        }

        Context 'Output' {

            Mock Get-Date -ModuleName ScriptLogger { [DateTime] '2000-12-31 01:02:03' }

            Mock Show-InformationMessage -ModuleName ScriptLogger -ParameterFilter { $Message -eq 'My Information' }

            BeforeAll {

                $Path = 'TestDrive:\test.log'
            }

            It 'LogFile' {

                Start-ScriptLogger -Path $Path -NoEventLog -NoConsoleOutput

                Write-InformationLog -Message 'My Information'

                $Content = Get-Content -Path $Path
                $Content | Should Be "2000-12-31   01:02:03   $Env:ComputerName   $Env:Username   Information   My Information"
            }

            It 'EventLog' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoConsoleOutput

                $Before = Get-Date

                Write-InformationLog -Message 'My Information'

                $Event = Get-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -InstanceId 0 -EntryType Information -After $Before -Newest 1

                $Event | Should Not Be $null
                $Event.EventID        | Should Be 0
                $Event.CategoryNumber | Should Be 0
                $Event.EntryType      | Should Be 'Information'
                $Event.Message        | Should Be "The description for Event ID '0' in Source 'PowerShell' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'My Information'"
                $Event.Source         | Should Be 'PowerShell'
                $Event.InstanceId     | Should Be 0
            }

            It 'ConsoleOutput' {

                Start-ScriptLogger -Path $Path -NoLogFile -NoEventLog

                $Before = Get-Date

                Write-InformationLog -Message 'My Information'

                Assert-MockCalled -CommandName Show-InformationMessage -Times 1 -Exactly
            }

            AfterEach {

                Get-ScriptLogger | Remove-Item -Force
                Stop-ScriptLogger
            }
        }
    }
}
