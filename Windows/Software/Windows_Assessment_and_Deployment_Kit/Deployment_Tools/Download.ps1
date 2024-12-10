$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2196127"
$installerPath = "$env:TEMP\ADKSetup.exe"
Invoke-WebRequest -Uri $adkUrl -OutFile $installerPath
Start-Process -FilePath $installerPath -ArgumentList "/quiet /features OptionId.DeploymentTools" -Wait