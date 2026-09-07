$TaskName = 'AB Download Manager Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/AB_Download_Manager/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

#Requires -RunAsAdministrator
<#
    Update-ABDownloadManager.ps1

    Installs AB Download Manager if it isn't present, or silently updates it if the
    installed version is older than the latest GitHub release. Picks x64 or arm64
    based on the machine's actual processor architecture.

    Target: amir1376/ab-download-manager (Windows installer is NSIS-based; confirmed
    silent switch is /S). Windows-only, x64/arm64 only (no 32-bit Windows build exists
    for this app, so no fallback is attempted).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Configuration
$AppName = 'AB Download Manager'
$GitHubOwner = 'amir1376'
$GitHubRepo = 'ab-download-manager'
$LogPath = [IO.Path]::Combine($env:TEMP, 'ABDownloadManagerUpdater.txt')
$TimestampFormat = 'dd-MM-yyyy HH:mm:ss.fff'
#endregion

#region Helpers

if (-not ('System.Net.Http.HttpClient' -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}

function Write-Log([string]$Message) {
    $dir = [IO.Path]::GetDirectoryName($LogPath)
    [IO.Directory]::CreateDirectory($dir) | Out-Null
    $line = '[{0}] {1}' -f (Get-Date -Format $TimestampFormat), $Message
    [IO.File]::AppendAllText($LogPath, $line + [Environment]::NewLine)
}

function Write-Status([string]$Template, [hashtable]$Values = @{}) {
    [Console]::BackgroundColor = [ConsoleColor]::Black
    foreach ($part in ($Template -split '(\{[a-zA-Z]+\})')) {
        if ($part -match '^\{([a-zA-Z]+)\}$') {
            $role = $Matches[1]
            $color = switch ($role) {
                'name' {
                    [ConsoleColor]::Yellow
                }
                'version' {
                    [ConsoleColor]::Magenta
                }
                'url' {
                    [ConsoleColor]::Cyan
                }
                'path' {
                    [ConsoleColor]::DarkCyan
                }
                default {
                    [ConsoleColor]::White
                }
            }
            [Console]::ForegroundColor = $color
            [Console]::Write("'{0}'" -f $Values[$role])
        } else {
            [Console]::ForegroundColor = [ConsoleColor]::Green
            [Console]::Write($part)
        }
    }
    [Console]::ResetColor()
    [Console]::WriteLine()
    $logLine = [regex]::Replace($Template, '\{([a-zA-Z]+)\}', { param($m) "'$($Values[$m.Groups[1].Value])'" })
    Write-Log $logLine
}

function Get-InstalledVersion {
    $uninstallRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    foreach ($root in $uninstallRoots) {
        $match = Get-ItemProperty -Path $root -ErrorAction SilentlyContinue |
            Where-Object { $_.PSObject.Properties['DisplayName'] -and $_.DisplayName -eq $AppName } |
            Select-Object -First 1
        if ($match -and $match.DisplayVersion) {
            $versionMatches = [regex]::Match($match.DisplayVersion, '^\d+(\.\d+){1,3}')
            if ($versionMatches.Success) {
                return [version]$versionMatches.Value
            }
        }
    }
    return $null
}

function Get-LatestReleaseTag([Net.Http.HttpClient]$Client) {
    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AllowAutoRedirect = $false
    $redirectClient = [Net.Http.HttpClient]::new($handler)
    try {
        $redirectClient.Timeout = [TimeSpan]::FromSeconds(30)
        $redirectClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-ABDM-Updater')
        $latestUrl = "https://github.com/$GitHubOwner/$GitHubRepo/releases/latest"
        $response = $redirectClient.GetAsync($latestUrl).GetAwaiter().GetResult()
        $location = $response.Headers.Location.ToString()
        $tagMatches = [regex]::Match($location, '/releases/tag/(?<tag>[^/]+)$')
        if (-not $tagMatches.Success) {
            throw "Could not parse a release tag from redirect location: '$location'"
        }
        return $tagMatches.Groups['tag'].Value
    } finally {
        $redirectClient.Dispose()
    }
}

function Get-ReleaseAssetUri([Net.Http.HttpClient]$Client, [string]$Tag, [string]$FileName) {
    $expandedUrl = "https://github.com/$GitHubOwner/$GitHubRepo/releases/expanded_assets/$Tag"
    $html = $Client.GetStringAsync($expandedUrl).GetAwaiter().GetResult()

    $pattern = 'href="(?<href>[^"]*/' + [regex]::Escape($FileName) + ')"'
    $assetMatches = [regex]::Matches($html, $pattern)

    $resolvedUris = @($assetMatches | ForEach-Object {
            [Uri]::new([Uri]'https://github.com/', $_.Groups['href'].Value).AbsoluteUri
        } | Select-Object -Unique)

    if ($resolvedUris.Count -eq 0) {
        throw "No matching asset found for '$FileName' in release '$Tag'."
    }
    if ($resolvedUris.Count -gt 1) {
        throw "Multiple distinct assets matched '$FileName' in release '$Tag' - refusing to guess."
    }
    return $resolvedUris[0]
}

function Invoke-FileDownload([Net.Http.HttpClient]$Client, [string]$Uri, [string]$Destination) {
    $response = $Client.GetAsync($Uri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
    $response.EnsureSuccessStatusCode() | Out-Null

    $totalBytes = $response.Content.Headers.ContentLength
    $buffer = New-Object byte[] 81920
    $bytesRead = 0L
    $lastPercent = -1
    $lastUpdate = Get-Date
    $sw = [Diagnostics.Stopwatch]::StartNew()

    $sourceStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
    $destStream = [IO.File]::Create($Destination)
    try {
        while ($true) {
            $read = $sourceStream.Read($buffer, 0, $buffer.Length)
            if ($read -le 0) {
                break
            }
            $destStream.Write($buffer, 0, $read)
            $bytesRead += $read

            $now = Get-Date
            if (($now - $lastUpdate).TotalSeconds -ge 1) {
                $speed = $bytesRead / [Math]::Max($sw.Elapsed.TotalSeconds, 0.001)
                $speedText = if ($speed -ge 1MB) {
                    '{0:N1} MB/s' -f ($speed / 1MB)
                } elseif ($speed -ge 1KB) {
                    '{0:N1} KB/s' -f ($speed / 1KB)
                } else {
                    '{0:N0} B/s' -f $speed
                }

                if ($totalBytes) {
                    $percent = [int](($bytesRead / $totalBytes) * 100)
                    if ($percent -ne $lastPercent) {
                        Write-Progress -Activity "Downloading $AppName" -Status "$percent% - $speedText" -PercentComplete $percent
                        $lastPercent = $percent
                        if ($percent % 10 -eq 0) {
                            Write-Log "Download progress: $percent% ($speedText)"
                        }
                    }
                } else {
                    Write-Progress -Activity "Downloading $AppName" -Status "$bytesRead bytes - $speedText"
                }
                $lastUpdate = $now
            }
        }
    } finally {
        $destStream.Dispose()
        $sourceStream.Dispose()
        Write-Progress -Activity "Downloading $AppName" -Completed
    }

    if ($bytesRead -le 0) {
        throw "Downloaded file '$Destination' is empty."
    }
}

#endregion

#region Main

[IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($LogPath)) | Out-Null

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
        'arm64'
    } else {
        'x64'
    }
    Write-Status 'Detected architecture: {version}' @{ version = $arch }

    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [Net.DecompressionMethods]::GZip -bor [Net.DecompressionMethods]::Deflate
    $httpClient = [Net.Http.HttpClient]::new($handler)
    $httpClient.Timeout = [TimeSpan]::FromSeconds(30)
    $httpClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-ABDM-Updater')

    try {
        $tag = Get-LatestReleaseTag -Client $httpClient
        $latestVersionMatches = [regex]::Match($tag, '\d+(\.\d+){1,3}')
        if (-not $latestVersionMatches.Success) {
            throw "Could not extract a version number from tag '$tag'."
        }
        $latestVersion = [version]$latestVersionMatches.Value
        Write-Status 'Latest available version: {version}' @{ version = $latestVersion }

        $installedVersion = Get-InstalledVersion
        if ($installedVersion) {
            Write-Status 'Currently installed version: {version}' @{ version = $installedVersion }
        } else {
            Write-Status '{name} is not currently installed.' @{ name = $AppName }
        }

        if ($installedVersion -and $installedVersion -ge $latestVersion) {
            Write-Status 'Already up to date at version {version} - nothing to do.' @{ version = $installedVersion }
            return
        }

        $versionString = $tag.TrimStart('v')
        $fileName = "ABDownloadManager_${versionString}_windows_${arch}.exe"
        $assetUri = Get-ReleaseAssetUri -Client $httpClient -Tag $tag -FileName $fileName
        Write-Status 'Resolved installer asset: {url}' @{ url = $assetUri }

        $installerPath = [IO.Path]::Combine($env:TEMP, $fileName)
        Write-Status 'Downloading to {path}' @{ path = $installerPath }
        Invoke-FileDownload -Client $httpClient -Uri $assetUri -Destination $installerPath

        Write-Status 'Installing {name} silently...' @{ name = $AppName }
        $psi = [Diagnostics.ProcessStartInfo]::new($installerPath, '/S')
        $psi.UseShellExecute = $false
        $process = [Diagnostics.Process]::Start($psi)
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            throw "Installer exited with code $($process.ExitCode)."
        }

        [IO.File]::Delete($installerPath)
        $action = if ($installedVersion) {
            'updated'
        } else {
            'installed'
        }
        Write-Status "{name} successfully $action to version {version}." @{ name = $AppName; version = $latestVersion }
    } finally {
        $httpClient.Dispose()
    }
} catch {
    Write-Log "ERROR: $($_.Exception.GetType().Name): $($_.Exception.Message)"
    Write-Log "Category: $($_.CategoryInfo.Category)"
    Write-Log "Position: $($_.InvocationInfo.PositionMessage)"
    Write-Log "StackTrace: $($_.ScriptStackTrace)"
    $inner = $_.Exception.InnerException
    while ($inner) {
        Write-Log "InnerException: $($inner.GetType().Name): $($inner.Message)"
        $inner = $inner.InnerException
    }
    Write-Error $_
    exit 1
}

#endregion
