
# Get and dot source all helper functions (private)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\ScriptLogger\Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\ScriptLogger\Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Update format data
Update-FormatData "$PSScriptRoot\..\Modules\ScriptLogger\Resources\ScriptLogger.Formats.ps1xml"

# Update type data
Update-TypeData "$PSScriptRoot\..\Modules\ScriptLogger\Resources\ScriptLogger.Types.ps1xml"

# Execute deubg
# ToDo...
