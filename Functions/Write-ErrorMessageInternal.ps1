<#
.SYNOPSIS
    Write error to host.

.DESCRIPTION
    Use the internal .NET method WriteErrorLine() of the host class to write an
    error to the console host.

.PARAMETER Message
    The error message.

.EXAMPLE
    C:\> Write-HostErrorLine -Message 'My Error Message'
    Log the error message.
#>

function Write-HostErrorLine
{
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    $Host.UI.WriteErrorLine("ERROR: $Message")
}
