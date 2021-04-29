$SPWeb = Get-SPWeb "http://cp-sp2013-wfe1/sites/CP"
$LibraryName = "Records"

#Local folder to which attachments to be downloaded
$DownloadPath = "C:\Root\RecordsRoot" 
#Get the Library
$List = $SPWeb.Lists[$LibraryName]

$uri = "http://cp-sp2013-wfe1/sites/CP/Records"
$Rfolder = $SPWeb.GetFolder("http://cp-sp2013-wfe1/sites/CP/Records")
$thepath = "C:\Root\RecordsRoot"

Import-Csv C:\Root\NotUploadedDocs.csv |`
ForEach-Object
	{
	$spSourceItems = $List.Items | where {$_['Name'] -eq $_.FileName}
	foreach ($listItem in $spSourceItems)
		{
		foreach ($attachment in $listItem.Attachments)
			{
			#Get the attachment File      
			$file = $SPWeb.GetFile($listItem.Attachments.UrlPrefix + $attachment)       
			$bytes = $file.OpenBinary()               
			 
			#Save the attachment as a file 
			$FilePath = $thepath + " \" + $attachment
			$fs = new-object System.IO.FileStream($FilePath, "OpenOrCreate")
			$fs.Write($bytes, 0 , $bytes.Length)   
			$fs.Close()   
			}
		}
	}
$SPWeb.Dispose();
<#
		$spSourceItems | ForEach-Object {
		#Get all attachments
        $AttachmentsColl = $ListItem.Attachments	}


	$Fname = $uri + "/" + $_.FileName
#    Write-Host "File: "$Fname

    if ((Invoke-WebRequest -Method Head -Uri $Fname -UseDefaultCredentials).StatusCode -eq 200)
        {
        Write-Host "File: " + $Fname + " exists"
        }

}
#>
