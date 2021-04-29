ForEach ($Accela_rec in $Accela_recs)
	{
    if ($Accela_rec.B1_ALT_ID -ne $a)
        {
        $myItems = getProject $mfvault $Accela_rec.B1_ALT_ID
        $myItems | Select-Object
        if ($myItems.count -gt $b)
            {
            ## HERE IS WHERE I WANT TO CALL A FUNCTION TO RETRIEVE AND COPY DOWN ASSOCIATED ATTACHMENTS ##
            ForEach($myItem in $myItems)
                {
#                Write-Host $myItems.Name
                }

#            Write-Host $Accela_rec.B1_ALT_ID " has " $myItems.count " items"
            }
        }
    }


## Search by size (30)
$myCondition = New-Object MFilesAPI.SearchConditionClass
$value = 4 # conditiontype 1 for equal, 4 is less than
$myCondition.ConditionType = $value
$value = 31 # PropertyDef 100 for class, 30 for size
$myCondition.Expression.DataPropertyValuePropertyDef = $value
$myDataType = 2 # 1 for text, 9 for lookup, 2 for integer
$value = 110000
$myCondition.TypedValue.SetValue($myDataType, $value)
$mySearchConditions.Add(-1, $myCondition)



$Class = @{
    Name = 'Class'
    Expression = { 39 }
    }

$HearingBody = @{
    Name = 'Hearing Body'
    Expression = { 'Planning Commission - CPC' }
    }

$HearingDocument = @{
    Name = 'HearingDocument'
    Expression = { 'Advertisement' }
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

