Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$BuildISO_Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$BuildISO_FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select Folder'
    Filter          = 'Folders|*.'
    CheckFileExists = $false
}

if ($BuildISO_FileDialog.ShowDialog($BuildISO_Form) -eq [Windows.Forms.DialogResult]::OK) {
    $BuildISO_FileSelected = [IO.Path]::GetDirectoryName($BuildISO_FileDialog.FileName)

    & 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe' -m -o -u2 -udfver102 $BuildISO_FileSelected "$BuildISO_FileSelected\ISO.iso"
}

$BuildISO_Form.Dispose()