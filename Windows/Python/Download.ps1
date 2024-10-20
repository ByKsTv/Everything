$Python_TaskName = 'Python Updater'
if (-not (Get-ScheduledTask -TaskName $Python_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Python_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')"
    $Python_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Python_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Python_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Python_TaskName -Action $Python_TaskAction -Trigger $Python_TaskTrigger -Principal $Python_TaskPrincipal -Settings $Python_TaskSettings -Force
}

$Python_InstalledVersion = Get-Command python -ErrorAction SilentlyContinue
if ($Python_InstalledVersion) {
    $Python_InstalledVersion = (python --version) -replace 'Python ', '' 
}
else {
    $Python_InstalledVersion = $null 
}
$Python_LatestVersion = (Invoke-RestMethod 'https://github.com/python/cpython/releases.atom').title -replace '^v' -notmatch '[a-z]' | Sort-Object { [version] $_ } -Descending | Select-Object -First 1

if ($null -eq $Python_InstalledVersion -or $Python_InstalledVersion -notmatch $Python_LatestVersion) {
    $Python_DDL = "https://www.python.org/ftp/python/${Python_LatestVersion}/python-${Python_LatestVersion}-amd64.exe"
    $Python_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Python_DDL).AbsolutePath)
    $Python_SavePath = [System.IO.Path]::Combine($env:TEMP, $Python_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Python'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Python_DDL, $Python_SavePath)
    
    $Python_Argument = '/silent InstallAllUsers=1 PrependPath=1 Include_test=0'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Python'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Python_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Python_SavePath -ArgumentList $Python_Argument -Wait
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}