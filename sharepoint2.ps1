	$docLibraryUrlName = "Shared Documents\arizona"    # specify your subfolder url here

# $localFolderPath = "C:\Test"

#Open web and library

$web = Get-SPWeb $webUrl
write-host $webUrl

	$docLibrary = $web.Lists[$docLibraryName]
write-host $docLibrary

#  $files = ([System.IO.DirectoryInfo] (Get-Item $localFolderPath)).GetFiles()

#  write-host $files

ForEach($file in $files)
{

if($file.Name.Contains(".pdf"))
{
    write-host $file

        #Open file
        try
        {
        $fileStream = ([System.IO.FileInfo] (Get-Item $file.FullName)).OpenRead()

        #Add file
        $folder =  $web.getfolder($docLibraryUrlName)

        write-host "Copying file " $file.Name " to " $folder.ServerRelativeUrl "..."
        $spFile = $folder.Files.Add($folder.Url + "/" + $file.Name,[System.IO.Stream]$fileStream, $true)
        write-host "Success"

        #Close file stream
        $fileStream.Close();
        }
        catch
        {
        Write "Error: $file.name: $_" >>c:\logfile.txt
            continue;
        }
}
    }

	
$l = $web.Lists["EM_DOC_LIBRARY"]
$l.Items | ? { $_.Name -eq "yourfilename.txt" } | %{ $item = $l.GetItemByID($_.ID); $item.Delete(); }
    #Dispose web

    $web.Dispose()
	
	
	
