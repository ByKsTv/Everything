$Telegram_TaskName = 'Telegram Updater'
if (-not (Get-ScheduledTask -TaskName $Telegram_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Telegram_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Telegram/Download.ps1')"
    $Telegram_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Telegram_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Telegram_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Telegram_TaskName -Action $Telegram_TaskAction -Trigger $Telegram_TaskTrigger -Principal $Telegram_TaskPrincipal -Settings $Telegram_TaskSettings -Force
}

$Telegram_InstalledVersion = (Get-Package -Name 'Telegram Desktop' -ErrorAction SilentlyContinue).Version
$Telegram_LatestVersion = ((Invoke-RestMethod 'https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest').tag_name).Replace('v', '')

if ($null -eq $Telegram_InstalledVersion -or $Telegram_InstalledVersion -notmatch $Telegram_LatestVersion) {
    $Telegram_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest').assets | Where-Object { $_.label -match '64' -and $_.label -match 'Installer' } ).browser_download_url
    $Telegram_Filename = [IO.Path]::GetFileName(([URI]$Telegram_DDL).AbsolutePath)
    $Telegram_SavePath = [IO.Path]::Combine($env:TEMP, $Telegram_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Telegram'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Telegram_DDL, $Telegram_SavePath)
    
    $Telegram_Argument = '/verysilent'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Telegram'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Telegram_SavePath -ArgumentList $Telegram_Argument
}