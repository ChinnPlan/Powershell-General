PARAM (
  $Path = 'I:\Temp\Record Digitization\Ricoh - Population 1 - Address files',
  $Report = 'c:\users\achinn\downloads\AddressFiles.csv'
  )

# Set up list for missing files
$filelisting = @()
$reftype = "Address File"

# Open Pop1.csv
$addrlistings = Import-Csv C:\users\achinn\Downloads\Pop1.csv -delimiter ","
ForEach ($item in $addrlistings)
	{
    $full = $item.Dir + "\" + $item.Name
    $addresses = Import-Csv $full -header PDF_FileName,Street_number,Street_Name,Street_Type,Image_FileName -delimiter ","
#    $addresses = Get-Content $full | Select -skip 0 | ConvertFrom-Csv -Header Name, Field2, Field3, Field4
    ForEach ($address in $addresses)
        {
        if ($address.Street_Type -eq "")
            {
            $combined = $address.Street_number.ToString() + " " + $address.Street_Name
            }
        else
            {
            $combined = $address.Street_number.ToString() + " " + $address.Street_Name + " " + $address.Street_Type
            }
        $addressFile = New-Object PSObject -Property @{
            "DocName" = $address.PDF_FileName.Substring(0,$address.PDF_FileName.Length-4)
            "DocClass" = 54
            "Address" = $combined
            "ReferenceType" = $reftype
            "FullName" = $item.Dir + "\" + $address.PDF_FileName
            "Street_Number" = $address.Street_number
            "Street_Name" = $address.Street_Name
            "Street_Type" = $address.Street_Type
            }
        $filelisting += $addressFile
        $filelisting | Export-Csv C:\users\achinn\Downloads\addressFiles.csv -delimiter "|"
        Write-Host $address.PDF_FileName.Substring(0,$address.PDF_FileName.Length-4)
        }
#    Write-Host $full
    }

