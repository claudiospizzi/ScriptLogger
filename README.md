[![PowerShell Gallery - ScriptLogger](https://img.shields.io/badge/PowerShell_Gallery-ScriptLogger-0072C6.svg)](https://www.powershellgallery.com/packages/ScriptLogger)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/ScriptLogger.svg)](https://github.com/claudiospizzi/ScriptLogger/releases)
[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/ScriptLogger/master.svg)](https://ci.appveyor.com/project/claudiospizzi/ScriptLogger/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/ScriptLogger/dev.svg)](https://ci.appveyor.com/project/claudiospizzi/ScriptLogger/branch/dev)

# ScriptLogger PowerShell Module

PowerShell Module to provide logging capabilities for PowerShell controller
scripts.

## Introduction

With the ScriptLogger module, you are able to log error, warning, informational
and verbose messages into log files, the Windows event log and the current
console host. You can start and stop the logger as required. Works great in
cooperation with the [ScriptConfig] module to improve controller scripts.

## Features

* **Start-ScriptLogger**  
  Start the script logger in the active PowerShell session.

* **Stop-ScriptLogger**  
  Stop the script logger in the active PowerShell session.

* **Set-ScriptLogger**  
  Update the script logger log configuration.

* **Get-ScriptLogger**  
  Get the active script logger object.

* **Write-VerboseLog**  
  Log a verbose message.

* **Write-InformationLog**  
  Log an information message.

* **Write-WarningLog**  
  Log a warning message.

* **Write-ErrorLog**  
  Log an error message.

### Example

The following example show two options how to start the script logger, the
logger management and how to log the log messages.

```powershell
# Initialize the logger with default values
Start-ScriptLogger

# Second options, specify multiple custom settings for the logger
Start-ScriptLogger -Path 'C:\Temp\test.log' -Format '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}' -Level Warning -Encoding 'UTF8' -NoEventLog -NoConsoleOutput

# Start a second script logger with a dedicated name. The default script logger
# is always named 'Default'
Start-ScriptLogger -Name 'Logger2' -Path 'C:\Temp\test2.log'

# Get the current script logger configuration object
Get-ScriptLogger

# Update the script logger configuration
Set-ScriptLogger -Level Verbose

# Log an error record
try { 0 / 0 } catch { Write-ErrorLog -ErrorRecord $_ }

# Log an error message
Write-ErrorLog -Message 'My Error Message'

# Log a warning massage
Write-WarningLog -Message 'My Warning Message'

# Log an information message
Write-InformationLog -Message 'My Information Message'

# Log a verbose message
Write-VerboseLog -Message 'My Verbose Message'

# Write a log message into the log 2
Write-InformationLog -Name 'Logger2' -Message 'My Information Message in Log 2'

# Disable the logger
Stop-ScriptLogger
```

## Versions

Please find all versions in the [GitHub Releases] section and the release notes
in the [CHANGELOG.md] file.

## Installation

Use the following command to install the module from the [PowerShell Gallery],
if the PackageManagement and PowerShellGet modules are available:

```powershell
# Download and install the module
Install-Module -Name 'ScriptLogger'
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]

## Requirements

The following minimum requirements are necessary to use this module, or in other
words are used to test this module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7

## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code] with the [PowerShell Extension]
* [Pester], [PSScriptAnalyzer] and [psake] PowerShell Modules

[ScriptConfig]: https://github.com/claudiospizzi/ScriptConfig

[PowerShell Gallery]: https://www.powershellgallery.com/packages/ScriptLogger
[GitHub Releases]: https://github.com/claudiospizzi/ScriptLogger/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[CHANGELOG.md]: CHANGELOG.md

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
[Pester]: https://www.powershellgallery.com/packages/Pester
[PSScriptAnalyzer]: https://www.powershellgallery.com/packages/PSScriptAnalyzer
[psake]: https://www.powershellgallery.com/packages/psake
