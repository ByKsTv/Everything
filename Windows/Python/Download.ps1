Write-Host 'Python > Get latest' -ForegroundColor green -BackgroundColor black
$PyReleases = Invoke-RestMethod 'https://github.com/python/cpython/releases.atom'
$PyLatestVersion = ($PyReleases.title) -replace '^v' -notmatch '[a-z]' | Sort-Object { [version] $_ } -Descending | Select-Object -First 1
$PyLatestBaseUrl = "https://www.python.org/ftp/python/${PyLatestVersion}/"
$PyUrl = "${PyLatestBaseUrl}/python-${PyLatestVersion}-amd64.exe"
$PyPkg = $PyUrl | Split-Path -Leaf
$PyVerDir = ($PyPkg -replace '\.exe' -replace '-amd64' -replace '-').Split('.')
$PyVerDir = $PyVerDir[0] + $PyVerDir[-2]
$PyVerDir = $PyVerDir.Substring(0, 1).ToUpper() + $PyVerDir.Substring(1).ToLower()
Write-Host 'Python > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -UseBasicParsing -Uri $PyUrl -OutFile "$env:TEMP\${PyPkg}"
Write-Host 'Python > Install' -ForegroundColor green -BackgroundColor black
Start-Process "$env:TEMP\${PyPkg}" -ArgumentList '/passive', 'InstallAllUsers=1', 'PrependPath=1', 'Include_test=0' -NoNewWindow