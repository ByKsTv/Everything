# C Coding Standards

This document defines the coding conventions for C code in this repository. It applies to human contributors and AI coding assistants alike. Follow it unless a file already uses a different, consistent local style — in that case, match the surrounding code rather than mixing conventions.

## 1. Language Version & Portability

- Target **C11** unless the project specifies otherwise. Avoid compiler-specific extensions (`__attribute__`, MSVC pragmas) unless wrapped in a portability macro.
- Do not assume a specific platform (Linux/Windows/macOS) unless the module is explicitly platform-specific. Guard platform code with `#ifdef` and isolate it in its own file.
- Avoid undefined behavior: no signed integer overflow, no strict-aliasing violations, no use of uninitialized variables, no out-of-bounds access.

## 2. File Organization

- One module = one `.c`/`.h` pair. Header files declare the public interface; nothing in a header should be private implementation detail.
- Every header must have include guards:

  ```c
  #ifndef PROJECT_MODULE_NAME_H
  #define PROJECT_MODULE_NAME_H
  /* ... */
  #endif /* PROJECT_MODULE_NAME_H */
  ```

- Include order: standard library headers, then third-party headers, then project headers — each group separated by a blank line, alphabetized within the group.
- Keep source files focused. If a `.c` file exceeds ~800 lines or handles more than one clear responsibility, split it.

## 3. Naming Conventions

| Element                           | Convention                         | Example                  |
| --------------------------------- | ---------------------------------- | ------------------------ |
| Functions                         | `snake_case`, verb-first           | `parse_config_file()`    |
| Variables                         | `snake_case`                       | `retry_count`            |
| Constants / macros                | `UPPER_SNAKE_CASE`                 | `MAX_BUFFER_SIZE`        |
| Types (`struct`/`enum`/`typedef`) | `snake_case_t` suffix              | `connection_state_t`     |
| File-static (private) functions   | prefix with module name            | `buffer_grow_internal()` |
| Global variables                  | avoid; if unavoidable, prefix `g_` | `g_log_level`            |

Names should be descriptive, not clever. Avoid single-letter names outside tight loop counters (`i`, `j`, `k`). No Hungarian notation.

## 4. Formatting

- Indent with **4 spaces**, no tabs.
- Line length: **100 characters** max.
- Braces: opening brace on the same line for functions and control statements (K&R style):

  ```c
  int compute_total(int a, int b) {
      if (a > b) {
          return a;
      }
      return b;
  }
  ```

- Always use braces for `if`/`else`/`for`/`while`, even single-statement bodies.
- One statement per line. One blank line between functions.
- Pointer declarations bind to the variable, not the type: `int *ptr`, not `int* ptr`.

## 5. Functions

- A function should do one thing. If you can't summarize it in one sentence, split it.
- Prefer functions under ~50 lines. Longer functions need a strong justification (e.g., a state machine `switch`).
- Limit parameters to ~5. Beyond that, group related parameters into a `struct`.
- Every function with non-obvious behavior gets a comment above it stating: purpose, ownership/lifetime of any pointer parameters or return values, and error conditions.
- Validate arguments at public API boundaries. Internal/static helpers may assume pre-validated input if documented.

## 6. Memory Management

- Every `malloc`/`calloc`/`realloc` must have a matching `free`, with a clear, documented owner.
- Check every allocation for `NULL` before use.
- Set pointers to `NULL` immediately after freeing them.
- Prefer stack allocation and fixed-size buffers when size is bounded and known at compile time.
- Never return a pointer to a local (stack) variable.
- Use a consistent ownership convention: functions that return heap memory the caller must free should be named or documented accordingly (e.g., `*_create()` / `*_destroy()` pairs, or `_dup`, `_new` naming).

## 7. Error Handling

- Never ignore a return value that signals success/failure (`malloc`, `fopen`, `read`, `write`, etc.). Explicitly cast to `(void)` only when ignoring is intentional and safe, and add a comment saying why.
- Prefer returning an error code / status enum over `errno`-style globals, unless wrapping a POSIX API.
- Fail fast and clean up with `goto cleanup` / `goto fail` patterns rather than duplicating teardown logic:

  ```c
  int result = -1;
  FILE *fp = fopen(path, "r");
  if (!fp) {
      goto out;
  }
  buffer = malloc(size);
  if (!buffer) {
      goto close_file;
  }
  /* ... work ... */
  result = 0;
  close_file:
  fclose(fp);
  out:
  return result;
  ```

