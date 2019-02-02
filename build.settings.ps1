
Properties {

    $ModuleNames    = 'ScriptLogger'

    $GalleryEnabled = $true
    $GalleryKey     = Use-VaultSecureString -TargetName 'PowerShell Gallery Key'

    $GitHubEnabled  = $true
    $GitHubRepoName = 'claudiospizzi/ScriptLogger'
    $GitHubToken    = Use-VaultSecureString -TargetName 'GitHub Token'
}
