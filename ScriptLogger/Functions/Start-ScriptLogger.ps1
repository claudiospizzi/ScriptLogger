<#
    .SYNOPSIS
        Start the script logger in the current PowerShell session.

    .DESCRIPTION
        Start the script logger in the current PowerShell session. By starting
        the logger, a global log configuration for the current PowerShell
        session will be set. This configuration is customizable with the
        available paramters.
        With the format parameter, the logfile format can be defined. The format
        definition will be used to call the System.String.Format() method. The
        following values are used as arguments:
        - {0} Timestamp as datetime value.
        - {1} NetBIOS computer name.
        - {2} Current session username.
        - {3} Log entry level.
        - {4} Message.

    .INPUTS
        None.

    .OUTPUTS
        ScriptLogger.Configuration. Configuration of the script logger instance.

    .EXAMPLE
        PS C:\> Start-ScriptLogger
        Initialize the logger with default values.

    .EXAMPLE
        PS C:\> Start-ScriptLogger -Name 'MyLogger' -Path 'C:\my.log'
        Start a custom named logger instance.

    .EXAMPLE
        PS C:\> Start-ScriptLogger -Path 'C:\test.log' -Format '{3}: {4}' -Level 'Verbose' -SkipEventLog -HideConsoleOutput
        Log all message with verbose level or higher to the log file but skip
        the event log and the consule output. In addition, use a custom format
        for the log file content.

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/ScriptLogger
#>
function Start-ScriptLogger
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # The logger name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

        # The path to the log file.
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [System.String]
        $Path,

        # This parameter defines, how the log output will be formated.
        [Parameter(Mandatory = $false)]
        [ValidateScript({$_ -f (Get-Date), $Env:ComputerName, $Env:Username, 'Verbose', 'Message'})]
        [System.String]
        $Format = '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}',

        # The event log level. All log messages equal to or higher to the level
        # will be logged. This is the level order: Verbose, Information, Warning
        # and Error.
        [Parameter(Mandatory = $false)]
        [ValidateSet('Verbose', 'Information', 'Warning', 'Error')]
        [System.String]
        $Level = 'Verbose',

        # Define the encoding which is used to write the log file. The possible
        # options are the same as on the used Out-File cmdlet.
        [Parameter(Mandatory = $false)]
        [ValidateSet('Unicode', 'UTF7', 'UTF8', 'UTF32', 'ASCII', 'BigEndianUnicode', 'Default', 'OEM')]
        [System.String]
        $Encoding = 'UTF8',

        # Allow the auto log rotation. The period is attached to the log file.
        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'Hourly', 'Daily', 'Monthly', 'Yearly')]
        [System.String]
        $Rotation = 'None',

        # Do not write the log messages into the log file. By default, all
        # messages are written to the specified or default log file.
        [Parameter(Mandatory = $false)]
        [Switch]
        $NoLogFile,

        # Skip the event log output. By default, all log messages will be
        # written into the "Windows PowerShell" event log.
        [Parameter(Mandatory = $false)]
        [Switch]
        $NoEventLog,

        # Hide the PowerShell console output. By default, all log messages are
        # shown on the console.
        [Parameter(Mandatory = $false)]
        [Switch]
        $NoConsoleOutput,

        # If specified, the created script logger object will be returned.
        [Parameter(Mandatory = $false)]
        [Switch]
        $PassThru
    )

    # If the Path parameter was not specified, add a default value. If possible,
    # use the last script called this function. Else use the temp path.
    if (-not $PSBoundParameters.ContainsKey('Path') -or [System.String]::IsNullOrEmpty($Path))
    {
        $lastScriptPath = Get-PSCallStack | Select-Object -Skip 1 -First 1 -ExpandProperty 'ScriptName'

        if (-not [System.String]::IsNullOrEmpty($lastScriptPath))
        {
            $Path = $lastScriptPath + '.log'
        }
        else
        {
            $Path = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'PowerShell.log'
        }
    }

    # If log rotation is enable, add the current period to the path
    switch ($Rotation)
    {
        'Hourly'
        {
            $Path = $Path.Insert($Path.LastIndexOf('.'), [System.String]::Format('.{0:yyyyMMddHH}', (Get-Date)))
        }
        'Daily'
        {
            $Path = $Path.Insert($Path.LastIndexOf('.'), [System.String]::Format('.{0:yyyyMMdd}', (Get-Date)))
        }
        'Monthly'
        {
            $Path = $Path.Insert($Path.LastIndexOf('.'), [System.String]::Format('.{0:yyyyMM}', (Get-Date)))
        }
        'Yearly'
        {
            $Path = $Path.Insert($Path.LastIndexOf('.'), [System.String]::Format('.{0:yyyy}', (Get-Date)))
        }
    }

    # Create the log file folder, if it does not exist
    $parent = Split-Path -Path $Path -Parent
    if (-not (Test-Path -Path $parent))
    {
        try
        {
            New-Item -Path $parent -ItemType 'Directory' -ErrorAction 'Stop' | Out-Null
        }
        catch
        {
            throw "ScriptLogger failed to create the log folder: $parent"
        }
    }

    # Create an empty log file, if it does not exist
    if (-not (Test-Path -Path $Path))
    {
        try
        {
            New-Item -Path $Path -ItemType 'File' -ErrorAction 'Stop' | Out-Null
        }
        catch
        {
            throw "ScriptLogger failed to create the log file: $Path"
        }
    }

    # Only work with absolute path, makes error handling easier
    $Path = (Resolve-Path -Path $Path).Path

    if ($PSCmdlet.ShouldProcess('ScriptLogger', 'Start'))
    {
        Write-Verbose "Start script logger '$Name'"

        $Script:Loggers[$Name] = [PSCustomObject] @{
            PSTypeName    = 'ScriptLogger.Configuration'
            Name          = $Name
            Enabled       = $true
            Path          = $Path
            Format        = $Format
            Level         = $Level
            Encoding      = $Encoding
            Rotation      = $Rotation
            LogFile       = -not $NoLogFile.IsPresent
            EventLog      = -not $NoEventLog.IsPresent
            ConsoleOutput = -not $NoConsoleOutput.IsPresent
        }

        # Return logger object
        if ($PassThru.IsPresent)
        {
            Write-Output $Script:Loggers[$Name]
        }
    }
}
