# qBittorrent Power Saver — Smart Shutdown Script written in Powershell
PowerShell script to automatically shutdown Windows laptop during blackouts when qBittorrent is running, power is lost, and Wi-Fi disconnects.

## How It Works
The script is triggered instantly whenever Windows detects a network disconnection (e.g., your Wi-Fi router loses power). Once triggered, it runs a background check for **three strict conditions**:
1. **Is qBittorrent running?** (If you are not downloading anything, the laptop stays on).
2. **Is the laptop running on battery?** (If you just unplugged the router manually but the laptop is plugged into the wall, it stays on).
3. **Is Wi-Fi completely disconnected?** (Includes a 15-second grace period for minor router reboots).

If all conditions are met, the script triggers a safe, forced Windows shutdown with a 30-second warning timer.

---

## Step 1: Save the Script

1. Create a text file on your laptop and name it `check_power.ps1`.
2. Copy and paste the following code into it:

```powershell
# 1. Check if qBittorrent is running for ANY user (required for SYSTEM context)
$TorrentProcess = Get-Process -Name "qbittorrent" -IncludeUserName -ErrorAction SilentlyContinue

if ($TorrentProcess) {
    # 2. Check power status: $true = AC power, $false = Battery
    $BatteryStatus = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnLine
    
    if ($BatteryStatus -eq $false) {
        # Grace period (15s) in case the router just flickered
        Start-Sleep -Seconds 15
        
        # 3. Check if Wi-Fi is still down
        $WiFiStatus = Get-NetAdapter -Name "*" | Where-Object {$_.InterfaceDescription -like "*Wireless*" -or $_.InterfaceDescription -like "*Wi-Fi*"}
        
        # If Wi-Fi is still disconnected (Status is not 'Up'), shut down the PC
        if ($WiFiStatus.Status -ne "Up") {
            shutdown /s /f /t 30
        }
    }
}
```
3. Save the file to a secure directory (e.g., `C:\Scripts\check_power.ps1`).

---

## Step 2: Configure Windows Task Scheduler

To ensure this script works seamlessly—even when your laptop screen is locked (**Win + L**) and without prompting you for a password—follow these steps in the Windows Task Scheduler.

### 1. Create a New Task
- [ ] Press `Win + R`, type `taskschd.msc`, and hit **Enter**.
- [ ] In the right-hand panel, click **Create Basic Task...**.
- [ ] Name it `Smart Blackout Shutdown` and click **Next**.

### 2. Set the Trigger
- [ ] Select **When a specific event is logged** -> click **Next**.
- [ ] Fill in the following Event parameters:
  - **Log** `Microsoft-Windows-NetworkProfile/Operational`
  - **Source** `NetworkProfile`
  - **Event ID** `10001` *(This specific ID represents network disconnection)*
- [ ] Click **Next**.

### 3. Set the Action
- [ ] Select **Start a program** -> click **Next**.
- [ ] In the **Program/script** field, type: `powershell`
- [ ] In the **Add arguments (optional)** field, paste the following line (adjust the path if yours is different):
  ```text
  -ExecutionPolicy Bypass -File "C:\check_power.ps1"
  ```
- [ ] Click **Next**, then click **Finish**.

### 4. Critical Configuration (Must-Do Properties Checkboxes)
Find your newly created task in the center list, **right-click it**, select **Properties**, and strictly configure these checkboxes across the tabs:

#### [General Tab] Security Options
- [ ] Check **Run whether user is logged on or not**.
- [ ] Check **Run with highest privileges** — *Essential for the shutdown command to work.*
- [ ] Click **Change User or Group...** -> type `SYSTEM` (or `СИСТЕМА` on Russian Windows) -> click **Check Names**, then click **OK**. *This completely bypasses the need to type your Windows password.*

#### [Conditions Tab] Power Options
- [ ] **UNCHECK** **Start the task only if the computer is on AC power**. *If left checked, the script will refuse to run when the power goes out!*

Click **OK** to save all changes.

---

## How to Temporarily Disable This Task
If you want to manually disable this automation rule (e.g., you are working away from home on public Wi-Fi):
1. Open **Task Scheduler**.
2. Right-click `Smart Shutdown` in the list.
3. Click **Disable**.
4. Click **Enable** when you want it back on.
