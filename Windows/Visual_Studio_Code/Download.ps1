$VSCode = 'Visual Studio Code Updater'
$VSCode_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $VSCode }
if (!($VSCode_Exists)) {
    Write-Host "VSCode: Task Scheduler: Adding $VSCode" -ForegroundColor green -BackgroundColor black
    $VSCode_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $VSCode_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')"
    $VSCode_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $VSCode_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $VSCode_Parameters = @{
        TaskName  = $VSCode
        Principal = $VSCode_Principal
        Action    = $VSCode_Action
        Trigger   = $VSCode_Trigger
        Settings  = $VSCode_Settings
    }
    Register-ScheduledTask @VSCode_Parameters -Force
}

Write-Host 'Visual Studio Code: Getting current version' -ForegroundColor green -BackgroundColor black
$VSCode_Installed = Get-Package -Name 'Microsoft Visual Studio Code' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Version'

Write-Host 'Visual Studio Code: Getting latest version' -ForegroundColor green -BackgroundColor black
$VSCode_Latest = (Invoke-RestMethod https://api.github.com/repos/microsoft/vscode/releases).tag_name | Select-Object -First 1

if (($null -eq $VSCode_Installed) -or ($VSCode_Installed -notmatch $VSCode_Latest)) {
    Write-Host "Visual Studio Code: Downloading $VSCode_Latest" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://code.visualstudio.com/sha/download?build=stable&os=win32-x64', "$env:TEMP\VisualStudioCode.exe")

    Write-Host "Visual Studio Code: Installing $VSCode_Latest" -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath $env:TEMP\VisualStudioCode.exe -ArgumentList '/VERYSILENT /MERGETASKS=!runcode'
}