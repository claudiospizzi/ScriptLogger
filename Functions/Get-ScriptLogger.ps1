<#
.SYNOPSIS
    

.DESCRIPTION
    

.EXAMPLE
    C:\>

.EXAMPLE
    C:\>
#>

function Get-ScriptLogger
{
    [CmdletBinding()]
    param
    (
    )

    if ($Global:ScriptLogger -ne $null)
    {
        return $Global:ScriptLogger
    }
    else
    {
        throw 'Script logger not found!'
    }
}
