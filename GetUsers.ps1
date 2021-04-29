<#
    testGetUsers.ps1
    .SYNOPSIS
	  Constructs a search of the PPTS doc class group
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
$mfVault = connectVaultonServer $mfserver "CCSF Prod"

# This includes ID and LoginName ( ie CITYPLANNING\rschuett )
$loginList = $mfVault.UserOperations.GetUserAccounts()

# Get the Accela users
$UsersPlanning = Import-Csv "C:\M-Files_Indexes\UsersPlanning.csv"

# This includes fullname, UserName, EmailAddress, AccountName
# $loginList = $mfserver.LoginAccountOperations.GetLoginAccounts()

# Set up list for list
$user_Accounts = @()

foreach ($login in $loginList)
    {
    if ($login.Enabled)
        {
        $user = $mfserver.LoginAccountOperations.GetLoginAccount($login.LoginName)
        if ($user -ne $null)
            {
            foreach($planner in $UsersPlanning)
                {
                if ($user.UserName.ToUpper() -eq $planner."USER ID")
                    {
                    Write-Host $user.FullName, " is ", $login.ID, " username ", $user.UserName, " email ", $user.EmailAddress, ":", $login.LoginName, ":", $planner.Phone
                    $user_Account = New-Object PSObject -Property @{
                        "Login Account" = $user.UserName.ToUpper()
                        "ID" = $login.ID
                        "Full Name" = $user.FullName
                        "eMail" = $user.EmailAddress
                        "Phone" = $planner.PHONE
                        }
                    $user_Accounts += $user_Account
                    $user_Accounts | Export-Csv c:\M-Files_Indexes\User_Accounts.csv -NoTypeInformation -delimiter ","
                    }
                }
            }
        $user = $null
        }
#     Write-Host $login.ID, " username ", $login.LoginName, " internal? ", $login.InternalUser
#     Get-Member -InputObject $login
    }
# Write-Host "Number of Accounts: ", $loginList.Count

$mfserver.Disconnect()

