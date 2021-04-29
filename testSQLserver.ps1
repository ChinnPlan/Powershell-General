Import-Module SQLPS -DisableNameChecking
#out of the box, the SQLBrowser is disabled. To enable:
Set-Service SQLBrowser -StartupType Automatic
#sql browser must be installed and running for us
#to discover SQL Server instances
Start-Service “SQLBrowser”

$instanceName = "localhost"
$managedComputer = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $instanceName

#list server instances
$managedComputer.ServerInstances

#list server instances
$managedComputer.Services | Where-Object Type –eq “SqlServer” |Select-Object Name, State, Type, StartMode, ProcessId

$managedComputer.Services |
Select-Object Name, Type, ServiceState, DisplayName |
Format-Table -AutoSize
