$f = (Get-ChildItem *.apks | Select-Object -First 1).FullName
$z = "$env:TEMP\temp_app.zip"
$t = "$env:TEMP\apks_tmp"
Copy-Item $f $z -Force
Expand-Archive -Path $z -DestinationPath $t -Force
& adb install-multiple (Get-ChildItem $t\*.apk).FullName
Remove-Item $z, $t -Recurse -Force
