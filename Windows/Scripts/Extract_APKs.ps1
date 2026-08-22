Get-Content '.\selection_export.txt' | ForEach-Object {
    $pkg = $_
    $paths = (adb shell pm path $pkg) -replace 'package:', ''
    if (!(Test-Path $pkg)) {
        mkdir $pkg
    }
    $paths | ForEach-Object {
        adb pull $_ "$pkg/"
    }
}
