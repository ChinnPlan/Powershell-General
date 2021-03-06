PARAM (
#  $Path = '\\CITYPLN-INFOVOL\I$\CASES\2013',
  $Path = 'I:\Citywide\City Design\SDAT\Minutes\Vlads Archive Zone',
  $Report = 'c:\users\achinn\downloads\SDATminutes.csv'
  )

$Class = @{
    Name = 'Class'
    Expression = { 10 }
 }

$WorkingDraftType = @{
  Name = 'WorkingDraftType'
  Expression = { 'SDAT Document' }
}
$DocGroup = @{
  Name = 'DocGroup'
  Expression = { 'PLN' }
}
$DocCategory = @{
  Name = 'DocCategory'
  Expression = { 'Staff Report' }
}
$Project = @{
  Name = 'Project'
  Expression = { 'CCSF-15CAP-00000-00B8O' }
}
$Created = @{
  Name = 'Creation Time'
  Expression = { $_.CreationTime.ToString('yyyy-MM-dd HH:mm') }
}
$Creator = @{
  Name = 'File Creator'
  Expression = { getFirstLast (Get-Acl $_.FullName).Owner.Substring(13) }
}

$LastWrite = @{
  Name = 'Last Write Time'
  Expression = { $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm') }
}
$Owner = @{
  Name = 'File Owner'
  Expression = { Owner.Substring(13) }
}

# Sample Call of this script
# .\Get-ChildItems -Path 'I:\MEA\Greenhouse Gases\June 2016 Research\GHG Legislation and Plans' -Report c:\temp\test.csv
import-module ActiveDirectory
Import-Module -Name 'C:\AlphaFS.2.1.2.0\Lib\Net40\AlphaFS.dll'

function getFirstLast ($AD_name)
    {
    $user = Get-ADUser -Identity $AD_name
    return $user.Name
    }

# Get-ChildItem I: -recurse | Where-Object {$_.PSIsContainer -eq $True} | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-AlphaFSChildItem I: -recurse | Where-Object {$_.PSIsContainer -eq $True} | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-ChildItem -Recurse -Depth 2 -Path $Path  | ?{ $_.PSIsContainer } | select Fullname, $LastWrite | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# Get-ChildItem -Recurse -Path $Path -Include *.* | select Name, $Class, Fullname, Directory, $Workprogram, $Created, $Creator, $LastWrite, $Owner | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
# [Alphaleonis.Win32.Filesystem.Directory]::EnumerateFileSystemEntries('\\CITYPLN-INFOVOL\InfoDrive', '*', [System.IO.SearchOption]::AllDirectories) 
# Attempts to get all directories in I:
# [Alphaleonis.Win32.Filesystem.Directory]::EnumerateDirectories('\\CITYPLN-INFOVOL\InfoDrive', '*')
# Retrieves files in i:\cases without creator or update information
Get-ChildItem -Recurse -Path $Path -Include *.pdf | select Fullname, Name, $Class, $WorkingDraftType, $Project, $DocCategory, $DocGroup | Sort-Object Fullname | Export-Csv -NoTypeInformation $Report
