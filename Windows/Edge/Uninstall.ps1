$EdgeUninstaller = 'Edge Uninstaller'
$EdgeUninstaller_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $EdgeUninstaller }
if (!($EdgeUninstaller_Exists)) {
    Write-Host "Edge Uninstaller: Task Scheduler: Adding $EdgeUninstaller" -ForegroundColor green -BackgroundColor black
    $EdgeUninstaller_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $EdgeUninstaller_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Edge/Uninstall.ps1')"
    $EdgeUninstaller_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $EdgeUninstaller_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $EdgeUninstaller_Parameters = @{
        TaskName  = $EdgeUninstaller
        Principal = $EdgeUninstaller_Principal
        Action    = $EdgeUninstaller_Action
        Trigger   = $EdgeUninstaller_Trigger
        Settings  = $EdgeUninstaller_Settings
    }
    Register-ScheduledTask @EdgeUninstaller_Parameters -Force
}

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
if (($InstalledSoftware -match 'Microsoft Edge')) {
    # https://github.com/fr33thytweaks/Ultimate-Windows-Optimization-Guide/blob/main/6%20Windows/14%20Edge.ps1
    Write-Host 'Edge Uninstaller: Stopping Related Processes' -ForegroundColor green -BackgroundColor black
    $stopedgerunning = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
    $stopedgerunning | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

    Write-Host 'Edge Uninstaller: Uninstalling Copilot' -ForegroundColor green -BackgroundColor black
    Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage

    Write-Host 'Edge Uninstaller: Disabling Updates' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate) -ne $true) {
        New-Item -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Force
    }
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Name DoNotUpdateToEdgeWithChromium -PropertyType DWord -Value 1 -Force

    Write-Host 'Edge Uninstaller: Allowing Uninstall' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev) -ne $true) {
        New-Item HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Force
    }
    New-ItemProperty -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Name 'AllowUninstall' -Value '' -PropertyType String -Force

    Write-Host 'Edge Uninstaller: Creating Temporary Folder' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe") -ne $true) {
        New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType Directory
    }

    Write-Host 'Edge Uninstaller: Creating Temporary File' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe") -ne $true) {
        New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType File -Name 'MicrosoftEdge.exe'
    }

    Write-Host 'Edge Uninstaller: Getting UninstallString' -ForegroundColor green -BackgroundColor black
    $regview = [Microsoft.Win32.RegistryView]::Registry32
    $microsoft = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regview).
    OpenSubKey('SOFTWARE\Microsoft', $true)
    $uninstallregkey = $microsoft.OpenSubKey('Windows\CurrentVersion\Uninstall\Microsoft Edge')
    try {
        $uninstallstring = $uninstallregkey.GetValue('UninstallString') + ' --force-uninstall'
    }
    catch {
    }

    Write-Host 'Edge Uninstaller: Uninstalling' -ForegroundColor green -BackgroundColor black
    Start-Process cmd.exe "/c $uninstallstring" -WindowStyle Hidden -Wait

    Write-Host 'Edge Uninstaller: Deleting Temporary Folder' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe") -eq $true) {
        Remove-Item -Recurse -Force "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    }

    Write-Host 'Edge Uninstaller: Searching EdgeUpdate' -ForegroundColor green -BackgroundColor black
    $edgeupdate = @(); 'LocalApplicationData', 'ProgramFilesX86', 'ProgramFiles' | ForEach-Object {
        $folder = [Environment]::GetFolderPath($_)
        $edgeupdate += Get-ChildItem "$folder\Microsoft\EdgeUpdate\*.*.*.*\MicrosoftEdgeUpdate.exe" -rec -ea 0
    }

    Write-Host 'Edge Uninstaller: Deleting EdgeUpdate' -ForegroundColor green -BackgroundColor black
    $global:REG = 'HKCU:\SOFTWARE', 'HKLM:\SOFTWARE', 'HKCU:\SOFTWARE\Policies', 'HKLM:\SOFTWARE\Policies', 'HKCU:\SOFTWARE\WOW6432Node', 'HKLM:\SOFTWARE\WOW6432Node', 'HKCU:\SOFTWARE\WOW6432Node\Policies', 'HKLM:\SOFTWARE\WOW6432Node\Policies'
    foreach ($location in $REG) {
        Remove-Item "$location\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue 
    }

    Write-Host 'Edge Uninstaller: Uninstalling EdgeUpdate' -ForegroundColor green -BackgroundColor black
    foreach ($path in $edgeupdate) {
        if (Test-Path $path) {
            Start-Process -Wait $path -Args '/unregsvc' | Out-Null 
        }
        do {
            Start-Sleep 3 
        } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '*\Microsoft\Edge*')
        if (Test-Path $path) {
            Start-Process -Wait $path -Args '/uninstall' | Out-Null 
        }
        do {
            Start-Sleep 3 
        } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '*\Microsoft\Edge*')
    }

    Write-Host 'Edge Uninstaller: Deleting EdgeWebView' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') -eq $true) {
        Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }
    if ((Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') -eq $true) {
        Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }

    Write-Host 'Edge Uninstaller: Deleting Folders' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path "$env:C:\Program Files (x86)\Microsoft") -eq $true) {
        Remove-Item -Recurse -Force "$env:C:\Program Files (x86)\Microsoft"
    }

    Write-Host 'Edge Uninstaller: Deleting Shortcuts' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path "$env:C:\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk") -eq $true) {
        Remove-Item -Force "$env:C:\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"
    }
    if ((Test-Path -Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk") -eq $true) {
        Remove-Item -Force "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk"
    }
}

# other methods
#Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1')

#Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1')
#explorer.exe

# (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/he3als/EdgeRemover/main/RemoveEdge.ps1', "$env:TEMP\RemoveEdge.ps1")
# Start-Process -FilePath 'powershell' -Verb RunAs -ArgumentList "-NoP -EP Unrestricted -File `"$env:TEMP\RemoveEdge.ps1`" -UninstallEdge -RemoveEdgeData -NonInteractive"