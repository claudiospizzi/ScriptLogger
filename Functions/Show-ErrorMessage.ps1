<#
.SYNOPSIS
    Shows an error message on the PowerShell host.

.DESCRIPTION
    Uses the internal .NET method WriteErrorLine() of the host UI class to show
    the error message on the console.

.PARAMETER Message
    The error message.

.EXAMPLE
    C:\> Show-ErrorMessage -Message 'My Error Message'
    Show the error message.

.NOTES
    Author     : Claudio Spizzi
    License    : MIT License

.LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Show-ErrorMessage
{
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    $Host.UI.WriteErrorLine("ERROR: $Message")
}
