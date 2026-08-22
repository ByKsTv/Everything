$TaskName = 'scrcpy Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/scrcpy/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$GitHub = Invoke-RestMethod -Uri 'https://api.github.com/repos/Genymobile/scrcpy/releases/latest'
$LatestVersion = ($GitHub).tag_name -replace '^v', ''

$Destination = [IO.Path]::Combine($env:USERPROFILE, 'scrcpy', 'scrcpy.exe')
if (Test-Path $Destination) {
    $InstalledVersion = [regex]::Match(((& $Destination --version) -join "`n"), 'scrcpy\s+([0-9.]+)').Groups[1].Value
}

if (-not (Test-Path $Destination) -or $InstalledVersion -notmatch $LatestVersion) {
    $DDL = (($GitHub).assets | Where-Object { $_.Name -match 'win64' }).browser_download_url
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'scrcpy'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $ExtractPath = Split-Path $Destination -Parent
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TempExtractPath = [IO.Path]::Combine($env:TEMP, [guid]::NewGuid().ToString())
    Expand-Archive -Path $SavePath -DestinationPath $TempExtractPath -Force
    $InnerFolder = Get-ChildItem -Path $TempExtractPath -Directory | Select-Object -First 1
    New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null
    Get-ChildItem -Path $InnerFolder.FullName -Force | Move-Item -Destination $ExtractPath -Force
    Remove-Item -Path $TempExtractPath -Recurse -Force -ErrorAction SilentlyContinue

    if (Test-Path $Destination) {
        $OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
        if (-not ($OLD_PATH.Contains($ExtractPath))) {
            $NEW_PATH = "$OLD_PATH; $ExtractPath"
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'scrcpy'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
            [Environment]::SetEnvironmentVariable('Path', $NEW_PATH, [EnvironmentVariableTarget]::User)
            $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
        }
        $SavePath = $Destination
        $Argument = '--keyboard=uhid --video-bit-rate=100M --max-fps=60 --no-downsize-on-error --keep-active --no-audio'
        $ShortcutPath = [IO.Path]::Combine([Environment]::GetFolderPath('Desktop'), 'scrcpy.lnk')

        if (-not (Test-Path -LiteralPath $ShortcutPath)) {
            $Shell = New-Object -ComObject WScript.Shell
            $Shortcut = $Shell.CreateShortcut($ShortcutPath)
            $Shortcut.TargetPath = $SavePath
            $Shortcut.Arguments = $Argument
            $Shortcut.WorkingDirectory = [IO.Path]::GetDirectoryName($SavePath)
            $Shortcut.IconLocation = $SavePath
            $Shortcut.Save()
        }
    }
}
