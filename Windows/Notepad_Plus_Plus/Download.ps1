Write-Host 'Notepad++: Getting latest release' -ForegroundColor green -BackgroundColor black
$npp = Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest' | ConvertFrom-Json
$nppPackage = 'x64.exe'
$dlUrl = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty browser_download_url
$outfile = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty name
$installerPath = Join-Path $env:temp $outfile

Write-Host 'Notepad++: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($dlUrl, $installerPath)

Write-Host 'Notepad++: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $installerPath -ArgumentList '/S'