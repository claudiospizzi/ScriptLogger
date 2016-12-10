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
    [CmdletBinding(SupportsShouldProcess = $true)]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param
    (
    )

    if ($null -ne $Global:ScriptLogger)
    {
        if ($PSCmdlet.ShouldProcess('ScriptLogger', 'Stop'))
        {
            Remove-Variable -Scope Global -Name ScriptLogger -Force
        }
    }
}
