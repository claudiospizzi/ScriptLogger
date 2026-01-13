<#
    .SYNOPSIS
        Stop the script logger in the current PowerShell session.

    .DESCRIPTION
        Stop the script logger in the current PowerShell session and clear all
        log configurations.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Stop-ScriptLogger
        Stop the default logger.

    .EXAMPLE
        PS C:\> Stop-ScriptLogger -Name 'MyLogger'
        Stop the custom logger.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Stop-ScriptLogger
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default'
    )

    if ($Script:Loggers.ContainsKey($Name))
    {
        if ($PSCmdlet.ShouldProcess('ScriptLogger', 'Stop'))
        {
            Microsoft.PowerShell.Utility\Write-Verbose "Stop script logger '$Name'"

            $Script:Loggers.Remove($Name)
        }
    }
}
