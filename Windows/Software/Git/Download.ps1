$TaskName = 'Git Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Git/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'DisplayVersion'
$LatestVersion = (((Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' | Select-Object -ExpandProperty 'assets' | Where-Object { $_.name -match '64-bit.exe' } ).name).Replace('Git-', '')).Replace('-64-bit.exe', '')

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
    $DDL = (Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' | Select-Object -ExpandProperty 'assets' | Where-Object { $_.name -match '64-bit.exe' } ) | Select-Object -ExpandProperty 'browser_download_url'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
    
    # https://github.com/git-for-windows/git/wiki/Silent-or-Unattended-Installation
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Git/Download.ini', "$env:TEMP\Git_Download.inf")
    $Argument = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$env:TEMP\Git_Download.inf"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SavePath -ArgumentList $Argument -Wait

    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
    $CurrentUsername = & git.exe config user.name
    $CurrentEmail = & git.exe config user.email
    
    if (($null -eq $CurrentUsername) -and ($null -eq $CurrentEmail)) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        [Windows.Forms.Application]::EnableVisualStyles()

        $Form = New-Object System.Windows.Forms.Form
        $Form.width = 350
        $Form.height = 125
        $Form.Text = 'Git Setup'
        $Form.StartPosition = 'CenterScreen'
        $Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
        $Form.Topmost = $true
        $Form.MaximizeBox = $false
        $Form.MinimizeBox = $false
        $Form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog

        $X_Axis = 5
        $Y_Axis = 0
        $Size_X = (($Form.width) - 25)
        $Size_Y = 26
        $LocationAdd = 26

        $TextBox_CustomUsername = New-Object System.Windows.Forms.TextBox
        $TextBox_CustomUsername.Location = New-Object System.Drawing.Size($X_Axis, $Y_Axis)
        $Y_Axis += $LocationAdd
        $TextBox_CustomUsername.Size = New-Object System.Drawing.Size($Size_X, $Size_Y)
        $TextBox_CustomUsername.Text = 'Git Username'
        $Form.Controls.Add($TextBox_CustomUsername)

        $TextBox_CustomEmail = New-Object System.Windows.Forms.TextBox
        $TextBox_CustomEmail.Location = New-Object System.Drawing.Size($X_Axis, $Y_Axis)
        $Y_Axis += $LocationAdd
        $TextBox_CustomEmail.Size = New-Object System.Drawing.Size($Size_X, $Size_Y)
        $TextBox_CustomEmail.Text = 'Git Email'
        $Form.Controls.Add($TextBox_CustomEmail)

        $Form_OK = New-Object System.Windows.Forms.Button
        $Form_OK.Location = New-Object System.Drawing.Size((($Form.Width) / 3 ), (($Form.height) - 60))
        $Form_OK.Size = New-Object System.Drawing.Size(57, 20)
        $Form_OK.Text = 'OK'
        $Form_OK.Add_Click({ $Form.Close() })
        $Form.Controls.Add($Form_OK)

        $Form_Cancel = New-Object System.Windows.Forms.Button
        $Form_Cancel.Location = New-Object System.Drawing.Size((($Form.Width) / 2 ), (($Form.height) - 60))
        $Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
        $Form_Cancel.Text = 'Cancel'
        $Form_Cancel.Add_Click({ $Form.Close() })
        $Form.Controls.Add($Form_Cancel)

        $Form_OK.Add_Click({
                $Form.Topmost = $false

                & git.exe config --global user.name $TextBox_CustomUsername.Text
                $CurrentUsername = & git.exe config user.name
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Setting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' username '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CurrentUsername'"); [Console]::ResetColor(); [Console]::WriteLine()
            
                & git.exe config --global user.email $TextBox_CustomEmail.Text
                $CurrentEmail = & git.exe config user.email
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Setting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Git'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' email '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CurrentEmail'"); [Console]::ResetColor(); [Console]::WriteLine()
            })
            
        $Form.Add_Shown({ $Form.Activate() })
        [void] $Form.ShowDialog()
    }
}