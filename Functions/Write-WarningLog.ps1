<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER Message
    

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
#>

function Write-WarningLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Warning'
}
