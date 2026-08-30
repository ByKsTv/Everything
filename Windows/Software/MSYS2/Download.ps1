$TaskName = 'MSYS2 Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MSYS2/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$StatusColors = @{ name = 'Yellow'; version = 'Magenta'; url = 'Cyan'; path = 'DarkCyan'; dest = 'Blue'; list = 'Yellow' }

function Write-Status([string]$Template, [hashtable]$Values = @{}) {
    [Console]::BackgroundColor = 'Black'
    foreach ($part in [regex]::Split($Template, '(\{\w+\})')) {
        if ($part -match '^\{(\w+)\}$') {
            $role = $Matches[1].ToLowerInvariant()
            [Console]::ForegroundColor = if ($StatusColors.ContainsKey($role)) {
                $StatusColors[$role]
            } else {
                'Yellow'
            }
            [Console]::Write("'$($Values[$role])'")
        } elseif ($part) {
            [Console]::ForegroundColor = 'Green'
            [Console]::Write($part)
        }
    }
    [Console]::ResetColor(); [Console]::WriteLine()
}

function Invoke-FileDownload([string]$Uri, [string]$Destination, [Net.Http.HttpClient]$HttpClient) {
    $response = $HttpClient.GetAsync($Uri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
    $response.EnsureSuccessStatusCode() | Out-Null

    $totalBytes = $response.Content.Headers.ContentLength
    $lastPercent = -1
    $bytesRead = 0
    $buffer = New-Object byte[] 81920
    $sourceStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
    $destStream = [IO.File]::Create($Destination)

    try {
        while (($read = $sourceStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $destStream.Write($buffer, 0, $read)
            $bytesRead += $read
            if ($totalBytes) {
                $percent = [int](($bytesRead / $totalBytes) * 100)
                if ($percent -ne $lastPercent) {
                    Write-Progress -Activity 'Downloading MSYS2 installer' -Status "$bytesRead / $totalBytes bytes" -PercentComplete $percent
                    $lastPercent = $percent
                }
            } else {
                Write-Progress -Activity 'Downloading MSYS2 installer' -Status "$bytesRead bytes"
            }
        }
    } finally {
        Write-Progress -Activity 'Downloading MSYS2 installer' -Completed
        $destStream.Dispose(); $sourceStream.Dispose()
    }

    if ($bytesRead -eq 0) {
        throw "Downloaded file '$Destination' is empty."
    }
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $InstallPath = "$env:SystemDrive\msys64"
    $Bash = [IO.Path]::Combine($InstallPath, 'usr', 'bin', 'bash.exe')
    $Architecture = if ($env:PROCESSOR_ARCHITEW6432) {
        $env:PROCESSOR_ARCHITEW6432
    } else {
        $env:PROCESSOR_ARCHITECTURE
    }

    switch ($Architecture.ToUpperInvariant()) {
        'AMD64' {
            $AssetArchitecture = 'x86_64'
            $EnvironmentPath = [IO.Path]::Combine($InstallPath, 'ucrt64', 'bin')
            $ToolchainPackages = @('base-devel', 'mingw-w64-ucrt-x86_64-toolchain', 'mingw-w64-clang-x86_64-clang', 'mingw-w64-clang-x86_64-clang-tools-extra')
        }
        'ARM64' {
            $AssetArchitecture = 'arm64'
            $EnvironmentPath = [IO.Path]::Combine($InstallPath, 'clangarm64', 'bin')
            # CLANGARM64 is Clang/LLVM, not GCC (no aarch64-w64-mingw32 GCC backend); gcc-compat adds gcc/g++ shims over clang.
            $ToolchainPackages = @('base-devel', 'mingw-w64-clang-aarch64-toolchain', 'mingw-w64-clang-aarch64-gcc-compat')
        }
        default {
            throw "Unsupported Windows architecture: '$Architecture'."
        }
    }

    if (-not ('Net.Http.HttpClient' -as [type])) {
        Add-Type -AssemblyName System.Net.Http
    }
    $HttpClient = [Net.Http.HttpClient]::new()

    try {
        $HttpClient.Timeout = [TimeSpan]::FromSeconds(30)
        # HttpClient sends no User-Agent by default (unlike Invoke-RestMethod); GitHub's API requires one.
        $HttpClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-MSYS2-Installer')

        if (-not [IO.File]::Exists($Bash)) {
            $Releases = $HttpClient.GetStringAsync('https://api.github.com/repos/msys2/msys2-installer/releases?per_page=100').GetAwaiter().GetResult() | ConvertFrom-Json
            $LatestRelease = $Releases | Where-Object { -not $_.draft -and -not $_.prerelease -and $_.tag_name -match '^\d{4}-\d{2}-\d{2}$' } |
                Sort-Object tag_name -Descending | Select-Object -First 1
            $LatestVersion = $LatestRelease.tag_name -replace '-', ''
            # Match on architecture + .exe only — but MSYS2 also publishes a self-extracting
            # "-base-...sfx.exe" archive per architecture, which looks like a hit on that loose
            # pattern too and takes different CLI args than the interactive installer. Exclude it.
            $Asset = $LatestRelease.assets | Where-Object { $_.Name -like "*$AssetArchitecture*" -and $_.Name -like '*.exe' -and $_.Name -notlike '*.sfx.exe' }
            if (-not $Asset) {
                throw "No installer asset found for architecture '$AssetArchitecture' in release '$($LatestRelease.tag_name)'."
            }
            if (@($Asset).Count -gt 1) {
                throw "Multiple candidate installer assets found for architecture '$AssetArchitecture' in release '$($LatestRelease.tag_name)': $(($Asset.Name) -join ', ')."
            }
            $DownloadUri = $Asset.browser_download_url
            $SavePath = [IO.Path]::Combine($env:TEMP, [IO.Path]::GetFileName(([Uri]$DownloadUri).AbsolutePath))

            Write-Status 'Downloading {name} version {version} from {url} to {path}' @{ name = 'MSYS2'; version = $LatestVersion; url = $DownloadUri; path = $SavePath }
            Invoke-FileDownload -Uri $DownloadUri -Destination $SavePath -HttpClient $HttpClient

            $Signature = Get-AuthenticodeSignature -FilePath $SavePath
            if ($Signature.Status -ne 'Valid') {
                throw "The downloaded installer at '$SavePath' failed Authenticode signature validation with status '$($Signature.Status)'."
            }

            # We only get here when bash.exe is missing, so any existing $InstallPath is a stale/partial
            # install (e.g. left over from a prior failed run) — wipe it so the installer sees a clean target.
            if ([IO.Directory]::Exists($InstallPath)) {
                Write-Status 'Removing stale install at {path}' @{ path = $InstallPath }
                Remove-Item -LiteralPath $InstallPath -Recurse -Force
            }

            Write-Status 'Installing {name} version {version} to {path}' @{ name = 'MSYS2'; version = $LatestVersion; path = $InstallPath }
            $InstallerArgs = @('in', '--confirm-command', '--accept-messages', '--root', """$($InstallPath -replace '\\', '/')""") -join ' '
            $StartInfo = [Diagnostics.ProcessStartInfo]::new($SavePath, $InstallerArgs)
            $StartInfo.UseShellExecute = $false
            $Process = [Diagnostics.Process]::Start($StartInfo)
            $Process.WaitForExit()
            if ($Process.ExitCode -ne 0) {
                throw "MSYS2 installation failed with exit code '$($Process.ExitCode)'."
            }

            Remove-Item -Path $SavePath -Force -ErrorAction SilentlyContinue
        }
    } finally {
        $HttpClient.Dispose()
    }

    if (-not [IO.File]::Exists($Bash)) {
        throw "Unable to find '$Bash'."
    }

    Write-Status 'Checking {name} for updates' @{ name = 'MSYS2' }
    & $Bash -lc 'pacman --noconfirm -Sy'
    if ($LASTEXITCODE -ne 0) {
        throw 'Unable to update the MSYS2 package databases.'
    }

    # pacman -Qu returning no output means nothing to update; don't trust its exit code for that check.
    $Updates = @(& $Bash -lc 'pacman -Qu 2>/dev/null || true')

    if ($Updates.Count -gt 0) {
        Write-Status 'Updating {name} to the latest version' @{ name = 'MSYS2' }
        1..2 | ForEach-Object {
            & $Bash -lc 'pacman --noconfirm -Syu'
            if ($LASTEXITCODE -ne 0) {
                throw "MSYS2 update failed with exit code '$LASTEXITCODE'."
            }
        }
    } else {
        Write-Status '{name} is already up to date' @{ name = 'MSYS2' }
    }

    $ToolchainList = $ToolchainPackages -join ', '
    Write-Status 'Ensuring all required toolchain packages are installed: {list}' @{ list = $ToolchainList }
    & $Bash -lc "pacman -S --needed --noconfirm $($ToolchainPackages -join ' ')"
    if ($LASTEXITCODE -ne 0) {
        throw "Toolchain installation failed with exit code '$LASTEXITCODE'."
    }

    # Add the native MSYS2 environment to the USER PATH if it isn't already there.
    $OldPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $PathEntries = @(($OldPath -split ';') | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim().TrimEnd('\') })

    if ($PathEntries -notcontains $EnvironmentPath.TrimEnd('\')) {
        Write-Status 'Adding {name} from {path} to {dest}' @{ name = 'MSYS2'; path = $EnvironmentPath; dest = 'PATH' }
        $NewPath = if ($OldPath) {
            "$($OldPath.TrimEnd(';'));$EnvironmentPath"
        } else {
            $EnvironmentPath
        }
        [Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
    }

    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')

    $GccPath = [IO.Path]::Combine($EnvironmentPath, 'gcc.exe')
    if (-not [IO.File]::Exists($GccPath)) {
        throw "Unable to find '$GccPath' after installation."
    }
} catch {
    Write-Error $_
    exit 1
}
