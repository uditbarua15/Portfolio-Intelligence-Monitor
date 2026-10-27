# Watchdog, run by Task Scheduler at 4:30 PM Mon-Fri.
# Emails an alert if today's report (or holiday notice) was not logged as sent.
# PLACEHOLDERS: <PROJECT_DIR> and <YOUR_EMAIL>. Password comes from the user environment variable GMAIL_APP_PASSWORD (never in this file).
$ErrorActionPreference = 'Stop'
try {
  $now = Get-Date
  $today = $now.ToString('yyyy-MM-dd')
  if ($now.DayOfWeek -eq 'Saturday' -or $now.DayOfWeek -eq 'Sunday') { exit 0 }
  $log = '<PROJECT_DIR>\logs\run_log.csv'
  $lines = @()
  if (Test-Path $log) { $lines = @(Get-Content $log | Where-Object { $_ -like ($today + ' *') }) }
  $csv = Import-Csv '<PROJECT_DIR>\data\NSE_Holidays_2026.csv'
  $isHoliday = ($csv | Where-Object { $_.date -eq $today } | Measure-Object).Count -gt 0
  if ($isHoliday) { $ok = @($lines | Where-Object { $_ -like '*,HOLIDAY_EMAIL,SENT*' }).Count -gt 0 }
  else { $ok = @($lines | Where-Object { $_ -like '*,SENT_OK,*' }).Count -gt 0 }
  if (-not $ok) {
    $pw = ConvertTo-SecureString ([Environment]::GetEnvironmentVariable('GMAIL_APP_PASSWORD','User').Trim()) -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential('<YOUR_EMAIL>',$pw)
    $body = "Today's portfolio report did not go out.`r`n`r`nToday's log lines:`r`n" + ($lines -join "`r`n")
    Send-MailMessage -From 'Portfolio Monitor <<YOUR_EMAIL>>' -To '<YOUR_EMAIL>' -Subject ('ALERT: portfolio report missing ' + $today) -Body $body -SmtpServer smtp.gmail.com -Port 587 -UseSsl -Credential $cred
  } else {
    Get-Process 'PAD.Console.Host' -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object { [void]$_.CloseMainWindow() }
  }
} catch {
  Write-Output ('FAILED: ' + $_.Exception.Message)
}
