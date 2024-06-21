$7Zip = '7-Zip Updater'
$7Zip_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $7Zip }
if (!($7Zip_Exists)) {
    Write-Host "7Zip: Task Scheduler: Adding $7Zip" -ForegroundColor green -BackgroundColor black
    $7Zip_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $7Zip_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')"
    $7Zip_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $7Zip_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $7Zip_Parameters = @{
        TaskName  = $7Zip
        Principal = $7Zip_Principal
        Action    = $7Zip_Action
        Trigger   = $7Zip_Trigger
        Settings  = $7Zip_Settings
    }
    Register-ScheduledTask @7Zip_Parameters -Force
}

Write-Host '7-Zip: Checking if updated' -ForegroundColor green -BackgroundColor black
$7ZipInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' -ErrorAction SilentlyContinue).DisplayVersion
$7ZipLatestVer = (Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').tag_name

if ($7ZipInstalledVer -match $7ZipLatestVer) {
    Write-Host '7-Zip: Latest Version Is Already Installed' -ForegroundColor green -BackgroundColor black
}

elseif ($7ZipInstalledVer -notmatch $7ZipLatestVer ) {
    Write-Host '7-Zip: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').assets | Where-Object name -Like '*-x64.msi*').browser_download_url, "$env:TEMP\7zip-x64.msi")
    
    Write-Host '7-Zip: Installing' -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\7zip-x64.msi" -ArgumentList '/quiet /norestart' -Wait
}