$folder = [IO.Path]::Combine($env:TEMP, 'AdbSettingsWatch')
$beforeFolder = [IO.Path]::Combine($folder, 'before')
$afterFolder = [IO.Path]::Combine($folder, 'after')
$tables = @('system', 'secure', 'global')

if (-not (Test-Path -Path $beforeFolder)) {
    New-Item -Path $beforeFolder -ItemType Directory -Force | Out-Null

    foreach ($table in $tables) {
        $file = [IO.Path]::Combine($beforeFolder, "$table.txt")
        & adb.exe shell settings list $table | Set-Content -Path $file
    }

    Write-Host 'Saved baseline. Change one setting on the phone, then run again.'
}

New-Item -Path $afterFolder -ItemType Directory -Force | Out-Null

foreach ($table in $tables) {
    $beforeFile = [IO.Path]::Combine($beforeFolder, "$table.txt")
    $afterFile = [IO.Path]::Combine($afterFolder, "$table.txt")
    & adb.exe shell settings list $table | Set-Content -Path $afterFile

    $before = @{}
    $after = @{}
    $keys = @{}

    foreach ($line in (Get-Content -Path $beforeFile)) {
        $i = $line.IndexOf('=')

        if ($i -ge 0) {
            $key = $line.Substring(0, $i)
            $value = $line.Substring($i + 1)
            $before[$key] = $value
            $keys[$key] = $true
        }
    }

    foreach ($line in (Get-Content -Path $afterFile)) {
        $i = $line.IndexOf('=')

        if ($i -ge 0) {
            $key = $line.Substring(0, $i)
            $value = $line.Substring($i + 1)
            $after[$key] = $value
            $keys[$key] = $true
        }
    }

    foreach ($key in ($keys.Keys | Sort-Object)) {
        $beforeHas = $before.ContainsKey($key)
        $afterHas = $after.ContainsKey($key)

        if ($beforeHas -and $afterHas -and $before[$key] -ne $after[$key]) {
            Write-Host "$table $($key): $($before[$key]) -> $($after[$key])"
        }
        elseif (-not $beforeHas -and $afterHas) {
            Write-Host "$table $($key): added -> $($after[$key])"
        }
        elseif ($beforeHas -and -not $afterHas) {
            Write-Host "$table $($key): $($before[$key]) -> removed"
        }
    }

    Copy-Item -Path $afterFile -Destination $beforeFile -Force
}