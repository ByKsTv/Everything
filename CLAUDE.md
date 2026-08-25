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

## Robustness

- Validate that a regex/parse actually matched before using the result (e.g. don't let an empty string silently become `[version]''` and throw a cryptic error) — throw a clear, specific error message instead.
- Wrap resource-holding logic (`HttpClient`, file handles) in `try { } finally { }` to guarantee disposal even on early exit/throw.
- After starting an external process (e.g. an installer), call `.WaitForExit()` and check `.ExitCode` rather than firing-and-forgetting — the script should know if the operation actually succeeded.
- Clean up temp files only after confirmed success, so a failed run leaves artifacts for debugging.
- Set TLS explicitly (`[Net.ServicePointManager]::SecurityProtocol = Tls12`) when targeting older/locked-down Windows PowerShell 5.1 environments, where the default can be TLS 1.0.
- Set an explicit `User-Agent` header on HTTP requests — some servers reject requests with missing/default .NET user-agents.
- Fail fast with a clear message for known failure modes (e.g. not running elevated when installing to `Program Files`) instead of letting a downstream step fail confusingly.

## Parsing/matching resilience

- Don't assume a fixed quote style in HTML/text parsing (e.g. match both `"` and `'` around attribute values) — minifiers/CMS changes can flip this silently.

## UX / output

- Don't hard-code console `BackgroundColor` — it overrides the user's terminal theme (light theme, transparency, etc.). Only set `ForegroundColor` unless a background is truly necessary.
- Report outcomes explicitly (e.g. "already up to date", "installed successfully") rather than only logging on the action-taken path.

## Reusability

- Parameterize hard-coded values (URLs, names, paths) via `param()` blocks so the script can be reused for similar tasks without editing the body.
