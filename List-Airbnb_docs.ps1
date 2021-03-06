<#
    Get-Children.ps1
    .SYNOPSIS
	  Searches for response files by sub-folder
      Exports into one CSV
#>

PARAM (
    $Path = '\\cp-etl-01\C$\ETLs\Airbnb\docs',
    $StartLevel = 0,
    $Depth = 2,
    $Report = 'c:\users\achinn\dropbox\m-files\airbnb_docs.csv'
  )
#    $Report = 'C:\ETLs\Airbnb\airbnb_docs.csv'


# Sets class number variables
$vConfidential = 62

# Set up list for files
$filelisting = @()

Get-ChildItem -Recurse -Path $Path | Where-Object {$_.Length -gt 1000} | select Name | Sort-Object Name | Export-Csv -NoTypeInformation $Report -Delimiter ","
#For ($i=$StartLevel; $i -le $Depth; $i++) {
#    $Levels = "\*" * $i
#    (Resolve-Path $Path$Levels).ProviderPath | Get-ChildItem | Select Name, Directory, FullName | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter ","
#}

