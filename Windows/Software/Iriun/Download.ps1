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
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$AppName = 'Iriun'
$BaseUri = [Uri]'https://iriun.com/'
$programFilesX86 = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86)
if (-not $programFilesX86) {
    # 32-bit OS has no separate x86 folder
    $programFilesX86 = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)
}
$UninstallerPath = [IO.Path]::Combine($programFilesX86, 'Iriun Webcam', 'uninstall.exe')

function Write-Info {
    param([Parameter(ValueFromRemainingArguments)] [string[]]$Segments)
    for ($i = 0; $i -lt $Segments.Count; $i++) {
        [Console]::ForegroundColor = if ($i % 2 -eq 0) {
            'Green'
        } else {
            'Yellow'
        }
        [Console]::Write($Segments[$i])
    }
    [Console]::ResetColor()
    [Console]::WriteLine()
}

try {
    Add-Type -AssemblyName System.Net.Http
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $httpClient = [Net.Http.HttpClient]::new()
    $httpClient.Timeout = [TimeSpan]::FromSeconds(30)
    $httpClient.DefaultRequestHeaders.UserAgent.ParseAdd('Mozilla/5.0 (Windows NT 10.0; Win64; x64)')

    try {
        $html = $httpClient.GetStringAsync($BaseUri).GetAwaiter().GetResult()

        $downloadHref = ''
        foreach ($match in [regex]::Matches($html, 'href=["'']([^"'']+\.exe)["'']')) {
            if ($match.Groups[1].Value -notmatch 'VR') {
                $downloadHref = $match.Groups[1].Value
                break
            }
        }
        if (-not $downloadHref) {
            throw "No .exe download link found on $BaseUri."
        }

        $versionText = [regex]::Match($downloadHref, '[\d.]+(?=\.exe$)').Value
        if (-not $versionText) {
            throw "Could not parse a version number from '$downloadHref'."
        }
        [version]$latestVersion = $versionText

        [version]$installedVersion = if ([IO.File]::Exists($UninstallerPath)) {
            [Diagnostics.FileVersionInfo]::GetVersionInfo($UninstallerPath).ProductVersion
        } else {
            '0.0'
        }

        if ($installedVersion -ge $latestVersion) {
            Write-Info "'$AppName'" ' is already up to date ' "('$installedVersion')"
            exit 0
        }

        $downloadUri = [Uri]::new($BaseUri, $downloadHref)
        $savePath = [IO.Path]::Combine($env:TEMP, [IO.Path]::GetFileName($downloadUri.AbsolutePath))

        Write-Info 'Downloading ' "'$AppName'" ' version ' "'$latestVersion'" ' from ' "'$downloadUri'" ' to ' "'$savePath'"

        # Stream the download with ResponseHeadersRead so we get a response as soon as
        # headers arrive, then copy chunk-by-chunk so we can report progress. Using
        # GetByteArrayAsync (as before) buffers the entire file in memory with no
        # opportunity to report interim progress.
        $response = $httpClient.GetAsync($downloadUri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        try {
            $response.EnsureSuccessStatusCode() | Out-Null

            $totalBytes = $response.Content.Headers.ContentLength
            $sourceStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
            $destStream = [IO.File]::Create($savePath)
            try {
                $buffer = [byte[]]::new(81920)
                $totalRead = 0L
                $lastPercent = -1
                while (($bytesRead = $sourceStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                    $destStream.Write($buffer, 0, $bytesRead)
                    $totalRead += $bytesRead

                    if ($totalBytes) {
                        $percent = [int](($totalRead / $totalBytes) * 100)
                        if ($percent -ne $lastPercent) {
                            Write-Progress -Activity "Downloading $AppName $latestVersion" `
                                -Status "$percent% ($totalRead of $totalBytes bytes)" `
                                -PercentComplete $percent
                            $lastPercent = $percent
                        }
                    } else {
                        # Server didn't return Content-Length (e.g. chunked encoding) —
                        # fall back to an indeterminate byte-count status.
                        Write-Progress -Activity "Downloading $AppName $latestVersion" `
                            -Status "$totalRead bytes downloaded"
                    }
                }
            } finally {
                $destStream.Dispose()
                $sourceStream.Dispose()
                Write-Progress -Activity "Downloading $AppName $latestVersion" -Completed
            }
        } finally {
            $response.Dispose()
        }

        if ($totalRead -eq 0) {
            throw "Downloaded file from '$downloadUri' is empty."
        }

        $installArgs = '/S'
        Write-Info 'Installing ' "'$AppName'" ' from ' "'$savePath'" ' with ' "'$installArgs'"
        $process = [Diagnostics.Process]::Start($savePath, $installArgs)
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            throw "Installer exited with code $($process.ExitCode)."
        }
        [IO.File]::Delete($savePath)
        Write-Info "'$AppName'" ' installed successfully ' "('$latestVersion')"
    } finally {
        $httpClient.Dispose()
    }
} catch {
    Write-Error $_
    exit 1
}
