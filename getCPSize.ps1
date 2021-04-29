 
#Script settings
$SPWeb = Get-SPWeb "http://cp-sp2013-wfe1/sites/CP"

foreach ($list in $SPWeb.Lists)
	{
	if($list.BaseType -eq "DocumentLibrary")   
		{
		$listSize = 0
        $spItems = $list.Items | where {$_['Alt_ID'] -gt ""}
        foreach ($item in $spItems)
			{
    		$listSize += ($item.file).length
			}
		"Library Name: "+$list.Title+", Size: "+[Math]::Round(($listSize/1KB),2)+"KB"     
		}
	}
	
#Dispose web
$SPWeb.Dispose()	
