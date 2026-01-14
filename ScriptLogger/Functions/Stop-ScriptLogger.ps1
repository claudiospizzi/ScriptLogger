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
            Microsoft.PowerShell.Utility\Write-Debug "Stop script logger '$Name'"

            # Cleanup the aliases for the default logger, if set.
            if ($Script:Loggers[$Name].OverrideStream)
            {
                $aliasNames = 'Write-Verbose', 'Write-Information', 'Write-Warning', 'Write-Error'

                foreach ($aliasName in $aliasNames)
                {
                    $removeAliasCommand = [System.Management.Automation.ScriptBlock]::Create("Get-Alias -Scope 'Global' | Where-Object { `$_.Name -eq '$aliasName' } | Remove-Alias -ErrorAction 'SilentlyContinue'")
                    $Script:Loggers[$Name].SessionState.InvokeCommand.InvokeScript($Script:Loggers[$Name].SessionState, $removeAliasCommand, $null)
                }
            }

            # Log stop message
            if (-not $Script:Loggers[$Name].SkipStartStop)
            {
                Write-ScriptLoggerLog -Name $Name -Level 'Verbose' -Message 'PowerShell log stopped'
            }

            $Script:Loggers.Remove($Name)
        }
    }
}
