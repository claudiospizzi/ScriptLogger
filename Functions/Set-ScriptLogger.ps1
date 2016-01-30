<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER Path
    

.PARAMETER Format
    

.PARAMETER Level
    

.PARAMETER Enabled
    

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
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
        [Boolean] $LogFile,

        [Parameter(Position=4,
                   Mandatory=$false)]
        [Boolean] $EventLog,

        [Parameter(Position=5,
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
