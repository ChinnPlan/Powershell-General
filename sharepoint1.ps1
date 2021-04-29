 if((Get-PSSnapin "Microsoft.SharePoint.PowerShell") -eq $null)
    {
        Add-PSSnapin Microsoft.SharePoint.PowerShell
    }

#Script settings

$webUrl = "http://cp-sp2013-wfe1/sites/cp/"
$docLibraryName = "Records"

$docs = Get-Content C:\Root\Records_Corrupted.txt
$separator = ","
ForEach($line in $docs)
	{
	$fields = $line.Split($separator)
	$files = ([System.IO.DirectoryInfo] (Get-Item $localFolderPath)).GetFiles()

	$docLibraryName = $fields[4]
	write-host $fields[0]
	}

#Dispose web
$web.Dispose()	
