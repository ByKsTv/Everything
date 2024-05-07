Write-Host 'Mediainfo > Get latest' -ForegroundColor green -BackgroundColor black
$LastestMediaInfoVersion = 'https://mediaarea.net/download/binary/mediainfo-gui/' + (Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest' | ConvertFrom-Json | Select-Object -ExpandProperty name) + '/MediaInfo_GUI_' + (Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest' | ConvertFrom-Json | Select-Object -ExpandProperty name) + '_Windows.exe'
Write-Host 'Mediainfo > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($LastestMediaInfoVersion, "$env:TEMP\MediaInfo.exe")
Write-Host 'Mediainfo > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\MediaInfo.exe -Args '/S'