# Create a csv list from doc library
$SPWeb = Get-SPWeb "http://cp-sp2013-wfe1/sites/CP"
$SPList = $SPWeb.Lists["Minor Alteration Letters"]
$exportlist = @()
$SPList.Items | foreach {
$obj = New-Object PSObject -Property @{
"Title" = $_["Title"]
"Name" = $_["Name"]
"Alt_ID" = $_["Alt_ID"]
"DocGroup" = $_["DocumentGroup"]
"DocCategory" = $_["Category"]
"Modified Date" = $_["Modified"]
}
$exportlist += $obj
$exportlist | Export-Csv -path 'C:\Root\MinorAlterationLetters.csv' -noType
}
$SPWeb.Dispose()

# Download the files
$SPWeb = Get-SPWeb "http://cp-sp2013-wfe1/sites/CP"
$files = $SPWeb.GetFolder("http://cp-sp2013-wfe1/sites/CP/Minor Alteration Letters").Files
foreach ($file in $files) {
    Write-host $file.Name
    $b = $file.OpenBinary()
    $fs = New-Object System.IO.FileStream(("C:\Root\MinorAlterationLetters\"+$file.Name), [System.IO.FileMode]::Create,[System.IO.FileAccess]::ReadWrite)
    $bw = New-Object System.IO.BinaryWriter($fs)
    $bw.Write($b)
    $bw.Close()
#        $stream = New-Object System.IO.FileStream($folderPathToSave,[System.IO.FileMode]::Create,[System.IO.FileAccess]::ReadWrite);
#        $writer = New-Object System.IO.BinaryWriter($stream);
#        $writer.Write($binary);
#        $writer.Close();

}

