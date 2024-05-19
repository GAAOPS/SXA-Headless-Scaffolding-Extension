$inputProps = @{
    Prompt       = "Enter the module name:"
    Validation   = [Sitecore.Configuration.Settings]::ItemNameValidation
    ErrorMessage = "'`$Input' is not a valid name."
    MaxLength    = [Sitecore.Configuration.Settings]::MaxItemNameLength
}

$name = Show-Input @inputProps

if ($name) {
    Import-Function New-DataFolderItemAction

    $CurrentItem = Get-Item .
    New-DataFolderItemAction -Item $CurrentItem -ModuleName $name
}
