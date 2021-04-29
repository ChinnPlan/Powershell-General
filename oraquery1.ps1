# Ora002.ps1
# Need installation of ODAC1120320Xcopy_x64.zip 
# The 32 bit version also exists

# Load the good assembly
# Add-Type -AssemblyName "C:\oracle\product\12.1.0\client_1\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
[Reflection.Assembly]::Assembly.LoadFrom("C:\oracle\product\12.1.0\client_1\odp.net\managed\common\Oracle.ManagedDataAccess.dll")
# Production connexion string
$compConStr = "Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=PLANDB-TCP)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=Plandb10)));User Id=gisdata;Password=gisdata;"

# Connexion
$oraConn= New-Object Oracle.DataAccess.Client.OracleConnection($compConStr)
$oraConn.Open()

# Requête SQL
$sql1 = @"
select BLOCKLOT, FILENAME from gisdata.mapphotos
"@

$command1 = New-Object Oracle.DataAccess.Client.OracleCommand($sql1,$oraConn)

# Execution
$reader1=$command1.ExecuteReader()

$n = 0
while ($reader1.read())
{
  $reader1["FILENAME"]  
}

# Fermeture de la conexion
$reader1.Close()
$oraConn.Close()

Write-Output $retObj