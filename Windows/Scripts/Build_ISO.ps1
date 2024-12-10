Add-Type -AssemblyName System.Windows.Forms

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog
$FileDialog.CheckFileExists = $false
$FileDialog.ValidateNames = $false
$FileDialog.FileName = 'Select Folder'

$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true

if ($FileDialog.ShowDialog($form) -eq 'OK') {
    $path = [System.IO.Path]::GetDirectoryName($FileDialog.FileName)

    & 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe' -m -o -u2 -udfver102 $path "$path\unattend.iso"

    Write-Host "ISO image created successfully at $path\unattend.iso"
}