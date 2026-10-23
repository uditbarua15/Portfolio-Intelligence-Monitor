# Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| SMTP 5.7.8 BadCredentials | Wrong or revoked app password, or PAD's built-in email action used | Regenerate the app password, update `GMAIL_APP_PASSWORD`, use the PowerShell sender |
| Report PDF not found | Path ended `.pdf.pdf` | Fix the path variable to a single `.pdf` |
| No exported PDF found | Keystrokes after a Power BI Refresh did not register | Open a `.pbit` template instead of refreshing by keyboard |
| Report shows yesterday's data | Excel not refreshed or old `.pbit` | Refresh Excel first; re-export the template after dashboard edits |
| Flow runs twice / duplicate email | Log deleted after sending | Do not delete `run_log.csv` on a sent day |
| PAD confirmation window waits | PAD asks before external runs | Launcher script presses Enter after 45 s |
| VM froze after closing PAD console by script | Force-killing PAD | Leave the console open |
| Watchdog file "does not exist" | Script not saved with exact name | Save as All files, `Check_Daily_Report.ps1` |
| Chrome PDF tab stays open | Ctrl+W went to wrong window | Activate `Untitled.pdf` window first, or close manually |
