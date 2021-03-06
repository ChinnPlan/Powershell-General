<#
    searchByObjectID.ps1
    .SYNOPSIS
	  Constructs a search by Object ID
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

$vObjID = "445-447 Hayes Street"

$vObj = New-Object MFilesAPI.ObjID
$vObj.SetIDs(0, $vObjID)

# $mfVault.ObjectOperations.DestroyObject($vObj, $true, -1)
