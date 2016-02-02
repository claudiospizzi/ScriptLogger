[![Build status](https://ci.appveyor.com/api/projects/status/syyabalhc1ivgei7/branch/master?svg=true)](https://ci.appveyor.com/project/claudiospizzi/scriptlogger/branch/master) [![Build status](https://ci.appveyor.com/api/projects/status/syyabalhc1ivgei7/branch/dev?svg=true)](https://ci.appveyor.com/project/claudiospizzi/scriptlogger/branch/dev)

# ScriptLogger PowerShell Module
PowerShell Module to provide logging capabilities for PowerShell Controller Scripts.


## Introduction

With the ScriptLogger module, you are able to log error, warning, informational and verbose log messages into log files, the event log and the console host.


## Requirenments

The following minimum requirenments are necessary to use the module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7


## Installation

Install the module **automatically** from the [PowerShell Gallery](https://www.powershellgallery.com/packages/ScriptLogger) with PowerShell 5.0:

```powershell
Install-Module ScriptLogger
```

To install the module **manually**, perform the following steps:

1. Download the latest release from [GitHub](https://github.com/claudiospizzi/ScriptLogger/releases) as a ZIP file
2. Extract the downloaded module into one of your module paths ([TechNet: Installing Modules](https://technet.microsoft.com/en-us/library/dd878350))


## Cmdlets

The module has for cmdlets to manage the logger configuration and four cmdlets to write messages with different levels:

| Cmdlet                  | Description                                                     |
| ----------------------- | --------------------------------------------------------------- |
| `Start-ScriptLogger`    | Start the script logger inside the current PowerShell session.  |
| `Stop-ScriptLogger`     | Stop the script logger inside the current PowerShell session.   |
| `Set-ScriptLogger`      | Update the script logger log configuration.                     |
| `Get-ScriptLogger`      | Get the current script logger object.                           |
| `Write-VerboseLog`      | Log a verbose message.                                          |
| `Write-InformationLog`  | Log an information message.                                     |
| `Write-WarningLog`      | Log a warning message.                                          |
| `Write-ErrorLog`        | Log an error message.                                           |



## Examples

The following example show two options how to start the script logger, the logger management and how to log the log messages.

```powershell
# Initialize the logger with default values
Start-ScriptLogger

# Second options, specify multiple custom settings for the logger
Start-ScriptLogger -Path 'C:\Temp\test.log' -Format '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}' -Level Warning -SkipEventLog -HideConsoleOutput

# Get the current script logger configuration object
Get-ScriptLogger

# Update the script logger configuration
Set-ScriptLogger -Level Verbose

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
```


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
