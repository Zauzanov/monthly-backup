# monthly-backup
A PowerShell script designed to automate monthly folder backups into ZIP archives with timestamps. 

## 1. Replace the paths in the source code(`mb.ps1` file) with your own;
## 2. To run this script automatically every month, do the following:
### 2.1 Open `Windows Task Scheduler`;
### 2.2 Create a new task;
### 2.3 Under `Triggers` select `Monthly`
### 2.4 Under `Actions` specify:
```
- Program: `powershell.exe`
- Arguments: `-ExecutionPolicy Bypass -File “C:\path\to\script\mb.ps1”`
```