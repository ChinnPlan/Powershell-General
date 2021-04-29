<#
    listByClass.ps1
    .SYNOPSIS
	  Constructs a search by M-Files Class
#>

# Load the M-Files API.
[Reflection.Assembly]::LoadWithPartialName( "Interop.MFilesAPI" )

#*=============================================================================
#* FUNCTIONS
#*=============================================================================

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================


# Connect to the M-Files server with current Windows user (must be system administrator).
$mfclient = New-Object MFilesAPI.MFilesClientApplicationClass
$mfConnections = $mfclient.GetVaultConnections()
foreach ($mfvaultConnection in $mfConnections)
    {
    if ($mfvaultConnection.Name -eq "Planning Prod")
        {
        Write-Host $mfvaultConnection.Name
        break
        }
    }

if ($mfvaultConnection.IsLoggedIn())
    {
    $mfvault = $mfvaultConnection.BindToVault(0, $false, $false)
    Write-Host "No login needed"
    }
else
    {
	Write-Host "Gotta log in"
    $mfvault = $mfvaultConnection.LoginAsUser(3, "PublicUser", "remember", $null, $null)
	Write-Host "PublicUser is logged in"
    }

$mfClass = 29  # 29 is Notice of Special Restrictions, 18 is Environmental Analysis

$mySearchConditions = New-Object MFilesAPI.SearchConditionsClass

$mySearchCondition = New-Object MFilesAPI.SearchConditionClass
$mySearchCondition.ConditionType = 1	# 2 is NOT equals, 9 is startswith
$prop = 100  # 100 is MFBuiltInPropertyDef for Class
$mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
$myDataType = 9 # lookup list
$value = $mfClass
$mySearchCondition.TypedValue.SetValue($myDataType, $value)

$mySearchConditions.Add(-1, $mySearchCondition)

$myResults = $mfVault.ObjectSearchOperations.SearchForObjectsByConditionsEx($mySearchConditions, 0, $true, 0)

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
        if ($oPropertyDef.Name -eq "Project")
            {
            $vProject = $oPropertyValue2.TypedValue.DisplayValue
            if ($vProject.IndexOf("--") -ne -1)
                {
                $vRecordNumber = $vProject.Substring(0, $vProject.IndexOf("--"))
                }
            else
                {
                $vRecordNumber = $vProject
                }
            }
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
            "ObjectGUID" = $mfResult.ObjectGUID
            "FileGUID" = $file.FileGUID
            "RecordNumber" = $vRecordNumber
            "LastModified" = $file.LastWriteTimeUtc.ToShortDateString()
            }
         $mFiles += $mFile
         $mFiles | Export-Csv -NoTypeInformation I:\GIS\OASIS\ParcelInfoOnlineData\NSRs.csv -delimiter ","

    }



