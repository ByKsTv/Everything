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
- Do not use `-like`, instead use `-match`.
- Do not use `;`, instead use a new line.
- Do not use prompts (`Read-Host`).
- Do not use `!`, instead use `-not`.
- Use new line after `{`.
- If running a standalone `.exe` cmdlet (i.e `powercfg` cmdlet), Use `&` prefix and `.exe` suffix.
- Code as short as possible.

## Cascading Style Sheets (CSS)

- Do not use comments (`/*`).
- Do not use variables (`var(--uc-bg)`), instead manually specify a value.
- Merge selectors.
- Sort.
- Do not trim spacing and line breaks.
- Do not remove `root` global settings.
- Add `animation` and `transition` and disable it globally and per relevant elements.
- For `userChrome.css`: Do not use `:is()`.
- Code as short as possible.
