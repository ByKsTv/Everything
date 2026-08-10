Add-Type -AssemblyName System.Windows.Forms

$Dialog = New-Object System.Windows.Forms.OpenFileDialog
$Dialog.Title = 'Choose first file'

if ($Dialog.ShowDialog() -ne 'OK') {
    exit
}

$Input1 = $Dialog.FileName

$Dialog = New-Object System.Windows.Forms.OpenFileDialog
$Dialog.Title = 'Choose second file'

if ($Dialog.ShowDialog() -ne 'OK') {
    exit
}

$Input2 = $Dialog.FileName

$SaveDialog = New-Object System.Windows.Forms.SaveFileDialog
$SaveDialog.Title = 'Choose output location'
$SaveDialog.Filter = 'Matroska Video (*.mkv)|*.mkv'
$SaveDialog.FileName = ([IO.Path]::GetFileNameWithoutExtension($Input1) + '.combined.mkv')

if ($SaveDialog.ShowDialog() -ne 'OK') {
    exit
}

$SavePath = $SaveDialog.FileName

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ffmpeg'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Input1 + $Input2'"); [Console]::ResetColor(); [Console]::WriteLine()

& ffmpeg.exe -i $Input1 -i $Input2 -map 0 -map 1 -c copy $SavePath