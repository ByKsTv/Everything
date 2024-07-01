Write-Host 'nvidiaProfileInspector: Downloading' -ForegroundColor green -BackgroundColor black
$nvidiaProfileInspectorURL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/Orbmu2k/nvidiaProfileInspector/releases/latest').assets.browser_download_url)
(New-Object System.Net.WebClient).DownloadFile("$nvidiaProfileInspectorURL", "$env:TEMP\nvidiaProfileInspector.zip")

Write-Host 'nvidiaProfileInspector: Extracting' -ForegroundColor green -BackgroundColor black
if (!(Test-Path -Path $env:TEMP\nvidiaProfileInspector)) {
  Expand-Archive "$env:TEMP\nvidiaProfileInspector.zip" -DestinationPath "$env:TEMP\nvidiaProfileInspector"
}

Write-Host 'nvidiaProfileInspector: Using custom settings' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/nvidiaProfileInspector/Settings.xml', "$env:TEMP\nvidiaProfileInspector\Settings.nip")
Start-Process -Wait "$env:TEMP\nvidiaProfileInspector\nvidiaProfileInspector.exe" -ArgumentList "$env:TEMP\nvidiaProfileInspector\Settings.nip -silent"