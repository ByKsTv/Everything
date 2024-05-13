Write-Host 'Step4: Setting UI: Setting Title' -ForegroundColor green -BackgroundColor black
$host.UI.RawUI.WindowTitle = 'Step4'

Write-Host 'Step4: Setting UI: Setting Colors' -ForegroundColor green -BackgroundColor black
$host.UI.RawUI.BackgroundColor = 'black'
$Host.UI.RawUI.ForegroundColor = 'white'

Write-Host 'Step4: Setting UI: Maximizing Window' -ForegroundColor green -BackgroundColor black
$sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
Add-Type -MemberDefinition $sig -Name NativeMethods -Namespace Win32
$hwnd = @(Get-Process PowerShell)[0].MainWindowHandle
[Win32.NativeMethods]::ShowWindowAsync($hwnd, 3)

Write-Host 'Step4: Setting UI: Setting Foreground' -ForegroundColor green -BackgroundColor black
(New-Object -ComObject WScript.Shell).AppActivate((Get-Process powershell).MainWindowTitle)

Write-Host 'Step4: Setting UI: Applying Colors' -ForegroundColor green -BackgroundColor black
Clear-Host

Write-Host 'Step4: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step4 -Confirm:$false

Write-Host 'Step4: Windows Update: Checking for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

Write-Host 'Step4: O&O ShutUp10++: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/OO_ShutUp10/Download.ps1')

Write-Host 'Step4: Mozila Firefox Arkenfox: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

Write-Host 'Step4: Windows Group Policy: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Group_Policy.ps1')

Write-Host 'Step4: Windows Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')

Write-Host 'Step4: Windows Network Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Network.ps1')

Write-Host 'Step4: Mozila Firefox Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Write-Host 'Step4: Google Chrome Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Write-Host 'Step4: Software Selection: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')