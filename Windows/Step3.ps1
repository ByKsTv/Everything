[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Removing current step'); [Console]::ResetColor(); [Console]::WriteLine()
Unregister-ScheduledTask -TaskName Step3 -Confirm:$false

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('DirectX: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.microsoft.com/en-us/download/details.aspx?id=8109' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'directx_Jun2010_redist.exe') } | Select-Object -First 1).href), "$env:TEMP\directx_Jun2010_redist.exe")
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('DirectX: Extracting'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $env:TEMP\directx_Jun2010_redist.exe -ArgumentList "/Q /T:$env:TEMP\directx_Jun2010_redist" -Wait
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('DirectX: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath "$env:TEMP\directx_Jun2010_redist\DXSETUP.exe" -ArgumentList '/silent'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('.NET: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Microsoft Visual C++ Redistributable: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/VC_redist.x64.exe', "$env:TEMP\VC_redist.x64.exe")
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Microsoft Visual C++ Redistributable: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath "$env:TEMP\VC_redist.x64.exe" -ArgumentList '/install /quiet /norestart'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')