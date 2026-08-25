# PowerShell Style Rules

Rules to apply when writing or reviewing PowerShell scripts.

> **Instruction to Claude:** Whenever the user asks for help with PowerShell code in a conversation, apply the rules below. If that conversation surfaces a new rule, correction, or gotcha (e.g. a bug, a better .NET equivalent, a parsing pitfall, a style preference the user states), add it to this file and provide the user an updated copy of this file alongside the updated code — even if the user doesn't explicitly ask for the rules file to be updated that time. Keep entries concise, sorted into the existing categories (or a new category if none fits), and avoid duplicating an existing rule.

## Performance — prefer .NET over cmdlets

- Use `HttpClient` (reused instance) instead of `Invoke-WebRequest` for HTTP calls — skips cmdlet response-object overhead.
- Use `HttpClient` instead of `System.Net.WebClient` — `WebClient` is marked `[Obsolete]` (`SYSLIB0014`) since .NET 6; still works on Windows PowerShell 5.1/.NET Framework, but not recommended for new code.
- Reuse a single `HttpClient` instance for multiple requests instead of creating a new client/connection per call (avoids repeated TCP/TLS handshakes).
- Use `[IO.File]::Exists()` instead of `Test-Path` for plain file checks — skips the provider abstraction layer.
- Use `[Diagnostics.FileVersionInfo]::GetVersionInfo()` instead of `(Get-Item ...).VersionInfo` — avoids building a full `FileInfo` object.
- Use `[Diagnostics.Process]::Start()` instead of `Start-Process` — bypasses cmdlet parameter binding.
- Use `[regex]::Matches()` / `[regex]::Match()` instead of parsing objects (e.g. `.Links`) when a direct pattern match is available and cheaper.
- Use `[Uri]::new(baseUri, relativeHref)` instead of string concatenation for building URLs — correctly resolves both relative and absolute links.

## Minimalism / readability

- Consolidate repeated blocks (e.g. multi-line `[Console]::Write` color sequences) into one small helper function instead of duplicating them.
- Use descriptive, full-word variable/function names (`$downloadUri`, `Write-Info`) over abbreviations.
- Prefer camelCase local variables in scripts intended as internal/utility (adjust to house style if the target codebase differs) — main point is _consistency_, not the specific casing.
- Don't introduce a cmdlet or object just to extract one property — reach for the direct API instead.

## Parameter defaults (`param()` gotchas)

- If a script-level `param()` block throws "The assignment expression is not valid" even on a plain literal default (e.g. `[string]$AppName = 'Test'`), stop debugging the param syntax and drop `param()` entirely — use plain variable assignments at the top of the script instead. This error on a trivial default usually means the _execution context_ (e.g. pasting a multi-line script directly into an interactive console instead of running it as a `.ps1` file) doesn't handle script-level `param()` blocks correctly, not that the syntax itself is wrong.
- Prefer plain top-of-script variables (`$AppName = 'Test'`) over `param()` for scripts that will mainly be edited-and-run rather than invoked with arguments — same editability, no parsing risk.
- If `param()` is genuinely needed (the script must accept CLI arguments), keep default values as plain literals only. Don't put complex/computed expressions (especially anything with nested parentheses) as a default. Compute non-trivial defaults in the script body instead (`if (-not $Param) { $Param = <computed value> }`).
- Never use `${env:ProgramFiles(x86)}`-style curly-brace env-var syntax inside a `param()` default value — the unescaped `(x86)` inside nested parentheses can cause a parse error. Use `[Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86)` instead — it's also more robust than depending on the env var being set.
- Prefer `#Requires -RunAsAdministrator` at the top of the script over a manual `WindowsPrincipal`/`WindowsBuiltInRole` elevation check — it's shorter, self-documenting, and PowerShell enforces it before the script body runs at all.

## PowerShell 5.1 compatibility (target environment)

- Load `System.Net.Http` explicitly with `Add-Type -AssemblyName System.Net.Http` before using `HttpClient`. Unlike PowerShell 7 (.NET Core, which auto-loads it as a core library), Windows PowerShell 5.1 runs on .NET Framework and does **not** load this assembly by default — `[Net.Http.HttpClient]::new()` will throw a type-not-found error without this line.
- `WebClient` is **not** marked obsolete on .NET Framework/PowerShell 5.1 — the `[Obsolete]`/`SYSLIB0014` attribute only applies starting in .NET 6+. Prefer `HttpClient` anyway when reusing a connection (e.g. already open from a prior request) or for forward-compatibility, but don't frame it as "avoiding a deprecation warning" in this environment — there isn't one.
- Avoid PS7+-only syntax: no ternary operator (`condition ? a : b`), no null-coalescing (`??`, `??=`), no `$PSStyle`. Use `if/else` expressions instead (already the pattern used in this script).
- Explicitly set `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` before making HTTPS calls — 5.1's default `SecurityProtocol` can still be pinned to older TLS versions on some systems, causing HTTPS requests to fail with no clear error.

