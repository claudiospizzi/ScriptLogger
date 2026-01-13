<#
    .SYNOPSIS
        Log an information message.

    .DESCRIPTION
        Log an information message to the log file, the event log and show it on
        the current console. If the global log level is set to 'warning', no
        information message will be logged.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-InformationLog -Message 'My Information Message'
        Log the information message.

    .EXAMPLE
        PS C:\> Write-InformationLog -Name 'MyLogger' -Message 'My Information Message'
        Log the information message in a custom logger.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Write-InformationLog
{
    [CmdletBinding()]
    param
    (
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

        # The information message.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [System.String[]]
        $Message
    )

    process
    {
        foreach ($currentMessage in $Message)
        {
            Write-ScriptLoggerLog -Name $Name -Message $currentMessage -Level 'Information'
        }
    }
}
