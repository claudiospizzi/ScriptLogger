<#
.SYNOPSIS
    Stop the script logger inside the current PowerShell session.

.DESCRIPTION
    Stop the script logger inside the current PowerShell session and clear all
    log configurations.

.EXAMPLE
    C:\> Stop-ScriptLogger
    Stop the current logger.
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
