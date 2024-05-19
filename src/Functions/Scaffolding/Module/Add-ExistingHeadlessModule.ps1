function Add-ExistingHeadlessModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        $Model
    )

    begin {
        Write-Verbose "Cmdlet Add-HeadlessModule - Begin"
        Import-Function Add-FolderStructure
    }

    process {
        Write-Verbose "Cmdlet Add-HeadlessModule - Process"

        $expectedPath = $Model.LayerRootPath + $Model.Tail + "/" + $Model.Name
        $folderTemplate = (Get-ItemTemplate -Path $($Model.LayerRootPath + $Model.Tail)).FullName
        if (-not (Test-Path $expectedPath)) {
            Add-FolderStructure $expectedPath $folderTemplate > $null
        }
        
        $settingsItem = Get-Item -Path $expectedPath
        $Model.SetupItemTemplatesIds | % {
            [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $_ )
            $setupItem = New-Item -ItemType $templateItem.FullName -Path $settingsItem.Paths.Path -Name "$($Model.Name) $($templateItem.'DisplayName')"  | Wrap-Item
            $setupItem.__Name = $Model.Name
            if($_ -eq "{BED31D6F-D968-45A9-B54E-12D7F977D861}"){
                # Adding Headless Variant as dependecy
                $setupItem.Dependencies = "{C4D79D81-83E9-4506-AE8C-F7145C75762F}"
            }
        }
    }

    end {
        Write-Verbose "Cmdlet Add-HeadlessModule - End"
    }
}