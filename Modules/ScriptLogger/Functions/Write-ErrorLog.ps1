<#
    .SYNOPSIS
    Log an error message.

    .DESCRIPTION
    Log an error message to the log file, the event log and show it on the
    current console. It can also use an error record conataining an exception
    as input. The exception will be converted into a log message.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Write-ErrorLog -Message 'My Error Message'
    Log the error message.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Write-ErrorLog
{
    [CmdletBinding(DefaultParameterSetName = 'Message')]
    param
    (
        # The error message.
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [System.String]
        $Message,

        # The error record containing an exception to log.
        [Parameter(Mandatory = $true, ParameterSetName = 'ErrorRecord')]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    # Extract error message and invocation info from error record object
    if ($PSCmdlet.ParameterSetName -eq 'ErrorRecord')
    {
        $Message = '{0} ({1}: {2}:{3} char:{4})' -f $ErrorRecord.Exception.Message,
                                                    $ErrorRecord.FullyQualifiedErrorId,
                                                    $ErrorRecord.InvocationInfo.ScriptName,
                                                    $ErrorRecord.InvocationInfo.ScriptLineNumber,
                                                    $ErrorRecord.InvocationInfo.OffsetInLine
    }

    Write-Log -Message $Message -Level 'Error'
}
