$VSCode_TaskName = 'Visual Studio Code Updater'
if (-not (Get-ScheduledTask -TaskName $VSCode_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $VSCode_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')"
    $VSCode_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $VSCode_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $VSCode_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $VSCode_TaskName -Action $VSCode_TaskAction -Trigger $VSCode_TaskTrigger -Principal $VSCode_TaskPrincipal -Settings $VSCode_TaskSettings -Force
}

$VSCode_InstalledVersion = (Get-Package -Name 'Microsoft Visual Studio Code' -ErrorAction SilentlyContinue).Version
$VSCode_LatestVersion = (Invoke-RestMethod https://api.github.com/repos/microsoft/vscode/releases).tag_name | Select-Object -First 1

if ($null -eq $VSCode_InstalledVersion -or $VSCode_InstalledVersion -notmatch $VSCode_LatestVersion) {
    $VSCode_DDL = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64'
    $VSCode_Filename = 'VSCodeSetup-x64-' + "$VSCode_LatestVersion" + '.exe'
    $VSCode_SavePath = [IO.Path]::Combine($env:TEMP, $VSCode_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Visual Studio Code'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($VSCode_DDL, $VSCode_SavePath)
    
    $VSCode_Argument = '/VERYSILENT /MERGETASKS=!runcode'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Visual Studio Code'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VSCode_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $VSCode_SavePath -ArgumentList $VSCode_Argument
}