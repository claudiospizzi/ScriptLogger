<#
.SYNOPSIS
    

.DESCRIPTION
    

.PARAMETER Message
    

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
#>

function Write-ErrorLog
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message
    )

    Write-Log -Message $Message -Level 'Error'
}
