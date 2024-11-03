$BetterDiscord_TaskName = 'BetterDiscord Updater'
if (-not (Get-ScheduledTask -TaskName $BetterDiscord_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $BetterDiscord_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/Download.ps1')"
    $BetterDiscord_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $BetterDiscord_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $BetterDiscord_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $BetterDiscord_TaskName -Action $BetterDiscord_TaskAction -Trigger $BetterDiscord_TaskTrigger -Principal $BetterDiscord_TaskPrincipal -Settings $BetterDiscord_TaskSettings -Force
}

$Discord_TaskName = 'Discord Client Updater'
if (-not (Get-ScheduledTask -TaskName $Discord_TaskName -ErrorAction SilentlyContinue)) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
}
if (Get-ScheduledTask -TaskName $Discord_TaskName -ErrorAction SilentlyContinue) {
    Start-Sleep -Milliseconds 2000
    while ((Get-ScheduledTask -TaskName $Discord_TaskName).State -eq 'Running') {
        Start-Sleep -Milliseconds 1000
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_TaskName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to close '); [Console]::ResetColor(); [Console]::WriteLine()
    while ((Get-Process | Where-Object { $_.MainWindowTitle -eq $Discord_TaskName } )) {
        Start-Sleep -Milliseconds 1000
    }
}

$Discord_IndexJS = (Get-ChildItem "$env:LOCALAPPDATA\Discord\app*\modules\discord_desktop*\discord_desktop*" -Directory | Sort-Object -Descending | Select-Object -First 1).FullName + '\index.js'
if (Select-String -Quiet -Path $Discord_IndexJS -Pattern 'betterdiscord') {
    $BetterDiscord_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -EQ 'betterdiscord.asar').browser_download_url
    $BetterDiscord_Filename = [IO.Path]::GetFileName(([URI]$BetterDiscord_DDL).AbsolutePath)
    $BetterDiscord_SavePath = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'data', $BetterDiscord_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($BetterDiscord_DDL, $BetterDiscord_SavePath)

    $BetterDiscord_ThemesDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'themes')
    $BetterDiscord_ThemesURLs = @(
        'https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css'
    )
    foreach ($BetterDiscord_ThemeURL in $BetterDiscord_ThemesURLs) {
        $BetterDiscord_ThemeFilename = [IO.Path]::GetFileName(([URI]$BetterDiscord_ThemeURL).AbsolutePath)
        $BetterDiscord_ThemeSavePath = [IO.Path]::Combine($BetterDiscord_ThemesDir, $BetterDiscord_ThemeFilename)
        if (Test-Path $BetterDiscord_ThemeSavePath) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($BetterDiscord_ThemeURL, $BetterDiscord_ThemeSavePath)
        }
    }

    $BetterDiscord_PluginsDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'plugins')
    $BetterDiscord_PluginsURLs = @(
        'https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js',
        'https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js',
        'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js',
        'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js',
        'https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js',
        'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js',
        'https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js',
        'https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js',
        'https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js',
        'https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js'
    )
    foreach ($BetterDiscord_PluginURL in $BetterDiscord_PluginsURLs) {
        $BetterDiscord_PluginFilename = [IO.Path]::GetFileName(([URI]$BetterDiscord_PluginURL).AbsolutePath)
        $BetterDiscord_PluginSavePath = [IO.Path]::Combine($BetterDiscord_PluginsDir, $BetterDiscord_PluginFilename)
        if (Test-Path $BetterDiscord_PluginSavePath) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($BetterDiscord_PluginURL, $BetterDiscord_PluginSavePath)
        }
    }
}

if (-not (Select-String -Quiet -Path $Discord_IndexJS -Pattern 'betterdiscord')) {
    if (-not (Test-Path -Path $env:APPDATA\BetterDiscord)) {
        $BetterDiscord_Folders = @(
            "$env:APPDATA\BetterDiscord",
            "$env:APPDATA\BetterDiscord\plugins",
            "$env:APPDATA\BetterDiscord\themes",
            "$env:APPDATA\BetterDiscord\data",
            "$env:APPDATA\BetterDiscord\data\stable"
        )
        
        foreach ($BetterDiscord_Folder in $BetterDiscord_Folders) {
            if (-not (Test-Path $BetterDiscord_Folder)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Creating folder '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_Folder'"); [Console]::ResetColor(); [Console]::WriteLine()

                New-Item -ItemType Directory -Path $BetterDiscord_Folder -Force
            }
        }

        $BetterDiscord_ThemesDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'themes')
        $BetterDiscord_ThemesURLs = @(
            'https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css'
        )
        foreach ($BetterDiscord_ThemeURL in $BetterDiscord_ThemesURLs) {
            $BetterDiscord_ThemeFilename = [IO.Path]::GetFileName(([URI]$BetterDiscord_ThemeURL).AbsolutePath)
            $BetterDiscord_ThemeSavePath = [IO.Path]::Combine($BetterDiscord_ThemesDir, $BetterDiscord_ThemeFilename)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_ThemeSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
                (New-Object Net.WebClient).DownloadFile($BetterDiscord_ThemeURL, $BetterDiscord_ThemeSavePath)
        }
        
        $BetterDiscord_PluginsDir = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'plugins')
        $BetterDiscord_PluginsURLs = @(
            'https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js',
            'https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js',
            'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js',
            'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js',
            'https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js',
            'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js',
            'https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js',
            'https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js',
            'https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js',
            'https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js'
        )
        foreach ($BetterDiscord_PluginURL in $BetterDiscord_PluginsURLs) {
            $BetterDiscord_PluginFilename = [IO.Path]::GetFileName(([URI]$BetterDiscord_PluginURL).AbsolutePath)
            $BetterDiscord_PluginSavePath = [IO.Path]::Combine($BetterDiscord_PluginsDir, $BetterDiscord_PluginFilename)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_PluginSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($BetterDiscord_PluginURL, $BetterDiscord_PluginSavePath)
        }
    }

    $BetterDiscord_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -EQ 'betterdiscord.asar').browser_download_url
    $BetterDiscord_Filename = [IO.Path]::GetFileName(([URI]$BetterDiscord_DDL).AbsolutePath)
    $BetterDiscord_SavePath = [IO.Path]::Combine($env:APPDATA, 'BetterDiscord', 'data', $BetterDiscord_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($BetterDiscord_DDL, $BetterDiscord_SavePath)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BetterDiscord_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_IndexJS'"); [Console]::ResetColor(); [Console]::WriteLine()
    Set-Content $Discord_IndexJS -Value "require('$($env:APPDATA -replace '\\','/')/BetterDiscord/data/betterdiscord.asar');`nmodule.exports = require('./core.asar');" -Force
}