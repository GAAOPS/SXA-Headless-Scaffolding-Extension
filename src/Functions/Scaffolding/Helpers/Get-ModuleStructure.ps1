function Get-ModuleStructure {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Sitecore.Data.Items.Item]$SiteSetupItem
    )

    begin {
        Write-Verbose "Cmdlet Get-ModuleStructure - Begin"
    }

    process {
        if(-not($SiteSetupItem.Paths.FullPath.StartsWith("/sitecore/system/Settings"))){
            throw "Item path should start with /sitecore/system/Settings"
        }
        $currentPath = $SiteSetupItem.Paths.FullPath.Replace("/sitecore/system/Settings","")

        $moduleStruct = $currentPath.Split("/",[System.StringSplitOptions]::RemoveEmptyEntries)
        $layer = $moduleStruct[0]
        $siteName = ""
        $moduleName = ""
        
        if($moduleStruct.Length -eq 4){
            $siteName = $moduleStruct[1]
            $moduleName = $moduleStruct[2]
        }elseif($moduleStruct.Length -eq 3){
            $moduleName = $moduleStruct[1]
        }
        
        return New-Object psobject -Property @{
            Layer      = $layer
            SiteName   = $siteName
            ModuleName = $moduleName
        }
    }

    end {
        Write-Verbose "Cmdlet Get-ModuleStructure - End"
    }
}