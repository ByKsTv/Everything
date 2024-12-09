# Build .ISO from folder
$sourcePath = "path\Unattend"
$isoPath = "path\unattend.iso"
$oscdimgPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
& $oscdimgPath -m -o -u2 -udfver102 $sourcePath $isoPath
Write-Host "ISO image created successfully at $isoPath"