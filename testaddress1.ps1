<#
    testaddress1.ps1
    .SYNOPSIS
	  Constructs a search of the PPTS doc class group
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
    if ($mfvaultConnection.Name -eq "CCSF Prod")
        {
#        Write-Host "Got it"
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
    $mfvault = $mfvaultConnection.LoginAsUser(3, "PublicUser", "remember", $null, $null)
    }


## Search by Document Name
$mySearchCondition = New-Object MFilesAPI.SearchConditionClass
$mySearchCondition.ConditionType = 1	# 1 is equals, 9 is startswith, 7 is contains
$prop = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.NameOrTitle")
$mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
$myDataType = 1
$value = "1-250_MISSOURI_ST_Address_File"
$mySearchCondition.TypedValue.SetValue($myDataType, $value)

$mySearchConditions = New-Object MFilesAPI.SearchConditionsClass

$mySearchConditions.Add(-1, $mySearchCondition)

$myResults = $mfVault.ObjectSearchOperations.SearchForObjectsByConditionsEx($mySearchConditions, 0, $false, 0)

foreach ($mfResult in $myResults)
    {
    $myObjID = $mfVault.ObjectOperations.GetObjIDByGUID($mfResult.ObjectGUID)
    $oResult = $mfVault.ObjectOperations.GetLatestObjectVersionAndProperties($myObjID, $true)
    foreach ($oPropertyValue2 in $oResult.Properties)
        {
        # Find the property definition for the property.
        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)
        Write-Host $oPropertyDef.Name + " datatype is " $oPropertyDef.DataType " and is " + $oPropertyValue2.TypedValue.Value
        }

#         $mFiles | Export-Csv c:\Scripts\testPPTSdocs.csv -delimiter "|"

    }


