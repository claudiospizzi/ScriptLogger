<#
.SYNOPSIS
    Get the current script logger.

.DESCRIPTION
    Returns an object with the current configuration of the script logger
    inside this PowerShell session.

.EXAMPLE
    C:\> Get-ScriptLogger
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

    if ($Global:ScriptLogger -ne $null)
    {
        return $Global:ScriptLogger
    }
    else
    {
        throw 'Script logger not found!'
    }
}
