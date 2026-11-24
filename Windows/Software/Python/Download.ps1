$TaskName = 'Python Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Python/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

#Requires -Version 5.1
#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Root = Join-Path $env:ProgramFiles 'Python-Runtimes'
$Manager = Join-Path $env:ProgramFiles 'PyManager\pymanager.exe'
$Temp = Join-Path $env:TEMP "Python-$(New-Guid)"
$Repository = 'https://www.python.org/ftp/python/pymanager/'

$Registry = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

function Assert-ExitCode {
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE"
    }
}

if (![Environment]::Is64BitProcess) {
    throw 'Run this script using 64-bit PowerShell.'
}

New-Item -ItemType Directory -Path $Temp, $Root -Force | Out-Null

try {
    # Install or update Python Install Manager
    $Page = Invoke-WebRequest $Repository -UseBasicParsing

    $LatestManager = [regex]::Matches(
        $Page.Content, 'python-manager-(\d+(?:\.\d+){1,3})\.msi'
    ) | ForEach-Object {
        [version]$_.Groups[1].Value
    } | Sort-Object -Descending | Select-Object -First 1

    if (!$LatestManager) {
        throw 'Unable to determine latest Python Install Manager version.'
    }

    $InstalledManager = Get-ItemProperty $Registry[0] -ErrorAction SilentlyContinue |
        Where-Object DisplayName -EQ 'Python Install Manager' |
        Select-Object -First 1

    if (!(Test-Path $Manager) -or !$InstalledManager -or
        [version]$InstalledManager.DisplayVersion -lt $LatestManager) {

        $FileName = "python-manager-$LatestManager.msi"
        $SavePath = Join-Path $Temp $FileName

        Write-Host "Downloading Python Install Manager $LatestManager" -ForegroundColor Green
        Invoke-WebRequest "$Repository$FileName" -OutFile $SavePath -UseBasicParsing

        if ((Get-AuthenticodeSignature $SavePath).Status -ne 'Valid') {
            throw 'Invalid installer signature.'
        }

        Write-Host "Installing Python Install Manager $LatestManager" -ForegroundColor Green
        $Process = Start-Process msiexec.exe -ArgumentList "/i `"$SavePath`" /quiet /norestart" -Wait -PassThru

        if ($Process.ExitCode -notin 0, 3010) {
            throw "Manager installation failed: $($Process.ExitCode)"
        }
    } else {
        Write-Host "Python Install Manager $($InstalledManager.DisplayVersion) is already installed." -ForegroundColor Green
    }

    # Configure Python Install Manager
    $Config = Join-Path $Temp 'pymanager.json'
    [IO.File]::WriteAllText($Config, (@{
                download_dir      = $Temp
                welcome_on_update = $false
            } | ConvertTo-Json -Compress))

    # Determine latest stable 64-bit Python
    $Result = & $Manager list "--config=$Config" --online --one --format=json 3-64
    Assert-ExitCode

    $Latest = ($Result | ConvertFrom-Json).versions | Select-Object -First 1

    if (!$Latest -or $Latest.'sort-version' -notmatch '^\d+\.\d+\.\d+$') {
        throw 'Unable to determine latest stable Python version.'
    }

    $LatestVersion = [version]$Latest.'sort-version'
    $Target = Join-Path $Root "$LatestVersion"
    $Python = Join-Path $Target 'python.exe'
    $Tag = "$($Latest.company)\$($Latest.tag)"

    # Install Python if missing or incomplete
    if (!(Test-Path $Python) -or !(Test-Path "$Target\Lib\os.py")) {
        if (Test-Path $Target) {
            Remove-Item -LiteralPath $Target -Recurse -Force
        }

        Write-Host "Installing Python $LatestVersion" -ForegroundColor Green
        & $Manager install "--config=$Config" "--target=$Target" --yes $Tag
        Assert-ExitCode
    } else {
        Write-Host "Python $LatestVersion is already installed." -ForegroundColor Green
    }

    # Verify installation
    $InstalledVersion = (& $Python -I --version) -replace '^Python ', ''
    Assert-ExitCode

    if ($InstalledVersion -ne "$LatestVersion") {
        throw "Unexpected Python version: $InstalledVersion"
    }

    # Configure PATH for the current session before upgrading pip
    $env:Path = "$Target;$Target\Scripts;$env:Path"

    # Ensure pip is available
    if (!(Test-Path "$Target\Lib\site-packages\pip\__init__.py")) {
        & $Python -m ensurepip --upgrade
        Assert-ExitCode
    }

    # Upgrade pip
    Write-Host 'Upgrading pip' -ForegroundColor Green
    & $Python -m pip install --upgrade pip --no-input --disable-pip-version-check --cache-dir "$Temp\pip"
    Assert-ExitCode

    # Uninstall traditional Python installations
    Get-ItemProperty $Registry -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Publisher -eq 'Python Software Foundation' -and
            $_.DisplayName -match '^Python (\d+\.\d+\.\d+) \((32-bit|64-bit|ARM64)\)$' -and
            [version]$Matches[1] -le $LatestVersion
        } | ForEach-Object {
            Write-Host "Uninstalling $($_.DisplayName)" -ForegroundColor Yellow

            if ($_.UninstallString -notmatch '^"([^"]+\.exe)"') {
                throw "Unsupported uninstall command: $($_.DisplayName)"
            }

            $Process = Start-Process $Matches[1] -ArgumentList '/uninstall /quiet /norestart' -Wait -PassThru

            if ($Process.ExitCode -notin 0, 3010) {
                throw "Uninstallation failed: $($Process.ExitCode)"
            }
        }

    # Uninstall older manager-installed Python versions
    $Result = & $Manager list "--config=$Config" --only-managed --format=json
    Assert-ExitCode

    ($Result | ConvertFrom-Json).versions |
        Where-Object {
            $_.company -eq 'PythonCore' -and
            $_.'sort-version' -match '^\d+\.\d+\.\d+$' -and
            [version]$_.'sort-version' -lt $LatestVersion
        } | ForEach-Object {
            Write-Host "Uninstalling managed Python $($_.'sort-version')" -ForegroundColor Yellow
            & $Manager uninstall "--config=$Config" --yes "$($_.company)\$($_.tag)"
            Assert-ExitCode
        }

    # Update system-wide PATH only when necessary
    $CurrentPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')

    $Path = $CurrentPath -split ';' | Where-Object {
        $_ -and $_ -notlike "$Root\*"
    }

    $Path = (@($Target, "$Target\Scripts") + @($Path)) -join ';'

    if ($Path -cne $CurrentPath) {
        Write-Host 'Updating system PATH' -ForegroundColor Green
        [Environment]::SetEnvironmentVariable('Path', $Path, 'Machine')
    }

    $env:Path = $Path + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')

    # Remove older shared Python runtimes
    Get-ChildItem $Root -Directory | Where-Object {
        $_.Name -match '^\d+\.\d+\.\d+$' -and
        [version]$_.Name -lt $LatestVersion
    } | ForEach-Object {
        Write-Host "Removing Python $($_.Name)" -ForegroundColor Yellow
        Remove-Item -LiteralPath $_.FullName -Recurse -Force
    }

    # Final verification
    Write-Host "`nPython is up to date." -ForegroundColor Green
    & $Python --version
    Assert-ExitCode

    & $Python -m pip --version
    Assert-ExitCode

} finally {
    Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue
}
