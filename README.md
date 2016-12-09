[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/ScriptLogger/master.svg)](https://ci.appveyor.com/project/claudiospizzi/ScriptLogger/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/ScriptLogger/dev.svg)](https://ci.appveyor.com/project/claudiospizzi/ScriptLogger/branch/dev)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/ScriptLogger.svg)](https://github.com/claudiospizzi/ScriptLogger/releases)
[![PowerShell Gallery - ScriptLogger](https://img.shields.io/badge/PowerShell_Gallery-ScriptLogger-0072C6.svg)](https://www.powershellgallery.com/packages/ScriptLogger)


# ScriptLogger PowerShell Module

PowerShell Module to provide logging capabilities for PowerShell controller
scripts.


## Introduction

With the ScriptLogger module, you are able to log error, warning, informational
and verbose messages into log files, the Windows event log and the current
console host. You can start and stop the logger as required. Works great in
cooperation with the [ScriptConfig] module to improve controller scripts.


## Requirements

The following minimum requirements are necessary to use this module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7


## Installation

With PowerShell 5.0, the new [PowerShell Gallery] was introduced. Additionally,
the new module [PowerShellGet] was added to the default WMF 5.0 installation.
With the cmdlet `Install-Module`, a published module from the PowerShell Gallery
can be downloaded and installed directly within the PowerShell host, optionally
with the scope definition:

```powershell
Install-Module ScriptLogger [-Scope {CurrentUser | AllUsers}]
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]


## Features

* **Start-ScriptLogger**  
  Start the script logger inside the current PowerShell session.

* **Stop-ScriptLogger**  
  Stop the script logger inside the current PowerShell session.

* **Set-ScriptLogger**  
  Update the script logger log configuration.

* **Get-ScriptLogger**  
  Get the current script logger object.

* **Write-VerboseLog**  
  Log a verbose message.

* **Write-InformationLog**  
  Log an information message.

* **Write-WarningLog**  
  Log a warning message.

* **Write-ErrorLog**  
  Log an error message.

The following example show two options how to start the script logger, the
logger management and how to log the log messages.

```powershell
# Initialize the logger with default values
Start-ScriptLogger

# Second options, specify multiple custom settings for the logger
Start-ScriptLogger -Path 'C:\Temp\test.log' -Format '{0:yyyy-MM-dd}   {0:HH:mm:ss}   {1}   {2}   {3,-11}   {4}' -Level Warning  -NoEventLog -NoConsoleOutput

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


## Versions

### Unreleased

- Convert module to new deployment model
- Refactor code against high quality module guidelines by Microsoft
- BREAKING CHANGE: Remove positional parameters


### 1.2.0

- Add encoding option for the log file output
- Add error handling for log file and event log output
- Change console output from cmdlets to $Host.UI methods
- Fix error record handling to log correct invocation information

### 1.1.1

- Add formats and types resources
- Fix tests for PowerShell 3.0 & 4.0

### 1.1.0

- Add an ErrorRecord parameter to Write-ErrorLog
- Return logger object inside Start-ScriptLogger

### 1.0.0

- Initial public release


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

This module is tested with the PowerShell testing framework Pester. To run all
tests, just start the included test script `.\Scripts\test.ps1` or invoke Pester
directly with the `Invoke-Pester` cmdlet. The tests will automatically download
the latest meta test from the claudiospizzi/PowerShellModuleBase repository.

To debug the module, just copy the existing `.\Scripts\debug.default.ps1` file
to `.\Scripts\debug.ps1`, which is ignored by git. Now add the command to the
debug file and start it.



[ScriptConfig]: https://github.com/claudiospizzi/ScriptConfig

[PowerShell Gallery]: https://www.powershellgallery.com/packages/SecurityFever
[PowerShellGet]: https://technet.microsoft.com/en-us/library/dn807169.aspx

[GitHub Releases]: https://github.com/claudiospizzi/SecurityFever/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
