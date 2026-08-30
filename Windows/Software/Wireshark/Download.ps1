$TaskName = 'Wireshark Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Wireshark/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Ensure TLS 1.2 is enabled (important for older .NET Framework)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Load System.Net.Http if not already present (PowerShell 5.1 doesn't load it by default)
if (-not ([System.Net.Http.HttpClient] -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}

#region Configuration
$WiresharkPageUrl = 'https://www.wireshark.org/download.html'
$UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
$TimeoutSeconds = 30
$DownloadChunkSize = 80 * 1024  # 80 KB
#endregion

#region Helpers
function Write-Status {
    <#
    .SYNOPSIS
        Writes a colored status message with named placeholders.
        The second parameter is optional; if omitted, an empty hashtable is used.
    .EXAMPLE
        Write-Status 'Downloading {name} from {url} to {path}' @{ name='Wireshark'; url=$url; path=$savePath }
    .EXAMPLE
        Write-Status 'Installation completed successfully.'
    #>
    param(
        [string]$Template,
        [hashtable]$Values = @{}
    )

    $roleColors = @{
        name    = [ConsoleColor]::Yellow
        version = [ConsoleColor]::Magenta
        url     = [ConsoleColor]::Cyan
        path    = [ConsoleColor]::DarkCyan
        status  = [ConsoleColor]::Green
    }
    $literalColor = [ConsoleColor]::Green
    $bgColor = [ConsoleColor]::Black

    $pattern = '\{(?<role>\w+)\}'
    $lastIndex = 0
    $outputSegments = [System.Collections.Generic.List[object]]::new()

    foreach ($match in [regex]::Matches($Template, $pattern)) {
        $literal = $Template.Substring($lastIndex, $match.Index - $lastIndex)
        if ($literal) {
            $outputSegments.Add(@{ Text = $literal; Color = $literalColor })
        }

        $role = $match.Groups['role'].Value
        if (-not $Values.ContainsKey($role)) {
            throw "Missing value for placeholder '{'$role'}' in template: $Template"
        }
        $value = $Values[$role]
        $color = if ($roleColors.ContainsKey($role)) {
            $roleColors[$role]
        } else {
            $literalColor
        }

        $display = "'$value'"
        $outputSegments.Add(@{ Text = $display; Color = $color })

        $lastIndex = $match.Index + $match.Length
    }

    $remaining = $Template.Substring($lastIndex)
    if ($remaining) {
        $outputSegments.Add(@{ Text = $remaining; Color = $literalColor })
    }

    $originalBg = [Console]::BackgroundColor
    $originalFg = [Console]::ForegroundColor
    try {
        [Console]::BackgroundColor = $bgColor
        foreach ($seg in $outputSegments) {
            [Console]::ForegroundColor = $seg.Color
            [Console]::Write($seg.Text)
        }
        [Console]::ResetColor()
        [Console]::WriteLine()
    } finally {
        [Console]::BackgroundColor = $originalBg
        [Console]::ForegroundColor = $originalFg
    }
}

function Get-DownloadLink {
    param([string]$PageUrl)

    Write-Status 'Fetching page {url}' @{ url = $PageUrl }

    $html = $null
    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [System.Net.DecompressionMethods]::GZip -bor [System.Net.DecompressionMethods]::Deflate
    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.DefaultRequestHeaders.UserAgent.ParseAdd($UserAgent)
    $client.Timeout = [TimeSpan]::FromSeconds($TimeoutSeconds)

    try {
        $response = $client.GetAsync($PageUrl).GetAwaiter().GetResult()
        $response.EnsureSuccessStatusCode() | Out-Null
        $html = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    } finally {
        $client.Dispose()
        $handler.Dispose()
    }

    $pattern = '<a\s+[^>]*href="([^"]*x64\.exe[^"]*)"[^>]*>'
    $linkMatches = [regex]::Matches($html, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    if ($linkMatches.Count -eq 0) {
        throw "No download link containing 'x64.exe' found on $PageUrl"
    }

    $baseUri = [Uri]$PageUrl
    $resolvedUris = $linkMatches | ForEach-Object {
        $href = $_.Groups[1].Value
        try {
            [Uri]::new($baseUri, $href).AbsoluteUri
        } catch {
            Write-Warning "Skipping unresolvable href: $href"
            $null
        }
    } | Where-Object { $_ -ne $null }

    $distinct = $resolvedUris | Select-Object -Unique

    if ($distinct.Count -eq 0) {
        throw 'No valid, resolvable download links found.'
    }

    if ($distinct.Count -eq 1) {
        return $distinct[0]
    }

    Write-Status 'Multiple download links found, selecting latest version.' @{}
    $selectedUri = $null
    $highestVersion = $null
    $versionRegex = '(\d+\.\d+\.\d+)'

    foreach ($uri in $distinct) {
        $fileName = [IO.Path]::GetFileName(([URI]$uri).AbsolutePath)
        $versionMatch = [regex]::Match($fileName, $versionRegex)
        if ($versionMatch.Success) {
            $ver = [version]$versionMatch.Groups[1].Value
            if (-not $highestVersion -or $ver -gt $highestVersion) {
                $highestVersion = $ver
                $selectedUri = $uri
            }
        } else {
            Write-Warning "Could not extract version from '$fileName' - skipping"
        }
    }

    if ($selectedUri) {
        Write-Status 'Selected {url} (version {version})' @{ url = $selectedUri; version = $highestVersion }
        return $selectedUri
    }

    throw "Multiple links found but no version could be extracted from any: $($distinct -join ', ')"
}

function Get-InstalledWiresharkVersion {
    <#
    .SYNOPSIS
        Returns the installed Wireshark version as a [version], or $null if not found.
        Tries registry uninstall keys first, then falls back to the main .exe file version.
    #>
    # Try registry (64-bit and 32-bit hives)
    $uninstallPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Wireshark',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Wireshark'
    )
    $displayVersion = $null
    foreach ($path in $uninstallPaths) {
        if (Test-Path $path) {
            $displayVersion = (Get-ItemProperty -Path $path -Name 'DisplayVersion' -ErrorAction SilentlyContinue).DisplayVersion
            if ($displayVersion) {
                break
            }
        }
    }

    if ($displayVersion) {
        # Extract only the numeric part (e.g., "3.6.8" from "3.6.8 (x64)")
        $numeric = [regex]::Match($displayVersion, '^(\d+\.\d+\.\d+)')
        if ($numeric.Success) {
            return [version]$numeric.Groups[1].Value
        }
        # If regex fails, try direct cast (but be careful)
        try {
            return [version]$displayVersion
        } catch {
            Write-Warning "Could not parse registry DisplayVersion '$displayVersion' as a version."
        }
    }

    # Fallback: check the file version of the main executable
    $possiblePaths = @(
        "${env:ProgramFiles}\Wireshark\wireshark.exe",
        "${env:ProgramFiles(x86)}\Wireshark\wireshark.exe"
    )
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $fileVer = [Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileVersion
            if ($fileVer) {
                return [version]$fileVer
            }
        }
    }

    return $null
}
#endregion

