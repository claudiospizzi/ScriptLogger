<#
    .SYNOPSIS
        Log an error message.

    .DESCRIPTION
        Log an error message to the log file, the event log and show it on the
        current console. It can also use an error record conataining an
        exception as input. The exception will be converted into a log message.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-ErrorLog -Message 'My Error Message'
        Log the error message.

    .EXAMPLE
        PS C:\> Write-ErrorLog -Name 'MyLogger' -Message 'My Error Message'
        Log the error message in a custom logger.

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
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

        # The error message.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'Message')]
        [System.String[]]
        $Message,

        # The error record containing an exception to log.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'ErrorRecord')]
        [System.Management.Automation.ErrorRecord[]]
        $ErrorRecord
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Message')
        {
            foreach ($currentMessage in $Message)
            {
                Write-Log -Name $Name -Message $currentMessage -Level 'Error'
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'ErrorRecord')
        {
            foreach ($currentErrorRecord in $ErrorRecord)
            {
                $currentMessage = '{0} ({1}: {2}:{3} char:{4})' -f $currentErrorRecord.Exception.Message,
                                                                   $currentErrorRecord.FullyQualifiedErrorId,
                                                                   $currentErrorRecord.InvocationInfo.ScriptName,
                                                                   $currentErrorRecord.InvocationInfo.ScriptLineNumber,
                                                                   $currentErrorRecord.InvocationInfo.OffsetInLine

                Write-Log -Name $Name -Message $currentMessage -Level 'Error'
            }
        }
    }
}
