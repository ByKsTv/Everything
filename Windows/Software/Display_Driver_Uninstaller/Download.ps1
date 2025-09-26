$DDU_DDL1 = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.wagnardsoft.com/display-driver-uninstaller-DDU-').Links | Where-Object { $_.outerHTML -match 'Download Display Driver Uninstaller' } | Select-Object -First 1).href
$DDU_DDL2 = ((Invoke-WebRequest -UseBasicParsing -Uri ('https://www.wagnardsoft.com' + $DDU_DDL1)).Links | Where-Object { $_.outerHTML -match 'DOWNLOAD' } | Select-Object -First 1).href
$DDU_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri $DDU_DDL2).Links | Where-Object { $_.outerHTML -match 'setup.exe' } | Select-Object -First 1).href
$FileName = [Uri]::UnescapeDataString([IO.Path]::GetFileName(([URI]$DDU_DDL).AbsolutePath))
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDU_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
$DisplayDriverUninstaller_Downloader = New-Object System.Net.WebClient
$DisplayDriverUninstaller_Downloader.Headers['User-Agent'] = 'Mozilla/5.0'
$DisplayDriverUninstaller_Downloader.DownloadFile($DDU_DDL, $SavePath)

$Argument = '/S'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $SavePath -ArgumentList $Argument -Wait

$Settings_Path = "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings\Settings.xml"
$Settings_FileName = [IO.Path]::GetFileName(([URI]$Settings_Path).AbsolutePath)
$Settings_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Display_Driver_Uninstaller/Settings.xml'

if (-not (Test-Path -Path $Settings_Path)) {
    New-Item -Path $Settings_Path -ItemType File -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Settings_DDL, $Settings_Path)