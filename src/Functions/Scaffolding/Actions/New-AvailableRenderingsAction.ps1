function New-AvailableRenderingsAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-AvailableRenderingsAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-AvailableRenderingsAction - Process"
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Add $($ModuleName) Available Renderings"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Scaffolding/JSS Tenant Folder/JSS Tenant Folder/JSS Tenant/JSS Site/Presentation/Available Renderings
        $setupItem.Location = "{3F14C1B6-5A2D-44CA-A8EF-DFE3CBD574E4}" 
        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "Available Headless $ModuleName Renderings").Paths.FullPath
        $finalPath = $branchItemPath + '/$name'
        if(-not (Test-Path $finalPath)){
            #/sitecore/templates/Foundation/Experience Accelerator/Presentation/Available Renderings/Available Renderings 
            [Sitecore.Data.Items.TemplateItem]$availableRenderingsTemplate = (Get-Item -Path . -ID "{76DA0A8D-FC7E-42B2-AF1E-205B49E43F98}")
            New-Item -Path $branchItemPath -ItemType $availableRenderingsTemplate.FullName -Name '$name' | Out-Null 

        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-AvailableRenderingsAction - End"
    }
}