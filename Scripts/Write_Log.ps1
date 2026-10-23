# Appends one line to logs\run_log.csv. Change $step and $detail per call in the PAD flow.
$step = 'STEP'; $detail = 'detail text'
$dir = '<PROJECT_DIR>\logs'
$log = Join-Path $dir 'run_log.csv'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
if (-not (Test-Path $log)) { Add-Content $log 'timestamp,step,detail' }
Add-Content $log ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ',' + $step + ',' + $detail)
