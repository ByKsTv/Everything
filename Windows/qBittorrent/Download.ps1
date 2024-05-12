if (!(Test-Path -Path $env:ProgramFiles\qBittorrent\qbittorrent.exe)) {
	Write-Host 'qBittorrent > Download' -ForegroundColor green -BackgroundColor black
	$qBittorrent = New-Object System.Net.WebClient
	$qBittorrent.Headers.Add('user-agent', 'Wget')
	$qBittorrent.DownloadFile('https://sourceforge.net/projects/qbittorrent/files/latest/download', "$ENV:temp\qBittorrent.exe")
	Write-Host 'qBittorrent > Install' -ForegroundColor green -BackgroundColor black
	Start-Process $ENV:temp\qBittorrent.exe -ArgumentList '/S'
}
Write-Host 'qBittorrent > Custom Settings' -ForegroundColor green -BackgroundColor black
$qBitSettings = '
[BitTorrent]
Session\MaxUploadsPerTorrent=-1
Session\GlobalMaxInactiveSeedingMinutes=0
Session\Port=0
Session\QueueingSystemEnabled=false
Session\GlobalMaxRatio=0
Session\GlobalMaxSeedingMinutes=0
Session\MaxRatioAction=1
Session\MaxConnectionsPerTorrent=-1
Session\BTProtocol=TCP
Session\MaxConnections=-1
Session\MaxUploads=-1
Session\RefreshInterval=2000
Session\MultiConnectionsPerIp=true
Session\ValidateHTTPSTrackerCertificate=false

[Preferences]
Advanced\RecheckOnCompletion=true
Advanced\confirmTorrentRecheck=false
General\AlternatingRowColors=false
General\HideZeroValues=true
General\Locale=en
Downloads\DblClOnTorDl=3
Downloads\DblClOnTorFn=3
Connection\ResolvePeerCountries=false
Advanced\confirmRemoveAllTags=false
Session\ReannounceWhenAddressChanged=true

[TransferListFilters]
HideZeroStatusFilters=true

[ShutdownConfirmDlg]
DontConfirmAutoExit=true

[Application]
ProcessMemoryPriority=Normal

[GUI]
ConfirmActions\PauseAndResumeAllTorrents=false
MainWindow\FiltersSidebarWidth=214
Log\Enabled=true
Qt6\TorrentProperties\TrackerListState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x5\x37\0\0\0\b\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\b\0\0\0>\0\0\0\x1\0\0\0\0\0\0\0\xac\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0t\0\0\0\x1\0\0\0\0\0\0\0}\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0~\0\0\0\x1\0\0\0\0\0\0\x2\x16\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0\0\0\0\x64\0\0\0\0)
Qt6\TransferList\HeaderState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\x2\x1\0\0\0\"\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\b\0\0\0\t\0\0\0\x6\0\0\0\a\0\0\0\n\0\0\0\v\0\0\0\f\0\0\0\r\0\0\0\xe\0\0\0\xf\0\0\0\x10\0\0\0\x11\0\0\0\x12\0\0\0\x13\0\0\0\x14\0\0\0\x15\0\0\0\x16\0\0\0\x17\0\0\0\x18\0\0\0\x19\0\0\0\x1a\0\0\0\x1b\0\0\0\x1c\0\0\0\x1d\0\0\0\x1e\0\0\0\x1f\0\0\0 \0\0\0!\0\0\0\"\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\b\0\0\0\t\0\0\0\x6\0\0\0\a\0\0\0\n\0\0\0\v\0\0\0\f\0\0\0\r\0\0\0\xe\0\0\0\xf\0\0\0\x10\0\0\0\x11\0\0\0\x12\0\0\0\x13\0\0\0\x14\0\0\0\x15\0\0\0\x16\0\0\0\x17\0\0\0\x18\0\0\0\x19\0\0\0\x1a\0\0\0\x1b\0\0\0\x1c\0\0\0\x1d\0\0\0\x1e\0\0\0\x1f\0\0\0 \0\0\0!\0\0\0\"\t\xf8\xff\xfd\x3\0\0\0\x18\0\0\0\xf\0\0\0\x64\0\0\0\x1e\0\0\0\x64\0\0\0\x1b\0\0\0\x64\0\0\0\x1f\0\0\0\x64\0\0\0 \0\0\0\x64\0\0\0\x12\0\0\0\x64\0\0\0\f\0\0\0\x64\0\0\0!\0\0\0\x64\0\0\0\x18\0\0\0\x64\0\0\0\x1c\0\0\0\x64\0\0\0\r\0\0\0\x64\0\0\0\x10\0\0\0\x64\0\0\0\x16\0\0\0\x64\0\0\0\x14\0\0\0\x64\0\0\0\0\0\0\0\x64\0\0\0\x3\0\0\0\x64\0\0\0\x17\0\0\0\x64\0\0\0\x1d\0\0\0\x64\0\0\0\x11\0\0\0\x64\0\0\0\x15\0\0\0\x64\0\0\0\v\0\0\0\x64\0\0\0\xe\0\0\0\x64\0\0\0\x1a\0\0\0\x64\0\0\0\x13\0\0\0\x64\0\0\x6~\0\0\0\"\x1\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\"\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\x1\x86\0\0\0\x1\0\0\0\0\0\0\0\xa8\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\xca\0\0\0\x1\0\0\0\0\0\0\0{\0\0\0\x1\0\0\0\0\0\0\0`\0\0\0\x1\0\0\0\0\0\0\0z\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\xa2\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\xc7\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0\0\0\0\x64\0\0\0\0)
Qt6\TorrentProperties\FilesListState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x6\x8f\0\0\0\x6\x1\x1\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\x6\0\0\0\xe6\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\x4\x19\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0\0\0\0\x64\0\0\0\0)
Qt6\TorrentProperties\PeerListState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\a\x1\0\0\0\0\0\0\0\0\0\0\0\xf\x41@\0\0\0\x3\0\0\0\0\0\0\0\x64\0\0\0\x6\0\0\0\x64\0\0\0\xe\0\0\0\x64\0\0\x5\x1a\0\0\0\xf\x1\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\xf\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\xa3\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0s\0\0\0\x1\0\0\0\0\0\0\0\x80\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0\xff\xff\xff\xff\0\0\0\0)

[MainWindow]
geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\xff\xff\xff\xf8\0\0\a}\0\0\x3w\0\0\x1\xf6\0\0\0\xb2\0\0\x5\x87\0\0\x2\xe4\0\0\0\0\x2\0\0\0\a~\0\0\0\0\0\0\0\x17\0\0\a}\0\0\x3w)

[SpeedWidget]
Enabled=false

[LegalNotice]
Accepted=true
'
if (!(Test-Path -Path $env:APPDATA\qBittorrent)) {
	Write-Host 'qBittorrent > APPDATA > Roaming > qBittorrent' -ForegroundColor green -BackgroundColor black
	New-Item -Path $env:APPDATA\qBittorrent -Value qBittorrent -ItemType Directory
}
Set-Content -Path $env:APPDATA\qBittorrent\qBittorrent.ini -Value $qBitSettings -Force