# Check4NewVersion.ps1

$Files = Get-ChildItem -LiteralPath 'C:\Program Files\M-Files' -Directory | Where {$_.Creationtime -gt (Get-Date).AddDays(-2)}

[string]$Report = $files | Convertto-HTML -as Table

# Send-MailMessage -SmtpServer smtp.server.test -Body $Report -BodyAsHtml -Subject "New M-File Version Found" -To alton.chinn@sfgov.org -From Sender@domain.com
Write-Host $Report