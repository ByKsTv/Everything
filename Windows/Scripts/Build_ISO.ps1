Add-Type -AssemblyName System.Windows.Forms

$FolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderDialog.ShowNewFolderButton = $true

$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true

if ($FolderDialog.ShowDialog($form) -eq 'OK') {
    $path = $FolderDialog.SelectedPath

    & "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe" -m -o -u2 -udfver102 $path "$path\unattend.iso"

    Write-Host "ISO image created successfully at $path\unattend.iso"
}