- Never silently swallow errors. Log or propagate them.

## 8. Types & Data

- Use fixed-width integer types (`int32_t`, `uint8_t`, `size_t`) from `<stdint.h>` for anything where size matters (protocol data, buffer indices, serialization).
- Use `const` aggressively: parameters not modified by a function, pointers to read-only data, and local variables that don't change.
- Avoid global mutable state. If shared state is required, document thread-safety and access rules explicitly.
- Prefer `enum` over raw `#define` integer constants for related sets of values.
- Avoid magic numbers; name them via `const` or `#define`.

## 9. Strings & Buffers

- Never use `gets`, `strcpy`, `strcat`, `sprintf`, or other unbounded string functions. Use `snprintf`, `strncpy` (with explicit null-termination), or safer equivalents.
- Always know and check buffer sizes before writing. Prefer passing buffer length alongside buffer pointer.
- Check `snprintf` return value against the buffer size to detect truncation.

## 10. Comments & Documentation

- Comments explain **why**, not what — the code already says what.
- Every public function in a header gets a Doxygen-style comment:

  ```c
  /**
   * @brief Parses a configuration file into a config struct.
   *
   * @param path   Path to the config file. Must not be NULL.
   * @param out    Output struct, populated on success.
   * @return 0 on success, negative error code on failure.
   */
  int config_parse(const char *path, config_t *out);
  ```

- Avoid commented-out dead code in commits. Delete it — version control remembers it.
- `TODO`/`FIXME` comments must include an owner or ticket reference: `// TODO(alice): handle IPv6 case (JIRA-123)`.

## 11. Testing

- New logic (especially parsing, math, buffer manipulation, and error paths) should include unit tests.
- Tests must cover the error/edge paths, not just the happy path: NULL inputs, zero-length buffers, allocation failure where feasible, boundary values.
- Keep tests deterministic — no reliance on timing, uninitialized memory, or external network state.

## 12. Compiler Hygiene

- Code must compile warning-free with:

  ```bash
  -Wall -Wextra -Wpedantic -Werror
  ```

- Treat warnings as bugs, not noise. Do not suppress a warning without a comment explaining why it's a false positive.
- Run static analysis (`clang-tidy`, `cppcheck`, or the project's configured linter) before submitting; fix or justify every flagged issue.
- Where available, prefer building with sanitizers during development/testing (`-fsanitize=address,undefined`).

## 13. Guidance for AI Assistants Specifically

When generating or modifying C code in this repo, an AI assistant must:

1. Follow every rule above without exception unless the user explicitly overrides it.
2. Never introduce unbounded string/memory functions (`strcpy`, `sprintf`, `gets`, etc.).
3. Always pair allocation with a documented deallocation path; never leave an obvious leak "for the user to handle" without flagging it.
4. Check all return values from I/O and allocation calls; never silently discard them.
5. State any assumption made about undocumented behavior (e.g., thread-safety, ownership) directly in a comment rather than guessing silently.
6. Prefer clarity over cleverness — no obscure macro tricks, no unnecessary bit-twiddling, no unexplained one-liners.
7. When modifying existing code, match the file's existing style even where it deviates slightly from this document, and note the deviation if asked.
8. Flag (in a comment or a message to the user) any place where fully satisfying this document isn't possible without more context — do not silently make a risky choice on memory ownership, concurrency, or security-sensitive parsing.

## 14. Security Baseline

- Treat all external input (files, network, CLI args, environment variables) as untrusted. Validate lengths, ranges, and encoding before use.
- Avoid integer operations that can overflow when used for buffer sizes or loop bounds; check before multiplying/adding into an allocation size.
- Do not build format strings from user input: `printf(user_input)` is forbidden — use `printf("%s", user_input)`.
- Avoid `system()`/`popen()` with any input derived from untrusted sources; if shelling out is required, use `execve`-family calls with an explicit argument list.

---

_Keep this document short enough to actually be read. If a rule stops making sense for the project, change the rule here — don't let practice and documentation drift apart._
