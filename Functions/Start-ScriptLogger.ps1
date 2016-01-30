<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER Path
    The path to the log file.

.PARAMETER Format
    This parameter defines, how the log output will be formated. The format
    definition will be used to call the System.String.Format() method. The
    following values are used as arguments:
    {0} Timestamp as datetime value.
    {1} NetBIOS computer name.
    {2} Current session username.
    {3} Log entry level.
    {4} Message.

.PARAMETER Level
    The event log level. All log messages equal to or higher to the level will
    be logged. This is the level order:
    1. Verbose
    2. Information
    3. Warning
    4. Error

.PARAMETER SkipEventLog
    Skip the event log output. By default, all log messages will be written
    into the "Windows PowerShell" event log.

.PARAMETER HideConsoleOutput
    Hide the PowerShell console output. By default, all log messages are shown
    on the console.

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
#>

function Start-ScriptLogger
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0,
                   Mandatory=$false)]
        [ValidateScript({Test-Path -Path (Split-Path -Path $_ -Parent)})]
        [String] $Path = $Global:MyInvocation.MyCommand.Definition.Trim() + '.log',

        [Parameter(Position=1,
                   Mandatory=$false)]
        [ValidateScript({$_ -f (Get-Date), $Env:ComputerName, $Env:Username, 'Verbose', 'Message'})]
        [String] $Format = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}',

        [Parameter(Position=2,
                   Mandatory=$false)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [String] $Level = 'Verbose',
        
        [Parameter(Position=3,
                   Mandatory=$false)]
        [Switch] $NoLogFile,

        [Parameter(Position=4,
                   Mandatory=$false)]
        [Switch] $NoEventLog,

        [Parameter(Position=5,
                   Mandatory=$false)]
        [Switch] $NoConsoleOutput
    )

    # Create an empty log file, if it does not exist
    if (-not (Test-Path -Path $Path))
    {
        New-Item -Path $Path -ItemType File | Out-Null
    }

    # Only work with absolute path, makes error handling easier
    $Path = (Resolve-Path -Path $Path).Path

    Write-Verbose "Enable script logger with log file '$Path'"

    # Define global variable for the logging
    $Global:ScriptLogger = New-Object -TypeName PSObject -Property @{
        Enabled       = $true
        Path          = $Path
        Format        = $Format
        Level         = $Level
        LogFile       = -not $NoLogFile.IsPresent
        EventLog      = -not $NoEventLog.IsPresent
        ConsoleOutput = -not $NoConsoleOutput.IsPresent
    }
    $Global:ScriptLogger.PSTypeNames.Insert(0, 'ScriptLogger.Configuration')
}
