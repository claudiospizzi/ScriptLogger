<#
    .SYNOPSIS
        Writes a platform specific event log.

    .DESCRIPTION
        Writes a log entry to the Windows Event Log or Linux syslog.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Write-ScriptLoggerLog -Level 'Warning' -Message 'My Warning Message'
        Log the warning message.

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Write-ScriptLoggerPlatformLog
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
        $Level,

        # The Windows event log name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $EventLogName = 'Windows PowerShell',

        # The Windows event log source.
        [Parameter(Mandatory = $false)]
        [System.String]
        $EventLogSource = 'PowerShell',

        # The Windows event log ID.
        [Parameter(Mandatory = $false)]
        [System.Int32]
        $EventLogId = 0,

        # The Windows event log category.
        [Parameter(Mandatory = $false)]
        [System.Int32]
        $EventLogCategory = 0,

        # The Linux syslog tag.
        [Parameter(Mandatory = $false)]
        [System.String]
        $SystemLogTag = 'PowerShell'
    )

    # Windows (Windows PowerShell, PowerShell 6+ on Windows)
    if ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows)
    {
        switch ($Level)
        {
            'Verbose'     { $eventLogEntryType = 'Information' }
            'Information' { $eventLogEntryType = 'Information' }
            'Warning'     { $eventLogEntryType = 'Warning' }
            'Error'       { $eventLogEntryType = 'Error' }
        }

        $writeEventLogSplat = @{
            LogName   = $EventLogName
            Source    = $EventLogSource
            EventId   = $EventLogId
            Category  = $EventLogCategory
            EntryType = $eventLogEntryType
            Message   = $Message
        }
        Write-EventLog @writeEventLogSplat -ErrorAction 'Stop'
    }

    # Linux (PowerShell 6+ on Linux)
    if ($PSVersionTable.PSVersion.Major -ge 6 -and $IsLinux)
    {
        switch ($Level)
        {
            'Verbose'     { $systemLogPriority = 'user.info' }
            'Information' { $systemLogPriority = 'user.notice' }
            'Warning'     { $systemLogPriority = 'user.warning' }
            'Error'       { $systemLogPriority = 'user.err' }
        }

        logger -t $SystemLogTag -p $systemLogPriority $Message
    }
}
