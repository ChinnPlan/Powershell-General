PARAM (
  $Path = 'I:\Commissions\Advertisements',
  $Report = 'c:\temp\Advertisement.csv'
  )

$Class = @{
    Name = 'Class'
    Expression = { 39 }
    }

$HearingBody = @{
    Name = 'Hearing Body'
    Expression = { 'Planning Commission - CPC' }
    }

$HearingDocument = @{
    Name = 'Hearing Document'
    Expression = { 'Advertisement' }
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
Get-ChildItem -Recurse -Path $Path -Include *.* | select Name, $Class, Fullname, $HearingBody, $HearingDocument | Sort-Object Name | Export-Csv -NoTypeInformation $Report -Delimiter "|"