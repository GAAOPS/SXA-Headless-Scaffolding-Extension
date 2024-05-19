function New-PartialDesignAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-PartialDesignAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-PartialDesignAction - Process"
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Add $($ModuleName) Partial Design"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Scaffolding/JSS Tenant Folder/JSS Tenant Folder/JSS Tenant/JSS Site/Presentation/Partial Designs
        $setupItem.Location = "{98AB60C3-0FE5-467B-A6C7-ABD981E30E7A}" 
        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "Add $($ModuleName) Partial Design").Paths.FullPath
        $finalPath = $branchItemPath + '/$name'
        if(-not (Test-Path $finalPath)){
            #/sitecore/templates/Foundation/JSS Experience Accelerator/Presentation/Partial Design
            [Sitecore.Data.Items.TemplateItem]$partialDesignTemplate = (Get-Item -Path . -ID "{FD2059FD-6043-4DFE-8C04-E2437CE87634}")
            New-Item -Path $branchItemPath -ItemType $partialDesignTemplate.FullName -Name '$name' | Out-Null
        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-PartialDesignAction - End"
    }
}