## Composability (calling this script from another script)

- Never dot-source (`. .\script.ps1`) a script that calls `exit` — dot-sourcing merges it into the caller's scope, so `exit` terminates the entire calling script/session, not just the called script.
- Invoke scripts with `exit` statements via the call operator (`& .\script.ps1`) or by bare path (`.\script.ps1`) instead — this runs them in their own scope, so `exit` only ends that script and control returns cleanly to the caller.
- After invoking, check `$LASTEXITCODE` in the parent to detect success/failure, rather than assuming the child always succeeded.
- Wrapping a script's body in `try/catch` with explicit `exit 0`/`exit 1` (as this script does) is deliberate: it converts internal failures into a predictable, checkable exit code instead of letting an uncaught exception propagate in a way that depends on the caller's `$ErrorActionPreference`.

## Error handling

- Add `Set-StrictMode -Version Latest` near the top of scripts — turns typos (e.g. a misspelled variable name) into hard errors instead of silently evaluating to `$null`.
- Wrap the script body in an outer `try { } catch { Write-Error $_; exit 1 }` so uncaught exceptions produce a clean message and a non-zero exit code (useful for automation/Task Scheduler) instead of a raw stack trace.
- Set `$ErrorActionPreference = 'Stop'` near the top alongside `Set-StrictMode` — without it, non-terminating errors from cmdlets (as opposed to thrown .NET exceptions) won't be caught by an outer `try/catch`, so they'd be silently skipped instead of triggering the `catch` block and `exit 1`.

## Robustness

- Validate that a regex/parse actually matched before using the result (e.g. don't let an empty string silently become `[version]''` and throw a cryptic error) — throw a clear, specific error message instead.
- Wrap resource-holding logic (`HttpClient`, file handles) in `try { } finally { }` to guarantee disposal even on early exit/throw.
- After starting an external process (e.g. an installer), call `.WaitForExit()` and check `.ExitCode` rather than firing-and-forgetting — the script should know if the operation actually succeeded.
- Clean up temp files only after confirmed success, so a failed run leaves artifacts for debugging.
- Set TLS explicitly (`[Net.ServicePointManager]::SecurityProtocol = Tls12`) when targeting older/locked-down Windows PowerShell 5.1 environments, where the default can be TLS 1.0.
- Set an explicit `User-Agent` header on HTTP requests — some servers reject requests with missing/default .NET user-agents.
- Fail fast with a clear message for known failure modes (e.g. not running elevated when installing to `Program Files`) instead of letting a downstream step fail confusingly.
- Cast version strings to `[version]` before comparing (`-ge`, `-gt`, etc.) instead of comparing as plain strings — string comparison is lexicographic and gets ordering like `'1.9' -gt '1.10'` wrong.
- Set an explicit `Timeout` on `HttpClient` (e.g. `$httpClient.Timeout = [TimeSpan]::FromSeconds(30)`) instead of relying on the 100-second default — fail fast on a hung connection rather than blocking a script for minutes.
- Validate a downloaded payload is non-empty (e.g. check `$fileBytes.Length -gt 0` or a streamed byte counter `-gt 0`) before writing it to disk / treating the download as complete and running it — an empty or truncated download should fail loudly, not silently produce a broken installer.
- `[Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86)` returns an empty string on a 32-bit OS (there's no separate x86 folder there) — if the script must also run on 32-bit Windows, fall back to `ProgramFiles` when the x86 path is empty.

## Progress reporting

- To show download progress, don't use `HttpClient.GetByteArrayAsync()` — it buffers the entire response in memory and returns only once complete, giving no opportunity to report interim progress. Instead call `GetAsync(uri, HttpCompletionOption.ResponseHeadersRead)`, read `Content.Headers.ContentLength`, then copy the response stream to the destination file manually in a buffered loop (e.g. 80 KB chunks via `Stream.Read`/`Stream.Write`), computing percent complete from bytes-read vs. `ContentLength` after each chunk.
- Use `Write-Progress` (not a raw `[Console]::Write` loop) for progress bars — it's the standard PowerShell UI primitive, renders a native progress bar in the console/ISE, and is automatically suppressed in non-interactive hosts. This is a UI concern, not the kind of per-call overhead the "prefer .NET over cmdlets" performance rules are aimed at, so reaching for a cmdlet here is fine.
- Only call `Write-Progress -PercentComplete` when the integer percent actually changes (track a `$lastPercent` variable) — calling it on every chunk read (which can be thousands of times per second for a large file) adds needless overhead and console flicker for no visible benefit.
- `Content.Headers.ContentLength` can be `$null` (e.g. chunked transfer encoding, or a server that omits it) — guard for this and fall back to reporting a raw byte count instead of a percentage; don't assume it's always present.
- Always call `Write-Progress -Completed` in a `finally` block once the download loop ends (success or failure) — otherwise a stale progress bar can linger in the console/host after the script moves on or errors out.
