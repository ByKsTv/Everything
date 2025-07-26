$TaskName = 'Windows Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Update.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Searching for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Windows Updates'"); [Console]::ResetColor(); [Console]::WriteLine()
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$criteria = 'IsInstalled=0 and IsHidden=0'
$searchResult = $searcher.Search($criteria)

if ($searchResult.Updates.Count -eq 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('No updates found for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Windows Updates'"); [Console]::ResetColor(); [Console]::WriteLine()
    return
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Found '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($searchResult.Updates.Count)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' updates: '); [Console]::ResetColor(); [Console]::WriteLine()
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
    $u = $searchResult.Updates.Item($i)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('[{0}] ' -f $i); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'{0}'" -f $u.Title); [Console]::ResetColor(); [Console]::WriteLine()
}

$updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
    $updatesToDownload.Add($searchResult.Updates.Item($i)) | Out-Null
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Windows Updates'"); [Console]::ResetColor(); [Console]::WriteLine()
$downloader = $session.CreateUpdateDownloader()
$downloader.Updates = $updatesToDownload
$dlResult = $downloader.Download()
$rcMap = @{
    0 = 'NotStarted'
    1 = 'InProgress'
    2 = 'Succeeded'
    3 = 'SucceededWithErrors'
    4 = 'Failed'
    5 = 'Aborted'
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Download overall: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($rcMap[$dlResult.ResultCode])'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' - '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'(ResultCode=$($dlResult.ResultCode))'"); [Console]::ResetColor(); [Console]::WriteLine()
if ($dlResult.HResult -ne 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Download HResult: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write(('0x{0:X8}' -f $dlResult.HResult)); [Console]::ResetColor(); [Console]::WriteLine()
}

$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $updatesToDownload.Count; $i++) {
    $u = $updatesToDownload.Item($i)
    $status = if ($u.IsDownloaded) {
        'READY' 
    }
    else {
        'NOT DOWNLOADED' 
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write(('[{0}] ' -f $i)); [Console]::ForegroundColor = 'Yellow'; [Console]::Write(('{0} ' -f $u.Title)); [Console]::ForegroundColor = 'Cyan'; [Console]::Write(('--> {0}' -f $status)); [Console]::ResetColor(); [Console]::WriteLine()
    if ($u.IsDownloaded) {
        $updatesToInstall.Add($u) | Out-Null 
    }
}

if ($updatesToInstall.Count -eq 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Red'; [Console]::Write('No updates downloaded successfully.'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Sleep 10
    return
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($updatesToInstall.Count)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' updates'); [Console]::ResetColor(); [Console]::WriteLine()
$installer = $session.CreateUpdateInstaller()
$installer.Updates = $updatesToInstall
$installResult = $installer.Install()

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Install overall: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($rcMap[$installResult.ResultCode])'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' - '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'(ResultCode=$($installResult.ResultCode))'"); [Console]::ResetColor(); [Console]::WriteLine()
if ($installResult.HResult -ne 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Install HResult: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write(('0x{0:X8}' -f $installResult.HResult)); [Console]::ResetColor(); [Console]::WriteLine()
}

for ($i = 0; $i -lt $updatesToInstall.Count; $i++) {
    $up = $updatesToInstall.Item($i)
    $ir = $installResult.GetUpdateResult($i)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('[{0}] ' -f $i); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('{0} --> {1} (HResult=0x{2:X8})' -f $up.Title, $rcMap[$ir.ResultCode], $ir.HResult); [Console]::ResetColor(); [Console]::WriteLine()
}

if ($installResult.RebootRequired) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('A reboot is required to complete installation'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Sleep 60
}
else {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('No reboot required'); [Console]::ResetColor(); [Console]::WriteLine()
}

Start-Sleep 10