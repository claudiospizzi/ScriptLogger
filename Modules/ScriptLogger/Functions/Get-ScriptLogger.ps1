<#
    .SYNOPSIS
    Get the current script logger.

    .DESCRIPTION
    Returns an object with the current configuration of the script logger inside
    this PowerShell session.

    .INPUTS
    None.

    .OUTPUTS
    ScriptLogger.Configuration. Configuration of the script logger instance.

    .EXAMPLE
    PS C:\> Get-ScriptLogger
    Get the current script logger object.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Get-ScriptLogger
{
    [CmdletBinding()]
    param
    (
    )

    if ($null -ne $Global:ScriptLogger)
    {
        return $Global:ScriptLogger
    }
    else
    {
        throw 'Script logger not found!'
    }
}