#region Main
try {
    $downloadUrl = Get-DownloadLink -PageUrl $WiresharkPageUrl

    # Extract the latest version from the download URL (same logic as in Get-DownloadLink)
    $fileName = [IO.Path]::GetFileName(([URI]$downloadUrl).AbsolutePath)
    $versionRegex = '(\d+\.\d+\.\d+)'
    $versionMatch = [regex]::Match($fileName, $versionRegex)
    if (-not $versionMatch.Success) {
        throw "Could not extract version from download URL: $downloadUrl"
    }
    $latestVersion = [version]$versionMatch.Groups[1].Value

    Write-Status 'Latest Wireshark version: {version}' @{ version = $latestVersion }

    # Detect installed version
    $installedVersion = Get-InstalledWiresharkVersion
    if ($installedVersion) {
        Write-Status 'Installed Wireshark version: {version}' @{ version = $installedVersion }

        if ($installedVersion -ge $latestVersion) {
            Write-Status 'Already up-to-date. No update required.'   # ASCII hyphen now
            exit 0
        }
        Write-Status 'Installed version is older. Updating...'
    } else {
        Write-Status 'Wireshark is not installed. Proceeding with fresh install.'
    }

    $savePath = [IO.Path]::Combine($env:TEMP, $fileName)

    Write-Status 'Downloading {name} from {url} to {path}' @{
        name = 'Wireshark'
        url  = $downloadUrl
        path = $savePath
    }

    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [System.Net.DecompressionMethods]::GZip -bor [System.Net.DecompressionMethods]::Deflate
    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.DefaultRequestHeaders.UserAgent.ParseAdd($UserAgent)
    $client.Timeout = [TimeSpan]::FromSeconds($TimeoutSeconds)

    try {
        $response = $client.GetAsync($downloadUrl, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        $response.EnsureSuccessStatusCode() | Out-Null

        $contentLength = $response.Content.Headers.ContentLength
        $totalBytes = if ($contentLength -gt 0) {
            $contentLength
        } else {
            $null
        }

        $stream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $fileStream = [System.IO.File]::OpenWrite($savePath)

        try {
            $buffer = [byte[]]::new($DownloadChunkSize)
            $bytesRead = 0
            $totalRead = 0
            $lastPercent = -1
            $speedTimer = [System.Diagnostics.Stopwatch]::StartNew()
            $lastSpeedUpdate = $speedTimer.Elapsed.TotalSeconds
            $bytesSinceLastSpeed = 0

            do {
                $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
                if ($bytesRead -gt 0) {
                    $fileStream.Write($buffer, 0, $bytesRead)
                    $totalRead += $bytesRead
                    $bytesSinceLastSpeed += $bytesRead

                    $now = $speedTimer.Elapsed.TotalSeconds
                    if ($totalBytes) {
                        $percent = [int](($totalRead / $totalBytes) * 100)
                        if ($percent -ne $lastPercent -or ($now - $lastSpeedUpdate) -ge 1) {
                            $elapsedSinceLast = $now - $lastSpeedUpdate
                            if ($elapsedSinceLast -gt 0) {
                                $currentSpeed = $bytesSinceLastSpeed / $elapsedSinceLast
                            } else {
                                $currentSpeed = 0
                            }
                            $speedDisplay = if ($currentSpeed -ge 1e6) {
                                '{0:F2} MB/s' -f ($currentSpeed / 1e6)
                            } elseif ($currentSpeed -ge 1e3) {
                                '{0:F1} KB/s' -f ($currentSpeed / 1e3)
                            } else {
                                '{0:F0} B/s' -f $currentSpeed
                            }
                            $status = "$($totalRead.ToString('N0')) / $(($totalBytes).ToString('N0')) bytes ($speedDisplay)"

                            Write-Progress -Activity 'Downloading Wireshark' -Status $status -PercentComplete $percent
                            $lastPercent = $percent
                            $lastSpeedUpdate = $now
                            $bytesSinceLastSpeed = 0
                        }
                    } else {
                        if (($now - $lastSpeedUpdate) -ge 1) {
                            $status = "$($totalRead.ToString('N0')) bytes"
                            Write-Progress -Activity 'Downloading Wireshark' -Status $status -PercentComplete -1
                            $lastSpeedUpdate = $now
                        }
                    }
                }
            } while ($bytesRead -gt 0)

            Write-Progress -Activity 'Downloading Wireshark' -Completed
        } finally {
            $stream.Dispose()
            $fileStream.Dispose()
        }

        if ((Get-Item $savePath).Length -eq 0) {
            throw "Downloaded file is empty: $savePath"
        }
    } finally {
        $client.Dispose()
        $handler.Dispose()
    }

    # 3. Verify Authenticode signature
    Write-Status 'Verifying digital signature of {name}' @{ name = $fileName }
    $sig = Get-AuthenticodeSignature -FilePath $savePath
    if ($sig.Status -ne 'Valid') {
        throw "Authenticode signature is not valid (Status: $($sig.Status))"
    }
    Write-Status 'Signature verified: {status}' @{ status = $sig.Status }

    # 4. Install silently
    $argument = '/S'
    Write-Status 'Installing {name} from {path} with {args}' @{
        name = $fileName
        path = $savePath
        args = $argument
    }

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $savePath
    $psi.Arguments = $argument
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $false
    $psi.RedirectStandardError = $false

    $process = [System.Diagnostics.Process]::Start($psi)
    $process.WaitForExit()
    $exitCode = $process.ExitCode
    $process.Dispose()

    if ($exitCode -ne 0) {
        throw "Installer exited with code $exitCode"
    }

    Remove-Item -Path $savePath -Force -ErrorAction SilentlyContinue

    Write-Status 'Installation completed successfully.'
    exit 0
} catch {
    Write-Error "Error: $_"
    Write-Progress -Activity 'Downloading Wireshark' -Completed -ErrorAction SilentlyContinue
    exit 1
}
#endregion
