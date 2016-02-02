<#
.SYNOPSIS
    Log a warning message.

.DESCRIPTION
    Log a warning message to the log file, the event log and show it on the
    current console. If the global log level is set to 'error', no warning
    message will be logged.

.PARAMETER Message
    The warning message

.EXAMPLE
    C:\> Write-WarningLog -Message 'My Warning Message'
    Log the warning message.
#>

function Write-WarningLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Warning'
}
