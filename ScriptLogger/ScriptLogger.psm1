<#
    .SYNOPSIS
        Root module file.

    .DESCRIPTION
        The root module file loads all classes, helpers and functions into the
        module context.
#>


## Module Core

# Module behavior
Set-StrictMode -Version 'Latest'
$Script:ErrorActionPreference = 'Stop'

# Module metadata
$Script:PSModulePath = [System.IO.Path]::GetDirectoryName($PSCommandPath)
$Script:PSModuleName = [System.IO.Path]::GetFileName($PSCommandPath).Split('.')[0]


## Module Loader

# Get and dot source all helper functions (internal)
Get-ChildItem -Path "$Script:PSModulePath\Helpers" -Filter '*.ps1' -File -Recurse |
    ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Get-ChildItem -Path "$Script:PSModulePath\Functions" -Filter '*.ps1' -File -Recurse |
    ForEach-Object { . $_.FullName }


## Module Context

# Module wide array hosting all script loggers
$Script:Loggers = @{}
