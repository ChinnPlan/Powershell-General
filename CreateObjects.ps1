<#
    DeleteAllObjects.ps1
    .SYNOPSIS
	  Constructs a search of the object type Accela Records
#>

# Load the M-Files API.
[Reflection.Assembly]::LoadWithPartialName( "Interop.MFilesAPI" )

#*=============================================================================
#* FUNCTIONS
#*=============================================================================
function connectVaultonServer ($inServer, $inVaultName)
    {
    $mfvaults = $inServer.GetOnlineVaults()
    foreach ($mfvault in $mfvaults)
	    {
	    Write-Host "Vault: "$mfvault.Name
        if ($mfvault.Name -eq $inVaultName)
            {
            $myVault = $mfvault.LoginEx()
            return $myVault
            }
        }
    }

function getObjectType ($inVault, $inName)
    {
    $mfobjecttypes = $inVault.ObjectTypeOperations.GetObjectTypes()
    foreach ($mfobjecttype in $mfobjecttypes)
        {
        if ($mfobjecttype.NameSingular -eq $inName)
            {
            return $mfobjecttype
            }
        }
    }

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================


# Connect to the M-Files server with current Windows user (must be system administrator).
$mfserver = New-Object MFilesAPI.MFilesServerApplicationClass
$mfserver.ConnectAdministrative()

$mfVault = connectVaultonServer $mfserver "Planning Documents"
$myObjectType = getObjectType $mfVault "PPTS Record"

$a = Get-Date
Write-Host "At Start: " $a.ToLongTimeString()
Import-Csv I:\GIS\PPTS\Document Management\PPTS_Records.csv |`
ForEach-Object
	{
	$spSourceItems = $List.Items | where {$_['Name'] -eq $_.FileName}
	}

foreach ($mfResult in $myResults)
    {
    $myObjID = $mfVault.ObjectOperations.GetObjIDByGUID($mfResult.ObjectGUID)
    $mfVault.ObjectOperations.DestroyObject($myObjID, $true, -1)
    }
$b = Get-Date
$c = $b - $a
Write-Host "Elapsed time = " $c

$mfserver.Disconnect()

