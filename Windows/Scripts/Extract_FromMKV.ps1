param(
  [Parameter(Mandatory, Position = 0)]
  [string]$InputPath,

  [Parameter(Position = 1)]
  [string]$OutputRoot = $null,

  [switch]$Force
)

if (-not (Get-Command ffmpeg.exe -ErrorAction SilentlyContinue)) {
  throw 'ffmpeg.exe not found in PATH'
}

if (-not (Get-Command ffprobe.exe -ErrorAction SilentlyContinue)) {
  throw 'ffprobe.exe not found in PATH'
}

$files = @()
$resolved = Resolve-Path -LiteralPath $InputPath -ErrorAction Stop

foreach ($r in $resolved) {
  if ([IO.Directory]::Exists($r.Path)) {
    $files += (Get-ChildItem -LiteralPath $r.Path -Filter '*.mkv' -File).FullName
  }
  elseif ([IO.File]::Exists($r.Path)) {
    $files += $r.Path
  }
}

foreach ($file in $files) {
  if (-not [IO.File]::Exists($file)) {
    continue
  }

  $base = [IO.Path]::GetFileNameWithoutExtension($file)
  $invalid = [IO.Path]::GetInvalidFileNameChars()
  $sb = New-Object System.Text.StringBuilder

  foreach ($ch in $base.ToCharArray()) {
    if ($invalid -contains $ch) {
      [void]$sb.Append('_')
    }
    else {
      [void]$sb.Append($ch)
    }
  }

  $safeBase = ($sb.ToString() -replace '\s+', ' ').Trim()

  $root = if ($OutputRoot -and $OutputRoot.Trim()) {
    $OutputRoot
  }
  else {
    [IO.Path]::GetDirectoryName($file)
  }

  $outDir = [IO.Path]::Combine($root, $safeBase)

  if ($Force) {
    if ([IO.Directory]::Exists($outDir)) {
      Remove-Item -LiteralPath $outDir -Recurse -Force
    }
  }
  else {
    if ([IO.Directory]::Exists($outDir)) {
      $found = $false

      for ($i = 1; $i -lt 1000; $i++) {
        $try = "${outDir}_$i"

        if (-not [IO.Directory]::Exists($try)) {
          $outDir = $try
          $found = $true
          break
        }
      }

      if (-not $found) {
        throw "Could not create unique output folder for $file"
      }
    }
  }

  $chapDir = [IO.Path]::Combine($outDir, 'chapters')
  $subsDir = $outDir
  $attDir = [IO.Path]::Combine($outDir, 'attachments')

  [IO.Directory]::CreateDirectory($chapDir) | Out-Null
  [IO.Directory]::CreateDirectory($attDir) | Out-Null

  Write-Host "==> $file"
  Write-Host "    Output: $outDir"

  $chapFile = [IO.Path]::Combine($chapDir, "$safeBase.chapters.ffmeta")

  & ffmpeg.exe -hide_banner -nostdin -loglevel error -y -i $file -map_chapters 0 -f ffmetadata $chapFile | Out-Null

  if (-not [IO.File]::Exists($chapFile)) {
    & ffmpeg.exe -hide_banner -nostdin -loglevel error -y -i $file -f ffmetadata $chapFile | Out-Null
  }

  if ([IO.File]::Exists($chapFile)) {
    Write-Host "    Chapters: $chapFile"
  }

  $fpArgs = @(
    '-v'
    'error'
    '-analyzeduration'
    '0'
    '-probesize'
    '32k'
    '-of'
    'json'
    '-show_entries'
    'stream=index,codec_type,codec_name:stream_tags=language,title'
    '-show_streams'
    $file
  )

  $fpRaw = & ffprobe.exe @fpArgs
  $fp = $fpRaw | ConvertFrom-Json
  $subStreams = @($fp.streams | Where-Object {
      $_.codec_type -eq 'subtitle'
    })

  $langCounts = @{}
  $subJobs = @()

  for ($j = 0; $j -lt $subStreams.Count; $j++) {
    $s = $subStreams[$j]
    $lang = $null

    if ($s.PSObject.Properties.Name -contains 'tags' -and $s.tags -and ($s.tags.PSObject.Properties.Name -contains 'language')) {
      $lang = $s.tags.language.ToString().Trim().ToLowerInvariant()
    }

    if (-not $lang -or $lang -eq 'n/a') {
      $lang = 'und'
    }

    if (-not $langCounts.ContainsKey($lang)) {
      $langCounts[$lang] = 0
    }

    $langCounts[$lang]++
    $n = $langCounts[$lang]

    $title = $null

    if ($s.PSObject.Properties.Name -contains 'tags' -and $s.tags -and ($s.tags.PSObject.Properties.Name -contains 'title')) {
      $title = $s.tags.title.ToString()
    }

    $titleSafe = ''

    if ($title) {
      $sb2 = New-Object System.Text.StringBuilder

      foreach ($ch2 in $title.ToCharArray()) {
        if ($invalid -contains $ch2) {
          [void]$sb2.Append('_')
        }
        else {
          [void]$sb2.Append($ch2)
        }
      }

      $titleSafe = (($sb2.ToString() -replace '\s+', ' ').Trim())

      if ($titleSafe.Length -gt 40) {
        $titleSafe = $titleSafe.Substring(0, 40).Trim()
      }

      $titleSafe = ($titleSafe -replace ' ', '_')
    }

    $codec = ''

    if ($s.PSObject.Properties.Name -contains 'codec_name' -and $s.codec_name) {
      $codec = $s.codec_name.ToString().ToLowerInvariant()
    }

    $ext = 'mks'
    $container = 'matroska'
    $mode = 'copy'

    if ($codec -eq 'subrip') {
      $ext = 'srt'
      $container = $null
    }
    elseif ($codec -eq 'ass') {
      $ext = 'ass'
      $container = $null
    }
    elseif ($codec -eq 'ssa') {
      $ext = 'ssa'
      $container = $null
    }
    elseif ($codec -eq 'webvtt') {
      $ext = 'vtt'
      $container = $null
    }
    elseif ($codec -eq 'hdmv_pgs_subtitle') {
      $ext = 'sup'
      $container = $null
    }
    elseif ($codec -eq 'dvd_subtitle') {
      $ext = 'idx'
      $container = 'vobsub'
      $mode = 'vobsub'
    }

    $stem = "$lang"

    if ($n -gt 1) {
      $stem += ".$n"
    }

    if ($titleSafe) {
      $stem += ".$titleSafe"
    }

    $outSub = [IO.Path]::Combine($subsDir, "$stem.$ext")

    $subJobs += [pscustomobject]@{
      StreamIndex = [int]$s.index
      OutFile     = $outSub
      Container   = $container
      Mode        = $mode
    }
  }

  if ($subStreams.Count -eq 0) {
    Write-Host '    Subtitles: (none found)'
  }
  else {
    $ffArgs = @(
      '-hide_banner'
      '-nostdin'
      '-loglevel'
      'error'
      '-y'
      '-analyzeduration'
      '0'
      '-probesize'
      '32k'
      '-i'
      $file
    )

    foreach ($job in $subJobs) {
      $ffArgs += @(
        '-map'
        "0:$($job.StreamIndex)"
        '-an'
        '-vn'
        '-dn'
        '-c:s'
        'copy'
      )

      if ($job.Mode -eq 'vobsub') {
        $ffArgs += @(
          '-f'
          'vobsub'
        )
      }
      elseif ($job.Container) {
        $ffArgs += @(
          '-f'
          $job.Container
        )
      }

      $ffArgs += $job.OutFile
    }

    & ffmpeg.exe @ffArgs | Out-Null

    foreach ($job in $subJobs) {
      if ([IO.File]::Exists($job.OutFile)) {
        Write-Host "    Subtitle: $($job.OutFile)"

        if ($job.Mode -eq 'vobsub') {
          $side = [IO.Path]::ChangeExtension($job.OutFile, '.sub')

          if ([IO.File]::Exists($side)) {
            Write-Host "              $side"
          }
        }
      }
    }
  }

  Push-Location -LiteralPath $attDir

  try {
    $nullSink = if ($env:OS -match 'Windows') {
      'NUL'
    }
    else {
      '/dev/null'
    }

    & ffmpeg.exe -hide_banner -nostdin -loglevel error -y -dump_attachment:t '""' -i $file -t 0 -f null $nullSink | Out-Null

    $dumped = @(Get-ChildItem -File -ErrorAction SilentlyContinue)

    if ($dumped.Count -gt 0) {
      Write-Host "    Attachments: $($dumped.Count) file(s) -> $attDir"
    }
    else {
      Write-Host '    Attachments: (none found)'
    }
  }
  finally {
    Pop-Location
  }

  Write-Host ''
}