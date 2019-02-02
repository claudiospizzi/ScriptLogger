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

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>

function Write-WarningLog
{
    [CmdletBinding()]
    param
    (
        # The warning message.
        [Parameter(Mandatory=$true)]
        [System.String]
        $Message
    )

    Write-Log -Message $Message -Level 'Warning'
}
