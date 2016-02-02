
# Dot source all nested functions (.ps1 files) inside the \Functions folder
Split-Path -Path $PSCommandPath |
    Join-Path -ChildPath 'Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName; }
