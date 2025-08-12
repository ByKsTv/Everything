$TaskName = 'Edge Uninstaller'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Edge/Uninstall.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledSoftware = Get-Package | Select-Object -ExpandProperty 'Name'
if ($InstalledSoftware -match 'Microsoft Edge') {
    $Process = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Stopping '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' process '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Process'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Process | ForEach-Object {
        Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue 
    }

    $MicrosoftCopilot = Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider*
    if ($MicrosoftCopilot) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Copilot'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' package '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MicrosoftCopilot'"); [Console]::ResetColor(); [Console]::WriteLine()
        $MicrosoftCopilot | Remove-AppxPackage
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Disabling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' updates'); [Console]::ResetColor(); [Console]::WriteLine()
    if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\EdgeUpdate')) {
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\EdgeUpdate' -Force
    }
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\EdgeUpdate' -Name 'DoNotUpdateToEdgeWithChromium' -PropertyType DWord -Value 1 -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Allowing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to uninstall'); [Console]::ResetColor(); [Console]::WriteLine()
    if (-not (Test-Path -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev')) {
        New-Item 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev' -Force
    }
    New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev' -Name 'AllowUninstall' -Value '' -PropertyType String -Force

    $TemporaryFile = [IO.Path]::Combine($env:SystemRoot, 'SystemApps', 'Microsoft.MicrosoftEdge_8wekyb3d8bbwe', 'MicrosoftEdge.exe')
    if (-not (Test-Path $TemporaryFile)) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Creating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary file in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TemporaryFile'"); [Console]::ResetColor(); [Console]::WriteLine()
        New-Item $TemporaryFile -ItemType File -Force
    }

    $UninstallString = ([Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry32).OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge')).GetValue('UninstallString') + ' --force-uninstall'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallString'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process cmd.exe "/c $UninstallString" -WindowStyle Hidden -Wait

    $TemporaryFolder = Split-Path $TemporaryFile -Parent
    if (Test-Path $TemporaryFolder) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Taking ownership on '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        & takeown.exe /F $TemporaryFolder /R /D Y

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Granting premissions on '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        & icacls.exe $TemporaryFolder /grant 'Everyone:F' /T

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' temporary folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TemporaryFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $TemporaryFolder -Recurse -Force
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
        } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '\Microsoft\Edge')
        if (Test-Path $path) {
            Start-Process -Wait $path -Args '/uninstall' | Out-Null 
        }
        do {
            Start-Sleep 3 
        } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '\Microsoft\Edge')
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Edge Uninstaller: Deleting EdgeWebView'); [Console]::ResetColor(); [Console]::WriteLine()
    if (Test-Path -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') {
        Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }
    if (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView') {
        Remove-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView' -Force
    }

    $ProgramFilesFolder = [IO.Path]::Combine(${env:ProgramFiles(x86)}, 'Microsoft')
    if (Test-Path $ProgramFilesFolder) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ProgramFilesFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        & takeown.exe /F $ProgramFilesFolder /R /D Y
        & icacls.exe $ProgramFilesFolder /grant 'Everyone:F' /T
        Remove-Item $ProgramFilesFolder -Recurse -Force
    }

    $UserQuickLaunch = [IO.Path]::Combine($env:APPDATA, 'Microsoft', 'Internet Explorer', 'Quick Launch', 'Microsoft Edge.lnk')
    if (Test-Path $UserQuickLaunch) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UserQuickLaunch'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $UserQuickLaunch -Force
    }

    $SystemQuickLaunch = [IO.Path]::Combine($env:SystemRoot, 'System32', 'config', 'systemprofile', 'AppData', 'Roaming', 'Microsoft', 'Internet Explorer', 'Quick Launch', 'Microsoft Edge.lnk')
    if (Test-Path $SystemQuickLaunch) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Edge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SystemQuickLaunch'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item $SystemQuickLaunch -Force
    }

    # Microsoft Edge: Deleting Desktop Shortcut
    if (Test-Path -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk") {
        Remove-Item -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
    }

    $DesktopPath = [Environment]::GetFolderPath('Desktop')
    if (Test-Path -Path "$DesktopPath\Microsoft Edge.lnk") {
        Remove-Item -Path "$DesktopPath\Microsoft Edge.lnk"
    }
}