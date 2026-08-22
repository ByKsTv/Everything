#requires -Version 5.1

<#
.SYNOPSIS
Creates an AnimeTosho-style "All Attachments" .7z archive using Windows PowerShell 5.1.

.DESCRIPTION
Written specifically for Windows PowerShell 5.1 and .NET Framework.
It does not require PowerShell 7 or pwsh.exe.

Uses MKVToolNix (mkvmerge + mkvextract) to identify and extract:
  - Matroska attachments into attachments\
  - supported subtitle tracks as track<TrackNumber>.<language>.<extension>
  - chapters as chapters.xml
  - tags as tags.xml

File mode creates the archive contents at the root, matching AnimeTosho's per-file
attachment pack. Torrent mode prefixes each extracted path with the source file's
relative path and filename, matching AnimeTosho's torrent-wide attachment pack.

The resulting archive has the same practical directory and naming scheme, but it
will not be byte-for-byte identical to AnimeTosho's server-generated archive.

.EXAMPLE
.\New-AnimeToshoAttachmentPack-WindowsPowerShell51.ps1 -Path "D:\Anime\Episode 01.mkv"

.EXAMPLE
.\New-AnimeToshoAttachmentPack-WindowsPowerShell51.ps1 -Path "D:\Anime\Release Folder" -Mode Torrent

.EXAMPLE
.\New-AnimeToshoAttachmentPack-WindowsPowerShell51.ps1 -Path "D:\Anime\Episode 01.mkv" `
  -OutputPath "D:\Packs\Episode 01_attachments.7z" `
  -MkvToolNixDirectory "C:\Program Files\MKVToolNix"
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory, Position = 0)]
  [string] $Path,

  [ValidateSet('Auto', 'File', 'Torrent')]
  [string] $Mode = 'Auto',

  [string] $OutputPath,

  [string] $MkvToolNixDirectory,

  [string] $SevenZipPath,

  [switch] $KeepWorkingDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Windows PowerShell 5.1 uses the Desktop edition on .NET Framework.
if ($PSVersionTable.PSVersion -lt [version]'5.1') {
  throw 'This script requires Windows PowerShell 5.1 or later.'
}

$script:SupportedMatroskaExtensions = @('.mkv', '.mka', '.mks', '.webm')

function Resolve-Tool {
  param(
    [Parameter(Mandatory)]
    [string[]] $Names,

    [string] $Directory
  )

  if ($Directory) {
    foreach ($name in $Names) {
      $candidate = Join-Path $Directory $name
      if (Test-Path -LiteralPath $candidate -PathType Leaf) {
        return (Resolve-Path -LiteralPath $candidate).Path
      }
    }
  }

  foreach ($name in $Names) {
    $command = Get-Command $name -CommandType Application -ErrorAction SilentlyContinue
    if ($command) {
      return $command.Source
    }
  }

  throw "Could not find any of these executables: $($Names -join ', ')"
}

