Write-Host 'Step3: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step3 -Confirm:$false

Write-Host 'Step3: DirectX: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.microsoft.com/en-us/download/details.aspx?id=8109' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'directx_Jun2010_redist.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\directx_Jun2010_redist.exe")
Write-Host 'Step3: DirectX: Extracting' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\directx_Jun2010_redist.exe -ArgumentList "/Q /T:$env:TEMP\directx_Jun2010_redist" -Wait
Write-Host 'Step3: DirectX: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:TEMP\directx_Jun2010_redist\DXSETUP.exe" -ArgumentList "/silent"

Write-Host 'Step3: .NET: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')

Write-Host 'Step3: Microsoft Visual C++ Redistributable: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/VC_redist.x64.exe', "$env:TEMP\VC_redist.x64.exe")
Write-Host 'Step3: Microsoft Visual C++ Redistributable: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:TEMP\VC_redist.x64.exe" -ArgumentList '/install /quiet /norestart'

Write-Host 'Step3: Mozilla Firefox Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Write-Host 'Step3: Google Chrome Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Write-Host 'Step3: Software Selection: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')