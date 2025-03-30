& adb.exe kill-server

do {
    $ADB_Devices_CMD = & adb.exe devices
    $ADB_Devices_Line = ($ADB_Devices_CMD -split "`n")[1].Trim()
    if (-not $ADB_Devices_Line) {
        Write-Host 'Please connect a device and enable USB debugging on the developer options' -ForegroundColor Red
    }
    elseif ($ADB_Devices_Line -match 'unauthorized') {
        Write-Host 'On the phone check `Always allow from this computer` and click `Allow`' -ForegroundColor Yellow
    }
    elseif ($ADB_Devices_Line -match 'device') {
        Write-Host 'Device found' -ForegroundColor Green
    }
    Start-Sleep -Seconds 1
} until ($ADB_Devices_Line -match 'device')

Get-ChildItem "$env:USERPROFILE\Downloads" -Filter *.apk | ForEach-Object {
    & adb.exe install $_.FullName
}