<#
    SearchPPTSDocs.ps1
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
    if ($mfvaultConnection.Name -eq "Planning Prod")
        {
        Write-Host "Got it"
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

# Open csv
$docs = Import-Csv C:\Users\achinn\Downloads\docketFixes.csv -delimiter ","
ForEach ($doc in $docs)
	{
    $vObjID = $doc.objID
    $vName = $doc.fixedName

    $vObj = New-Object MFilesAPI.ObjID
    $vObj.SetIDs(0, $vObjID)

    $myResult = $mfVault.ObjectOperations.CheckOut($vObj)
    foreach ($oPropertyValue2 in $myResult.Properties)
        {
        # Find the property definition for the property.
        $oPropertyDef = $mfVault.PropertyDefOperations.GetPropertyDef($oPropertyValue2.PropertyDef)
#        Write-Host $oPropertyDef.Name, " is ", $oPropertyValue2.TypedValue.DisplayValue
        if ($oPropertyDef.Name -eq "Name or Title") {
            $oPropertyValue2.TypedValue.SetValue(1, $vName)
            $mfVault.ObjectPropertyOperations.SetProperty($myResult.ObjVer, $oPropertyValue2)
            $myResult = $mfVault.ObjectOperations.CheckIn($vObj)
            }
        }
    }
