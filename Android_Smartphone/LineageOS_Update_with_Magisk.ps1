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

& adb.exe push "$env:USERPROFILE/Downloads/boot.img" /storage/emulated/0/Download

Add-Type -AssemblyName System.Windows.Forms
Write-Host "Magisk > Install > Select and Patch a File > boot.img > Let's Go." -ForegroundColor Yellow
[Windows.Forms.MessageBox]::Show("Magisk > Install > Select and Patch a File > boot.img > Let's Go.", [Windows.Forms.MessageBoxButtons]::OK)

& adb.exe pull /storage/emulated/0/Download/magisk_patched.img "$env:USERPROFILE\Downloads"

& adb.exe reboot sideload

Write-Host 'Please wait for phone to reboot into sideload' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Please wait for phone to reboot into sideload', [Windows.Forms.MessageBoxButtons]::OK)

& adb.exe sideload (Get-ChildItem "$env:USERPROFILE\Downloads\*.zip" | Where-Object {
        $_.Name -like '*lineage*'
    } | Select-Object -First 1).FullName

Write-Host 'Do you want to reboot to recovery now? Yes' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Do you want to reboot to recovery now? Yes', [Windows.Forms.MessageBoxButtons]::OK)

Write-Host 'Advanced > Enable ADB' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Advanced > Enable ADB', [Windows.Forms.MessageBoxButtons]::OK)

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

& adb.exe reboot sideload

Write-Host 'Please wait for phone to reboot into sideload' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Please wait for phone to reboot into sideload', [Windows.Forms.MessageBoxButtons]::OK)

& adb.exe sideload (Get-ChildItem "$env:USERPROFILE\Downloads\*.zip" | Where-Object {
        $_.Name -like '*MindTheGapps*'
    } | Select-Object -First 1).FullName

Write-Host 'Install anyway? > Yes' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Install anyway? > Yes', [Windows.Forms.MessageBoxButtons]::OK)

Write-Host 'Advanced > Enable ADB' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Advanced > Enable ADB', [Windows.Forms.MessageBoxButtons]::OK)

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

& adb.exe reboot bootloader

Write-Host 'Please wait for phone to reboot into bootloader' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Please wait for phone to reboot into bootloader', [Windows.Forms.MessageBoxButtons]::OK)

& fastboot.exe flash boot "$env:USERPROFILE\Downloads\magisk_patched.img"

& fastboot.exe reboot

Write-Host 'Please disable USB debugging' -ForegroundColor Yellow 
[Windows.Forms.MessageBox]::Show('Please disable USB debugging', [Windows.Forms.MessageBoxButtons]::OK)