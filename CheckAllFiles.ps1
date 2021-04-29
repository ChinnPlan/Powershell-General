<#
    CheckAllFiles.ps1
    .SYNOPSIS
	  Constructs a search of the object type Accela Records
#>

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================

# Set up list for missing files
$adsMissing = @()

# Open Accela ADS csv
$Accela_docs = Import-Csv C:\Users\achinn\Downloads\LiveData.csv -delimiter "|"
ForEach ($Accela_doc in $Accela_docs)
	{
    $fileExists = Test-Path $Accela_doc.FullName
#    Write-Host $Accela_doc.DocName, ":", $fileExists

    if ($fileExists -eq $False)
        {
        $adsFile = New-Object PSObject -Property @{
            "DocName" = $Accela_doc.DocName
            "DocClass" = $Accela_doc.DocClass
            "FullName" = $Accela_doc.FullName
            "Project" = $Accela_doc.Project
            "DocGroup" = $Accela_doc.DocGroup
            "DocCategory" = $Accela_doc.DocCategory
            }
        $adsMissing += $adsFile
        $adsMissing | Export-Csv C:\Users\achinn\Downloads\adsMissing.txt -delimiter "|"
        Write-Host $Accela_doc.DocName
        }

    }


