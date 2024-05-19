$inputProps = @{
    Prompt       = "Enter the module name(Dictionary Folder name):"
    Validation   = [Sitecore.Configuration.Settings]::ItemNameValidation
    ErrorMessage = "'`$Input' is not a valid name."
    MaxLength    = [Sitecore.Configuration.Settings]::MaxItemNameLength
}

$name = Show-Input @inputProps

if ($name) {
    Import-Function New-DictionaryAction

    $CurrentItem = Get-Item .
    New-DictionaryAction -SiteSetupItem $CurrentItem -ModuleName $name
}
