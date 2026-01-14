<#
    .SYNOPSIS
        Log an error message.

    .DESCRIPTION
        Log an error message to the log file, the event log and show it on the
        current console. It can also use an error record containing an
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

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Write-ErrorLog
{
    [CmdletBinding(DefaultParameterSetName = 'Message')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The parameter -RemainingArguments is require to mock the Write-Error stream command.')]
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

        # The exception to log.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'Exception')]
        [System.Exception[]]
        $Exception,

        # The error record to log.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'ErrorRecord')]
        [System.Management.Automation.ErrorRecord[]]
        $ErrorRecord,

        # Include the stack trace in the error log message.
        [Parameter(Mandatory = $false, ParameterSetName = 'ErrorRecord')]
        [Switch]
        $IncludeStackTrace,

        # Remaining arguments to ignore any additional input if mocking the
        # Write-Error stream command.
        [Parameter(ValueFromRemainingArguments = $true)]
        [System.String[]]
        $RemainingArguments
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Message')
        {
            foreach ($currentMessage in $Message)
            {
                Write-ScriptLoggerLog -Name $Name -Message $currentMessage -Level 'Error'
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Exception')
        {
            foreach ($currentException in $Exception)
            {
                $currentMessage = '{0} ({1})' -f $currentException.Message, $currentException.GetType().FullName

                Write-ScriptLoggerLog -Name $Name -Message $currentMessage -Level 'Error'
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

                if ($IncludeStackTrace.IsPresent)
                {
                    $currentMessage += [System.Environment]::NewLine
                    $currentMessage += $currentErrorRecord.ScriptStackTrace
                }

                Write-ScriptLoggerLog -Name $Name -Message $currentMessage -Level 'Error'
            }
        }
    }
}
