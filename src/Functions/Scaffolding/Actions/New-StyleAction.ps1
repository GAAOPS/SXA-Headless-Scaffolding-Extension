function New-StyleAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-StyleAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-StyleAction - Process"
        #/sitecore/templates/Common/Folder
        $folderTemplateID = "{A87A00B1-E6DB-45AB-8B54-636FEC3B5523}"
        $folderPath = "$($SiteSetupItem.Paths.Path)/Styles"
        if(-not(Test-Path $folderPath)){
            [Sitecore.Data.Items.TemplateItem]$folderTemplateItem = (Get-Item -Path . -ID $folderTemplateID)
            $setupItem = New-Item -ItemType $folderTemplateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Styles"  | Wrap-Item    
        }

        $folderPath = (Get-Item $folderPath).Paths.FullPath
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $folderPath -Name "Add $($ModuleName) Styles"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Presentation/Styles/Styles
        $setupItem.Location = "{47019583-10DF-46B6-BDCC-1741BECC3CDA}" 
        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "$ModuleName Styles").Paths.FullPath
        $finalPath = $branchItemPath + '/$name'
        if(-not (Test-Path $finalPath)){
            #/sitecore/templates/Foundation/Experience Accelerator/Presentation/Styles 
            [Sitecore.Data.Items.TemplateItem]$stylesTemplate = (Get-Item -Path . -ID "{C6DC7393-15BB-4CD7-B798-AB63E77EBAC4}")
            $variantFolder = New-Item -Path $branchItemPath -ItemType $stylesTemplate.FullName -Name '$name'

            #/sitecore/templates/Foundation/Experience Accelerator/Presentation/Style
            [Sitecore.Data.Items.TemplateItem]$styleTemplate = (Get-Item -Path . -ID "{6B8AABEF-D650-46E0-97D0-C0B04F7F016B}")
            New-Item -Path $variantFolder.Paths.FullPath -ItemType $styleTemplate.FullName -Name 'Default' | Out-Null
        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-StyleAction - End"
    }
}