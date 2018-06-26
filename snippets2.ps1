
$mySearchCondition = New-Object MFilesAPI.SearchConditionClass
$mySearchCondition.ConditionType = 1	# 1 is equals, 9 is startswith
$prop = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.Project")
$mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
$myDataType = 10 # 10 is multiselect
$value = "2015-000940ENV--The Hub/Market Octavia Plan Update and Development Coordination"
$mySearchCondition.TypedValue.SetValue($myDataType, 98)

$mySearchConditions = New-Object MFilesAPI.SearchConditionsClass
$mySearchConditions.Add(-1, $mySearchCondition)

$myResults = $mfVault.ObjectSearchOperations.SearchForObjectsByConditionsEx($mySearchConditions, 0, $false, 0)


# Set up list for files
$mFiles = @()

foreach ($mfResult in $myResults)
    {
    $myObjID = $mfVault.ObjectOperations.GetObjIDByGUID($mfResult.ObjectGUID)
    $oResult = $mfVault.ObjectOperations.GetLatestObjectVersionAndProperties($myObjID, $true)
    foreach ($oPropertyValue2 in $oResult.Properties)
        {
        # Find the property definition for the property.
        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)

        # Output the name and the value of the property.
        if ($oPropertyDef.Name -eq "Name or Title") {
            $vDocName = $oPropertyValue2.TypedValue.DisplayValue }
        if ($oPropertyDef.Name -eq "Document Group") {
            $vDocGroup = $oPropertyValue2.TypedValue.DisplayValue }
        if ($oPropertyDef.Name -eq "Document Category") {
            $vDocCategory = $oPropertyValue2.TypedValue.DisplayValue }
        }

    $myFiles = $mfResult.Files
    foreach ($file in $myFiles)
        {
#        Write-Host $mfVault.GetGUID() " has this object " $mfResult.ObjectGUID " with this file " $file.FileGUID
        }
       $mFile = New-Object PSObject -Property @{
            "DocName" = $vDocName
            "VaultGUID" = $mfVault.GetGUID()
            "ObjectGUID" = $mfResult.ObjectGUID
            "FileGUID" = $file.FileGUID
            "DocGroup" = $vDocGroup
            "DocCategory" = $vDocCategory
            }
         $mFiles += $mFile
#         $mFiles | Export-Csv c:\Scripts\testPPTSdocs.csv -delimiter "|"

    }
return $mFiles




    $myObjectType = getObjectType $inVault "Project"

    $mySearchCondition = New-Object MFilesAPI.SearchConditionClass
    $mySearchCondition.ConditionType = 1
    # $mySearchCondition.Expression.SetStatusValueExpression(6, $null)
    $myDataType = 9 # 9 for lookup, 2 for 32-bit integer
    $mySearchCondition.TypedValue.SetValue($myDataType, $myObjectType.ID)

    $mySearchConditions = New-Object MFilesAPI.SearchConditionsClass
    $mySearchConditions.Add(-1, $mySearchCondition)

function search1Project($inVault, $inRecordNumber)
    {
    $mySearchCondition = New-Object MFilesAPI.SearchConditionClass
    $mySearchCondition.ConditionType = 1	# 1 is equals, 9 is startswith
    $prop = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.RecordNumber")
    $mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
    $myDataType = 1 # 1 is text
    $value = $inRecordNumber
    $mySearchCondition.TypedValue.SetValue($myDataType, $value)

    $mySearchConditions = New-Object MFilesAPI.SearchConditionsClass
    $mySearchConditions.Add(-1, $mySearchCondition)
    
    $myResults = $mfVault.ObjectSearchOperations.SearchForObjectsByConditionsEx($mySearchConditions, 0, $false, 0)

    foreach ($mfResult in $myResults)
    {
    return "Found one"
    $myObjID = $mfVault.ObjectOperations.GetObjIDByGUID($mfResult.ObjectGUID)
    $oResult = $mfVault.ObjectOperations.GetLatestObjectVersionAndProperties($myObjID, $true)
    foreach ($oPropertyValue2 in $oResult.Properties)
        {
        # Find the property definition for the property.
        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)

        # Output the name and the value of the property.
        if ($oPropertyDef.Name -eq "Name or Title") {
            $vProjectName = $oPropertyValue2.TypedValue.DisplayValue }
        }
    }
}
