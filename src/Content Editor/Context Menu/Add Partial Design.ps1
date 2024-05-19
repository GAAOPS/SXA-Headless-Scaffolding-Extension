$inputProps = @{
    Prompt       = "Enter the module name:"
    Validation   = [Sitecore.Configuration.Settings]::ItemNameValidation
    ErrorMessage = "'`$Input' is not a valid name."
    MaxLength    = [Sitecore.Configuration.Settings]::MaxItemNameLength
}

$name = Show-Input @inputProps

if ($name) {
    Import-Function New-PartialDesignAction

    $CurrentItem = Get-Item .
    New-PartialDesignAction -SiteSetupItem $CurrentItem -ModuleName $name
}
