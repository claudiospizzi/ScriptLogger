<#
    .SYNOPSIS
        Shows a verbose message on the PowerShell host.

    .DESCRIPTION
        Uses the internal .NET method WriteVerboseLine() of the host UI class to
        show the verbose message on the console.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Show-ScriptLoggerVerboseMessage -Message 'My Verbose Message'
        Show the verbose message.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Show-ScriptLoggerVerboseMessage
{
    param
    (
        # The verbose message.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    $Host.UI.WriteVerboseLine($Message)
}
