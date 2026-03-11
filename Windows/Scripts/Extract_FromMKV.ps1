param(
  [Parameter(Mandatory, Position = 0)]
  [string]$InputPath,

  # Optional override. If omitted, outputs next to each MKV file.
  [Parameter(Position = 1)]
  [string]$OutputRoot = $null,

  [switch]$Force
)

# ---- prerequisites ----
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  throw 'ffmpeg not found in PATH'
}
if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue)) {
  throw 'ffprobe not found in PATH'
}

# ---- collect files ----
$files = @()
$resolved = Resolve-Path $InputPath -ErrorAction Stop

foreach ($r in $resolved) {
  if (Test-Path $r.Path -PathType Container) {
    $files += Get-ChildItem -Path $r.Path -Filter *.mkv -File | Select-Object -ExpandProperty FullName
  }
  else {
    $files += $r.Path
  }
}

foreach ($file in $files) {
  if (-not (Test-Path $file -PathType Leaf)) {
    continue 
  }

  $base = [IO.Path]::GetFileNameWithoutExtension($file)

  # sanitize base for folder name
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

  # Output root: same folder as MKV (unless -OutputRoot is provided)
  $root = if ($OutputRoot -and $OutputRoot.Trim()) {
    $OutputRoot 
  }
  else {
    Split-Path -Parent $file 
  }

  $outDir = Join-Path $root $safeBase

  if ($Force) {
    if (Test-Path $outDir) {
      Remove-Item -Recurse -Force $outDir 
    }
  }
  else {
    if (Test-Path $outDir) {
      for ($i = 1; $i -lt 1000; $i++) {
        $try = "${outDir}_$i"
        if (-not (Test-Path $try)) {
          $outDir = $try; break 
        }
      }
    }
  }

  $chapDir = Join-Path $outDir 'chapters'
  $subsDir = $outDir
  $attDir = Join-Path $outDir 'attachments'
  New-Item -ItemType Directory -Force -Path $chapDir, $attDir | Out-Null

  Write-Host "==> $file"
  Write-Host "    Output: $outDir"

  # ---- 1) Chapters (ffmetadata) ----
  $chapFile = Join-Path $chapDir "$safeBase.chapters.ffmeta"
  & ffmpeg -hide_banner -nostdin -loglevel error -y -i $file -map_chapters 0 -f ffmetadata $chapFile | Out-Null
  if (-not (Test-Path $chapFile)) {
    & ffmpeg -hide_banner -nostdin -loglevel error -y -i $file -f ffmetadata $chapFile | Out-Null
  }
  if (Test-Path $chapFile) {
    Write-Host "    Chapters: $chapFile" 
  }

  # ---- 2) Subtitles (ffprobe JSON; one ffmpeg run for all subtitle streams) ----
  $fpArgs = @(
    '-v', 'error',
    '-analyzeduration', '0', '-probesize', '32k',
    '-of', 'json',
    '-show_entries', 'stream=index,codec_type,codec_name:stream_tags=language,title',
    '-show_streams', "$file"
  )
  $fpRaw = & ffprobe @fpArgs
  $fp = $fpRaw | ConvertFrom-Json

  $subStreams = @($fp.streams | Where-Object { $_.codec_type -eq 'subtitle' })

  # language counts for de-dupe
  $langCounts = @{}

  # collect planned extractions, then run ffmpeg ONCE
  $subJobs = @()

  for ($j = 0; $j -lt $subStreams.Count; $j++) {
    $s = $subStreams[$j]

    # language (ffprobe usually gives 3-letter like eng; sometimes missing)
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

    # optional title
    $title = $null
    if ($s.PSObject.Properties.Name -contains 'tags' -and $s.tags -and ($s.tags.PSObject.Properties.Name -contains 'title')) {
      $title = $s.tags.title.ToString()
    }

    # sanitize title
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

    # choose extension/container by codec_name
    $codec = ''
    if ($s.PSObject.Properties.Name -contains 'codec_name' -and $s.codec_name) {
      $codec = $s.codec_name.ToString().ToLowerInvariant()
    }

    $ext = 'mks'
    $container = 'matroska'
    $mode = 'copy'

    if ($codec -eq 'subrip') {
      $ext = 'srt'; $container = $null 
    }
    elseif ($codec -eq 'ass') {
      $ext = 'ass'; $container = $null 
    }
    elseif ($codec -eq 'ssa') {
      $ext = 'ssa'; $container = $null 
    }
    elseif ($codec -eq 'webvtt') {
      $ext = 'vtt'; $container = $null 
    }
    elseif ($codec -eq 'hdmv_pgs_subtitle') {
      $ext = 'sup'; $container = $null 
    }
    elseif ($codec -eq 'dvd_subtitle') {
      $ext = 'idx'; $container = 'vobsub'; $mode = 'vobsub' 
    }

    # filename: lang[.n][.title].ext
    $stem = "$lang"
    if ($n -gt 1) {
      $stem += ".$n" 
    }
    if ($titleSafe) {
      $stem += ".$titleSafe" 
    }

    $outSub = Join-Path $subsDir ("$stem.$ext")

    $subJobs += [pscustomobject]@{
      StreamIndex = [int]$s.index  # global stream index (use -map 0:<index>)
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
      '-hide_banner', '-nostdin', '-loglevel', 'error', '-y',
      '-analyzeduration', '0', '-probesize', '32k',
      '-i', "$file"
    )

    foreach ($job in $subJobs) {
      $ffArgs += @('-map', "0:$($job.StreamIndex)", '-an', '-vn', '-dn', '-c:s', 'copy')

      if ($job.Mode -eq 'vobsub') {
        $ffArgs += @('-f', 'vobsub')
      }
      elseif ($job.Container) {
        $ffArgs += @('-f', $job.Container)
      }

      $ffArgs += @("$($job.OutFile)")
    }

    & ffmpeg @ffArgs | Out-Null

    foreach ($job in $subJobs) {
      if (Test-Path $job.OutFile) {
        Write-Host "    Subtitle: $($job.OutFile)"
        if ($job.Mode -eq 'vobsub') {
          $side = [IO.Path]::ChangeExtension($job.OutFile, '.sub')
          if (Test-Path $side) {
            Write-Host "              $side" 
          }
        }
      }
    }
  }

  # ---- 3) Attachments (no ffprobe needed) ----
  Push-Location $attDir
  try {
    $nullSink = if ($IsWindows -or $env:OS -like '*Windows*') {
      'NUL' 
    }
    else {
      '/dev/null' 
    }

    # IMPORTANT: '""' is a *literal* two-quote string, so ffmpeg uses the attachment's filename metadata
    & ffmpeg -hide_banner -nostdin -loglevel error -y `
      -dump_attachment:t '""' `
      -i "$file" -t 0 -f null $nullSink | Out-Null

    $dumped = Get-ChildItem -File -ErrorAction SilentlyContinue
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