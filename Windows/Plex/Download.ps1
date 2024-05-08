if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -eq $true) {
    $OpenWithChrome = New-Object System.Diagnostics.Process
    $OpenWithChrome.StartInfo.Filename = 'chrome.exe'
    $OpenWithChrome.StartInfo.Arguments = 'https://www.plex.tv/media-server-downloads/#plex-media-server'
    $OpenWithChrome.start()
    Start-Sleep -Milliseconds 5000
    [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
    Start-Sleep -Milliseconds 500
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Mozilla Firefox") -eq $true) {
    $OpenWithFirefox = New-Object System.Diagnostics.Process
    $OpenWithFirefox.StartInfo.Filename = 'firefox.exe'
    $OpenWithFirefox.StartInfo.Arguments = 'https://www.plex.tv/media-server-downloads/#plex-media-server'
    $OpenWithFirefox.start()
    Start-Sleep -Milliseconds 5000
    [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
    Start-Sleep -Milliseconds 500
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('^+k')
}
Start-Sleep -Milliseconds 2000
#[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'plex-downloads-releasesbutton tooltipstered'{)}{[}0{]}.click{(}{)}")
#[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
#Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'user-arch'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Mozilla Firefox") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+i')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('%o')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('s')
}
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$PlexMediaServerPath = Join-Path $Downloads 'PlexMediaServer-*.exe'
While (!(Test-Path $PlexMediaServerPath -ErrorAction SilentlyContinue)) {
}
do {
    $dirStats = Get-Item $PlexMediaServerPath | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )
Start-Process -FilePath $PlexMediaServerPath -ArgumentList '/VERYSILENT'