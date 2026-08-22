$TaskName = 'MSYS2 Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MSYS2/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$ErrorActionPreference = 'Stop'

$InstallPath = "$env:SystemDrive\msys64"
$Bash = [IO.Path]::Combine($InstallPath, 'usr', 'bin', 'bash.exe')

if ($env:PROCESSOR_ARCHITEW6432) {
    $Architecture = $env:PROCESSOR_ARCHITEW6432
} else {
    $Architecture = $env:PROCESSOR_ARCHITECTURE
}

switch ($Architecture.ToUpperInvariant()) {
    'AMD64' {
        $AssetArchitecture = 'x86_64'
        $EnvironmentPath = [IO.Path]::Combine($InstallPath, 'ucrt64', 'bin')
        $ToolchainPackages = @('base-devel', 'mingw-w64-ucrt-x86_64-toolchain')
    }

    'ARM64' {
        $AssetArchitecture = 'arm64'
        $EnvironmentPath = [IO.Path]::Combine($InstallPath, 'clangarm64', 'bin')

        # CLANGARM64 is a Clang/LLVM environment, not GCC: GCC has no aarch64-w64-mingw32
        # backend, so the mingw-w64-clang-aarch64-toolchain group provides clang instead.
        # gcc-compat adds 'gcc'/'g++' shims on top of clang for tooling that looks for gcc
        # by name.
        $ToolchainPackages = @('base-devel', 'mingw-w64-clang-aarch64-toolchain', 'mingw-w64-clang-aarch64-gcc-compat')
    }

    default {
        throw "Unsupported Windows architecture: '$Architecture'."
    }
}

# Install MSYS2 only if it does not already exist.
if (-not (Test-Path $Bash)) {
    $GitHubReleases = Invoke-RestMethod -Uri 'https://api.github.com/repos/msys2/msys2-installer/releases?per_page=100'

    $GitHub = $GitHubReleases |
        Where-Object {
            (-not $_.draft) -and
            (-not $_.prerelease) -and
            ($_.tag_name -match '^\d{4}-\d{2}-\d{2}$')
        } |
        Sort-Object -Property tag_name -Descending |
        Select-Object -First 1

    $LatestVersion = $GitHub.tag_name -replace '-', ''

    $AssetName = "msys2-$AssetArchitecture-$LatestVersion.exe"
    $DDL = (($GitHub).assets | Where-Object { $_.Name -eq $AssetName }).browser_download_url

    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()

    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $InstallerRoot = $InstallPath -replace '\\', '/'

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InstallPath'"); [Console]::ResetColor(); [Console]::WriteLine()

    $Process = Start-Process -FilePath $SavePath -ArgumentList @(
        'in',
        '--confirm-command',
        '--accept-messages',
        '--root',
        $InstallerRoot
    ) -Wait -PassThru

    if ($Process.ExitCode -ne 0) {
        throw "MSYS2 installation failed with exit code '$($Process.ExitCode)'."
    }

    Remove-Item -Path $SavePath -Force -ErrorAction SilentlyContinue
}

if (-not (Test-Path $Bash)) {
    throw "Unable to find '$Bash'."
}

# Check MSYS2 for updates.
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Checking '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' for updates'); [Console]::ResetColor(); [Console]::WriteLine()

& $Bash -lc 'pacman --noconfirm -Sy'

if ($LASTEXITCODE -ne 0) {
    throw 'Unable to update the MSYS2 package databases.'
}

# pacman -Qu returning no output means there is nothing to update.
# Do not use its exit code to determine whether the check succeeded.
$Updates = @(
    & $Bash -lc 'pacman -Qu 2>/dev/null || true'
)

if ($Updates.Count -gt 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to the latest version'); [Console]::ResetColor(); [Console]::WriteLine()

    & $Bash -lc 'pacman --noconfirm -Syu'

    if ($LASTEXITCODE -ne 0) {
        throw "MSYS2 update failed with exit code '$LASTEXITCODE'."
    }

    & $Bash -lc 'pacman --noconfirm -Syu'

    if ($LASTEXITCODE -ne 0) {
        throw "MSYS2 update failed with exit code '$LASTEXITCODE'."
    }
} else {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' is already up to date'); [Console]::ResetColor(); [Console]::WriteLine()
}

# Install the compiler toolchain (gcc, make, etc.) if it is not already present.
# A base MSYS2 install only provides bash/pacman/core tools - it does not include a
# compiler, which is why 'gcc --version' fails until these packages are installed.
$GccPath = [IO.Path]::Combine($EnvironmentPath, 'gcc.exe')

if (-not (Test-Path $GccPath)) {
    $ToolchainList = $ToolchainPackages -join ', '

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ToolchainList'"); [Console]::ResetColor(); [Console]::WriteLine()

    & $Bash -lc "pacman -S --needed --noconfirm $($ToolchainPackages -join ' ')"

    if ($LASTEXITCODE -ne 0) {
        throw "Toolchain installation failed with exit code '$LASTEXITCODE'."
    }
} else {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("'gcc'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' is already installed'); [Console]::ResetColor(); [Console]::WriteLine()
}

# Add the native MSYS2 environment to the USER PATH.
$OLD_PATH = [Environment]::GetEnvironmentVariable(
    'Path',
    [EnvironmentVariableTarget]::User
)

if ([string]::IsNullOrWhiteSpace($OLD_PATH)) {
    $PathEntries = @()
} else {
    $PathEntries = $OLD_PATH.Split(';') |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { $_.Trim().TrimEnd('\') }
}

if ($PathEntries -notcontains $EnvironmentPath.TrimEnd('\')) {
    if ([string]::IsNullOrWhiteSpace($OLD_PATH)) {
        $NEW_PATH = $EnvironmentPath
    } else {
        $NEW_PATH = "$($OLD_PATH.TrimEnd(';'));$EnvironmentPath"
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MSYS2'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$EnvironmentPath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()

    [Environment]::SetEnvironmentVariable(
        'Path',
        $NEW_PATH,
        [EnvironmentVariableTarget]::User
    )
}

# Refresh PATH in the current PowerShell session.
$env:Path =
[Environment]::GetEnvironmentVariable(
    'Path',
    [EnvironmentVariableTarget]::Machine
) +
';' +
[Environment]::GetEnvironmentVariable(
    'Path',
    [EnvironmentVariableTarget]::User
)

# Confirm the compiler is now reachable on PATH.
if (-not (Test-Path $GccPath)) {
    throw "Unable to find '$GccPath'."
}
