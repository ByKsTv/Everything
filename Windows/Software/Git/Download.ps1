$Git_TaskName = 'Git Updater'
if (-not (Get-ScheduledTask -TaskName $Git_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Git_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Git/Download.ps1')"
    $Git_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Git_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Git_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Git_TaskName -Action $Git_TaskAction -Trigger $Git_TaskTrigger -Principal $Git_TaskPrincipal -Settings $Git_TaskSettings -Force
}

$Git_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1' -ErrorAction SilentlyContinue).DisplayVersion
$Git_LatestVersion = ((((Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object name -Like '*64-bit.exe').name).Replace('Git-', '')).Replace('-64-bit.exe', '')

if ($null -eq $Git_InstalledVersion -or $Git_InstalledVersion -notmatch $Git_LatestVersion) {
    $Git_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object name -Like '*64-bit.exe').browser_download_url
    $Git_Filename = [IO.Path]::GetFileName(([URI]$Git_DDL).AbsolutePath)
    $Git_SavePath = [IO.Path]::Combine($env:TEMP, $Git_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Git_DDL, $Git_SavePath)
    
    # https://github.com/git-for-windows/git/wiki/Silent-or-Unattended-Installation
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Git/Download.ini', "$env:TEMP\Git_Download.inf")
    $Git_Argument = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$env:TEMP\Git_Download.inf"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Git_SavePath -ArgumentList $Git_Argument -Wait

    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $Git_CurrentUsername = git.exe config user.name
    $Git_CurrentEmail = git.exe config user.email
    
    if ($null -eq $Git_CurrentUsername -and $null -eq $Git_CurrentEmail) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        [System.Windows.Forms.Application]::EnableVisualStyles()

        $Git_Form = New-Object System.Windows.Forms.Form
        $Git_Form.width = 350
        $Git_Form.height = 125
        $Git_Form.Text = 'Git Setup'
        $Git_Form.StartPosition = 'CenterScreen'
        $Git_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
        $Git_Form.Topmost = $true
        $Git_Form.MaximizeBox = $false
        $Git_Form.MinimizeBox = $false
        $Git_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

        $Git_X_Axis = 5
        $Git_Y_Axis = 0
        $Git_Size_X = (($Git_Form.width) - 25)
        $Git_Size_Y = 26
        $Git_LocationAdd = 26

        $Git_TextBox_CustomUsername = New-Object System.Windows.Forms.TextBox
        $Git_TextBox_CustomUsername.Location = New-Object System.Drawing.Size($Git_X_Axis, $Git_Y_Axis)
        $Git_Y_Axis += $Git_LocationAdd
        $Git_TextBox_CustomUsername.Size = New-Object System.Drawing.Size($Git_Size_X, $Git_Size_Y)
        $Git_TextBox_CustomUsername.Text = 'Git Username'
        $Git_Form.Controls.Add($Git_TextBox_CustomUsername)

        $Git_TextBox_CustomEmail = New-Object System.Windows.Forms.TextBox
        $Git_TextBox_CustomEmail.Location = New-Object System.Drawing.Size($Git_X_Axis, $Git_Y_Axis)
        $Git_Y_Axis += $Git_LocationAdd
        $Git_TextBox_CustomEmail.Size = New-Object System.Drawing.Size($Git_Size_X, $Git_Size_Y)
        $Git_TextBox_CustomEmail.Text = 'Git Email'
        $Git_Form.Controls.Add($Git_TextBox_CustomEmail)

        $Git_Form_OK = New-Object System.Windows.Forms.Button
        $Git_Form_OK.Location = New-Object System.Drawing.Size((($Git_Form.Width) / 3 ), (($Git_Form.height) - 60))
        $Git_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
        $Git_Form_OK.Text = 'OK'
        $Git_Form_OK.Add_Click({ $Git_Form.Close() })
        $Git_Form.Controls.Add($Git_Form_OK)

        $Git_Form_Cancel = New-Object System.Windows.Forms.Button
        $Git_Form_Cancel.Location = New-Object System.Drawing.Size((($Git_Form.Width) / 2 ), (($Git_Form.height) - 60))
        $Git_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
        $Git_Form_Cancel.Text = 'Cancel'
        $Git_Form_Cancel.Add_Click({ $Git_Form.Close() })
        $Git_Form.Controls.Add($Git_Form_Cancel)

        $Git_Form_OK.Add_Click{
            $Git_Form.Topmost = $false

            git.exe config --global user.name $Git_TextBox_CustomUsername.Text
            $Git_CurrentUsername = git.exe config user.name
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Setting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' username '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_CurrentUsername'"); [Console]::ResetColor(); [Console]::WriteLine()
            
            git.exe config --global user.email $Git_TextBox_CustomEmail.Text
            $Git_CurrentEmail = git.exe config user.email
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Setting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' email '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Git_CurrentEmail'"); [Console]::ResetColor(); [Console]::WriteLine()
        }

        $Git_Form.Add_Shown({ $Git_Form.Activate() })
        [void] $Git_Form.ShowDialog()
    }
}