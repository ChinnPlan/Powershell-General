PARAM (
	$Path = 'E:\',
    $StartLevel = 0,
    $Depth = 2,
    $Report = 'c:\scripts\docket_csvs.csv'
  )


# Get-ChildItem -Recurse -Path $Path -Include *.csv | select Name, Fullname | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter "|"
For ($i=$StartLevel; $i -le $Depth; $i++) {
    $Levels = "\*" * $i
    (Resolve-Path $Path$Levels).ProviderPath | Get-Item | Where Extension -eq ".csv" | Select Name, FullName | Sort-Object FullName | Export-Csv -NoTypeInformation $Report -Delimiter "|"
}
