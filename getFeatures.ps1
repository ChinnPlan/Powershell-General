<#
    GetFeatures.ps1
    .SYNOPSIS
	  Constructs a search of the PPTS doc class group
#>

# get the ServerManager module
Import-Module ServerManager

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================

Get-WindowsFeature | 
  ? { $_.Installed } | 
  Sort-Object Name | 
  Select Name | 
  ForEach-Object { $_.Name } | 
  Out-File .\Features.txt
  
$(Get-Content .\Features.txt) | 
  Add-WindowsFeature