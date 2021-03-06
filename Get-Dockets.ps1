<#
    Get-Dockets.ps1
    .SYNOPSIS
	  Imports the CSV listing of CSVs listing scanned PDF dockets
      Exports into one combined CSV
#>

# Sets class number variables
$vBackground = 11
$vConfidential = 62

# Set up list for files
$filelisting = @()
$medialisting = @()

# Open docket_csvs.csv
# $listings = Import-Csv C:\scripts\docket_csvs.csv -delimiter "|"
$listings = Import-Csv C:\users\achinn\Downloads\docket_csvs.csv -delimiter "|"
ForEach ($item in $listings)
	{
    $full = $item.FullName
# round 1	$vPath = $item.FullName.Substring(0,14)
#	$vPath = "E:\" + $item.FullName.Substring(47,11)

	$vPath = "E:"

    Write-Host "CSV is", $item.FullName, "Path is", $vPath
	$scans = Import-Csv $full -header "RecordNumber","Media","Copyright","Confidential","PDFFilename" -delimiter ","
	ForEach ($scan in $scans)
       	{
        $vClass = $vBackground
        $vCategory = "Background Documents"
        $vKeywords = "Scanned docket"
        if ($scan.Copyright -eq "Y")
            {
            $vClass = $vConfidential
            $vCategory = "Confidential"
            $vKeywords = $vKeywords + ",Copyright"
            }
        if ($scan.Confidential -eq "Y")
            {
            $vClass = $vConfidential
            $vCategory = "Confidential"
            $vKeywords = $vKeywords + ",Confidential folder"
            }
        if ($scan.Media -eq "Y")
            {
            $vKeywords = $vKeywords + ",Media"
            }
        if ($scan.PDFFilename -ne "PDF FileName")
            {
    		$vFilename = $scan.PDFFileName.Substring(30)
            $docketFile = New-Object PSObject -Property @{
            	    "DocName" = $vFilename.Substring(0,$vFilename.Length - 4)
            	    "DocClass" = $vClass
            	    "FullName" = $vPath + $scan.PDFFileName
                    "RecordNumber" = $scan.RecordNumber
                    "DocGroup" = "PLN"
                    "DocCategory" = $vCategory
                    "Keywords" = $vKeywords
		        }
			$filelisting += $docketFile
			$filelisting | Export-Csv C:\users\achinn\Downloads\docketFiles.csv -NoTypeInformation -delimiter ","
            if ($scan.Media -eq "Y")
                {
                $medialisting += $docketFile
                $medialisting | Export-Csv C:\users\achinn\Downloads\mediaFiles.csv -NoTypeInformation -delimiter ","
                }
            Write-Host "Filename is", $scan."PDFFileName"
            }
        }
#    Write-Host $full
    }

