<#
    Get-Children.ps1
    .SYNOPSIS
	  Searches for response files by sub-folder
      Exports into one CSV
#>

PARAM (
    $Path = 'I:\Short Term Rentals\Validation Source Tools\Adhoc_PTR_Docs',
    $StartLevel = 0,
    $Depth = 1,
    $Report = 'C:\Users\achinn\Dropbox\Downloads\airbnb_docs.csv'
  )


# Sets class number variables
$vConfidential = 62

# Set up list for files
$filelisting = @()

Get-ChildItem -Recurse -Path $Path | where Length -gt 1000 | select Name, Length | Sort-Object Name | Export-Csv -NoTypeInformation $Report -Delimiter ","
#For ($i=$StartLevel; $i -le $Depth; $i++) {
#    $Levels = "\*" * $i
#    (Resolve-Path $Path$Levels).ProviderPath | Get-ChildItem | Select Name, Directory, FullName | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter ","
#}

