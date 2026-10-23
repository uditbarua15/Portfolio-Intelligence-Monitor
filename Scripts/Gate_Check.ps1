# Used inside the PAD flow (Run PowerShell action, output variable GateResult).
# Output: WEEKEND | HOLIDAY: <reason> | SKIP_EARLY | SKIP_DUP | TRADING | FAILED: <msg>
$ErrorActionPreference = 'Stop'
try {
  $now = Get-Date
  $today = $now.ToString('yyyy-MM-dd')
  $log = '<PROJECT_DIR>\logs\run_log.csv'
  $done = $false
  if (Test-Path $log) {
    $done = @(Get-Content $log | Where-Object { $_ -like ($today + ' *,SENT_OK,*') -or $_ -like ($today + ' *,HOLIDAY_EMAIL,SENT*') }).Count -gt 0
  }
  $dow = $now.DayOfWeek
  if ($dow -eq 'Saturday' -or $dow -eq 'Sunday') {
    Write-Output 'WEEKEND'
  } else {
    $csv = Import-Csv '<PROJECT_DIR>\data\NSE_Holidays_2026.csv'
    $hit = $csv | Where-Object { $_.date -eq $today } | Select-Object -First 1
    if ($hit) {
      if ($done) { Write-Output 'SKIP_DUP: already emailed today' }
      else { Write-Output ('HOLIDAY: ' + $hit.reason) }
    } elseif ($now.TimeOfDay -lt (New-TimeSpan -Hours 15 -Minutes 45)) {
      Write-Output 'SKIP_EARLY: before 15:45, prices not final'
    } elseif ($done) {
      Write-Output 'SKIP_DUP: report already sent today'
    } else {
      Write-Output 'TRADING'
    }
  }
} catch { Write-Output ('FAILED: ' + $_.Exception.Message) }
