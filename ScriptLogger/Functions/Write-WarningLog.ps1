<#
    .SYNOPSIS
        Log a warning message.

    .DESCRIPTION
        Log a warning message to the log file, the event log and show it on the
        current console. If the global log level is set to 'error', no warning
        message will be logged.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-WarningLog -Message 'My Warning Message'
        Log the warning message.

    .EXAMPLE
        PS C:\> Write-WarningLog -Name 'MyLogger' -Message 'My Warning Message'
        Log the warning message in a custom logger.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Write-WarningLog
{
    [CmdletBinding()]
    param
    (
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

        # The warning message.
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline = $true)]
        [System.String[]]
        $Message
    )

    process
    {
        foreach ($currentMessage in $Message)
        {
            Write-ScriptLoggerLog -Name $Name -Message $currentMessage -Level 'Warning'
        }
    }
}
