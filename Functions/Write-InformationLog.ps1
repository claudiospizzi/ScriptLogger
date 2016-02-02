<#
.SYNOPSIS
    Log an information message.

.DESCRIPTION
    Log an information message to the log file, the event log and show it on
    the current console. If the global log level is set to 'warning', no
    information message will be logged.

.PARAMETER Message
    The information message

.EXAMPLE
    C:\> Write-InformationLog -Message 'My Information Message'
    Log the information message.
#>

function Write-InformationLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Information'
}
