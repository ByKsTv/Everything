$TaskName = 'Iriun Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Iriun/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Installs or updates Iriun Webcam to the latest version available from iriun.com.
.DESCRIPTION
    Reads the installed version (if any) from uninstall.exe, compares it
    against the version currently advertised on the Iriun homepage, and — if
    newer — downloads, signature-verifies, and silently installs the update.
    All console output plus detailed failure diagnostics are appended to a
    persistent log file in %TEMP% so repeated runs can be debugged.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Configuration
$AppName = 'Iriun'
$BaseUri = [Uri]'https://iriun.com/'
$BufferSize = 81920                      # 80 KB read/write chunk size for streaming the download
$HttpTimeoutSeconds = 30
$MaxRetries = 3                          # for both the version check and the download

$programFilesX86 = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86)
if (-not $programFilesX86) {
    # 32-bit OS has no separate x86 folder
    $programFilesX86 = [Environment]::GetFolderPath([Environment]::ProgramFiles)
}
$UninstallerPath = [IO.Path]::Combine($programFilesX86, 'Iriun Webcam', 'uninstall.exe')

# Log lives in %TEMP%, named after the app so multiple scripts don't collide.
$LogPath = [IO.Path]::Combine($env:TEMP, "$AppName.txt")
#endregion

#region Logging

function Write-Log([string]$Message) {
    <#
    .SYNOPSIS
        Appends a single timestamped line to the persistent log file.
    .DESCRIPTION
        Always appends (never overwrites), so history from previous runs of
        this script is preserved across executions.
    #>
    $timestamp = [datetime]::Now.ToString('dd-MM-yyyy HH:mm:ss.fff')
    [IO.File]::AppendAllText($LogPath, "[$timestamp] $Message`r`n")
}

function Write-Info {
    <#
    .SYNOPSIS
        Writes colored status messages to the console and mirrors them, as plain
        text, to the persistent log file.
    .DESCRIPTION
        Accepts a template with named placeholders like {name}, {version}, etc.
        and a hashtable of values. Static text appears in Green, each role
        gets its own color, and values are automatically wrapped in single quotes.
        The exact same text (minus color) is appended to the log file so the log
        reflects precisely what was printed on-screen.
    #>
    param(
        [Parameter(Mandatory)] [string]$Template,
        [Parameter(Mandatory)] [hashtable]$Values
    )
    $roleColors = @{
        'name'        = 'Yellow'
        'version'     = 'Magenta'
        'url'         = 'Cyan'
        'path'        = 'DarkCyan'
        'arg'         = 'DarkYellow'
        'description' = 'Gray'
        'attempt'     = 'DarkCyan'
        'maxAttempts' = 'DarkCyan'
        'message'     = 'Red'
        'delay'       = 'DarkYellow'
        'subject'     = 'DarkMagenta'
    }
    [Console]::BackgroundColor = 'Black'
    $parts = [regex]::Split($Template, '(\{[\w]+\})')
    $plainLine = [Text.StringBuilder]::new()
    foreach ($part in $parts) {
        if ($part -match '^\{([\w]+)\}$') {
            $role = $Matches[1]
            $value = $Values[$role]
            if ($null -eq $value) {
                $value = ''
            }
            $color = if ($roleColors.ContainsKey($role)) {
                $roleColors[$role]
            } else {
                'Yellow'
            }
            [Console]::ForegroundColor = $color
            [Console]::Write("'$value'")
            $plainLine.Append("'$value'") | Out-Null
        } else {
            [Console]::ForegroundColor = 'Green'
            [Console]::Write($part)
            $plainLine.Append($part) | Out-Null
        }
    }
    [Console]::ResetColor()
    [Console]::WriteLine()
    Write-Log $plainLine.ToString()
}

function Write-LogError {
    <#
    .SYNOPSIS
        Logs full, detailed diagnostics for a caught error — everything needed
        to debug a failure after the fact, not just the message.
    #>
    param([Parameter(Mandatory)] [System.Management.Automation.ErrorRecord]$ErrorRecord)
    Write-Log '=== ERROR ==='
    Write-Log "Message: $($ErrorRecord.Exception.Message)"
    Write-Log "Exception type: $($ErrorRecord.Exception.GetType().FullName)"
    Write-Log "Category: $($ErrorRecord.CategoryInfo.ToString())"
    Write-Log "Position: $($ErrorRecord.InvocationInfo.PositionMessage -replace '\r?\n', ' | ')"
    Write-Log "Script stack trace: $($ErrorRecord.ScriptStackTrace -replace '\r?\n', ' <- ')"
    $inner = $ErrorRecord.Exception.InnerException
    $depth = 1
    while ($inner) {
        Write-Log "Inner exception #${depth}: $($inner.GetType().FullName): $($inner.Message)"
        $inner = $inner.InnerException
        $depth++
    }
    Write-Log '=== END ERROR ==='
}
#endregion

