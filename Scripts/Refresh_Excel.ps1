# Refreshes Power Query / prices in the Excel model before Power BI reads it.
# Output: REFRESHED | FAILED: <msg>
$ErrorActionPreference = 'Stop'
$xl = $null
try {
  $xl = New-Object -ComObject Excel.Application
  $xl.Visible = $false
  $xl.DisplayAlerts = $false
  $wb = $xl.Workbooks.Open('<PROJECT_DIR>\Portfolio_Model.xlsx')
  $wb.RefreshAll()
  $xl.CalculateUntilAsyncQueriesDone()
  $wb.Save()
  $wb.Close($false)
  Write-Output 'REFRESHED'
} catch { Write-Output ('FAILED: ' + $_.Exception.Message) }
finally { if ($xl) { $xl.Quit() } }
