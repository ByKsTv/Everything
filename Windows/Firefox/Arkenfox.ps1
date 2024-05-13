if ((Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $CurrentFireFoxProfilePath0 = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFireFoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles\$CurrentFireFoxProfilePath0"
    if ((Test-Path -Path $CurrentFireFoxProfilePath) -eq $true) {
        Write-Host 'Arkenfox Setup' -ForegroundColor green -BackgroundColor black
        Stop-Process -Name firefox -Force
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/user-overrides.js', "$CurrentFireFoxProfilePath\user-overrides.js")
        (New-Object System.Net.WebClient).DownloadFile('https://github.com/ByKsTv/Everything/raw/main/Windows/Firefox/search.json.mozlz4', "$CurrentFireFoxProfilePath\search.json.mozlz4")
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/arkenfox/user.js/master/updater.bat', "$CurrentFireFoxProfilePath\updater.bat")
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.bat', "$CurrentFireFoxProfilePath\prefsCleaner.bat")
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/arkenfox/user.js/master/user.js', "$CurrentFireFoxProfilePath\user.js")
        $Arkenfox_Update = 'Arkenfox Update'
        $Arkenfox_Update_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Arkenfox_Update }
        if (!($Arkenfox_Update_Exists)) {
            Write-Host "Task Scheduler > $Arkenfox_Update" -ForegroundColor green -BackgroundColor black
            $Arkenfox_Update_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Update_Action = New-ScheduledTaskAction -Execute "$CurrentFireFoxProfilePath\updater.bat" -Argument '-unattended -updatebatch'
            $Arkenfox_Update_Trigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Update_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
            $Arkenfox_Update_Parameters = @{
                TaskName  = $Arkenfox_Update
                Principal = $Arkenfox_Update_Principal
                Action    = $Arkenfox_Update_Action
                Trigger   = $Arkenfox_Update_Trigger
                Settings  = $Arkenfox_Update_Settings
            }
            Register-ScheduledTask @Arkenfox_Update_Parameters -Force
        }
        $Arkenfox_Clean = 'Arkenfox Clean'
        $Arkenfox_Clean_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Arkenfox_Clean }
        if (!($Arkenfox_Clean_Exists)) {
            Write-Host "Task Scheduler > $Arkenfox_Clean" -ForegroundColor green -BackgroundColor black
            $Arkenfox_Clean_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Clean_Action = New-ScheduledTaskAction -Execute "$CurrentFireFoxProfilePath\prefsCleaner.bat" -Argument '-unattended'
            $Arkenfox_Clean_Trigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Clean_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
            $Arkenfox_Clean_Parameters = @{
                TaskName  = $Arkenfox_Clean
                Principal = $Arkenfox_Clean_Principal
                Action    = $Arkenfox_Clean_Action
                Trigger   = $Arkenfox_Clean_Trigger
                Settings  = $Arkenfox_Clean_Settings
            }
            Register-ScheduledTask @Arkenfox_Clean_Parameters -Force
        }
        $Arkenfox_Overrides = 'Arkenfox Overrides'
        $Arkenfox_Overrides_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Arkenfox_Overrides }
        if (!($Arkenfox_Overrides_Exists)) {
            Write-Host "Task Scheduler > $Arkenfox_Overrides" -ForegroundColor green -BackgroundColor black
            $Arkenfox_Overrides_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Overrides_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/user-overrides.js -OutFile $CurrentFireFoxProfilePath\user-overrides.js"
            $Arkenfox_Overrides_Trigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Overrides_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
            $Arkenfox_Overrides_Parameters = @{
                TaskName  = $Arkenfox_Overrides
                Principal = $Arkenfox_Overrides_Principal
                Action    = $Arkenfox_Overrides_Action
                Trigger   = $Arkenfox_Overrides_Trigger
                Settings  = $Arkenfox_Overrides_Settings
            }
            Register-ScheduledTask @Arkenfox_Overrides_Parameters -Force
        }
        Start-ScheduledTask -TaskName $Arkenfox_Update
    }
}