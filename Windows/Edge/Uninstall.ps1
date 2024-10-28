$EdgeUninstaller_TaskName = 'Edge Uninstaller'
if (-not (Get-ScheduledTask -TaskName $EdgeUninstaller_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$EdgeUninstaller_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $EdgeUninstaller_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Edge/Uninstall.ps1')"
    $EdgeUninstaller_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $EdgeUninstaller_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $EdgeUninstaller_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $EdgeUninstaller_TaskName -Action $EdgeUninstaller_TaskAction -Trigger $EdgeUninstaller_TaskTrigger -Principal $EdgeUninstaller_TaskPrincipal -Settings $EdgeUninstaller_TaskSettings -Force
}

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
if (($InstalledSoftware -match 'Microsoft Edge')) {
    # https://github.com/fr33thytweaks/Ultimate-Windows-Optimization-Guide/blob/main/6%20Windows/14%20Edge.ps1
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Stopping Related Processes'); [Console]::ResetColor(); [Console]::WriteLine()
    $stopedgerunning = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
    $stopedgerunning | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Uninstalling Copilot'); [Console]::ResetColor(); [Console]::WriteLine()
    Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Disabling Updates'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate) -ne $true) {
        New-Item -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Force
    }
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Name DoNotUpdateToEdgeWithChromium -PropertyType DWord -Value 1 -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Allowing Uninstall'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev) -ne $true) {
        New-Item HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Force
    }
    New-ItemProperty -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Name 'AllowUninstall' -Value '' -PropertyType String -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Creating Temporary Folder'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe") -ne $true) {
        New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType Directory
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Creating Temporary File'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe") -ne $true) {
        New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType File -Name 'MicrosoftEdge.exe'
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Getting UninstallString'); [Console]::ResetColor(); [Console]::WriteLine()
    $regview = [Microsoft.Win32.RegistryView]::Registry32
    $microsoft = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regview).
    OpenSubKey('SOFTWARE\Microsoft', $true)
    $uninstallregkey = $microsoft.OpenSubKey('Windows\CurrentVersion\Uninstall\Microsoft Edge')
    try {
        $uninstallstring = $uninstallregkey.GetValue('UninstallString') + ' --force-uninstall'
    }
    catch {
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Uninstalling'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process cmd.exe "/c $uninstallstring" -WindowStyle Hidden -Wait

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting Temporary Folder'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe") -eq $true) {
        Remove-Item -Recurse -Force "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Searching EdgeUpdate'); [Console]::ResetColor(); [Console]::WriteLine()
    $edgeupdate = @(); 'LocalApplicationData', 'ProgramFilesX86', 'ProgramFiles' | ForEach-Object {
        $folder = [Environment]::GetFolderPath($_)
        $edgeupdate += Get-ChildItem "$folder\Microsoft\EdgeUpdate\*.*.*.*\MicrosoftEdgeUpdate.exe" -rec -ea 0
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting EdgeUpdate'); [Console]::ResetColor(); [Console]::WriteLine()
    $global:REG = 'HKCU:\SOFTWARE', 'HKLM:\SOFTWARE', 'HKCU:\SOFTWARE\Policies', 'HKLM:\SOFTWARE\Policies', 'HKCU:\SOFTWARE\WOW6432Node', 'HKLM:\SOFTWARE\WOW6432Node', 'HKCU:\SOFTWARE\WOW6432Node\Policies', 'HKLM:\SOFTWARE\WOW6432Node\Policies'
    foreach ($location in $REG) {
        Remove-Item "$location\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue 
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Uninstalling EdgeUpdate'); [Console]::ResetColor(); [Console]::WriteLine()
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

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting EdgeWebView'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') -eq $true) {
        Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }
    if ((Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') -eq $true) {
        Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting Folders'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path "$env:C:\Program Files (x86)\Microsoft") -eq $true) {
        Remove-Item -Recurse -Force "$env:C:\Program Files (x86)\Microsoft"
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting Shortcuts'); [Console]::ResetColor(); [Console]::WriteLine()
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