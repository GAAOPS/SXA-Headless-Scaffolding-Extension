function New-RenderingVariantsAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-RenderingVariantsAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-RenderingVariantsAction - Process"
        #/sitecore/templates/Common/Folder
        $folderTemplateID = "{A87A00B1-E6DB-45AB-8B54-636FEC3B5523}"
        $folderPath = "$($SiteSetupItem.Paths.Path)/Rendering Variants"
        if(-not(Test-Path $folderPath)){
            [Sitecore.Data.Items.TemplateItem]$folderTemplateItem = (Get-Item -Path . -ID $folderTemplateID)
            $setupItem = New-Item -ItemType $folderTemplateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Rendering Variants"  | Wrap-Item    
        }

        $folderPath = (Get-Item $folderPath).Paths.FullPath
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $folderPath -Name "Add $($ModuleName) Rendering Variant"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Scaffolding/JSS Tenant Folder/JSS Tenant Folder/JSS Tenant/JSS Site/Presentation/Headless Variants
        $setupItem.Location = "{C6F65339-F4DA-40FA-88D1-E1ECFFD54B91}" 
        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "$ModuleName Rendering Variant").Paths.FullPath
        $finalPath = $branchItemPath + '/$name'
        if(-not (Test-Path $finalPath)){
            # /sitecore/templates/Foundation/JSS Experience Accelerator/Headless Variants/HeadlessVariants
            [Sitecore.Data.Items.TemplateItem]$headlessVariantsTemplate = (Get-Item -Path . -ID "{49C111D0-6867-4798-A724-1F103166E6E9}")
            $variantFolder = New-Item -Path $branchItemPath -ItemType $headlessVariantsTemplate.FullName -Name '$name'

            # /sitecore/templates/Foundation/JSS Experience Accelerator/Headless Variants/Variant Definition
            [Sitecore.Data.Items.TemplateItem]$variantDefinitionTemplate = (Get-Item -Path . -ID "{4D50CDAE-C2D9-4DE8-B080-8F992BFB1B55}")
            New-Item -Path $variantFolder.Paths.FullPath -ItemType $variantDefinitionTemplate.FullName -Name 'Default' | Out-Null
        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-RenderingVariantsAction - End"
    }
}