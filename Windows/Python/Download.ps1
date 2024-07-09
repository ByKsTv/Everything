$Python = 'Python Updater'
$Python_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Python }
if (!($Python_Exists)) {
    Write-Host "Python: Task Scheduler: Adding $Python" -ForegroundColor green -BackgroundColor black
    $Python_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Python_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')"
    $Python_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $Python_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $Python_Parameters = @{
        TaskName  = $Python
        Principal = $Python_Principal
        Action    = $Python_Action
        Trigger   = $Python_Trigger
        Settings  = $Python_Settings
    }
    Register-ScheduledTask @Python_Parameters -Force
}

Write-Host 'Python: Getting latest release' -ForegroundColor green -BackgroundColor black
$PyReleases = Invoke-RestMethod 'https://github.com/python/cpython/releases.atom'
$PyLatestVersion = ($PyReleases.title) -replace '^v' -notmatch '[a-z]' | Sort-Object { [version] $_ } -Descending | Select-Object -First 1
$PyLatestBaseUrl = "https://www.python.org/ftp/python/${PyLatestVersion}/"
$PyUrl = "${PyLatestBaseUrl}/python-${PyLatestVersion}-amd64.exe"
$PyPkg = $PyUrl | Split-Path -Leaf
$PyVerDir = ($PyPkg -replace '\.exe' -replace '-amd64' -replace '-').Split('.')
$PyVerDir = $PyVerDir[0] + $PyVerDir[-2]
$PyVerDir = $PyVerDir.Substring(0, 1).ToUpper() + $PyVerDir.Substring(1).ToLower()

Write-Host 'Python: Checking if updated' -ForegroundColor green -BackgroundColor black
$PythonInstalledVer = py -V
$PythonInstalledVer = $PythonInstalledVer.Replace('Python ', '')

if (($null -eq $PythonInstalledVer) -or ($PythonInstalledVer -notmatch $PyLatestVersion)) {
    Write-Host 'Python: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile($PyUrl, "$env:TEMP\${PyPkg}")
    
    Write-Host 'Python: Installing' -ForegroundColor green -BackgroundColor black
    Start-Process "$env:TEMP\${PyPkg}" -ArgumentList '/silent', 'InstallAllUsers=1', 'PrependPath=1', 'Include_test=0' -NoNewWindow
}