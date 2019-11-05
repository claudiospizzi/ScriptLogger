<#
    .SYNOPSIS
        Log a message with the specified log level.

    .DESCRIPTION
        If the specified log level is higher as the configured log level, the
        message will be logged to the enabled destinations. These are the
        specified log file, the PowerShell event log and the current PowerShell
        console.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-Log -Name 'Default' -Message 'My Warning Message' -Level Warning
        Log the warning message.

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>

function Write-Log
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # The logger name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # The message to log.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message,

        # The log level to use.
        [Parameter(Mandatory = $true)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [System.String]
        $Level
    )

    if ($Script:Loggers.ContainsKey($Name))
    {
        $logger = $Script:Loggers[$Name]

        # Check if the logging enabled
        if ($logger.Enabled)
        {
            $levelMap = @{
                'Verbose'     = 0
                'Information' = 1
                'Warning'     = 2
                'Error'       = 3
            }

            # Check the logging level: The requested level needs to be equals or higher than the configured level
            if ($levelMap[$Level] -ge $levelMap[$logger.Level])
            {
                if ($logger.LogFile -and $PSCmdlet.ShouldProcess('LogFile', 'Write Log'))
                {
                    try
                    {
                        # Output to log file
                        $line = $logger.Format -f (Get-Date), $env:ComputerName, $Env:Username, $Level, $Message
                        $line | Out-File -FilePath $logger.Path -Encoding $logger.Encoding -Append -ErrorAction Stop
                    }
                    catch
                    {
                        Write-Warning "ScriptLogger '$Name' module error during write log file: $_"
                    }
                }

                if ($logger.EventLog -and $PSCmdlet.ShouldProcess('EventLog', 'Write Log'))
                {
                    $entryType = $Level.Replace('Verbose', 'Information')

                    try
                    {
                        # Output to event log
                        Write-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -EventId 0 -Category 0 -EntryType $entryType -Message $Message -ErrorAction Stop
                    }
                    catch
                    {
                        Write-Warning "ScriptLogger '$Name' module error during write event log: $_"
                    }
                }

                if ($logger.ConsoleOutput -and $PSCmdlet.ShouldProcess('ConsoleOutput', 'Write Log'))
                {
                    switch ($Level)
                    {
                        'Verbose'     { Show-VerboseMessage -Message $Message }
                        'Information' { Show-InformationMessage -Message $Message }
                        'Warning'     { Show-WarningMessage -Message $Message }
                        'Error'       { Show-ErrorMessage -Message $Message }
                    }
                }
            }
        }
    }
    else
    {
        Write-Warning "ScriptLogger '$Name' not found. No logs written."
    }
}
