PARAM (
    $StartLevel = 0,
    $Depth = 2,
    $Path = "E:",
    $Report = 'c:\users\achinn\downloads\docket_csvs.csv'
  )


# Get-ChildItem I: -recurse | Where-Object {$_.PSIsContainer -eq $True} | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-AlphaFSChildItem I: -recurse | Where-Object {$_.PSIsContainer -eq $True} | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-ChildItem -Recurse -Depth 2 -Path $Path  | ?{ $_.PSIsContainer } | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-ChildItem -Recurse -Path $Path -Include *.* | select Name, $Class, Fullname, Directory, $Workprogram, $Created, $Creator, $LastWrite, $Owner | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# [Alphaleonis.Win32.Filesystem.Directory]::EnumerateFileSystemEntries('\\CITYPLN-INFOVOL\InfoDrive', '*', [System.IO.SearchOption]::AllDirectories) 
# Attempts to get all directories in I:
# [Alphaleonis.Win32.Filesystem.Directory]::EnumerateDirectories('\\CITYPLN-INFOVOL\InfoDrive', '*')


# Retrieves files in i:\cases without creator or update information
# Get-ChildItem  -Recurse -Depth 0 -Path $Path -Include *.csv | select Name, Fullname | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter "|"
For ($i=$StartLevel; $i -le $Depth; $i++) {
    $Levels = "\*" * $i
    (Resolve-Path $Path$Levels).ProviderPath | Get-Item | Where Extension -eq ".csv" | Select Name, FullName | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter "|"
}
