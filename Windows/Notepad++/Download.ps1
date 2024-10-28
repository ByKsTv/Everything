$NotepadPlusPlus_TaskName = 'Notepad++ Updater'
if (-not (Get-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NotepadPlusPlus_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad++/Download.ps1')"
    $NotepadPlusPlus_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $NotepadPlusPlus_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $NotepadPlusPlus_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -Action $NotepadPlusPlus_TaskAction -Trigger $NotepadPlusPlus_TaskTrigger -Principal $NotepadPlusPlus_TaskPrincipal -Settings $NotepadPlusPlus_TaskSettings -Force
}

$NotepadPlusPlus_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++' -ErrorAction SilentlyContinue).DisplayVersion
$NotepadPlusPlus_LatestVersion = ((Invoke-RestMethod 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest').tag_name).Replace('v', '')

if ($null -eq $NotepadPlusPlus_InstalledVersion -or $NotepadPlusPlus_InstalledVersion -notmatch $NotepadPlusPlus_LatestVersion) {
    $NotepadPlusPlus_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest').assets | Where-Object name -Like '*x64.exe').browser_download_url
    $NotepadPlusPlus_Filename = [System.IO.Path]::GetFileName(([System.Uri]$NotepadPlusPlus_DDL).AbsolutePath)
    $NotepadPlusPlus_SavePath = [System.IO.Path]::Combine($env:TEMP, $NotepadPlusPlus_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Notepad++'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($NotepadPlusPlus_DDL, $NotepadPlusPlus_SavePath)
    
    $NotepadPlusPlus_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Notepad++'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $NotepadPlusPlus_SavePath -ArgumentList $NotepadPlusPlus_Argument
}