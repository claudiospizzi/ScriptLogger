<#
.SYNOPSIS
    Shows an information message on the PowerShell host.

.DESCRIPTION
    Uses the internal .NET method () of the host UI class to show
    the information message on the console.

.PARAMETER Message
    The information message.

.EXAMPLE
    C:\> Show-InformationMessage -Message 'My Information Message'
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
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    $Host.UI.WriteLine("INFORMATION: $Message")
}
