@{
    RootModule         = 'ScriptLogger.psm1'
    ModuleVersion      = '2.0.0'
    GUID               = '0E1AF375-67C1-460A-A247-045C5D2B54AA'
    Author             = 'Claudio Spizzi'
    Copyright          = 'Copyright (c) 2016 by Claudio Spizzi. Licensed under MIT license.'
    Description        = 'PowerShell Module to provide logging capabilities for PowerShell controller scripts.'
    PowerShellVersion  = '3.0'
    RequiredModules    = @()
    RequiredAssemblies = @()
    ScriptsToProcess   = @()
    TypesToProcess     = @(
        'Resources\ScriptLogger.Types.ps1xml'
    )
    FormatsToProcess   = @(
        'Resources\ScriptLogger.Formats.ps1xml'
    )
    FunctionsToExport  = @(
        'Start-ScriptLogger',
        'Stop-ScriptLogger',
        'Get-ScriptLogger',
        'Set-ScriptLogger',
        'Write-VerboseLog',
        'Write-InformationLog',
        'Write-WarningLog',
        'Write-ErrorLog'
    )
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData             = @{
            Tags               = @('PSModule', 'Log', 'Logger', 'Script', 'Controller')
            LicenseUri         = 'https://raw.githubusercontent.com/claudiospizzi/ScriptLogger/master/LICENSE'
            ProjectUri         = 'https://github.com/claudiospizzi/ScriptLogger'
            ExternalModuleDependencies = @()
        }
    }
}
