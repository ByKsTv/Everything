# Table Of Contents

- [PowerShell](#powershell)

## PowerShell

- Do not use functions.
- Do not use alias.
- Do not use comments (`#`).
- Do not use `Join-Path`, instead use `[IO.Path]`.
- Do not use `Split-Path`, instead use `[IO.Path]`.
- Do not use `Select-Object -ExpandProperty`, instead use `.` to get property.
- Do not use `Set-ItemProperty`, instead use `New-ItemProperty`.
- Do not use `;`, instead use a new line.
- Do not use prompts (`Read-Host`).
- For `if` statements: Do not use `!`, instead use `-not`.
- For `if` statements: Use new line after `{`.
- If running a standalone `.exe` cmdlet (i.e `powercfg` cmdlet), Use `&` prefix and `.exe` suffix.
- Code as short as possible.
