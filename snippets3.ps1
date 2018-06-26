	ForEach ($scan in $scans)
       	{

        $docketFile = New-Object PSObject -Property @{
            	"DocName" = $vFilename.Substring(0,$vFilename.Length - 4)
            	"DocClass" = $vClass
            	"FullName" = $vPath + $scan.PDFFileName
                "DocGroup" = "PLN"
                "DocCategory" = $vCategory
		    }
        if ($scan.Media -eq "Y")
            {
            $medialisting += $docketFile
            $medialisting | Export-Csv C:\scripts\mediaFiles.csv -delimiter ","
            }
        else
            {
            $filelisting += $docketFile
            $filelisting | Export-Csv C:\scripts\docketFiles.csv -delimiter ","
            }
        }
