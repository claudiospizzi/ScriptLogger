<#
    .SYNOPSIS
        Shows an error message on the PowerShell host.

    .DESCRIPTION
        Uses the internal .NET method WriteErrorLine() of the host UI class to
        show the error message on the console.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Show-ErrorMessage -Message 'My Error Message'
        Show the error message.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Show-ErrorMessage
{
    param
    (
        # The error message.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message
    )

    # Add the prefix ERROR: because WriteErrorLine() does not write it itself.
    $Host.UI.WriteErrorLine("ERROR: $Message")
}
