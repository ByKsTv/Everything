$EdgeUninstaller_TaskName = 'Edge Uninstaller'
if (-not (Get-ScheduledTask -TaskName $EdgeUninstaller_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$EdgeUninstaller_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $EdgeUninstaller_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Edge/Uninstall.ps1')"
    $EdgeUninstaller_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $EdgeUninstaller_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $EdgeUninstaller_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $EdgeUninstaller_TaskName -Action $EdgeUninstaller_TaskAction -Trigger $EdgeUninstaller_TaskTrigger -Principal $EdgeUninstaller_TaskPrincipal -Settings $EdgeUninstaller_TaskSettings -Force
}

$InstalledSoftware = (Get-Package).Name
if ($InstalledSoftware -match 'Microsoft Edge') {
    $MicrosoftEdge_Process = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Stopping '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' process '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_Process'"); [Console]::ResetColor(); [Console]::WriteLine()
    $MicrosoftEdge_Process | ForEach-Object {
        Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue 
    }

    $MicrosoftCopilot = Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider*
    if ($MicrosoftCopilot) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Copilot'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' package '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftCopilot'"); [Console]::ResetColor(); [Console]::WriteLine()
        $MicrosoftCopilot | Remove-AppxPackage
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Disabling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' updates'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate) -ne $true) {
        New-Item -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Force
    }
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Name DoNotUpdateToEdgeWithChromium -PropertyType DWord -Value 1 -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Allowing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to uninstall'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev) -ne $true) {
        New-Item HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Force
    }
    New-ItemProperty -Path HKLM:\Software\WOW6432Node\Microsoft\EdgeUpdateDev -Name 'AllowUninstall' -Value '' -PropertyType String -Force

    $MicrosoftEdge_TemporaryFile = [IO.Path]::Combine($env:SystemRoot, 'SystemApps', 'Microsoft.MicrosoftEdge_8wekyb3d8bbwe', 'MicrosoftEdge.exe')
    if (-not (Test-Path $MicrosoftEdge_TemporaryFile)) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Creating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary file in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_TemporaryFile'"); [Console]::ResetColor(); [Console]::WriteLine()
        New-Item $MicrosoftEdge_TemporaryFile -ItemType File -Force
    }

    $MicrosoftEdge_UninstallString = ([Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry32).OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge')).GetValue('UninstallString') + ' --force-uninstall'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_UninstallString'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process cmd.exe "/c $MicrosoftEdge_UninstallString" -WindowStyle Hidden -Wait

    $MicrosoftEdge_TemporaryFolder = Split-Path $MicrosoftEdge_TemporaryFile -Parent
    if (Test-Path $MicrosoftEdge_TemporaryFolder) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Taking ownership on '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        takeown.exe /F $MicrosoftEdge_TemporaryFolder /R /D Y

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Granting premissions on '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        icacls.exe $MicrosoftEdge_TemporaryFolder /grant 'Everyone:F' /T

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $MicrosoftEdge_TemporaryFolder -Recurse -Force
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

    $MicrosoftEdge_ProgramFilesFolder = [IO.Path]::Combine(${env:ProgramFiles(x86)}, 'Microsoft')
    if (Test-Path $MicrosoftEdge_ProgramFilesFolder) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_ProgramFilesFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $MicrosoftEdge_ProgramFilesFolder -Recurse -Force
    }

    $MicrosoftEdge_UserQuickLaunch = [IO.Path]::Combine($env:APPDATA, 'Microsoft', 'Internet Explorer', 'Quick Launch', 'Microsoft Edge.lnk')
    if (Test-Path $MicrosoftEdge_UserQuickLaunch) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_UserQuickLaunch'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $MicrosoftEdge_UserQuickLaunch -Force
    }

    $MicrosoftEdge_SystemQuickLaunch = [IO.Path]::Combine($env:SystemRoot, 'System32', 'config', 'systemprofile', 'AppData', 'Roaming', 'Microsoft', 'Internet Explorer', 'Quick Launch', 'Microsoft Edge.lnk')
    if (Test-Path $MicrosoftEdge_SystemQuickLaunch) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftEdge_SystemQuickLaunch'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $MicrosoftEdge_SystemQuickLaunch -Force
    }
}