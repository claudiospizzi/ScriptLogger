<#
    .SYNOPSIS
    Update the script logger log configuration.

    .DESCRIPTION
    The script logger inside the current PowerShell session can be updated with
    all parameters inside this cmdlet.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Set-ScriptLogger -Level 'Warning' -EventLog $true
    Set the script logger level to warning and enable the event log output.

    .EXAMPLE
    PS C:\> Set-ScriptLogger -Path 'C:\Temp\test.log' -Format '{3}: {4}'
    Update the log file path and its format.

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
        # Update the path to the log file.
        [Parameter(Mandatory = $false)]
        [ValidateScript({Test-Path -Path (Split-Path -Path $_ -Parent)})]
        [System.String]
        $Path,

        # Update the format for the log file.
        [Parameter(Mandatory = $false)]
        [ValidateScript({$_ -f (Get-Date), $Env:ComputerName, $Env:Username, 'Verbose', 'My Message'})]
        [System.String]
        $Format,

        # Update the logger level.
        [Parameter(Mandatory = $false)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [System.String]
        $Level,

        # Update the used log file encoding.
        [Parameter(Mandatory = $false)]
        [ValidateSet('Unicode', 'UTF7', 'UTF8', 'UTF32', 'ASCII', 'BigEndianUnicode', 'Default', 'OEM')]
        [System.String]
        $Encoding,

        # Enable or disable the log file output.
        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $LogFile,

        # Enable or disable the event log output.
        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $EventLog,

        # Enable or disable the console output.
        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $ConsoleOutput
    )

    if ($null -ne $Global:ScriptLogger)
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
