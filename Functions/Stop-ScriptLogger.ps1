<#
.SYNOPSIS
    

.DESCRIPTION
    

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
#>

function Stop-ScriptLogger
{
    [CmdletBinding()]
    param
    (
    )

    if ($Global:ScriptLogger -ne $null)
    {
        Remove-Variable -Scope Global -Name ScriptLogger -Force
    }
}
