<#
.SYNOPSIS
    Log an error message.

.DESCRIPTION
    Log an error message to the log file, the event log and show it on the
    current console.

.PARAMETER Message
    The error message

.EXAMPLE
    C:\> Write-ErrorLog -Message 'My Error Message'
    Log the error message.
#>

function Write-ErrorLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Error'
}
