<#
    Get-Responses.ps1
    .SYNOPSIS
	  Searches for response files by sub-folder
      Exports into one CSV
#>

PARAM (
    $Path = '\\cpc-file\infodrive\GIS\Queries\short_term_rental_certificate_business_portal_responses\uploaded_files\',
    $StartLevel = 0,
    $Depth = 2,
    $Report = 'c:\temp\strfiles.csv'
  )


# Sets class number variables
$vConfidential = 62

# Set up list for files
$filelisting = @()

Get-ChildItem -Recurse -Path $Path | select Name, Fullname | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter ","
#For ($i=$StartLevel; $i -le $Depth; $i++) {
#    $Levels = "\*" * $i
#    (Resolve-Path $Path$Levels).ProviderPath | Get-ChildItem | Select Name, Directory, FullName | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter ","
#}

