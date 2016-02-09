<#
.SYNOPSIS
    Log a verbose message.

.DESCRIPTION
    Log a verbose message to the log file, the event log and show it on the
    current console. If the global log level is set to 'information', no
    verbose message will be logged.

.PARAMETER Message
    The verbose message

.EXAMPLE
    C:\> Write-VerboseLog -Message 'My Verbose Message'
    Log the verbose message.

.NOTES
    Author     : Claudio Spizzi
    License    : MIT License

.LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Write-VerboseLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Verbose'
}
