
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

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

        $ScriptLogger = Start-ScriptLogger -PassThru

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

        $ScriptLogger = Start-ScriptLogger -Path $ExpectedPath -PassThru

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

        $ScriptLogger = Start-ScriptLogger -Format $ExpectedFormat -PassThru

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

        $ScriptLogger = Start-ScriptLogger -Level $ExpectedLevel -PassThru

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

        $ExpectedEncoding = 'UTF8'

        $ScriptLogger = Start-ScriptLogger -Encoding $ExpectedEncoding -PassThru

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

        $ScriptLogger = Start-ScriptLogger -NoLogFile -PassThru

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

        $ScriptLogger = Start-ScriptLogger -NoEventLog -PassThru

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

        $ScriptLogger = Start-ScriptLogger -NoConsoleOutput -PassThru

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
