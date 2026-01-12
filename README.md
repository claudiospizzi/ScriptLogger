[![GitHub Release](https://img.shields.io/github/v/release/claudiospizzi/ScriptLogger?label=Release&logo=GitHub&sort=semver)](https://github.com/claudiospizzi/ScriptLogger/releases)
[![GitHub CI Build](https://img.shields.io/github/actions/workflow/status/claudiospizzi/ScriptLogger/pwsh-ci.yml?label=CI%20Build&logo=GitHub)](https://github.com/claudiospizzi/ScriptLogger/actions/workflows/pwsh-ci.yml)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/ScriptLogger?label=PowerShell%20Gallery&logo=PowerShell)](https://www.powershellgallery.com/packages/ScriptLogger)
[![Gallery Downloads](https://img.shields.io/powershellgallery/dt/ScriptLogger?label=Downloads&logo=PowerShell)](https://www.powershellgallery.com/packages/ScriptLogger)

# ScriptLogger PowerShell Module

PowerShell Module to provide logging capabilities for PowerShell controller scripts.

## Introduction

With the ScriptLogger module, you are able to log error, warning, informational and verbose messages into log files, the Windows event log and the current console host. You can start and stop the logger as required. Works great in cooperation with the [ScriptConfig] module to improve controller scripts.

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

The following example demonstrates how to use the ScriptLogger module in a PowerShell script with some common operations.

```powershell
# Initialize the logger with default values
Start-ScriptLogger

# Second options, specify multiple custom settings for the logger
Start-ScriptLogger -Path 'C:\Temp\test.log' -Format '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}' -Level 'Warning' -Encoding 'UTF8' -NoEventLog -NoConsoleOutput

# Start a second script logger with a dedicated name. The default script logger
# is always named 'Default'
Start-ScriptLogger -Name 'Logger2' -Path 'C:\Temp\test2.log'

# Get the current script logger configuration object
Get-ScriptLogger

# Update the script logger configuration
Set-ScriptLogger -Level 'Verbose'

# Log a verbose message
Write-VerboseLog -Message 'My Verbose Message'

# Write a log message into the log 2
Write-InformationLog -Name 'Logger2' -Message 'My Information Message in Log 2'

# Log an information message
Write-InformationLog -Message 'My Information Message'

# Log a warning message
Write-WarningLog -Message 'My Warning Message'

# Log an error message
Write-ErrorLog -Message 'My Error Message'

# Log an error record
try
{
    0 / 0
}
catch
{
    Write-ErrorLog -ErrorRecord $_
}

# Disable the logger
Stop-ScriptLogger
```

## Versions

Please find all versions in the [GitHub Releases] section and the release notes in the [CHANGELOG.md] file.

## Installation

Use the following command to install the module from the [PowerShell Gallery], if the PackageManagement and PowerShellGet modules are available:

```powershell
# Download and install the module
Install-Module -Name 'ScriptLogger'
```

Alternatively, download the latest release from GitHub and install the module manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]

## Requirements

The following minimum requirements are recommended to use this module. It used to work on older versions too, but they are not officially supported and tested anymore.

* Windows PowerShell 5.1 / PowerShell 7 or higher
* Windows Server 2016 / Windows 11

## Contribute

Please feel free to contribute by opening new issues or providing pull requests. For the best development experience, open this project as a folder in Visual Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code] with the [PowerShell Extension]
* [Pester], [PSScriptAnalyzer], [InvokeBuild] and [InvokeBuildHelper] modules

[ScriptConfig]: https://github.com/claudiospizzi/ScriptConfig

[PowerShell Gallery]: https://www.powershellgallery.com/packages/ScriptLogger
[GitHub Releases]: https://github.com/claudiospizzi/ScriptLogger/releases
[Installing a PowerShell Module]: https://learn.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module

[CHANGELOG.md]: CHANGELOG.md

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
[Pester]: https://www.powershellgallery.com/packages/Pester
[PSScriptAnalyzer]: https://www.powershellgallery.com/packages/PSScriptAnalyzer
[InvokeBuild]: https://www.powershellgallery.com/packages/InvokeBuild
[InvokeBuildHelper]: https://www.powershellgallery.com/packages/InvokeBuildHelper
