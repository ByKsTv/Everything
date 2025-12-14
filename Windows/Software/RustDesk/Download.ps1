$GitHub = Invoke-RestMethod -Uri 'https://api.github.com/repos/rustdesk/rustdesk/releases/latest'
$LatestVersion = ($GitHub).name
$InstalledVersion = (Get-Package -Name 'RustDesk' -ErrorAction SilentlyContinue).Version

if (-not ($InstalledVersion)) {
    New-Item -Path "$env:APPDATA\RustDesk\config" -ItemType Directory -Force
    $SettingFilesURL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/RustDesk/RustDesk_default.toml', 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/RustDesk/RustDesk2.toml', 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/RustDesk/RustDesk_local.toml'
    $SettingFilesURL | ForEach-Object {
        $FileName = [IO.Path]::GetFileName(([URI]$_).AbsolutePath)
        $SavePath = [IO.Path]::Combine($env:APPDATA, 'RustDesk', 'config', $FileName)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'RustDesk'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$_'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($_, $SavePath)
    }
}

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
    $DDL = (($GitHub).assets | Where-Object { $_.Name -match '64.exe' }).browser_download_url
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'RustDesk'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $Argument = '--silent-install'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'RustDesk'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SavePath -ArgumentList $Argument # Do not add `-Wait`
}