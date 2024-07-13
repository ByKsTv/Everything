$WindowsUpdaterTask = 'Windows Updater'
$WindowsUpdaterTask_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $WindowsUpdaterTask }
if (!($WindowsUpdaterTask_Exists)) {
    Write-Host "Windows Updater: Task Scheduler: Adding $WindowsUpdaterTask" -ForegroundColor green -BackgroundColor black
    $WindowsUpdaterTask_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $WindowsUpdaterTask_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Updater.ps1')"
    $WindowsUpdaterTask_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $WindowsUpdaterTask_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $WindowsUpdaterTask_Parameters = @{
        TaskName  = $WindowsUpdaterTask
        Principal = $WindowsUpdaterTask_Principal
        Action    = $WindowsUpdaterTask_Action
        Trigger   = $WindowsUpdaterTask_Trigger
        Settings  = $WindowsUpdaterTask_Settings
    }
    Register-ScheduledTask @WindowsUpdaterTask_Parameters -Force
}

# https://stackoverflow.com/questions/15175054/powershell-install-windows-updates
Write-Host 'Windows Updater: Checking updates' -ForegroundColor green -BackgroundColor black
$Criteria = 'IsInstalled=0'
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search($Criteria).Updates

Write-Host 'Windows Updater: Downloading updates' -ForegroundColor green -BackgroundColor black
$Session = New-Object -ComObject Microsoft.Update.Session
$Downloader = $Session.CreateUpdateDownloader()
$Downloader.Updates = $SearchResult
$Downloader.Download()

Write-Host 'Windows Updater: Installing updates' -ForegroundColor green -BackgroundColor black
$Installer = New-Object -ComObject Microsoft.Update.Installer
$Installer.Updates = $SearchResult
$Result = $Installer.Install()

If ($Result.rebootRequired) {
    Write-Host 'Windows Updater: Restarting' -ForegroundColor green -BackgroundColor black
    shutdown /r /t 00
}

Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan