# Brings the Power BI Desktop window to the front before keystrokes are sent.
$p = Get-Process PBIDesktop -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if ($p) { $ok = (New-Object -ComObject WScript.Shell).AppActivate([int]$p.Id); Write-Output ('FOCUSED ' + $ok) } else { Write-Output 'NO WINDOW' }
