$inputProps = @{
    Prompt       = "Enter the module name:"
    Validation   = [Sitecore.Configuration.Settings]::ItemNameValidation
    ErrorMessage = "'`$Input' is not a valid name."
    MaxLength    = [Sitecore.Configuration.Settings]::MaxItemNameLength
}

$name = Show-Input @inputProps

if ($name) {
    Import-Function New-AvailableRenderingsAction

    $CurrentItem = Get-Item .
    New-AvailableRenderingsAction -SiteSetupItem $CurrentItem -ModuleName $name
}
