$AnyDesk_Settings = @'
ad.discovery.show_tile=0
ad.ui.show_tile.telemetry=false
ad.roster.contacts.view_type=1
ad.roster.discovered.view_type=1
ad.roster.favorites.view_type=1
ad.roster.recent_out.view_type=1
'@
$AnyDesk_LocalCFG = [IO.Path]::Combine($env:APPDATA, 'AnyDesk', 'user.conf')
New-Item -Path $AnyDesk_LocalCFG -ItemType File -Value $AnyDesk_Settings -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('AnyDesk: Optional Offer - Recommended by AnyDesk: Decline'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until')) {
    New-Item 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Name 'AnyDesk Software GmbH' -Value 30241008 -PropertyType DWord -Force

$DDL = 'https://download.anydesk.com/AnyDesk.exe'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'AnyDesk'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Argument = "--install `"${env:ProgramFiles(x86)}\AnyDesk`" --create-shortcuts --silent"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'AnyDesk'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait

Stop-Service -Name 'AnyDesk' -Force
Set-Service -Name 'AnyDesk' -StartupType Manual