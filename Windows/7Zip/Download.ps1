$7Zip_TaskName = '7-Zip Updater'
if (-not (Get-ScheduledTask -TaskName $7Zip_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $7Zip_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')"
    $7Zip_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $7Zip_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $7Zip_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $7Zip_TaskName -Action $7Zip_TaskAction -Trigger $7Zip_TaskTrigger -Principal $7Zip_TaskPrincipal -Settings $7Zip_TaskSettings -Force
}

$7Zip_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' -ErrorAction SilentlyContinue).DisplayVersion
$7Zip_LatestVersion = (Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').tag_name

if ($null -eq $7Zip_InstalledVersion -or $7Zip_InstalledVersion -notmatch $7Zip_LatestVersion) {
    $7Zip_DDL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').assets | Where-Object name -Like '*-x64.exe*').browser_download_url
    $7Zip_Filename = [System.IO.Path]::GetFileName(([System.Uri]$7Zip_DDL).AbsolutePath)
    $7Zip_SavePath = [System.IO.Path]::Combine($env:TEMP, $7Zip_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($7Zip_DDL, $7Zip_SavePath)

    $7Zip_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $7Zip_SavePath -ArgumentList $7Zip_Argument -Wait

    $7Zip_Destination = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '7-Zip*' }).InstallLocation
    $7Zip_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
    if ($7Zip_OLD_PATH -notlike "*$7Zip_Destination*") {
        $7Zip_NEW_PATH = "$7Zip_OLD_PATH;$7Zip_Destination"
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Adding '7-Zip' from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
        [System.Environment]::SetEnvironmentVariable('Path', $7Zip_NEW_PATH, [System.EnvironmentVariableTarget]::User)
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
}