Start-Process 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/' -Wait
Add-Type -AssemblyName System.Windows.Forms
Start-Sleep -Milliseconds 5000
[System.Windows.Forms.SendKeys]::SendWait('^+K')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'button startbutton'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'closest'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$NVCleanstallPath = Join-Path $Downloads 'NVCleanstall_*.exe'
$NVCleanstall = Get-Item $NVCleanstallPath
Start-Process -FilePath $NVCleanstall -Args '/install /tasks="DriverUpdateCheck,DesktopIcon" /silent'