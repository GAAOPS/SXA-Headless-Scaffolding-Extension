Import-Function Show-NewExistingHeadlessModuleDialog
Import-Function Add-ExistingHeadlessModule

$CurrentItem = Get-Item .
$model = Show-NewExistingHeadlessModuleDialog $CurrentItem
Add-ExistingHeadlessModule $model