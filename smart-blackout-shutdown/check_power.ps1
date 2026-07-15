# 1. Check if qBittorrent is running for any user (required for SYSTEM context)
$TorrentProcess = Get-Process -Name "qbittorrent" -IncludeUserName -ErrorAction SilentlyContinue

if ($TorrentProcess) {
    # 2. Check power status: $true = AC power (plugged in), $false = Battery power
    $BatteryStatus = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnLine
    
    if ($BatteryStatus -eq $false) {
        # If torrent is running AND power is lost, wait 15 seconds (protection against temporary router glitches)
        Start-Sleep -Seconds 15
        
        # 3. Check the Wi-Fi connection status
        $WiFiStatus = Get-NetAdapter -Name "*" | Where-Object {$_.InterfaceDescription -like "*Wireless*" -or $_.InterfaceDescription -like "*Wi-Fi*"}
        
        # If Wi-Fi is still disconnected (Status is not 'Up'), force a PC shutdown
        if ($WiFiStatus.Status -ne "Up") {
            shutdown /s /f /t 30
        }
    }
}
