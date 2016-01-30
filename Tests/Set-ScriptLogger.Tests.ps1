
# Load module
if ($Env:APPVEYOR -eq 'True')
{
    $Global:TestRoot = (Get-Module ScriptLogger -ListAvailable).ModuleBase

    Import-Module ScriptLogger -Force
}
else
{
    $Global:TestRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path).Path

    Import-Module "$Global:TestRoot\ScriptLogger.psd1" -Force
}

# Execute tests
Describe 'Set-ScriptLogger' {

    BeforeAll {

        $DefaultEnabled  = $true
        $DefaultPath     = 'TestDrive:\test.log'
        $DefaultFormat   = '{0:yyyy-MM-dd HH:mm:ss}   {1}   {2}   {3}   {4}'
        $DefaultLevel    = 'Information'
        $DefaultLogFile  = $true
        $DefaultEventLog = $true
        $DefaultConsole  = $true
    }

    BeforeEach {

        Start-ScriptLogger -Path $DefaultPath -Format $DefaultFormat -Level $DefaultLevel
    }

    It 'ParameterPath' {

        $ExpectedPath = 'TestDrive:\testnew.log'

        Set-ScriptLogger -Path $ExpectedPath

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled  | Should Be $DefaultEnabled
        $ScriptLogger.Path     | Should Be $ExpectedPath
        $ScriptLogger.Format   | Should Be $DefaultFormat
        $ScriptLogger.Level    | Should Be $DefaultLevel
        $ScriptLogger.LogFile  | Should Be $DefaultLogFile
        $ScriptLogger.EventLog | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterFormat' {

        $ExpectedFormat = '{4} {3} {2} {1} {0}'

        Set-ScriptLogger -Format $ExpectedFormat

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $ExpectedFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterLevel' {

        $ExpectedLevel = 'Error'

        Set-ScriptLogger -Level $ExpectedLevel

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $ExpectedLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoLogFile' {

        Set-ScriptLogger -LogFile (-not $DefaultLogFile)

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Not Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoEventLog' {

        Set-ScriptLogger -EventLog (-not $DefaultEventLog)

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Not Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoConsoleOutput' {

        Set-ScriptLogger -ConsoleOutput (-not $DefaultConsole)

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Not Be $DefaultConsole
    }

    AfterEach {

        Stop-ScriptLogger
    }
}
