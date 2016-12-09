<#
    .SYNOPSIS
    Stop the script logger inside the current PowerShell session.

    .DESCRIPTION
    Stop the script logger inside the current PowerShell session and clear all
    log configurations.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Stop-ScriptLogger
    Stop the current logger.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/ScriptLogger
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
