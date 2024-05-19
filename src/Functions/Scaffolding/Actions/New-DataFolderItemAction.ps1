function New-DataFolderItemAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        $Item,
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$ModuleName

    )

    begin {
        Write-Verbose "Cmdlet New-DataFolderItemAction - Begin"
    }

    process {
        Write-Verbose "Cmdlet New-DataFolderItemAction - Process"
        $AddItemTemplateID = "{3AEA335C-D06D-45B1-841A-CBC8D2D1CE40}" 	#/sitecore/templates/Foundation/JSS Experience Accelerator/Scaffolding/Actions/Site/AddItem

        [Sitecore.Data.Items.TemplateItem]$templateItem = (Get-Item -Path . -ID $AddItemTemplateID)
        $setupItem = New-Item -ItemType $templateItem.FullName -Path $Item.Paths.Path -Name "Add $($ModuleName) Data Folder"  | Wrap-Item
        
        $setupItem.__Name = $ModuleName

        $setupItem.Location = "{BA2F959D-A614-4C92-8B57-F1FC1A323ABE}"
    }

    end {
        Write-Verbose "Cmdlet New-DataFolderItemAction - End"
    }
}