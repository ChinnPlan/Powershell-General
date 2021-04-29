<#
    search1Project.psm1
    .SYNOPSIS
	  Constructs a search of the object type Accela Records
#>

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================

function search1Project
	{
    [CmdletBinding()]
	Param(
	  [Parameter(Mandatory=$true)]
	  [string]$RECORD_ID,
	  [Parameter(Mandatory=$true)]
	  [string]$RECORD_NAME,
	  [string]$PARCEL_NUMBER,
	  [Parameter(Mandatory=$true)]
	  [string]$RECORD_TYPE,
	  [Parameter(Mandatory=$true)]
	  [string]$RECORD_STATUS
	)

	Begin
		{
		# Load the M-Files API.
		[Reflection.Assembly]::LoadWithPartialName( "Interop.MFilesAPI" )


		# Connect to the M-Files server with current Windows user (must be system administrator).
		$mfClient = New-Object MFilesAPI.MFilesClientApplicationClass
		$myConnection = $mfClient.GetVaultConnection("Planning Dev") 
		$mfVault = $mfClient.BindToVault("Planning Dev", 0, $true, $false)

		## Get the Object Type
		$mfObjects = $mfVault.ObjectTypeOperations.GetObjectTypes()
		foreach ($mfObject in $mfObjects)
			{
			Write-Host $mfObject.ID
			if ($mfObject.NameSingular.ToString() -eq "Project2")
				{
				$objType = $mfObject
				}
			}

		# $objType = getObjectType($mfVault, "Project2")

		# Search condition = RECORD_ID
		$mySearchCondition = New-Object MFilesAPI.SearchConditionClass
		$mySearchCondition.ConditionType = 1
		$prop = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.RecordNumber")
		# $prop = 1058
		$mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
		$myDataType = 1
		$mySearchCondition.TypedValue.SetValue($myDataType, $RECORD_ID)

		$mySearchConditions = New-Object MFilesAPI.SearchConditionsClass
		$mySearchConditions.Add(-1, $mySearchCondition)

		# Search condition = Project2
		$mySearchCondition = New-Object MFilesAPI.SearchConditionClass
		$mySearchCondition.ConditionType = 1
		$prop = 100
		$mySearchCondition.Expression.DataPropertyValuePropertyDef = $prop
		$myDataType = 9
		$value = 56
		$mySearchCondition.TypedValue.SetValue($myDataType, $value)
		$mySearchConditions.Add(-1, $mySearchCondition)

		$myResults = $mfVault.ObjectSearchOperations.SearchForObjectsByConditionsEx($mySearchConditions, 0, $false, 0)
		if ($myResults.Count -gt 0)
			{
			Write-Host "Got one"
			}
		else
			{
			Write-Host "Cannot find it"
			$propertyValues = New-Object MFilesAPI.PropertyValuesClass
			# Single-file object
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = 22
			$oPropVal.PropertyDef = $propdef
			$oDataType = 8
			$oPropVal.TypedValue.SetValue($oDataType, $false)
			$propertyValues.Add(-1, $oPropVal)
			# Class ID
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = 100
			$oPropVal.PropertyDef = $propdef
			$oDataType = 9
			$value = 56
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)

			# RECORD_ID
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.RecordNumber")
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1
			$value = $RECORD_ID
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)

			# RECORD_NAME
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.ApplicationName")
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1
			$value = $RECORD_NAME
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)

			# PARCEL_NUMBER
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.ParcelNumber")
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1

			if ($PARCEL_NUMBER -eq $null)
				{
				$PARCEL_NUMBER = ""
				}
			$value = $PARCEL_NUMBER
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)
			# RECORD_STATUS
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.RecordStatus")
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1
			$value = $RECORD_STATUS
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)
			# RECORD_TYPE
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = $mfVault.PropertyDefOperations.GetPropertyDefIDByAlias("M-Files.Property.RecordType")
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1
			$value = $RECORD_TYPE
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)
			# Name or Title
			$oPropVal = New-Object MFilesAPI.PropertyValueClass
			$propdef = 0
			$oPropVal.PropertyDef = $propdef
			$oDataType = 1
			$value = $RECORD_ID + "--" + $RECORD_NAME
			$oPropVal.TypedValue.SetValue($oDataType,$value)
			$propertyValues.Add(-1, $oPropVal)

			$mySourcefiles = New-Object MFilesAPI.SourceObjectFilesClass
			$myACLs = New-Object MFilesAPI.AccessControlListClass

			$newObj = $mfVault.ObjectOperations.CreateNewObject($objType.ID, $propertyValues, $mySourcefiles, $myACLs)
			$mfVault.ObjectOperations.CheckIn($newObj.ObjVer)
			}
		
		}

	}