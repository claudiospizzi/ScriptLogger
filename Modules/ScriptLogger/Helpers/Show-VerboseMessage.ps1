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
    PS C:\> Show-VerboseMessage -Message 'My Verbose Message'
    Show the verbose message.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Show-VerboseMessage
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
