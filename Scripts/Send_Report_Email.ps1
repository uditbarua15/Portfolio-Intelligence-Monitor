# Used inside the PAD sub-flow. Placeholders: <PROJECT_DIR>, <YOUR_EMAIL>, <CC_EMAIL> (optional copy recipient; delete the -Cc part if not needed). Password is read from env var GMAIL_APP_PASSWORD.
$ErrorActionPreference = 'Stop'
try {
  $date = Get-Date -Format 'yyyy-MM-dd'
  $ReportPath = '<PROJECT_DIR>\Reports\Portfolio_Report_' + $date + '.pdf'
  $pw = ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GMAIL_APP_PASSWORD','User').Trim()) -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential('<YOUR_EMAIL>',$pw)
  Send-MailMessage -From 'Portfolio Monitor <<YOUR_EMAIL>>' -To '<YOUR_EMAIL>' -Cc '<CC_EMAIL>' -Subject ('Portfolio Report ' + $date) -Body 'Your daily portfolio report is attached.' -Attachments $ReportPath -SmtpServer smtp.gmail.com -Port 587 -UseSsl -Credential $cred
  Write-Output 'SENT'
} catch { Write-Output ('FAILED: ' + $_.Exception.Message) }
