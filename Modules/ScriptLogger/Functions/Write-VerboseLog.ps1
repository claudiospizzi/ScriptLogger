<#
    .SYNOPSIS
        Log a verbose message.

    .DESCRIPTION
        Log a verbose message to the log file, the event log and show it on the
        current console. If the global log level is set to 'information', no
        verbose message will be logged.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-VerboseLog -Message 'My Verbose Message'
        Log the verbose message.

    .EXAMPLE
        PS C:\> Write-VerboseLog -Name 'MyLogger' -Message 'My Verbose Message'
        Log the verbose message in a custom logger.

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
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

        # The verbose message.
        [Parameter(Mandatory=$true)]
        [System.String]
        $Message
    )

    Write-Log -Name $Name -Message $Message -Level 'Verbose'
}
