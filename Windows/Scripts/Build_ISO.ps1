Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$BuildISO_FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select Folder'
    CheckFileExists = $false
    ValidateNames   = $false
}
$BuildISO_Form = New-Object System.Windows.Forms.Form -Property @{ 
    TopMost       = $true
    ShowInTaskbar = $false
    Opacity       = 0 
}
$BuildISO_Form.Show()
$BuildISO_OK = $BuildISO_FileDialog.ShowDialog($BuildISO_Form)
$BuildISO_Form.Dispose()

if ($BuildISO_OK -eq [Windows.Forms.DialogResult]::OK) {
    $BuildISO_FileSelected = [IO.Path]::GetDirectoryName($BuildISO_FileDialog.FileName)

    & 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe' -m -o -u2 -udfver102 $BuildISO_FileSelected "$BuildISO_FileSelected\File.iso"
}
else {
    Write-Output 'No file selected.'
}