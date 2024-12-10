# Build .ISO from folder
$path = "path"
& "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe" -m -o -u2 -udfver102 $path "$path\unattend.iso"
Write-Host "ISO image created successfully at $isoPath"