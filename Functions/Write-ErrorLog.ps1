<#
.SYNOPSIS
    Log an error message.

.DESCRIPTION
    Log an error message to the log file, the event log and show it on the
    current console.

.PARAMETER Message
    The error message

.EXAMPLE
    C:\> Write-ErrorLog -Message 'My Error Message'
    Log the error message.

.NOTES
    Author     : Claudio Spizzi
    License    : MIT License

.LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Write-ErrorLog
{
    [CmdletBinding(DefaultParameterSetName='Message')]
    param
    (
        [Parameter(Mandatory=$true,
                   ParameterSetName='Message')]
        [String] $Message,

        [Parameter(Mandatory=$true,
                   ParameterSetName='ErrorRecord')]
        [System.Management.Automation.ErrorRecord] $ErrorRecord
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