function ConvertTo-NativeArgument {
  param(
    [AllowNull()]
    [AllowEmptyString()]
    [string] $Argument
  )

  # ProcessStartInfo.ArgumentList is unavailable on .NET Framework, which
  # Windows PowerShell 5.1 uses. Quote arguments according to the Windows
  # CommandLineToArgvW parsing rules instead.
  if ($null -eq $Argument -or $Argument.Length -eq 0) {
    return '""'
  }

  if ($Argument -notmatch '[\s"]') {
    return $Argument
  }

  $builder = New-Object System.Text.StringBuilder
  [void] $builder.Append('"')
  $backslashCount = 0

  foreach ($character in $Argument.ToCharArray()) {
    if ($character -eq '\') {
      $backslashCount++
      continue
    }

    if ($character -eq '"') {
      if ($backslashCount -gt 0) {
        [void] $builder.Append(('\' * ($backslashCount * 2)))
      }

      [void] $builder.Append('\"')
      $backslashCount = 0
      continue
    }

    if ($backslashCount -gt 0) {
      [void] $builder.Append(('\' * $backslashCount))
      $backslashCount = 0
    }

    [void] $builder.Append($character)
  }

  # Backslashes directly before the closing quote must be doubled.
  if ($backslashCount -gt 0) {
    [void] $builder.Append(('\' * ($backslashCount * 2)))
  }

  [void] $builder.Append('"')
  return $builder.ToString()
}

function Invoke-Tool {
  param(
    [Parameter(Mandatory)]
    [string] $FilePath,

    [Parameter(Mandatory)]
    [string[]] $ArgumentList,

    [int[]] $SuccessExitCodes = @(0),

    [string] $WorkingDirectory
  )

  $startInfo = New-Object System.Diagnostics.ProcessStartInfo
  $startInfo.FileName = $FilePath
  $startInfo.UseShellExecute = $false
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  $startInfo.CreateNoWindow = $true
  $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
  $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8
  $startInfo.Arguments = (($ArgumentList | ForEach-Object {
        ConvertTo-NativeArgument -Argument ([string] $_)
      }) -join ' ')

  if ($WorkingDirectory) {
    $startInfo.WorkingDirectory = $WorkingDirectory
  }

  $process = New-Object System.Diagnostics.Process
  $process.StartInfo = $startInfo

  try {
    if (-not $process.Start()) {
      throw "Failed to start: $FilePath"
    }

    # Read both streams asynchronously to avoid a full-buffer deadlock.
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.WaitForExit()

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    $exitCode = $process.ExitCode
  } finally {
    $process.Dispose()
  }

  if ($SuccessExitCodes -notcontains $exitCode) {
    $details = @(
      "Command failed with exit code $exitCode.",
      "Executable: $FilePath",
      "Arguments: $($startInfo.Arguments)"
    )

    if ($stderr.Trim()) {
      $details += "Error output: $($stderr.Trim())"
    }

    throw ($details -join [Environment]::NewLine)
  }

  if ($stderr.Trim()) {
    Write-Verbose $stderr.Trim()
  }

  [pscustomobject]@{
    ExitCode = $exitCode
    StdOut   = $stdout
    StdErr   = $stderr
  }
}

function Get-RelativePathCompat {
  param(
    [Parameter(Mandatory)]
    [string] $BasePath,

    [Parameter(Mandatory)]
    [string] $TargetPath
  )

  # System.IO.Path.GetRelativePath is unavailable on .NET Framework.
  $baseFullPath = [System.IO.Path]::GetFullPath($BasePath).TrimEnd([char[]]@('\', '/'))
  $targetFullPath = [System.IO.Path]::GetFullPath($TargetPath)
  $basePrefix = $baseFullPath + [System.IO.Path]::DirectorySeparatorChar

  if ($targetFullPath.StartsWith($basePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $targetFullPath.Substring($basePrefix.Length)
  }

  throw "Target path '$targetFullPath' is not inside base path '$baseFullPath'."
}

function ConvertTo-SafeWindowsName {
  param(
    [Parameter(Mandatory)]
    [string] $Name,

    [string] $Fallback = '_'
  )

  # AnimeTosho removes forward slashes and control characters from attachment
  # names. Windows has additional forbidden characters, which are replaced.
  $safe = $Name -replace '[/\x00-\x1f]', ''
  $safe = $safe -replace '[<>:"\\|?*]', '_'
  $safe = $safe.TrimEnd([char[]]@('.', ' '))

  if ([string]::IsNullOrWhiteSpace($safe)) {
    return $Fallback
  }

  # Avoid reserved DOS device names.
  $stem = [System.IO.Path]::GetFileNameWithoutExtension($safe)
  if ($stem -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$') {
    $safe = "_$safe"
  }

  return $safe
}

function Get-UniqueOutputPath {
  param(
    [Parameter(Mandatory)]
    [string] $Directory,

    [Parameter(Mandatory)]
    [string] $FileName,

    [Parameter(Mandatory)]
    [string] $Disambiguator
  )

  $candidate = Join-Path $Directory $FileName
  if (-not (Test-Path -LiteralPath $candidate)) {
    return $candidate
  }

  $stem = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
  $extension = [System.IO.Path]::GetExtension($FileName)
  $candidate = Join-Path $Directory ('{0}_{1}{2}' -f $stem, $Disambiguator, $extension)

  $counter = 2
  while (Test-Path -LiteralPath $candidate) {
    $candidate = Join-Path $Directory ('{0}_{1}_{2}{3}' -f $stem, $Disambiguator, $counter, $extension)
    $counter++
  }

  return $candidate
}

function Get-SubtitleExtension {
  param(
    [Parameter(Mandatory)]
    [string] $CodecId
  )

  switch ($CodecId) {
    'S_TEXT/UTF8' {
      return 'srt'
    }
    'S_TEXT/ASS' {
      return 'ass'
    }
    'S_TEXT/SSA' {
      return 'ssa'
    }
    'S_TEXT/WEBVTT' {
      return 'vtt'
    }
    'D_WEBVTT/SUBTITLES' {
      return 'vtt'
    }
    'S_VOBSUB' {
      return 'idx'
    }
    'S_HDMV/PGS' {
      return 'sup'
    }
    default {
      return $null
    }
  }
}

function Get-MatroskaIdentification {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileInfo] $File,

    [Parameter(Mandatory)]
    [string] $MkvMerge
  )

  $result = Invoke-Tool -FilePath $MkvMerge `
    -ArgumentList @('-J', $File.FullName) `
    -SuccessExitCodes @(0, 1)

  try {
    return $result.StdOut | ConvertFrom-Json
  } catch {
    throw "mkvmerge returned invalid JSON for '$($File.FullName)': $($_.Exception.Message)"
  }
}

function Export-AnimeToshoFileContents {
  param(
    [Parameter(Mandatory)]
    [System.IO.FileInfo] $File,

    [Parameter(Mandatory)]
    [string] $DestinationRoot,

    [Parameter(Mandatory)]
    [string] $MkvMerge,

    [Parameter(Mandatory)]
    [string] $MkvExtract
  )

  New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
  $identification = Get-MatroskaIdentification -File $File -MkvMerge $MkvMerge
  $created = 0

  # Embedded attachments, usually fonts.
  if ($identification.attachments) {
    $attachmentsDirectory = Join-Path $DestinationRoot 'attachments'
    New-Item -ItemType Directory -Path $attachmentsDirectory -Force | Out-Null

    foreach ($attachment in @($identification.attachments)) {
      $attachmentId = [int] $attachment.id
      $originalName = [string] $attachment.file_name

      if ([string]::IsNullOrWhiteSpace($originalName) -and $attachment.PSObject.Properties.Name -contains 'name') {
        $originalName = [string] $attachment.name
      }

      if ([string]::IsNullOrWhiteSpace($originalName)) {
        $originalName = "unnamed_$attachmentId"
      }

      $safeName = ConvertTo-SafeWindowsName -Name $originalName -Fallback "unnamed_$attachmentId"
      $destination = Get-UniqueOutputPath `
        -Directory $attachmentsDirectory `
        -FileName $safeName `
        -Disambiguator ([string] $attachmentId)

      Write-Host "  attachment $attachmentId -> attachments\$([System.IO.Path]::GetFileName($destination))"
      Invoke-Tool -FilePath $MkvExtract `
        -ArgumentList @($File.FullName, 'attachments', "${attachmentId}:$destination") `
        -SuccessExitCodes @(0, 1) | Out-Null

      if (Test-Path -LiteralPath $destination -PathType Leaf) {
        $created++
      } else {
        Write-Warning "Attachment $attachmentId was not created for '$($File.FullName)'."
      }
    }

    if (-not (Get-ChildItem -LiteralPath $attachmentsDirectory -Force -ErrorAction SilentlyContinue)) {
      Remove-Item -LiteralPath $attachmentsDirectory -Force -ErrorAction SilentlyContinue
    }
  }

  # Subtitle tracks, following AnimeTosho's codec and filename mapping.
  if ($identification.tracks) {
    foreach ($track in @($identification.tracks)) {
      if ([string] $track.type -ne 'subtitles') {
        continue
      }

      $codecId = [string] $track.properties.codec_id
      $extension = Get-SubtitleExtension -CodecId $codecId
      if (-not $extension) {
        Write-Warning "Skipping unsupported subtitle codec '$codecId' in '$($File.FullName)'."
        continue
      }

      $trackId = [int] $track.id
      $trackNumber = $track.properties.number
      if ($null -eq $trackNumber -or [string]::IsNullOrWhiteSpace([string] $trackNumber)) {
        # mkvmerge normally provides Matroska's 1-based TrackNumber.
        $trackNumber = $trackId + 1
      }

      $language = [string] $track.properties.language
      $language = $language -replace '/', ''
      $language = $language -replace '[<>:"\\|?*\x00-\x1f]', ''

      $baseName = "track$trackNumber"
      if (-not [string]::IsNullOrWhiteSpace($language)) {
        $baseName += ".$language"
      }

      $destination = Join-Path $DestinationRoot "$baseName.$extension"
      Write-Host "  subtitle track $trackNumber ($codecId) -> $([System.IO.Path]::GetFileName($destination))"

      Invoke-Tool -FilePath $MkvExtract `
        -ArgumentList @($File.FullName, 'tracks', "${trackId}:$destination") `
        -SuccessExitCodes @(0, 1) | Out-Null

      if ($codecId -eq 'S_VOBSUB') {
        $vobBase = [System.IO.Path]::Combine(
          [System.IO.Path]::GetDirectoryName($destination),
          [System.IO.Path]::GetFileNameWithoutExtension($destination)
        )

        foreach ($vobExtension in @('.idx', '.sub')) {
          if (Test-Path -LiteralPath "$vobBase$vobExtension" -PathType Leaf) {
            $created++
          }
        }
      } elseif (Test-Path -LiteralPath $destination -PathType Leaf) {
        $created++
      } else {
        Write-Warning "Subtitle track $trackNumber was not created for '$($File.FullName)'."
      }
    }
  }

  # mkvextract does not create these files when no chapters/tags exist.
  foreach ($metadataType in @('chapters', 'tags')) {
    $destination = Join-Path $DestinationRoot "$metadataType.xml"
    Invoke-Tool -FilePath $MkvExtract `
      -ArgumentList @($File.FullName, $metadataType, $destination) `
      -SuccessExitCodes @(0, 1) | Out-Null

    if (Test-Path -LiteralPath $destination -PathType Leaf) {
      if ((Get-Item -LiteralPath $destination).Length -gt 0) {
        Write-Host "  metadata -> $metadataType.xml"
        $created++
      } else {
        Remove-Item -LiteralPath $destination -Force
      }
    }
  }

  return $created
}

$resolvedInput = Resolve-Path -LiteralPath $Path
$inputItem = Get-Item -LiteralPath $resolvedInput.Path

if ($Mode -eq 'Auto') {
  $Mode = if ($inputItem.PSIsContainer) {
    'Torrent'
  } else {
    'File'
  }
}

if ($Mode -eq 'File' -and $inputItem.PSIsContainer) {
  throw 'File mode requires a Matroska file, not a directory.'
}

if ($Mode -eq 'Torrent' -and -not $inputItem.PSIsContainer) {
  throw 'Torrent mode requires a directory.'
}

$mkvmerge = Resolve-Tool -Names @('mkvmerge.exe', 'mkvmerge') -Directory $MkvToolNixDirectory
$mkvextract = Resolve-Tool -Names @('mkvextract.exe', 'mkvextract') -Directory $MkvToolNixDirectory

if ($SevenZipPath) {
  if (-not (Test-Path -LiteralPath $SevenZipPath -PathType Leaf)) {
    throw "7-Zip executable not found: $SevenZipPath"
  }
  $sevenZip = (Resolve-Path -LiteralPath $SevenZipPath).Path
} else {
  $sevenZip = Resolve-Tool -Names @('7z.exe', '7zz.exe', '7za.exe', '7z', '7zz', '7za')
}

if ($Mode -eq 'File') {
  $sourceFiles = @([System.IO.FileInfo] $inputItem)
  if ($script:SupportedMatroskaExtensions -notcontains $sourceFiles[0].Extension.ToLowerInvariant()) {
    throw "Unsupported input extension '$($sourceFiles[0].Extension)'. Expected: $($script:SupportedMatroskaExtensions -join ', ')"
  }

  $defaultArchiveName = '{0}_attachments.7z' -f [System.IO.Path]::GetFileNameWithoutExtension($sourceFiles[0].Name)
  $defaultArchiveDirectory = $sourceFiles[0].DirectoryName
  $sourceRoot = $sourceFiles[0].DirectoryName
} else {
  $sourceRoot = $inputItem.FullName
  $sourceFiles = @(
    Get-ChildItem -LiteralPath $sourceRoot -Recurse -File |
      Where-Object { $script:SupportedMatroskaExtensions -contains $_.Extension.ToLowerInvariant() } |
      Sort-Object FullName
  )

  if ($sourceFiles.Count -eq 0) {
    throw "No Matroska files were found under '$sourceRoot'."
  }

  $safeRootName = ConvertTo-SafeWindowsName -Name $inputItem.Name -Fallback 'attachments'
  $defaultArchiveName = "${safeRootName}_attachments.7z"
  $defaultArchiveDirectory = $inputItem.Parent.FullName
}

if ($OutputPath) {
  $archivePath = [System.IO.Path]::GetFullPath($OutputPath)
  if ([System.IO.Path]::GetExtension($archivePath) -ne '.7z') {
    $archivePath += '.7z'
  }
} else {
  $archivePath = Join-Path $defaultArchiveDirectory $defaultArchiveName
}

$archiveDirectory = [System.IO.Path]::GetDirectoryName($archivePath)
if (-not (Test-Path -LiteralPath $archiveDirectory -PathType Container)) {
  New-Item -ItemType Directory -Path $archiveDirectory -Force | Out-Null
}

$workingDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ('animetosho-attachments-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $workingDirectory -Force | Out-Null

$totalCreated = 0

try {
  foreach ($file in $sourceFiles) {
    if ($Mode -eq 'Torrent') {
      $relativeFilePath = Get-RelativePathCompat -BasePath $sourceRoot -TargetPath $file.FullName
      $safeParts = @(
        $relativeFilePath -split '[\\/]' |
          ForEach-Object { ConvertTo-SafeWindowsName -Name $_ -Fallback '_' }
      )

      $destinationRoot = $workingDirectory
      foreach ($part in $safeParts) {
        $destinationRoot = Join-Path $destinationRoot $part
      }
    } else {
      $destinationRoot = $workingDirectory
    }

    Write-Host "Processing: $($file.FullName)"
    $totalCreated += Export-AnimeToshoFileContents `
      -File $file `
      -DestinationRoot $destinationRoot `
      -MkvMerge $mkvmerge `
      -MkvExtract $mkvextract
  }

  if ($totalCreated -eq 0) {
    throw 'No supported attachments, subtitle tracks, chapters, or tags were extracted.'
  }

  if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
  }

  Write-Host "Creating archive: $archivePath"
  Invoke-Tool -FilePath $sevenZip `
    -WorkingDirectory $workingDirectory `
    -ArgumentList @(
    'a',
    '-t7z',
    '-mx=9',
    '-m0=LZMA2',
    '-ms=off',
    '-mmt=on',
    '-y',
    $archivePath,
    '*'
  ) `
    -SuccessExitCodes @(0, 1) | Out-Null

  if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
    throw '7-Zip completed without producing the requested archive.'
  }

  Write-Host "Done: $archivePath"
} finally {
  if ($KeepWorkingDirectory) {
    Write-Host "Working directory kept at: $workingDirectory"
  } elseif (Test-Path -LiteralPath $workingDirectory) {
    Remove-Item -LiteralPath $workingDirectory -Recurse -Force
  }
}
