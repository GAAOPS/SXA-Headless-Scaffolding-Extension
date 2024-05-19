function Show-NewExistingHeadlessModuleDialog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [Item]$CurrentItem
    )

    begin {
        Write-Verbose "Cmdlet Show-NewHeadlessModuleDialog - Begin"
        Import-Function Get-ModuleStartLocation
        Import-Function Get-Layer
    }

    process {
        Write-Verbose "Cmdlet Show-NewHeadlessModuleDialog - Process"

        $availableSetupTemplates = New-Object System.Collections.Specialized.OrderedDictionary
        $availableSetupTemplates.Add("Headless Tenant Setup", "{F036B5E0-37FB-4537-9D36-EF84E5BD41B7}")
        $availableSetupTemplates.Add("Headless Site Setup", "{BED31D6F-D968-45A9-B54E-12D7F977D861}")
        
        $selectedSetupTemplates = @("{BED31D6F-D968-45A9-B54E-12D7F977D861}")

        $dialogParmeters = @()
        $dialogParmeters += @{ Name = "newFeatureName"; Value = ""; Title = "Module name"; Tab = "General"}
        $dialogParmeters += @{ Name = "targetModule"; Value = $CurrentItem; Title = "Add to module group"; Root = $Root.Paths.Path; Tab = "General"}
        $dialogParmeters += @{ Name = "selectedSetupTemplates"; Title = "Module scaffolding actions"; Options = $availableSetupTemplates; Editor = "checklist"; Height = "30px"; Tab = "General"; }

        $result = Read-Variable -Parameters $dialogParmeters `
            -Description "Add a module by entering the name, location, system areas, and scaffolding actions" `
            -Title "Create a existing headless module" -Width 650 -Height 700 -OkButtonName "Proceed" -CancelButtonName "Abort" -ShowHints `
            -Validator {
                Import-Function Get-Layer
                $newFeatureName = $variables.newFeatureName.Value;
                $pattern = "^[\w][\w\s\-]*(\(\d{1,}\)){0,1}$"
                if ($newFeatureName.Length -gt 100) {
                    $variables.newFeatureName.Error = $("Please specify a value of less than {0} characters.") -f 100
                    continue
                }
                if ([System.Text.RegularExpressions.Regex]::IsMatch($newFeatureName, $pattern, [System.Text.RegularExpressions.RegexOptions]::ECMAScript) -eq $false) {
                    $variables.newFeatureName.Error = $("'{0}' is not a valid name.") -f $newFeatureName
                    continue
                }
                $Layer = Get-Layer $variables.targetModule.Value
        } 


        if ($result -ne "ok") {
            Exit
        }
       
        $Layer = Get-Layer $targetModule
        $layerRootPath = "/sitecore/system/Settings/{0}" -f $Layer
        
        $model = New-Object PSObject -Property @{
            Tail                    = [regex]::Replace($targetModule.Paths.Path , $layerRootPath, "")
            LayerRootPath           = $layerRootPath
            Name                    = $newFeatureName
            SetupItemTemplatesIds   = $selectedSetupTemplates
        }

        $model
    }

    end {
        Write-Verbose "Cmdlet Show-NewHeadlessModuleDialog - End"
    }
}