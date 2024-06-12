$Notepad = 'Notepad++ Updater'
$Notepad_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Notepad }
if (!($Notepad_Exists)) {
    Write-Host "Notepad++: Task Scheduler: Adding $Notepad" -ForegroundColor green -BackgroundColor black
    $Notepad_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Notepad_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad++/Download.ps1')"
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

Write-Host 'Notepad++: Getting latest release' -ForegroundColor green -BackgroundColor black
$npp = Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest' | ConvertFrom-Json
$nppPackage = 'x64.exe'
$dlUrl = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty browser_download_url
$outfile = $npp.assets | Where-Object { $_.name.Contains($nppPackage) -and !$_.name.Contains('.sig') } | Select-Object -ExpandProperty name
$installerPath = Join-Path $env:temp $outfile

Write-Host 'Notepad++: Checking if updated' -ForegroundColor green -BackgroundColor black
$NotepadInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++' -ErrorAction SilentlyContinue).DisplayVersion
$NotepadLatestVer = $npp.tag_name 
$NotepadLatestVer = $NotepadLatestVer.Replace('v', '')

if ($NotepadInstalledVer -match $NotepadLatestVer) {
    Write-Host 'Notepad++: Latest Version Is Already Installed' -ForegroundColor green -BackgroundColor black
}

elseif ($NotepadInstalledVer -notmatch $NotepadLatestVer ) {
    Write-Host 'Notepad++: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile($dlUrl, $installerPath)

    Write-Host 'Notepad++: Installing' -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath $installerPath -ArgumentList '/S'
}