#region Helpers

function Wait-Task {
    param([Parameter(Mandatory)] $Task)
    $Task.GetAwaiter().GetResult()
}

function Invoke-WithRetry {
    param(
        [Parameter(Mandatory)] [scriptblock]$Action,
        [int]$MaxAttempts = 3,
        [string]$Description = 'operation'
    )
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            return & $Action
        } catch {
            Write-LogError $_
            if ($attempt -eq $MaxAttempts) {
                throw
            }
            $delaySeconds = [Math]::Pow(2, $attempt)
            Write-Info '{description} failed on attempt {attempt}/{maxAttempts} ({message}), retrying in {delay}s...' @{
                description = $Description
                attempt     = $attempt
                maxAttempts = $MaxAttempts
                message     = $_.Exception.Message
                delay       = "${delaySeconds}"
            }
            Start-Sleep -Seconds $delaySeconds
        }
    }
}
#endregion

#region Main
Write-Log "===== Run started (PID $PID) ====="
try {
    # Only load the assembly if the type isn't already available.
    if (-not ('System.Net.Http.HttpClient' -as [type])) {
        Add-Type -AssemblyName System.Net.Http
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [Net.DecompressionMethods]::GZip -bor [Net.DecompressionMethods]::Deflate

    $httpClient = [Net.Http.HttpClient]::new($handler)
    $httpClient.Timeout = [TimeSpan]::FromSeconds($HttpTimeoutSeconds)
    $httpClient.DefaultRequestHeaders.UserAgent.ParseAdd('Mozilla/5.0 (Windows NT 10.0; Win64; x64)')

    try {
        # 1. Installed version.
        # NOTE (Iriun-specific): Iriun's installer does not register a Windows
        # "Uninstall" registry entry in HKLM or HKCU (confirmed by testing), so
        # a registry lookup would be dead code for this app — read the version
        # straight off uninstall.exe instead.
        $installedVersion = [version]'0.0'
        if ([IO.File]::Exists($UninstallerPath)) {
            $rawVersion = [Diagnostics.FileVersionInfo]::GetVersionInfo($UninstallerPath).ProductVersion
            $versionMatch = [regex]::Match([string]$rawVersion, '^\d+(\.\d+){1,3}')
            if ($versionMatch.Success) {
                $installedVersion = [version]$versionMatch.Value
            }
        }
        Write-Log "Detected installed version: $installedVersion"

        # 2. Latest version + download URL, from the homepage.
        $release = Invoke-WithRetry -MaxAttempts $MaxRetries -Description 'Checking latest version' -Action {
            $html = Wait-Task $httpClient.GetStringAsync($BaseUri)
            $opts = [Text.RegularExpressions.RegexOptions]::Singleline -bor [Text.RegularExpressions.RegexOptions]::IgnoreCase
            $candidates = [regex]::Matches($html, '<a\b[^>]*href=["'']([^"'']+\.exe)["''][^>]*>(.*?)</a>', $opts)
            if ($candidates.Count -eq 0) {
                throw "No .exe download link found on $BaseUri."
            }

            # Prefer the link labeled "Windows" (e.g. over a VR-specific installer);
            # fall back to the first .exe that isn't the VR build.
            $chosen = $candidates | Where-Object { $_.Groups[2].Value -match 'Windows' } | Select-Object -First 1
            if (-not $chosen) {
                $chosen = $candidates | Where-Object { $_.Groups[1].Value -notmatch 'VR' } | Select-Object -First 1
            }
            if (-not $chosen) {
                throw "Could not identify the Windows .exe download link on $BaseUri."
            }

            $href = $chosen.Groups[1].Value
            $versionMatch = [regex]::Match($href, '[\d.]+(?=\.exe$)')
            if (-not $versionMatch.Success) {
                throw "Could not parse a version number from '$href'."
            }

            [PSCustomObject]@{ Version = [version]$versionMatch.Value; Uri = [Uri]::new($BaseUri, $href) }
        }
        Write-Log "Latest available version: $($release.Version) ($($release.Uri))"

        if ($installedVersion -ge $release.Version) {
            Write-Info '{name} is already up to date ({version})' @{ name = $AppName; version = $installedVersion }
            Write-Log '===== Run finished: already up to date ====='
            exit 0
        }

        $savePath = [IO.Path]::Combine($env:TEMP, [IO.Path]::GetFileName($release.Uri.AbsolutePath))
        Write-Info 'Downloading {name} version {version} from {url} to {path}' @{
            name    = $AppName
            version = $release.Version
            url     = $release.Uri
            path    = $savePath
        }

        # 3. Download, with progress reporting and speed display.
        Invoke-WithRetry -MaxAttempts $MaxRetries -Description 'Downloading installer' -Action {
            if ([IO.File]::Exists($savePath)) {
                [IO.File]::Delete($savePath)
            }

            $totalRead = 0L
            $response = Wait-Task $httpClient.GetAsync($release.Uri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead)
            try {
                $response.EnsureSuccessStatusCode() | Out-Null
                $totalBytes = $response.Content.Headers.ContentLength
                $sourceStream = Wait-Task $response.Content.ReadAsStreamAsync()
                $destStream = [IO.File]::Create($savePath)
                try {
                    $buffer = [byte[]]::new($BufferSize)
                    $lastPercent = -1
                    $lastLoggedDecile = -1
                    $activity = "Downloading $AppName $($release.Version)"
                    $startTime = [datetime]::UtcNow
                    $lastUpdateTime = $startTime

                    while (($bytesRead = $sourceStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                        $destStream.Write($buffer, 0, $bytesRead)
                        $totalRead += $bytesRead

                        $now = [datetime]::UtcNow
                        $elapsed = $now - $startTime
                        $speed = if ($elapsed.TotalSeconds -gt 0) {
                            $totalRead / $elapsed.TotalSeconds
                        } else {
                            0
                        }
                        # Format speed with appropriate units
                        if ($speed -ge 1MB) {
                            $speedStr = '{0:N2} MB/s' -f ($speed / 1MB)
                        } elseif ($speed -ge 1KB) {
                            $speedStr = '{0:N2} KB/s' -f ($speed / 1KB)
                        } else {
                            $speedStr = '{0:N0} B/s' -f $speed
                        }

                        if ($totalBytes) {
                            $percent = [int](($totalRead / $totalBytes) * 100)
                            # Update progress only when percent changes or at least 1 second has passed
                            if ($percent -ne $lastPercent -or ($now - $lastUpdateTime).TotalSeconds -ge 1) {
                                Write-Progress -Activity $activity -Status "$percent% ($totalRead of $totalBytes bytes) at $speedStr" -PercentComplete $percent
                                $lastPercent = $percent
                                $lastUpdateTime = $now
                            }
                            # Log only every 10% so the log file doesn't get spammed.
                            $decile = [Math]::Floor($percent / 10)
                            if ($decile -ne $lastLoggedDecile) {
                                Write-Log "Download progress: $percent% ($totalRead of $totalBytes bytes) at $speedStr"
                                $lastLoggedDecile = $decile
                            }
                        } else {
                            # No Content-Length – update every second
                            if (($now - $lastUpdateTime).TotalSeconds -ge 1) {
                                Write-Progress -Activity $activity -Status "$totalRead bytes downloaded at $speedStr"
                                Write-Log "Download progress: $totalRead bytes downloaded at $speedStr"
                                $lastUpdateTime = $now
                            }
                        }
                    }
                } finally {
                    $destStream.Dispose()
                    $sourceStream.Dispose()
                    Write-Progress -Activity "Downloading $AppName $($release.Version)" -Completed
                }
            } finally {
                $response.Dispose()
            }

            if ($totalRead -eq 0) {
                [IO.File]::Delete($savePath)
                throw "Downloaded file from '$($release.Uri)' is empty."
            }
            Write-Log "Download complete: $totalRead bytes written to $savePath"
        } | Out-Null

        # 4. Signature check — required before running anything elevated.
        $signature = Get-AuthenticodeSignature -LiteralPath $savePath
        if ($signature.Status -ne 'Valid') {
            throw "Signature check failed for '$savePath': $($signature.StatusMessage)"
        }
        Write-Info 'Verified signature ({subject})' @{ subject = $signature.SignerCertificate.Subject }

        # 5. Install.
        Write-Info 'Installing {name} from {path} with {arg}' @{ name = $AppName; path = $savePath; arg = '/S' }
        $process = [Diagnostics.Process]::Start($savePath, '/S')
        $process.WaitForExit()
        Write-Log "Installer exit code: $($process.ExitCode)"
        if ($process.ExitCode -ne 0) {
            throw "Installer exited with code $($process.ExitCode)."
        }

        [IO.File]::Delete($savePath)
        Write-Info '{name} installed successfully ({version})' @{ name = $AppName; version = $release.Version }
        Write-Log '===== Run finished: success ====='
    } finally {
        $httpClient.Dispose()
    }
} catch {
    Write-LogError $_
    Write-Log '===== Run finished: FAILURE ====='
    Write-Error $_
    exit 1
}
#endregion
