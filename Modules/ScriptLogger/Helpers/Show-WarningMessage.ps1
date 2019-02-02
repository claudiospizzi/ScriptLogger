<#
    .SYNOPSIS
        Shows a warning message on the PowerShell host.

    .DESCRIPTION
        Uses the internal .NET method WriteWarningLine() of the host UI class to
        show the warning message on the console.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Show-WarningMessage -Message 'My Warning Message'
        Show the warning message.

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>

function Show-WarningMessage
{
    param
    (
        # The warning message.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    $Host.UI.WriteWarningLine($Message)
}
