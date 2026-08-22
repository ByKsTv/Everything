# Table Of Contents

- [General](#general)
- [PowerShell](#powershell)
- [Python](#python)

## General

- Names should be descriptive. Avoid single-letter names.

## PowerShell

- Use PowerShell 5.1.
- Do not use functions.
- Do not use alias.
- Do not use comments (`#`).
- Do not use `Join-Path`, instead use `[IO.Path]`.
- Do not use `Split-Path`, instead use `[IO.Path]`.
- Do not use `Select-Object -ExpandProperty`, instead use `.` to get property.
- Do not use `Set-ItemProperty`, instead use `New-ItemProperty`.
- Do not use `-like`, instead use `-match`.
- Do not use `;`, instead use a new line.
- Do not use `Write-Host`, instead use this template: `[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Program name'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()`.
- Do not split `[Console]::` to new lines, instead use a one-liner as shown in the template above, do not use `| ForEach-Object { & $_ }` for this.
- Do not use prompts (`Read-Host`).
- Do not use `!`, instead use `-not`.
- Use new line after `{`.
- If running a standalone `.exe` cmdlet (i.e `powercfg` cmdlet), Use `&` prefix and `.exe` suffix.
- Code as short as possible.

## Python

- Use [PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/)
