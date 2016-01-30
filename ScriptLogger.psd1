@{
    RootModule         = 'ScriptLogger.psm1'
    ModuleVersion      = '1.0.0'
    GUID               = '0E1AF375-67C1-460A-A247-045C5D2B54AA'
    Author             = 'Claudio Spizzi'
    Copyright          = 'Copyright (c) 2016 by Claudio Spizzi. Licensed under MIT license.'
    Description        = 'PowerShell Module to provide logging capabilities for PowerShell Controller Scripts.'
    PowerShellVersion  = '3.0'
    ScriptsToProcess   = @()
    TypesToProcess     = @()
    FormatsToProcess   = @()
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
        }
    }
}
