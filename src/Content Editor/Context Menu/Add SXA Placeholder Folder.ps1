$inputProps = @{
    Prompt       = "Enter the main module name:"
    Validation   = [Sitecore.Configuration.Settings]::ItemNameValidation
    ErrorMessage = "'`$Input' is not a valid name."
    MaxLength    = [Sitecore.Configuration.Settings]::MaxItemNameLength
}

$name = Show-Input @inputProps

if ($name) {
    Import-Function New-SXAPlaceholderFolderAction

    $CurrentItem = Get-Item .
    New-SXAPlaceholderFolderAction -SiteSetupItem $CurrentItem -ModuleName $name
}
