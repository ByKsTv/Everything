Write-Host 'Mediainfo > Get latest' -ForegroundColor green -BackgroundColor black
$MediaInfoVersion = (Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest' | ConvertFrom-Json | Select-Object -ExpandProperty name)
$LastestMediaInfoVersion = 'https://mediaarea.net/download/binary/mediainfo-gui/' + $MediaInfoVersion + '/MediaInfo_GUI_' + $MediaInfoVersion + '_Windows.exe'
Write-Host 'Mediainfo > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($LastestMediaInfoVersion, "$env:TEMP\MediaInfo.exe")
Write-Host 'Mediainfo > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\MediaInfo.exe -Args '/S'