
$f = Get-ChildItem -File -Filter *.apkm | Select-Object -First 1
if (-not $f) {
    throw 'No .apkm file found' 
}

$t = Join-Path $env:TEMP ('apkm_' + [guid]::NewGuid().ToString('N'))
$z = "$t.zip"

try {
    Copy-Item $f.FullName $z -Force
    Expand-Archive -Path $z -DestinationPath $t -Force

    $apks = @(Get-ChildItem $t -Filter *.apk -File -Recurse)
    if ($apks.Count -eq 0) {
        throw 'No APK files found' 
    }

    if ($apks.Count -eq 1) {
        & adb install -r $apks[0].FullName
    } else {
        & adb install-multiple -r $apks.FullName
    }

    if ($LASTEXITCODE -ne 0) {
        throw 'ADB installation failed'
    }
} finally {
    Remove-Item $z, $t -Recurse -Force -ErrorAction SilentlyContinue
}
