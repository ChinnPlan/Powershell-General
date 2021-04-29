Function GetMyItems ($list)
    {
    $query = New-Object -Type 'Microsoft.SharePoint.SPQuery'
    $query.ViewAttributes = "Scope='Recursive'"
    $FolderItems = $list.GetItems($query)
    [String]$csvfile = 'C:\Root\' + $list.Title + '.csv'
    $i = 0
    $test = ""
    $exportlist = @()
    $FolderItems | foreach {
        if ($_["Alt_ID"] -gt $test) {
            $obj = New-Object PSObject -Property @{
            "Name" = $_["Name"]
            "Alt_ID" = $_["Alt_ID"].ToString()
            "DocGroup" = $_["DocumentGroup"]
            "DocCategory" = $_["Category"]
            "Modified Date" = $_["Modified"]
            }
            $i++
            $exportlist += $obj
#            $exportlist | Export-Csv -path 'C:\Root\MinorAlterationLetters.csv' -noType
            $exportlist | Export-Csv -path $csvfile -noType
          }
        }
    $summary = "item count=" + $i.ToString()
    Write-Host $summary
    Write-Host "name is"$list.Title
    }

Function GetMyFiles($Folder, $LocalPath)
    {
    Write-Host “+in : “$Folder.Name
    Write-Host "+Path is"$LocalPath
    foreach($file in $Folder.Files)
        {
        $b = $file.OpenBinary()
        $fs = New-Object System.IO.FileStream(($LocalPath + "\" + $file.Name), [System.IO.FileMode]::Create,[System.IO.FileAccess]::ReadWrite)
        $bw = New-Object System.IO.BinaryWriter($fs)
        $bw.Write($b)
        $bw.Close()
        }

    #Loop through all subfolders and call the function recursively
    foreach ($SubFolder in $Folder.SubFolders)
        {
        if($SubFolder.Name -ne “Forms”)
            {
            GetMyFiles $Subfolder $LocalPath
            }
        }
    }


$SPWeb = Get-SPWeb "http://cp-sp2013-wfe1/sites/CP"
$SPList = $SPWeb.Lists["Minor Alteration Letters"]
# $SPList = $SPWeb.Lists["Letters of Determination"]

$thepath = "C:\Root\Minor Alteration Letters"
GetMyFiles $SPWeb.GetFolder("http://cp-sp2013-wfe1/sites/CP/Minor Alteration Letters") $thepath

# Write-Host "Folder is"$SPList.RootFolder.Name
GetMyItems $SPList
# GetMyChildrenItems($folderItems)
# $summary2 = "Item count again=" + $SPList.ItemCount
# Write-Host $summary2

