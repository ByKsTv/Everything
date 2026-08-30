$TaskName = 'MKVToolNix Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MKVToolNix/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

#Requires -RunAsAdministrator

#region Setup
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$AppName = 'MKVToolNix'
$InstallDir = [IO.Path]::Combine(${env:ProgramFiles}, 'MKVToolNix')
$LogFile = [IO.Path]::Combine($env:TEMP, "$AppName.txt")
$DownloadsPageUrl = 'https://mkvtoolnix.download/downloads.html'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Console]::BackgroundColor = 'Black'

if (-not ('System.Net.Http.HttpClient' -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}
#endregion

#region Helpers
function Write-Log([string]$Text) {
    [IO.Directory]::CreateDirectory($env:TEMP) | Out-Null
    $timestamp = Get-Date -Format 'dd-MM-yyyy HH:mm:ss.fff'
    [IO.File]::AppendAllText($LogFile, "[$timestamp] $Text`r`n")
}

function Write-Status([string]$Template, [hashtable]$Values = @{}) {
    $segments = @()
    $currentIndex = 0
    $regex = [regex]::new('\{([^}]+)\}')
    $placeholderMatches = $regex.Matches($Template)

    if ($placeholderMatches.Count -eq 0) {
        Write-Host $Template -ForegroundColor Green
        Write-Log $Template
        return
    }

    foreach ($match in $placeholderMatches) {
        $literal = $Template.Substring($currentIndex, $match.Index - $currentIndex)
        if ($literal) {
            $segments += @{ Text = $literal; Color = 'Green' }
        }

        $key = $match.Groups[1].Value
        $value = if ($Values.ContainsKey($key)) {
            $Values[$key]
        } else {
            ''
        }
        $color = switch ($key) {
            'name' {
                'Yellow'
            }
            'version' {
                'Magenta'
            }
            'url' {
                'Cyan'
            }
            'path' {
                'DarkCyan'
            }
            default {
                'White'
            }
        }
        $displayValue = "'$value'"
        $segments += @{ Text = $displayValue; Color = $color }

        $currentIndex = $match.Index + $match.Length
    }

    if ($currentIndex -lt $Template.Length) {
        $literal = $Template.Substring($currentIndex)
        if ($literal) {
            $segments += @{ Text = $literal; Color = 'Green' }
        }
    }

    foreach ($seg in $segments) {
        Write-Host $seg.Text -ForegroundColor $seg.Color -NoNewline
    }
    Write-Host ''

    $rendered = $Template
    foreach ($key in $Values.Keys) {
        $rendered = $rendered -replace "\{$key\}", "'$($Values[$key])'"
    }
    Write-Log $rendered
}

function Get-LatestReleaseInfo {
    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [Net.DecompressionMethods]::GZip -bor [Net.DecompressionMethods]::Deflate
    $client = [Net.Http.HttpClient]::new($handler)
    $client.Timeout = [TimeSpan]::FromSeconds(30)

    try {
        $client.DefaultRequestHeaders.UserAgent.ParseAdd('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
        $html = $client.GetStringAsync($DownloadsPageUrl).GetAwaiter().GetResult()

        # Extract all version-like numbers (X.Y or X.Y.Z) and pick the highest >= 10.0
        $versionMatches = [regex]::Matches($html, '\b(\d+\.\d+(?:\.\d+)?)\b')
        $allVersions = $versionMatches | ForEach-Object { $_.Groups[1].Value }
        $validVersions = $allVersions | Where-Object { [version]$_ -ge [version]'10.0' }
        if (-not $validVersions) {
            throw "Could not find any version number >= 10.0 on $DownloadsPageUrl."
        }
        $latestVersion = $validVersions | Sort-Object { [version]$_ } -Descending | Select-Object -First 1

        $installerUrl = "https://mkvtoolnix.download/windows/releases/$latestVersion/mkvtoolnix-64-bit-$latestVersion-setup.exe"
        return [pscustomobject]@{
            Version      = $latestVersion
            InstallerUrl = $installerUrl
        }
    } finally {
        $client.Dispose()
    }
}

function Get-ExpectedSha256([string]$Version, [string]$InstallerFileName) {
    $handler = [Net.Http.HttpClientHandler]::new()
    $client = [Net.Http.HttpClient]::new($handler)

    try {
        $client.DefaultRequestHeaders.UserAgent.ParseAdd('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
        $sumsUrl = "https://mkvtoolnix.download/windows/releases/$Version/sha256sums.txt"
        $sumsText = $client.GetStringAsync($sumsUrl).GetAwaiter().GetResult()

        $lineMatch = [regex]::Match($sumsText, '(?<hash>[0-9a-fA-F]{64})\s+\*?' + [regex]::Escape($InstallerFileName))
        if (-not $lineMatch.Success) {
            throw "Could not find a SHA-256 entry for '$InstallerFileName' in $sumsUrl."
        }
        return $lineMatch.Groups['hash'].Value.ToLowerInvariant()
    } finally {
        $client.Dispose()
    }
}

function Get-InstalledVersion {
    $exePath = [IO.Path]::Combine($InstallDir, 'mkvmerge.exe')
    if (-not ([IO.File]::Exists($exePath))) {
        return $null
    }
    $versionInfo = [Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)
    $versionMatch = [regex]::Match($versionInfo.ProductVersion, '^\d+(\.\d+){1,3}')
    if (-not $versionMatch.Success) {
        return $null
    }
    return [version]$versionMatch.Value
}

function Save-Installer([string]$Url, [string]$Destination) {
    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [Net.DecompressionMethods]::GZip -bor [Net.DecompressionMethods]::Deflate
    $client = [Net.Http.HttpClient]::new($handler)
    $client.Timeout = [TimeSpan]::FromSeconds(120)

    try {
        $client.DefaultRequestHeaders.UserAgent.ParseAdd('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
        $response = $client.GetAsync($Url, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        $response.EnsureSuccessStatusCode() | Out-Null
        $totalBytes = $response.Content.Headers.ContentLength

        $sourceStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $fileStream = [IO.File]::Create($Destination)
        $buffer = New-Object byte[] 81920
        $bytesRead = 0
        $totalRead = 0
        $lastPercent = -1
        $startTime = Get-Date

        try {
            while (($bytesRead = $sourceStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $fileStream.Write($buffer, 0, $bytesRead)
                $totalRead += $bytesRead

                $elapsed = [Math]::Max(((Get-Date) - $startTime).TotalSeconds, 0.001)
                $speed = $totalRead / $elapsed
                $speedText = if ($speed -ge 1MB) {
                    '{0:N2} MB/s' -f ($speed / 1MB)
                } elseif ($speed -ge 1KB) {
                    '{0:N2} KB/s' -f ($speed / 1KB)
                } else {
                    '{0:N0} B/s' -f $speed
                }

                if ($totalBytes) {
                    $percent = [int](($totalRead / $totalBytes) * 100)
                    if ($percent -ne $lastPercent) {
                        Write-Progress -Activity "Downloading $AppName" -Status "$percent% complete - $speedText" -PercentComplete $percent
                        $lastPercent = $percent
                    }
                } else {
                    Write-Progress -Activity "Downloading $AppName" -Status "$totalRead bytes - $speedText"
                }
            }
        } finally {
            Write-Progress -Activity "Downloading $AppName" -Completed
            $fileStream.Dispose()
            $sourceStream.Dispose()
        }

        if ($totalRead -le 0) {
            throw "Downloaded file '$Destination' is empty."
        }
    } finally {
        $client.Dispose()
    }
}

function Add-ToPath([string]$Directory) {
    $currentPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $pathEntries = @($currentPath -split ';' | Where-Object { $_ -ne '' })
    if ($pathEntries -contains $Directory) {
        Write-Status 'PATH already contains {path}' @{ path = $Directory }
        return
    }
    $newPath = ($pathEntries + $Directory) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')
    $env:Path = "$env:Path;$Directory"
    Write-Status 'Added {path} to system PATH' @{ path = $Directory }
}
#endregion

#region Main
try {
    Write-Status 'Checking installed {name} version' @{ name = $AppName }
    $installedVersion = Get-InstalledVersion

    if ($installedVersion) {
        Write-Status 'Found installed version {version}' @{ version = $installedVersion.ToString() }
    } else {
        Write-Status '{name} not currently installed' @{ name = $AppName }
    }

    Write-Status 'Checking official downloads page for the latest version'
    $releaseInfo = Get-LatestReleaseInfo

    $latestVersionMatch = [regex]::Match($releaseInfo.Version, '^\d+(\.\d+){1,3}')
    if (-not $latestVersionMatch.Success) {
        throw "Could not parse a version number from '$($releaseInfo.Version)'."
    }
    $latestVersion = [version]$latestVersionMatch.Value
    Write-Status 'Latest available version is {version}' @{ version = $latestVersion.ToString() }

    if ($installedVersion -and $installedVersion -ge $latestVersion) {
        Write-Status '{name} is already up to date' @{ name = $AppName }
        Add-ToPath $InstallDir
        exit 0
    }

    $installerUrl = $releaseInfo.InstallerUrl
    Write-Status 'Installer URL: {url}' @{ url = $installerUrl }

    $installerFileName = [Uri]::new($installerUrl).Segments[-1]
    $installerPath = [IO.Path]::Combine($env:TEMP, $installerFileName)

    Write-Status 'Downloading {name} {version}' @{ name = $AppName; version = $latestVersion.ToString() }
    Save-Installer $installerUrl $installerPath

    Write-Status 'Verifying SHA-256 checksum'
    $expectedHash = Get-ExpectedSha256 $releaseInfo.Version $installerFileName
    $actualHash = (Get-FileHash -Path $installerPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        throw "SHA-256 mismatch for '$installerFileName'. Expected $expectedHash, got $actualHash."
    }
    Write-Status 'Checksum verified: match'

    Write-Status 'Verifying installer signature'
    $signature = Get-AuthenticodeSignature -FilePath $installerPath
    if ($signature.Status -ne 'Valid') {
        throw "Installer signature is not valid (status: $($signature.Status)). Aborting."
    }
    Write-Status 'Signature verified: Valid'

    if ([IO.Directory]::Exists($InstallDir) -and -not $installedVersion) {
        Write-Status 'Removing stale install directory {path}' @{ path = $InstallDir }
        Remove-Item -Path $InstallDir -Recurse -Force
    }

    Write-Status 'Running installer silently'
    $startInfo = [Diagnostics.ProcessStartInfo]::new($installerPath)
    $startInfo.Arguments = "/S /D=$InstallDir"
    $startInfo.UseShellExecute = $false
    $process = [Diagnostics.Process]::Start($startInfo)
    $process.WaitForExit()

    if ($process.ExitCode -ne 0) {
        throw "Installer exited with code $($process.ExitCode)."
    }

    $newVersion = Get-InstalledVersion
    if (-not $newVersion) {
        throw "Installation did not produce a detectable mkvmerge.exe in $InstallDir."
    }
    Write-Status 'Installed {name} {version}' @{ name = $AppName; version = $newVersion.ToString() }

    Remove-Item -Path $installerPath -Force

    Add-ToPath $InstallDir

    Write-Status '{name} update complete' @{ name = $AppName }
    exit 0
} catch {
    Write-Log "ERROR: $($_.Exception.GetType().FullName): $($_.Exception.Message)"
    Write-Log "Category: $($_.CategoryInfo.Category)"
    Write-Log "Position: $($_.InvocationInfo.PositionMessage)"
    Write-Log "ScriptStackTrace: $($_.ScriptStackTrace)"
    $inner = $_.Exception.InnerException
    while ($inner) {
        Write-Log "InnerException: $($inner.GetType().FullName): $($inner.Message)"
        $inner = $inner.InnerException
    }
    Write-Error $_
    exit 1
}
#endregion
