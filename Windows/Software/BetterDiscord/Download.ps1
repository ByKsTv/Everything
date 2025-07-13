$TaskName = 'BetterDiscord Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/BetterDiscord/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$TaskName = 'Discord Client Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Discord/Download.ps1')
}
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Start-Sleep -Milliseconds 3000
    while ((Get-ScheduledTask -TaskName $TaskName).State -eq 'Running') {
        Start-Sleep -Milliseconds 1000
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to close '); [Console]::ResetColor(); [Console]::WriteLine()
    while ((Get-Process | Where-Object { $_.MainWindowTitle -eq $TaskName } )) {
        Start-Sleep -Milliseconds 1000
    }
}

$IndexJS = Get-ChildItem -Path "$env:LOCALAPPDATA\Discord\app*\modules\discord_desktop_core*\discord_desktop_core" -Directory | Sort-Object -Descending | Select-Object -First 1 | Get-ChildItem -Filter 'index.js' -File | Select-Object -ExpandProperty 'FullName'
if (Select-String -Quiet -Path $IndexJS -Pattern 'betterdiscord') {
    $DDL = Invoke-RestMethod -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest' | Select-Object -ExpandProperty 'assets' | Select-Object -ExpandProperty 'browser_download_url'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'data', $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $ThemesDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'themes')
    $ThemesURLs = @(
        'https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css'
    )
    foreach ($ThemeURL in $ThemesURLs) {
        $ThemeFileName = [IO.Path]::GetFileName(([URI]$ThemeURL).AbsolutePath)
        $ThemeSavePath = [IO.Path]::Combine($ThemesDir, $ThemeFileName)
        if (Test-Path $ThemeSavePath) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($ThemeURL, $ThemeSavePath)
        }
    }

    $PluginsDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'plugins')
    $PluginsURLs = @(
        'https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js',
        'https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js',
        'https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js'
    )
    foreach ($PluginURL in $PluginsURLs) {
        $PluginFileName = [IO.Path]::GetFileName(([URI]$PluginURL).AbsolutePath)
        $PluginSavePath = [IO.Path]::Combine($PluginsDir, $PluginFileName)
        if (Test-Path $PluginSavePath) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($PluginURL, $PluginSavePath)
        }
    }
}

if (-not (Select-String -Quiet -Path $IndexJS -Pattern 'betterdiscord')) {
    if (-not (Test-Path -Path "$env:APPDATA\BetterDiscord")) {
        $Folders = @(
            "$env:APPDATA\BetterDiscord",
            "$env:APPDATA\BetterDiscord\plugins",
            "$env:APPDATA\BetterDiscord\themes",
            "$env:APPDATA\BetterDiscord\data",
            "$env:APPDATA\BetterDiscord\data\stable"
        )
        
        foreach ($Folder in $Folders) {
            if (-not (Test-Path $Folder)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Creating folder '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Folder'"); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -ItemType Directory -Path $Folder -Force
            }
        }

        $ThemesDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'themes')
        $ThemesURLs = @(
            'https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css'
        )
        foreach ($ThemeURL in $ThemesURLs) {
            $ThemeFileName = [IO.Path]::GetFileName(([URI]$ThemeURL).AbsolutePath)
            $ThemeSavePath = [IO.Path]::Combine($ThemesDir, $ThemeFileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ThemeSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($ThemeURL, $ThemeSavePath)
        }
        
        $PluginsDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'plugins')
        $PluginsURLs = @(
            'https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js',
            'https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js',
            'https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js'
        )
        foreach ($PluginURL in $PluginsURLs) {
            $PluginFileName = [IO.Path]::GetFileName(([URI]$PluginURL).AbsolutePath)
            $PluginSavePath = [IO.Path]::Combine($PluginsDir, $PluginFileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PluginSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($PluginURL, $PluginSavePath)
        }

        $SettingsDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'data', 'stable')
        $SettingsURLs = @(
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/BetterDiscord/plugins.json',
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/BetterDiscord/themes.json'
        )
        foreach ($SettingsURL in $SettingsURLs) {
            $SettingFileName = [IO.Path]::GetFileName(([URI]$SettingsURL).AbsolutePath)
            $SettingSavePath = [IO.Path]::Combine($SettingsDir, $SettingFileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SettingFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SettingsURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SettingSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($SettingsURL, $SettingSavePath)
        }

        $RepoConfigJsons = @(
            "$env:AppData\BetterDiscord\plugins\PluginRepo.config.json",
            "$env:AppData\BetterDiscord\plugins\ThemeRepo.config.json"
        )
        foreach ($RepoConfigJson in $RepoConfigJsons) {
            if (-not (Test-Path $RepoConfigJson)) {
                New-Item -ItemType Directory -Path (Split-Path -Path $RepoConfigJson) -Force
                $RepoJsonSettings = @{ all = @{ general = @{ notifyNewEntries = $false } } } | ConvertTo-Json -Depth 10
                $RepoJsonSettings | Set-Content -Path $RepoConfigJson
            }
        }
    }

    $DDL = Invoke-RestMethod -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest' | Select-Object -ExpandProperty 'assets' | Select-Object -ExpandProperty 'browser_download_url'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'data', $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    if (Get-Process -Name 'Discord' -ErrorAction SilentlyContinue) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ResetColor(); [Console]::WriteLine()
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | ForEach-Object {
            $_.CloseMainWindow() | Out-Null
        }
        Start-Sleep -Milliseconds 1000
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$IndexJS'"); [Console]::ResetColor(); [Console]::WriteLine()
    Set-Content $IndexJS -Value "require('$($env:APPDATA -replace '\\','/')/BetterDiscord/data/betterdiscord.asar');`nmodule.exports = require('./core.asar');" -Force
}