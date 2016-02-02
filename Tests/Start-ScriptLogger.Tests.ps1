
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
Describe 'Start-ScriptLogger' {

    BeforeAll {

        $DefaultEnabled  = $true
        $DefaultPath     = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'PowerShell.log'
        $DefaultFormat   = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}'
        $DefaultLevel    = 'Verbose'
        $DefaultLogFile  = $true
        $DefaultEventLog = $true
        $DefaultConsole  = $true

        ## Convert default path from an relative to an absolute 
        #if (-not (Test-Path -Path $DefaultPath))
        #{
        #    New-Item -Path $DefaultPath -ItemType File | Out-Null
        #}
        #$DefaultPath = Resolve-Path -Path $DefaultPath | Select-Object -ExpandProperty Path
        #$DefaultPath | Remove-Item -Force
    }

    It 'ParameterNone' {

        Start-ScriptLogger

        $ScriptLogger = Get-ScriptLogger

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterPath' {

        $ExpectedPath = 'TestDrive:\test.log'

        Start-ScriptLogger -Path $ExpectedPath

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $ExpectedPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterFormat' {

        $ExpectedFormat = '{4} {3} {2} {1} {0}'

        Start-ScriptLogger -Format $ExpectedFormat

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

        Start-ScriptLogger -Level $ExpectedLevel

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

        Start-ScriptLogger -NoLogFile

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $false
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoEventLog' {

        Start-ScriptLogger -NoEventLog

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $false
        $ScriptLogger.ConsoleOutput | Should Be $DefaultConsole
    }

    It 'ParameterNoConsoleOutput' {

        Start-ScriptLogger -NoConsoleOutput

        $ScriptLogger | Should Not Be $null

        $ScriptLogger.Enabled       | Should Be $DefaultEnabled
        $ScriptLogger.Path          | Should Be $DefaultPath
        $ScriptLogger.Format        | Should Be $DefaultFormat
        $ScriptLogger.Level         | Should Be $DefaultLevel
        $ScriptLogger.LogFile       | Should Be $DefaultLogFile
        $ScriptLogger.EventLog      | Should Be $DefaultEventLog
        $ScriptLogger.ConsoleOutput | Should Be $false
    }

    AfterEach {

        Get-ScriptLogger | Remove-Item -Force
        Stop-ScriptLogger
    }
}
