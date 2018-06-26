    $adsFile = New-Object PSObject -Property @{
        "DocName" = $_["DocName"]
        "DocClass" = $_["DocClass"]
        "FullName" = ""
        "Project" = $_["Project"]
        "DocGroup" = $_["DocGroup"]
        "DocCategory" = $_["DocCategory"]
        }
    $ads1k += $adsFile
    $ads1k | Export-Csv c:\Scripts\M-files_1k.csv -delimiter "|"

         $ads1k += Get-ChildItem -Path $Accela_doc.thepath -Include $Accela_doc.DOCNAME -Recurse | Select-Object $adsFile.DocName, $adsFile.DocClass, FullName, $adsFile.Project, $adsFile.DocGroup, $adsFile.DocCategory

# List all the other properties and their values.
foreach ($oPropertyValue2 in $mfResult.Properties)

    if ($oPropertyValue2.PropertyDef -ne MFilesAPI.MFBuiltInPropertyDef.MFBuiltInPropertyDefNameOrTitle)
        {
        # Find the property definition for the property.
        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)

        # Output the name and the value of the property.
        Write-Host " " $oPropertyDef.Name + ": " + $oPropertyValue2.TypedValue.DisplayValue
        }
    End If

Next



### Dealing with document search results

foreach ($mfResult in $myResults)
    {
#    $mfResult | Get-Member
    $myObjID = $mfVault.ObjectOperations.GetObjIDByGUID($mfResult.ObjectGUID)
    
    $myFiles = $mfResult.Files
    foreach ($file in $myFiles)
        {
        Write-Host $mfVault.GetGUID() " has this object " $mfResult.ObjectGUID " with this file " $file.FileGUID
        }
###    $oResult = $mfVault.ObjectOperations.GetLatestObjectVersionAndProperties($myObjID, $true)
###    Write-Host "My Object is " $mfResult.ObjectGUID " My File is " $oResult.Properties.
##    foreach ($oPropertyValue2 in $oResult.Properties)
##        {
        # Find the property definition for the property.
##        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)

        # Output the name and the value of the property.
##        Write-Host " " $oPropertyDef.Name ": " $oPropertyValue2.TypedValue.DisplayValue

#        if ($oPropertyDef.Name -eq "Project") {
#            $vProject = $oPropertyValue2.TypedValue.DisplayValue }
#        if ($oPropertyDef.Name -eq "Document Group") {
#            $vDocGroup = $oPropertyValue2.TypedValue.DisplayValue }
#        if ($oPropertyDef.Name -eq "Document Category") {
#            $vDocCategory = $oPropertyValue2.TypedValue.DisplayValue }
##        }

#       $mFile = New-Object PSObject -Property @{
#            "DocName" = $mfResult.GetNameForFileSystem()
#            "DocClass" = $mfResult.Class
#            "Project" = $vProject
#            "DocGroup" = $vDocGroup
#            "DocCategory" = $vDocCategory
#            }
#         $mFiles += $mFile
#         $mFiles | Export-Csv c:\Scripts\testPPTSdocs.csv -delimiter "|"

#    Write-Host $mfResult.GetNameForFileSystem() ":" $mfResult.Class
    }
