
# Initialize the logger with default values
Start-ScriptLogger

# Alternative: Specify all possible parameters for the logger. Of course, this
# will not log anything, if you disable the log file, the event log and the
# console output at the same time.
Start-ScriptLogger -Path 'C:\Temp\test.log' -Format '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}' -Level 'Verbose' -NoLogFile -NoEventLog -NoConsoleOutput

# Log an error message
Write-ErrorLog -Message 'My Error Message'

# Log a warning massage
Write-WarningLog -Message 'My Warning Message'

# Log an information message
Write-InformationLog -Message 'My Information Message'

# Log a verbose message
Write-VerboseLog -Message 'My Verbose Message'

# Disable the logger
Stop-ScriptLogger
