$Notepad = 'Notepad++ Updater'
$Notepad_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Notepad }
if (!($Notepad_Exists)) {
    Write-Host "Notepad++: Task Scheduler: Adding $Notepad" -ForegroundColor green -BackgroundColor black
    $Notepad_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Notepad_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad++/Download.ps1')"
    $Notepad_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $Notepad_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $Notepad_Parameters = @{
        TaskName  = $Notepad
        Principal = $Notepad_Principal
        Action    = $Notepad_Action
        Trigger   = $Notepad_Trigger
        Settings  = $Notepad_Settings
    }
    Register-ScheduledTask @Notepad_Parameters -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Notepad++: Getting latest release'); [Console]::ResetColor(); [Console]::WriteLine()
$npp = Invoke-RestMethod 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest'
$nppPackage = 'x64.exe'
$dlUrl = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty browser_download_url
$outfile = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty name
$installerPath = Join-Path $env:temp $outfile

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Notepad++: Checking if updated'); [Console]::ResetColor(); [Console]::WriteLine()
$NotepadInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++' -ErrorAction SilentlyContinue).DisplayVersion
$NotepadLatestVer = $npp.tag_name 
$NotepadLatestVer = $NotepadLatestVer.Replace('v', '')

if (($null -eq $NotepadInstalledVer) -or ($NotepadInstalledVer -notmatch $NotepadLatestVer)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Notepad++: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($dlUrl, $installerPath)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Notepad++: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process -FilePath $installerPath -ArgumentList '/S'
}