# Automation setup

Replace `<PROJECT_DIR>` (e.g. `C:\Users\<you>\Documents\PortfolioProject`), `<YOUR_EMAIL>` and `<RUN_URL>` in the scripts before use.

## 1. Gmail credential (once)
1. Google Account -> Security -> 2-Step Verification on -> App passwords -> create one.
2. Set a **user** environment variable `GMAIL_APP_PASSWORD` (Windows: Settings -> System -> About -> Advanced system settings -> Environment Variables). Do not paste it into chats, scripts or screenshots.
3. Test with `Send_Report_Email.ps1` after a PDF exists: expect `SENT`.

## 2. Folder
Create `<PROJECT_DIR>` with `data\`, `Reports\`, `logs\`, `scripts\`. Copy the scripts and the holidays CSV.

## 2b. Nifty 50 index (optional card)
In the price Google Sheet add a tab `Index` with headers `Name, Level, Change %` and row `Nifty 50`, `=GOOGLEFINANCE("INDEXNSE:NIFTY_50","price")`, `=GOOGLEFINANCE("INDEXNSE:NIFTY_50","changepct")`. Publish only that tab as CSV (keep the link private), load it in Excel Power Query as `Nifty_Index`, then into Power BI.

## 3. Power BI template
Build the dashboard, then File -> Export -> Power BI template (`.pbit`). The flow opens this file; it loads data automatically (~1 minute).

## 4. Power Automate Desktop flow `Daily_Portfolio_Report`
Use Run PowerShell actions with the scripts, in this order:
1. Write_Log `RUN_START`
2. Gate_Check -> `GateResult`; Write_Log `GATE`
3. If `GateResult` contains `SKIP_` or `WEEKEND` -> Stop flow (Successfully)
4. If contains `HOLIDAY` -> send the "market closed" email, log `HOLIDAY_EMAIL`, stop
5. If contains `FAILED` -> Stop flow (With error)
6. Refresh_Excel -> must contain `REFRESHED`; log `EXCEL_OK`
7. Run DOS command: `start "" "<PROJECT_DIR>\Portfolio Dashboard.pbit"`; Wait 90 s
8. Focus_PowerBI; Send keys with 300 ms delay: Alt, f, Enter, Down x7, Enter, Down, Enter (Export to PDF); Wait 15 s
9. Copy_Exported_PDF -> must contain `COPIED`; log `EXPORT_OK`
10. Close the Chrome window showing the PDF: PowerShell `Get-Process chrome | Where-Object { $_.MainWindowTitle -like '*Untitled.pdf*' }` then `CloseMainWindow()` (no keystrokes, no focus needed)
11. `Stop-Process -Name PBIDesktop -Force`
12. Run sub-flow `Send_Portfolio_Report` (Send_Report_Email); log `SENT_OK`
13. Last step: gently close the PAD console window (`CloseMainWindow()` on `PAD.Console.Host`). Never force-kill it; that once froze the VM.

Note: "Run desktop flow" hides inner errors; keep the logic in one flow where possible.

## 5. Task Scheduler
| Task | Trigger | Action |
|---|---|---|
| Portfolio_Daily_Report | Weekly Mon-Fri 4:00 PM | `powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "<PROJECT_DIR>\scripts\Run_Daily_Report.ps1"` |
| Portfolio_Report_Watchdog | Weekly Mon-Fri 4:30 PM | same, with `Check_Daily_Report.ps1` (also closes the PAD console if the report was sent) |

Settings: Run only when user is logged on; run missed task as soon as possible; do not start a new instance; stop after 1 hour.

## 6. Machine must be ready at 4 PM
Plugged in, awake, signed in and unlocked; Windows screen saver off; don't touch the screen 3:55-4:10 PM.

## 7. Tests before trusting it
- Run the flow by hand on a trading day after 15:45: email arrives, log shows `SENT_OK`.
- Run it again: expect `SKIP_DUP`, nothing opens.
- Delete nothing from the log on a day a report was sent.
- Run the watchdog with no `SENT_OK` logged: alert email arrives.
