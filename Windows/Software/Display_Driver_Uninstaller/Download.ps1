$news = Invoke-WebRequest 'https://www.wagnardsoft.com/software' -UseBasicParsing

$version = [regex]::Match(
    $news.Content,
    'Download Display Driver Uninstaller \(DDU\)\s+([0-9]+(?:\.[0-9]+)+)'
).Groups[1].Value

if (-not $version) {
    throw 'Could not find the latest DDU version on Wagnardsoft.'
}

$DDL = "https://download.wagnardsoft.com/DDU/DDU%20v${version}_setup.exe"
$FileName = [Uri]::UnescapeDataString([IO.Path]::GetFileName(([URI]$DDL).AbsolutePath))
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Display Driver Uninstaller'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
$DDU_Agent = New-Object System.Net.WebClient
$DDU_Agent.Headers.Add('user-agent', 'Wget')
$DDU_Agent.DownloadFile($DDL, $SavePath)

$Argument = '/S'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Display Driver Uninstaller'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $SavePath -ArgumentList $Argument -Wait

$Settings_Path = "$env:ProgramFiles\Display Driver Uninstaller\Settings\Settings.xml"
$Settings_FileName = [IO.Path]::GetFileName(([URI]$Settings_Path).AbsolutePath)
$Settings_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Display_Driver_Uninstaller/Settings.xml'

if (-not (Test-Path -Path $Settings_Path)) {
    New-Item -Path $Settings_Path -ItemType File -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Settings_DDL, $Settings_Path)

$DesktopShortcut = "$env:PUBLIC\Desktop\Display Driver Uninstaller.lnk"
if (Test-Path -Path $DesktopShortcut) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Display Driver Uninstaller'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-Item -Path $DesktopShortcut
}
