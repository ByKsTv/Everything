$TaskName = 'Windows Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Update.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

Write-Host 'Searching for updates (software only)...'
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()

# Criteria: Adjust to include drivers: IsInstalled=0 and IsHidden=0
$criteria = "IsInstalled=0 and Type='Software' and IsHidden=0"
$searchResult = $searcher.Search($criteria)

if ($searchResult.Updates.Count -eq 0) {
    Write-Host 'No updates available.'
    return
}

Write-Host "Found $($searchResult.Updates.Count) updates:"
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
    $u = $searchResult.Updates.Item($i)
    Write-Host ('[{0}] {1}' -f $i, $u.Title)
}

# Prepare download collection
$updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
    $updatesToDownload.Add($searchResult.Updates.Item($i)) | Out-Null
}

Write-Host "`nDownloading..."
$downloader = $session.CreateUpdateDownloader()
$downloader.Updates = $updatesToDownload
$dlResult = $downloader.Download()

$rcMap = @{
    0 = 'NotStarted'; 1 = 'InProgress'; 2 = 'Succeeded'; 3 = 'SucceededWithErrors'; 4 = 'Failed'; 5 = 'Aborted'
}

Write-Host "Download overall: $($rcMap[$dlResult.ResultCode])  (ResultCode=$($dlResult.ResultCode))"
if ($dlResult.HResult -ne 0) {
    Write-Warning ('Download HResult: 0x{0:X8}' -f $dlResult.HResult)
}

# Build collection of successfully downloaded
$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $updatesToDownload.Count; $i++) {
    $u = $updatesToDownload.Item($i)
    $status = if ($u.IsDownloaded) {
        'READY' 
    }
    else {
        'NOT DOWNLOADED' 
    }
    Write-Host ('[{0}] {1} --> {2}' -f $i, $u.Title, $status)
    if ($u.IsDownloaded) {
        $updatesToInstall.Add($u) | Out-Null 
    }
}

if ($updatesToInstall.Count -eq 0) {
    Write-Warning 'No updates downloaded successfully. Exiting.'
    Start-Sleep 10
    return
}

Write-Host "`nInstalling $($updatesToInstall.Count) updates..."
$installer = $session.CreateUpdateInstaller()
$installer.Updates = $updatesToInstall
$installResult = $installer.Install()

Write-Host "Install overall: $($rcMap[$installResult.ResultCode]) (ResultCode=$($installResult.ResultCode))"
if ($installResult.HResult -ne 0) {
    Write-Warning ('Install HResult: 0x{0:X8}' -f $installResult.HResult)
}

# Per-update result details
for ($i = 0; $i -lt $updatesToInstall.Count; $i++) {
    $up = $updatesToInstall.Item($i)
    $ir = $installResult.GetUpdateResult($i)
    Write-Host ('[{0}] {1} --> {2} (HResult=0x{3:X8})' -f $i, $up.Title, $rcMap[$ir.ResultCode], $ir.HResult)
}

if ($installResult.RebootRequired) {
    Write-Host "`nA reboot is required to complete installation."
    Write-Host 'Rebooting in 60 seconds... (Close this window to abort)'
    Start-Sleep 60
    Restart-Computer -Force
}
else {
    Write-Host "`nNo reboot required."
}

Start-Sleep 10