function New-TemplateBranchItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$BranchName

    )

    begin {
        Write-Verbose "Cmdlet New-TemplateBranchItem - Begin"
        Import-Function Get-ModuleStructure
    }

    process {
        if(-not($SiteSetupItem.Paths.FullPath.StartsWith("/sitecore/system/Settings"))){
            throw "Item path should start with /sitecore/system/Settings"
        }
        
        $structure = Get-ModuleStructure $SiteSetupItem
        
        $branchLayerPath = "/sitecore/templates/Branches/$($structure.Layer)/$($structure.SiteName)"
        [Sitecore.Data.Items.TemplateItem]$branchFolderTemplate = (Get-Item -Path . -ID "{85ADBF5B-E836-4932-A333-FE0F9FA1ED1E}")
        if(-not (Test-Path $branchLayerPath)){
            New-Item -Path $branchLayerPath -ItemType $branchFolderTemplate.FullName | Out-Null
        }
        $moduleBranchPath = "$($(Get-Item $branchLayerPath).Paths.FullPath)/$($structure.ModuleName)"
        if(-not (Test-Path $moduleBranchPath)){
            New-Item -Path $moduleBranchPath -ItemType $branchFolderTemplate.FullName | Out-Null
        }

        $moduleBranchFolderPath = (Get-Item $moduleBranchPath).Paths.FullPath
        if(-not(Test-Path "$moduleBranchPath/$BranchName")){
            [Sitecore.Data.Items.TemplateItem]$branchItemTemplate = (Get-Item -Path . -ID "{35E75C72-4985-4E09-88C3-0EAC6CD1E64F}")
            New-Item -Path $moduleBranchFolderPath -ItemType $branchItemTemplate.FullName -Name $BranchName | Out-Null
        }

        $result = Get-Item "$moduleBranchPath/$BranchName"

        $result
    }

    end {
        Write-Verbose "Cmdlet New-TemplateBranchItem - End"
    }
}