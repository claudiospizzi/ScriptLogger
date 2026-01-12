<#
    .SYNOPSIS
        Get the current script logger.

    .DESCRIPTION
        Returns an object with the current configuration of the script logger
        inside this PowerShell session.

    .INPUTS
        None.

    .OUTPUTS
        ScriptLogger.Configuration. Configuration of the script logger instance.

    .EXAMPLE
        PS C:\> Get-ScriptLogger
        Get all script loggers.

    .EXAMPLE
        PS C:\> Get-ScriptLogger -Name 'MyLogger'
        Get the custom script logger.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Get-ScriptLogger
{
    [CmdletBinding()]
    param
    (
        # The logger name filter.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name
    )

    $selectedLoggers = $Script:Loggers.Values

    if ($PSBoundParameters.ContainsKey('Name'))
    {
        $selectedLoggers = $selectedLoggers | Where-Object { $_.Name -like $Name }
    }

    Write-Output $selectedLoggers
}
