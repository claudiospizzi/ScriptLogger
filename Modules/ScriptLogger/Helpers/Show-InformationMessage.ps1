<#
    .SYNOPSIS
        Shows an information message on the PowerShell host.

    .DESCRIPTION
        Uses the internal .NET method () of the host UI class to show the
        information message on the console.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Show-InformationMessage -Message 'My Information Message'
        Show the information message.

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>

function Show-InformationMessage
{
    param
    (
        # The information message.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    # A method WriteErrorLine() is not available, so add the prefix INFORMATION:
    # and use the default method WriteLine().
    $Host.UI.WriteLine("INFORMATION: $Message")
}
