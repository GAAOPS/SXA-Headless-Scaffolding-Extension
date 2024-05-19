function New-DictionaryAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-DictionaryAction - Begin"
        Import-Function New-TemplateBranchItem
    }

    process {
        Write-Verbose "Cmdlet New-DictionaryAction - Process"
        #/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $SiteSetupItem.Paths.Path -Name "Add $($ModuleName) Dictionary"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        #/sitecore/templates/Branches/Foundation/JSS Experience Accelerator/Scaffolding/JSS Site/$name/Dictionary
        $setupItem.Location = "{95DA6E6D-AA58-4322-A36E-E5C63FCF1AD1}" 
        
        $branchItemPath = (New-TemplateBranchItem -SiteSetupItem $SiteSetupItem -BranchName "$ModuleName Dictionary").Paths.FullPath
        $finalPath = $branchItemPath + '/$name'
        if(-not (Test-Path $finalPath)){
            #/sitecore/templates/System/Dictionary/Dictionary folder
            [Sitecore.Data.Items.TemplateItem]$dictionaryFolderTemplate = (Get-Item -Path . -ID "{267D9AC7-5D85-4E9D-AF89-99AB296CC218}")
            New-Item -Path $branchItemPath -ItemType $dictionaryFolderTemplate.FullName -Name '$name' | Out-Null
        }

        $branch = Get-Item $finalPath
        $setupItem.__Template = $branch.ParentID

        $branch
    }

    end {
        Write-Verbose "Cmdlet New-DictionaryAction - End"
    }
}