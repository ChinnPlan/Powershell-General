<#
    List-PDFs.ps1
    .SYNOPSIS
	  Searches for PDFs by sub-folder
      Exports into one CSV
#>

PARAM (
    [Parameter (Mandatory=$true)]
    [string] $Path,
    $StartLevel = 0,
    $Depth = 2,
    [Parameter (Mandatory=$true)]
    [string] $Report
  )

Get-ChildItem -Recurse -Path $Path | Where-Object {$_.Length -gt 1000} | select Name, fullname | Sort-Object Name | Export-Csv -NoTypeInformation $Report -Delimiter ","

