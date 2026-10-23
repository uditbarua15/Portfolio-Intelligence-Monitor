# After Power BI "Export to PDF", copies the newest PDF from %TEMP% into Reports\ with today's date.
$ErrorActionPreference = 'Stop'
try {
  $dest = '<PROJECT_DIR>\Reports\Portfolio_Report_' + (Get-Date -Format 'yyyy-MM-dd') + '.pdf'
  $src = Get-ChildItem (Join-Path $env:TEMP 'Power BI Desktop') -Recurse -Filter '*.pdf' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if (-not $src) { throw 'No exported PDF found' }
  if ($src.LastWriteTime -lt (Get-Date).AddMinutes(-5)) { throw 'Newest PDF is older than 5 minutes' }
  Copy-Item $src.FullName $dest -Force
  Write-Output ('COPIED ' + $src.Length + ' bytes')
} catch { Write-Output ('FAILED: ' + $_.Exception.Message) }
