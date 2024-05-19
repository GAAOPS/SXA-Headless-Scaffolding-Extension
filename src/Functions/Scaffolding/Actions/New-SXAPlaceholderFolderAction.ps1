function New-SXAPlaceholderFolderAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-SXAPlaceholderFolderAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-SXAPlaceholderFolderAction - Process"
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Add $($ModuleName) SXA Placeholder Folder Settings"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName
        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Scaffolding/JSS Tenant Folder/JSS Tenant Folder/JSS Tenant/JSS Site/Presentation/Placeholder Settings
        $setupItem.Location = "{050361FC-A05F-44CD-AC01-EEBCA2C57581}"

        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "$ModuleName SXA Placeholder Folder Settings").Paths.FullPath
        $finalPath = "$branchItemPath/$ModuleName"

        if(-not (Test-Path $finalPath)){
            # /sitecore/templates/Foundation/JSS Experience Accelerator/Placeholder Settings/Placeholder Settings Folder
            [Sitecore.Data.Items.TemplateItem]$placeholderSettingsFolderTemplate = (Get-Item -Path . -ID "{52288E39-7830-4694-B62D-32A54C6EF7BA}")
            New-Item -Path $branchItemPath -ItemType $placeholderSettingsFolderTemplate.FullName -Name $ModuleName | Out-Null
        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-SXAPlaceholderFolderAction - End"
    }
}