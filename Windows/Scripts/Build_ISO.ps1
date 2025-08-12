Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost       = $true
    StartPosition = 'CenterScreen'
}

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select Folder'
    Title           = 'Build ISO'
    Filter          = 'Folders|*.'
    CheckFileExists = $false
}

if ($FileDialog.ShowDialog($Form) -eq [Windows.Forms.DialogResult]::OK) {
    $SelectedFolder = [IO.Path]::GetDirectoryName($FileDialog.FileName)

    $InstalledSoftware = (Get-Package).Name
    if ($InstalledSoftware -notcontains 'Windows System Image Manager') {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Windows_Assessment_and_Deployment_Kit/Deployment_Tools/Download.ps1')
    }

    Start-Process -FilePath "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe" -ArgumentList "-m -o -u2 -udfver102 `"$SelectedFolder`" `"$SelectedFolder\ISO.iso`"" -NoNewWindow -Wait
}