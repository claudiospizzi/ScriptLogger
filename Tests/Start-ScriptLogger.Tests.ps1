
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
Describe 'Start-ScriptLogger' {

    BeforeAll {

        $DefaultEnabled  = $true
        $DefaultPath     = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'PowerShell.log'
        $DefaultFormat   = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}'
        $DefaultLevel    = 'Verbose'
        $DefaultEncoding = 'UTF8'
        $DefaultLogFile  = $true
        $DefaultEventLog = $true
        $DefaultConsole  = $true
    }

    It 'ParameterNone' {

        $ScriptLogger = Start-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterPath' {

        $ExpectedPath = 'TestDrive:\test.log'

        $ScriptLogger = Start-ScriptLogger -Path $ExpectedPath

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $ExpectedPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterFormat' {

        $ExpectedFormat = '{4} {3} {2} {1} {0}'

        $ScriptLogger = Start-ScriptLogger -Format $ExpectedFormat

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $ExpectedFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterLevel' {

        $ExpectedLevel = 'Error'

        $ScriptLogger = Start-ScriptLogger -Level $ExpectedLevel

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $ExpectedLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterEncoding' {

        $ExpectedEncoding = 'UTF7'

        $ScriptLogger = Start-ScriptLogger -Encoding $ExpectedEncoding

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $ExpectedEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoLogFile' {

        $ScriptLogger = Start-ScriptLogger -NoLogFile

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $false
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoEventLog' {

        $ScriptLogger = Start-ScriptLogger -NoEventLog

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $false
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoConsoleOutput' {

        $ScriptLogger = Start-ScriptLogger -NoConsoleOutput

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.Encoding      | Should Be $DefaultEncoding
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $false
    }

    AfterEach {

        Get-ScriptLogger | Remove-Item -Force
        Stop-ScriptLogger
    }
}
