<#
    .SYNOPSIS
    Log a message with the specified log level.

    .DESCRIPTION
    If the specified log level is higher as the configured log level, the
    message will be logged to the enabled destinations. These are the specified
    log file, the PowerShell event log and the current PowerShell console.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Write-WarningLog -Message 'My Warning Message' -Level Warning
    Log the warning message.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/ScriptLogger
#>

function Write-Log
{
    [CmdletBinding()]
    param
    (
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

    $ScriptLogger = Get-ScriptLogger

    # Check if the logging is setup and enabled
    if (($null -ne $ScriptLogger) -and ($ScriptLogger.Enabled -eq $true))
    {
        $LevelMap = @{
            'Verbose'     = 0
            'Information' = 1
            'Warning'     = 2
            'Error'       = 3
        }

        # Check the logging level: The requested level needs to be equals or higher than the configured level
        if ($LevelMap[$Level] -ge $LevelMap[$ScriptLogger.Level])
        {
            if ($ScriptLogger.LogFile)
            {
                try
                {
                    # Output to log file
                    $Line = $ScriptLogger.Format -f (Get-Date), $env:ComputerName, $Env:Username, $Level, $Message
                    $Line | Out-File -FilePath $ScriptLogger.Path -Encoding $ScriptLogger.Encoding -Append -ErrorAction Stop
                }
                catch
                {
                    Write-Error "ScriptLogger module error during write log file: $_"
                }
            }

            if ($ScriptLogger.EventLog)
            {
                $EntryType = $Level.Replace('Verbose', 'Information')

                try
                {
                    # Output to event log
                    Write-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -EventId 0 -Category 0 -EntryType $EntryType -Message $Message -ErrorAction Stop
                }
                catch
                {
                    Write-Error "ScriptLogger module error during write event log: $_"
                }
            }

            if ($ScriptLogger.ConsoleOutput)
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
