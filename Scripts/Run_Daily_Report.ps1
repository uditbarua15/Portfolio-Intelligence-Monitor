# Launched by Windows Task Scheduler at 4:00 PM Mon-Fri.
# Starts the Power Automate Desktop flow, then presses Enter on PAD's confirmation window.
# PLACEHOLDER: replace <RUN_URL> with your flow's Run URL (PAD > flow > Copy run URL). Keep the real URL out of GitHub.
$ErrorActionPreference = 'Stop'
$pad = 'C:\Program Files (x86)\Power Automate Desktop\PAD.Console.Host.exe'
$url = '<RUN_URL>'
Start-Process -FilePath $pad -ArgumentList $url
Start-Sleep -Seconds 45          # PAD cold start can be slow; 12 s was too short
$shell = New-Object -ComObject WScript.Shell
[void]$shell.AppActivate('Power Automate')
Start-Sleep -Seconds 1
$shell.SendKeys('{ENTER}')
