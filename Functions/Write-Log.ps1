<#
.SYNOPSIS
    Log a message with the specified log level.

.DESCRIPTION
    If the specified log level is higher as the configured log level, the
    message will be logged to the enabled destinations. These are the specified
    log file, the PowerShell event log and the current PowerShell console.

.PARAMETER Message
    The message to log.

.PARAMETER Level
    The log level to use.

.EXAMPLE
    C:\> Write-WarningLog -Message 'My Warning Message' -Level Warning
    Log the warning message.
#>

function Write-Log
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String] $Message,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [String] $Level
    )

    $ScriptLogger = Get-ScriptLogger

    # Check if the logging is setup and enabled
    if (($ScriptLogger -ne $null) -and ($ScriptLogger.Enabled -eq $true))
    {
        $LevelMap = @{
            'Verbose'     = 0
            'Information' = 1
            'Warning'     = 2
            'Error'       = 3
        }

        # Check the logging level
        if ($LevelMap[$Level] -ge $LevelMap[$ScriptLogger.Level])
        {
            if ($ScriptLogger.LogFile)
            {
                # Output to log file
                $Line = $ScriptLogger.Format -f (Get-Date), $env:ComputerName, $Env:Username, $Level, $Message
                $Line | Out-File -FilePath $ScriptLogger.Path -Append
            }

            if ($ScriptLogger.EventLog)
            {
                if ($Level -eq 'Verbose')
                {
                    $EntryType = 'Information'
                }
                else
                {
                    $EntryType = $Level
                }

                # Output to event log
                Write-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -EventId 0 -Category 0 -EntryType $EntryType -Message $Message
            }

            # Output to console
            if ($ScriptLogger.ConsoleOutput)
            {
                switch ($Level)
                {
                    'Verbose'     { Write-Verbose -Message $Message }
                    'Information' { try { Write-Information -MessageData $Message } catch { Write-Host $Message } }
                    'Warning'     { Write-Warning -Message $Message }
                    'Error'       { Write-Error -Message $Message }
                }
            }
        }
    }
}
