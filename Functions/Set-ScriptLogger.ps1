<#
.SYNOPSIS
    Update the script logger log configuration.

.DESCRIPTION
    The script logger inside the current PowerShell session can be updated with
    all parameters inside this cmdlet.

.PARAMETER Path
    Update the path to the log file.

.PARAMETER Format
    Update the format for the log file.

.PARAMETER Level
    Update the logger level.

.PARAMETER Encoding
    Update the used log file encoding.

.PARAMETER LogFile
    Enable or disable the log file output.

.PARAMETER EventLog
    Enable or disable the event log output.

.PARAMETER ConsoleOutput
    Enable or disable the console output.

.EXAMPLE
    C:\> Set-ScriptLogger -Level 'Warning' -EventLog $true
    Set the script logger level to warning and enable the event log output.

.EXAMPLE Set-ScriptLogger -Path 'C:\Temp\test.log' -Format '{3}: {4}'
    C:\> Update the log file path and its format.

.NOTES
    Author     : Claudio Spizzi
    License    : MIT License

.LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Set-ScriptLogger
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0,
                   Mandatory=$false)]
        [ValidateScript({Test-Path -Path (Split-Path -Path $_ -Parent)})]
        [String] $Path,

        [Parameter(Position=1,
                   Mandatory=$false)]
        [ValidateScript({$_ -f (Get-Date), $Env:ComputerName, $Env:Username, 'Verbose', 'My Message'})]
        [String] $Format,

        [Parameter(Position=2,
                   Mandatory=$false)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [String] $Level,

        [Parameter(Position=3,
                   Mandatory=$false)]
        [ValidateSet('Unicode', 'UTF7', 'UTF8', 'UTF32', 'ASCII', 'BigEndianUnicode', 'Default', 'OEM')]
        [String] $Encoding,

        [Parameter(Position=4,
                   Mandatory=$false)]
        [Boolean] $LogFile,

        [Parameter(Position=5,
                   Mandatory=$false)]
        [Boolean] $EventLog,

        [Parameter(Position=6,
                   Mandatory=$false)]
        [Boolean] $ConsoleOutput
    )

    if ($Global:ScriptLogger -ne $null)
    {
        if ($PSBoundParameters.ContainsKey('Path'))
        {
            # Create an empty log file, if it does not exist
            if (-not (Test-Path -Path $Path))
            {
                New-Item -Path $Path -ItemType File | Out-Null
            }

            # Only work with absolute path, makes error handling easier
            $Path = (Resolve-Path -Path $Path).Path

            $Global:ScriptLogger.Path = $Path
        }

        if ($PSBoundParameters.ContainsKey('Format'))
        {
            $Global:ScriptLogger.Format = $Format
        }

        if ($PSBoundParameters.ContainsKey('Level'))
        {
            $Global:ScriptLogger.Level = $Level
        }

        if ($PSBoundParameters.ContainsKey('Encoding'))
        {
            $Global:ScriptLogger.Encoding = $Encoding
        }

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $Global:ScriptLogger.LogFile = $LogFile
        }

        if ($PSBoundParameters.ContainsKey('EventLog'))
        {
            $Global:ScriptLogger.EventLog = $EventLog
        }

        if ($PSBoundParameters.ContainsKey('ConsoleOutput'))
        {
            $Global:ScriptLogger.ConsoleOutput = $ConsoleOutput
        }
    }
}
