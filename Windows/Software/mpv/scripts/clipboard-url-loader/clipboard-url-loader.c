/*
 * clipboard-url-loader.c
 *
 * Native Windows mpv C plugin.
 *
 * Behavior
 * --------
 *   - Watches the clipboard only while mpv is idle or at EOF.
 *   - Monitoring is purely event-driven:
 *
 *         AddClipboardFormatListener()  ->  WM_CLIPBOARDUPDATE
 *
 *     There is no polling anywhere in this file.
 *
 *   - A newly copied HTTP/HTTPS URL is loaded with:
 *
 *         loadfile <url> replace
 *
 *   - After the load is queued, mpv's window is restored, brought to the
 *     foreground, activated, and given keyboard focus.
 *
 *   - Progress/diagnostics are printed through mpv's "print-text" command
 *     so they show up on mpv's own terminal/stdout instead of only being
 *     visible via OutputDebugString.
 *
 * File layout
 * -----------
 *   1.  Configuration
 *   2.  mpv identifiers
 *   3.  Shared (cross-thread) state
 *   4.  State owned exclusively by the listener thread
 *   5.  Atomic helpers
 *   6.  Console / mpv logging
 *   7.  URL helpers
 *   8.  Clipboard reading
 *   9.  Clipboard retry bookkeeping
 *  10.  Monitor state (armed/disarmed)
 *  11.  mpv window lookup
 *  12.  Focus handling
 *  13.  Loading URLs into mpv
 *  14.  Processing WM_CLIPBOARDUPDATE
 *  15.  Hidden Win32 listener window
 *  16.  Listener thread
 *  17.  Listener startup/shutdown
 *  18.  mpv property/event glue
 *  19.  mpv plugin entry point
 *
 * Windows build
 * -------------
 *   gcc -std=c17 -O2 -Wall -Wextra -Wpedantic -Werror \
 *       -I".\include" \
 *       -shared -static-libgcc \
 *       ".\clipboard-url-loader.c" \
 *       -o ".\clipboard-url-loader.dll" \
 *       -luser32
 */

#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0600
#endif

/*
 * windows.h must be included first, with WIN32_LEAN_AND_MEAN/NOMINMAX
 * defined immediately before it, or later system headers can pull in a
 * conflicting or bloated windows.h first. This intentionally deviates
 * from strict "standard headers before third-party" ordering.
 */
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

#define MPV_CPLUGIN_DYNAMIC_SYM
#include <mpv/client.h>

#include <limits.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <wctype.h>

/* =========================================================================
 * 1. Configuration
 * ========================================================================= */

#define MAX_URL_CHARS 32768

/*
 * OpenClipboard() can transiently fail because the app that just changed
 * the clipboard still has it open. These retries fire ONLY after a
 * WM_CLIPBOARDUPDATE notification -- this is not clipboard polling.
 */
#define CLIPBOARD_RETRY_TIMER_ID 1
#define CLIPBOARD_RETRY_MS 20
#define CLIPBOARD_RETRY_MAX 15

/*
 * A short bounded retry helps when Windows raises mpv's window before
 * activation/focus state has fully settled. Unrelated to clipboard
 * monitoring.
 */
#define FOCUS_RETRY_TIMER_ID 2
#define FOCUS_RETRY_MS 30
#define FOCUS_RETRY_MAX 15

/* Custom messages handled by our hidden Win32 message-only window. */
#define WM_APP_MONITOR_STATE (WM_APP + 1)
#define WM_APP_FOCUS_MPV (WM_APP + 2)

/* =========================================================================
 * 2. mpv identifiers
 * ========================================================================= */

enum
{
    OBS_IDLE_ACTIVE = 1,
    OBS_EOF_REACHED = 2,
    OBS_WINDOW_ID = 3
};

#define REQ_LOAD_URL UINT64_C(0x434C5501)
#define REQ_PRINT_TEXT UINT64_C(0x434C5502)

/* =========================================================================
 * 3. Shared (cross-thread) state
 * ========================================================================= */

static mpv_handle *g_mpv = NULL;

/* LONG flags below are touched only through Interlocked*. */
static volatile LONG g_shutting_down = 0;
static volatile LONG g_monitor_wanted = 0;
static volatile LONG g_focus_pending = 0;

/* HWND is pointer-sized; use Interlocked*Pointer rather than assume
 * `volatile` alone makes pointer writes visible across threads. */
static PVOID volatile g_listener_hwnd_atomic = NULL;

static HANDLE g_listener_thread = NULL;
static HANDLE g_listener_ready = NULL;
static DWORD g_listener_thread_id = 0;
static DWORD g_listener_error = ERROR_SUCCESS;

/* =========================================================================
 * 4. State owned exclusively by the listener thread
 * ========================================================================= */

static bool listener_armed = false;
static DWORD listener_last_sequence = 0;

/*
 * Last HTTP/HTTPS URL observed while monitoring. A single logical copy can
 * trigger more than one clipboard-sequence change, and some programs
 * rewrite identical clipboard contents later. Remembering the URL value
 * (not just the sequence number) prevents those no-op changes from being
 * replayed into mpv.
 */
static char *listener_last_clipboard_url = NULL;

static DWORD listener_pending_sequence = 0;
static UINT listener_clipboard_retry_count = 0;
static UINT listener_focus_retry_count = 0;

/* =========================================================================
 * 5. Atomic helpers
 * ========================================================================= */

static bool atomic_get_bool(volatile LONG *value)
{
    return InterlockedCompareExchange(value, 0, 0) != 0;
}

static HWND get_listener_hwnd(void)
{
    return (HWND)InterlockedCompareExchangePointer(&g_listener_hwnd_atomic, NULL, NULL);
}

static void set_listener_hwnd(HWND hwnd)
{
    InterlockedExchangePointer(&g_listener_hwnd_atomic, (PVOID)hwnd);
}

/* =========================================================================
 * 6. Console / mpv logging
 * ========================================================================= */

/*
 * Fallback path only, used when mpv can't be asked to print for us (e.g.
 * during shutdown, or if the command couldn't be queued).
 */
static void fallback_console_write(const char *line)
{
    if (!line)
    {
        return;
    }

    HANDLE output = GetStdHandle(STD_OUTPUT_HANDLE);

    if (output && output != INVALID_HANDLE_VALUE)
    {
        DWORD written = 0;

        /*
         * This is already the last-resort logging fallback (used when mpv
         * itself can't be asked to print), so there's nowhere further to
         * report a WriteFile failure to. The calls are still checked
         * rather than ignored outright; failures are swallowed here on
         * purpose since OutputDebugStringA below is the true fallback.
         */
        if (!WriteFile(output, line, (DWORD)strlen(line), &written, NULL))
        {
            /* Nothing more to do; fall through to OutputDebugStringA. */
        }
        if (!WriteFile(output, "\r\n", 2, &written, NULL))
        {
            /* Nothing more to do; fall through to OutputDebugStringA. */
        }
    }

    OutputDebugStringA(line);
    OutputDebugStringA("\n");
}

/*
 * Equivalent in purpose to Lua's msg.info()/msg.warn() for this plugin.
 * "print-text" writes through mpv's normal stdout handling; every message
 * is also mirrored to OutputDebugString so tools like DebugView can see it.
 */
static void log_message(const char *level, const char *fmt, ...)
{
    char body[2048];
    char line[2304];

    va_list ap;
    va_start(ap, fmt);
    vsnprintf(body, sizeof(body), fmt, ap);
    va_end(ap);
    body[sizeof(body) - 1] = '\0';

    snprintf(line, sizeof(line), "[clipboard-url-loader] %s: %s", level, body);
    line[sizeof(line) - 1] = '\0';

    OutputDebugStringA(line);
    OutputDebugStringA("\n");

    if (!g_mpv || atomic_get_bool(&g_shutting_down))
    {
        fallback_console_write(line);
        return;
    }

    /*
     * Array-form mpv commands don't perform property expansion, so
     * clipboard strings containing '$', braces, etc. are harmless here.
     */
    const char *args[] = {"print-text", line, NULL};

    if (mpv_command_async(g_mpv, REQ_PRINT_TEXT, args) < 0)
    {
        fallback_console_write(line);
    }
}

#define LOG_INFO(...) log_message("info", __VA_ARGS__)
#define LOG_WARN(...) log_message("warn", __VA_ARGS__)
#define LOG_ERROR(...) log_message("error", __VA_ARGS__)

/* =========================================================================
 * 7. URL helpers
 * ========================================================================= */

static bool is_space_char(wchar_t c)
{
    return iswspace((wint_t)c) != 0;
}

static bool forbidden_url_character(wchar_t c)
{
    return is_space_char(c) || c < 0x20 || c == 0x7f;
}

/* Case-insensitive; requires at least one character after the scheme. */
static bool has_http_scheme(const wchar_t *text, size_t length)
{
    if (length > 7 && _wcsnicmp(text, L"http://", 7) == 0)
    {
        return true;
    }

    if (length > 8 && _wcsnicmp(text, L"https://", 8) == 0)
    {
        return true;
    }

    return false;
}

static char *utf16_to_utf8(const wchar_t *text, size_t length)
{
    if (!text || length == 0 || length > INT_MAX)
    {
        return NULL;
    }

    int needed = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, text, (int)length,
                                     NULL, 0, NULL, NULL);
    if (needed <= 0)
    {
        return NULL;
    }

    char *result = malloc((size_t)needed + 1);
    if (!result)
    {
        return NULL;
    }

    int written = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, text, (int)length,
                                      result, needed, NULL, NULL);
    if (written != needed)
    {
        free(result);
        return NULL;
    }

    result[written] = '\0';
    return result;
}

/* =========================================================================
 * 8. Clipboard reading
 * ========================================================================= */

enum clipboard_result
{
    CLIPBOARD_RESULT_URL,
    CLIPBOARD_RESULT_NOT_URL,
    CLIPBOARD_RESULT_BUSY,
    CLIPBOARD_RESULT_ERROR
};

static enum clipboard_result read_clipboard_url(HWND owner, char **url_out)
{
    if (!url_out)
    {
        return CLIPBOARD_RESULT_ERROR;
    }

    *url_out = NULL;

    /* This also filters out clipboard changes carrying images, files, etc. */
    if (!IsClipboardFormatAvailable(CF_UNICODETEXT))
    {
        return CLIPBOARD_RESULT_NOT_URL;
    }

    if (!OpenClipboard(owner))
    {
        return CLIPBOARD_RESULT_BUSY;
    }

    enum clipboard_result result = CLIPBOARD_RESULT_ERROR;
    HGLOBAL block = (HGLOBAL)GetClipboardData(CF_UNICODETEXT);
    const wchar_t *text = NULL;

    if (!block)
    {
        result = CLIPBOARD_RESULT_NOT_URL;
        goto done;
    }

    SIZE_T bytes = GlobalSize(block);
    if (bytes < sizeof(wchar_t))
    {
        result = CLIPBOARD_RESULT_NOT_URL;
        goto done;
    }

    text = (const wchar_t *)GlobalLock(block);
    if (!text)
    {
        goto done;
    }

    size_t max_chars = bytes / sizeof(wchar_t);
    size_t length = 0;

    /* Don't trust the clipboard data to be terminated correctly. */
    while (length < max_chars && text[length] != L'\0')
    {
        ++length;
    }

    if (length == max_chars)
    {
        LOG_WARN("clipboard Unicode text was not NUL-terminated");
        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    size_t first = 0;
    size_t last = length;

    while (first < last && is_space_char(text[first]))
    {
        ++first;
    }

    while (last > first && is_space_char(text[last - 1]))
    {
        --last;
    }

    size_t url_length = last - first;

    if (url_length == 0)
    {
        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    if (url_length > MAX_URL_CHARS)
    {
        LOG_WARN("clipboard text is too large to be treated as a URL");
        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    if (!has_http_scheme(text + first, url_length))
    {
        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    for (size_t i = first; i < last; ++i)
    {
        if (forbidden_url_character(text[i]))
        {
            result = CLIPBOARD_RESULT_NOT_URL;
            goto unlock;
        }
    }

    *url_out = utf16_to_utf8(text + first, url_length);

    if (!*url_out)
    {
        LOG_ERROR("could not convert clipboard URL from UTF-16 to UTF-8");
        result = CLIPBOARD_RESULT_ERROR;
        goto unlock;
    }

    result = CLIPBOARD_RESULT_URL;

unlock:
    GlobalUnlock(block);

done:
    CloseClipboard();
    return result;
}

static bool listener_remember_clipboard_url(const char *url)
{
    if (!url)
    {
        free(listener_last_clipboard_url);
        listener_last_clipboard_url = NULL;
        return true;
    }

    size_t length = strlen(url);
    char *copy = malloc(length + 1);

    if (!copy)
    {
        return false;
    }

    memcpy(copy, url, length + 1);

    free(listener_last_clipboard_url);
    listener_last_clipboard_url = copy;

    return true;
}

static bool listener_clipboard_url_is_unchanged(const char *url)
{
    return url && listener_last_clipboard_url &&
           strcmp(url, listener_last_clipboard_url) == 0;
}

static void listener_refresh_clipboard_baseline(HWND hwnd)
{
    char *url = NULL;
    enum clipboard_result result = read_clipboard_url(hwnd, &url);

    switch (result)
    {
    case CLIPBOARD_RESULT_URL:
        if (!listener_remember_clipboard_url(url))
        {
            LOG_WARN("could not remember clipboard URL baseline");
        }
        free(url);
        break;

    case CLIPBOARD_RESULT_NOT_URL:
        listener_remember_clipboard_url(NULL);
        break;

    case CLIPBOARD_RESULT_BUSY:
    case CLIPBOARD_RESULT_ERROR:
        /*
         * Keep whatever URL was previously remembered. Forgetting it here
         * would let a later sequence-only update replay a URL we've
         * already seen.
         */
        break;
    }
}

/* =========================================================================
 * 9. Clipboard retry bookkeeping
 * ========================================================================= */

static void cancel_clipboard_retry(HWND hwnd)
{
    KillTimer(hwnd, CLIPBOARD_RETRY_TIMER_ID);
    listener_pending_sequence = 0;
    listener_clipboard_retry_count = 0;
}

/* =========================================================================
 * 10. Monitor state (armed/disarmed)
 * ========================================================================= */

static void listener_apply_monitor_state(HWND hwnd)
{
    bool wanted = atomic_get_bool(&g_monitor_wanted);

    if (wanted == listener_armed)
    {
        return;
    }

    cancel_clipboard_retry(hwnd);

    if (wanted)
    {
        /*
         * Establish a baseline the moment monitoring starts, so a URL that
         * was already sitting in the clipboard before playback began is
         * NOT auto-loaded.
         */
        listener_last_sequence = GetClipboardSequenceNumber();
        listener_refresh_clipboard_baseline(hwnd);
        listener_armed = true;

        LOG_INFO("waiting for URL");
    }
    else
    {
        listener_armed = false;
        LOG_INFO("stopped watching clipboard");
    }
}

static void request_monitor_state(bool enable)
{
    LONG wanted = enable ? 1 : 0;
    LONG previous = InterlockedExchange(&g_monitor_wanted, wanted);

    if (previous == wanted)
    {
        return;
    }

    HWND hwnd = get_listener_hwnd();

    if (hwnd)
    {
        PostMessageW(hwnd, WM_APP_MONITOR_STATE, 0, 0);
    }
}

/* =========================================================================
 * 11. mpv window lookup
 * ========================================================================= */

static HWND get_mpv_window(void)
{
    if (!g_mpv || atomic_get_bool(&g_shutting_down))
    {
        return NULL;
    }

    int64_t raw_window_id = 0;
    int r = mpv_get_property(g_mpv, "window-id", MPV_FORMAT_INT64, &raw_window_id);

    if (r < 0 || raw_window_id == 0)
    {
        return NULL;
    }

    HWND hwnd = (HWND)(intptr_t)raw_window_id;

    if (!IsWindow(hwnd))
    {
        return NULL;
    }

    /*
     * "window-id" should already be mpv's top-level window on Windows, but
     * walk to the root defensively in case the backend ever returns a child.
     */
    HWND root = GetAncestor(hwnd, GA_ROOT);

    if (root && IsWindow(root))
    {
        hwnd = root;
    }

    return hwnd;
}

/* =========================================================================
 * 12. Focus handling
 * ========================================================================= */

enum focus_result
{
    FOCUS_RESULT_SUCCESS,
    FOCUS_RESULT_NO_WINDOW,
    FOCUS_RESULT_FAILED
};

static bool window_has_keyboard_focus(HWND target, DWORD target_thread_id)
{
    GUITHREADINFO info;
    memset(&info, 0, sizeof(info));
    info.cbSize = sizeof(info);

    if (!GetGUIThreadInfo(target_thread_id, &info))
    {
        return false;
    }

    if (info.hwndFocus == target)
    {
        return true;
    }

    /* Focus on a child of mpv's window counts as focus belonging to mpv. */
    return info.hwndFocus && IsChild(target, info.hwndFocus);
}

static enum focus_result focus_mpv_once(void)
{
    HWND target = get_mpv_window();

    if (!target)
    {
        return FOCUS_RESULT_NO_WINDOW;
    }

    DWORD current_thread_id = GetCurrentThreadId();
    DWORD target_thread_id = GetWindowThreadProcessId(target, NULL);

    if (target_thread_id == 0)
    {
        return FOCUS_RESULT_FAILED;
    }

    HWND old_foreground = GetForegroundWindow();
    DWORD foreground_thread_id = 0;

    if (old_foreground)
    {
        foreground_thread_id = GetWindowThreadProcessId(old_foreground, NULL);
    }

    BOOL attached_foreground = FALSE;
    BOOL attached_target = FALSE;

    /*
     * This runs on our hidden-window message thread, so the caller is
     * guaranteed to own a Win32 message queue. Attach to whichever thread
     * currently owns foreground input first.
     */
    if (foreground_thread_id != 0 &&
        foreground_thread_id != current_thread_id &&
        foreground_thread_id != target_thread_id)
    {
        attached_foreground = AttachThreadInput(current_thread_id, foreground_thread_id, TRUE);

        if (!attached_foreground)
        {
            LOG_WARN("AttachThreadInput(foreground) failed: Windows error %lu", GetLastError());
        }
    }

    /* Attach to mpv's window thread -- this is what makes SetFocus() work. */
    if (target_thread_id != current_thread_id)
    {
        attached_target = AttachThreadInput(current_thread_id, target_thread_id, TRUE);

        if (!attached_target)
        {
            LOG_WARN("AttachThreadInput(mpv) failed: Windows error %lu", GetLastError());
        }
    }

    if (IsIconic(target))
    {
        ShowWindowAsync(target, SW_RESTORE);
    }
    else if (!IsWindowVisible(target))
    {
        ShowWindowAsync(target, SW_SHOW);
    }

    /* Make sure mpv is at the top of the normal Z order. */
    SetWindowPos(target, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW);

    /* Activates the top-level window if Windows permits foreground activation. */
    BOOL foreground_result = SetForegroundWindow(target);

    BringWindowToTop(target);

    /* SetActiveWindow/SetFocus need the input queues connected when the
     * target belongs to another GUI thread. */
    if (target_thread_id == current_thread_id || attached_target)
    {
        SetActiveWindow(target);
        SetFocus(target);
    }

    /*
     * A second call after SetFocus is intentional -- in practice it helps
     * re-synchronize activation/focus if restoring the window caused an
     * activation transition.
     */
    SetForegroundWindow(target);

    /* Detach in reverse order. */
    if (attached_target)
    {
        AttachThreadInput(current_thread_id, target_thread_id, FALSE);
    }

    if (attached_foreground)
    {
        AttachThreadInput(current_thread_id, foreground_thread_id, FALSE);
    }

    HWND current_foreground = GetForegroundWindow();
    bool foreground_ok = current_foreground == target;

    if (!foreground_ok && current_foreground)
    {
        HWND root = GetAncestor(current_foreground, GA_ROOT);
        foreground_ok = root == target;
    }

    bool focus_ok = window_has_keyboard_focus(target, target_thread_id);

    if (foreground_ok && focus_ok)
    {
        LOG_INFO("mpv focused successfully (foreground=yes, keyboard-focus=yes)");
        return FOCUS_RESULT_SUCCESS;
    }

    LOG_WARN("focus attempt incomplete (SetForegroundWindow=%s, foreground=%s, keyboard-focus=%s)",
             foreground_result ? "yes" : "no",
             foreground_ok ? "yes" : "no",
             focus_ok ? "yes" : "no");

    return FOCUS_RESULT_FAILED;
}

static void cancel_focus_retry(HWND hwnd)
{
    KillTimer(hwnd, FOCUS_RETRY_TIMER_ID);
    listener_focus_retry_count = 0;
}

static void process_focus_request(HWND hwnd, bool new_request)
{
    if (!atomic_get_bool(&g_focus_pending) || atomic_get_bool(&g_shutting_down))
    {
        cancel_focus_retry(hwnd);
        return;
    }

    if (new_request)
    {
        cancel_focus_retry(hwnd);
        LOG_INFO("attempting to focus mpv window");
    }

    enum focus_result result = focus_mpv_once();

    if (result == FOCUS_RESULT_SUCCESS)
    {
        InterlockedExchange(&g_focus_pending, 0);
        cancel_focus_retry(hwnd);
        return;
    }

    /*
     * If mpv hasn't created its HWND yet, don't blindly poll for it --
     * window-id/file-loaded/video-reconfig events will trigger another
     * WM_APP_FOCUS_MPV later.
     */
    if (result == FOCUS_RESULT_NO_WINDOW)
    {
        cancel_focus_retry(hwnd);
        LOG_INFO("mpv window is not available yet; waiting for window creation");
        return;
    }

    if (listener_focus_retry_count >= FOCUS_RETRY_MAX)
    {
        cancel_focus_retry(hwnd);
        InterlockedExchange(&g_focus_pending, 0);
        LOG_WARN("could not acquire keyboard focus after %u attempts", FOCUS_RETRY_MAX + 1);
        return;
    }

    ++listener_focus_retry_count;

    if (!SetTimer(hwnd, FOCUS_RETRY_TIMER_ID, FOCUS_RETRY_MS, NULL))
    {
        LOG_WARN("could not schedule focus retry: Windows error %lu", GetLastError());
        cancel_focus_retry(hwnd);
        InterlockedExchange(&g_focus_pending, 0);
    }
}

static void request_focus(void)
{
    if (!atomic_get_bool(&g_focus_pending))
    {
        return;
    }

    HWND hwnd = get_listener_hwnd();

    if (hwnd)
    {
        PostMessageW(hwnd, WM_APP_FOCUS_MPV, 0, 0);
    }
}

/* =========================================================================
 * 13. Loading URLs into mpv
 * ========================================================================= */

static bool queue_url_load(HWND listener_hwnd, const char *url)
{
    if (!g_mpv || !url || atomic_get_bool(&g_shutting_down))
    {
        return false;
    }

    LOG_INFO("loading URL: %s", url);

    /* Stop accepting further clipboard URLs immediately. */
    InterlockedExchange(&g_monitor_wanted, 0);
    listener_apply_monitor_state(listener_hwnd);

    InterlockedExchange(&g_focus_pending, 1);

    const char *args[] = {"loadfile", url, "replace", NULL};
    int r = mpv_command_async(g_mpv, REQ_LOAD_URL, args);

    if (r < 0)
    {
        LOG_ERROR("could not queue loadfile: %s", mpv_error_string(r));

        InterlockedExchange(&g_focus_pending, 0);

        /* We were armed immediately before this failed, so restore monitoring. */
        InterlockedExchange(&g_monitor_wanted, 1);
        listener_apply_monitor_state(listener_hwnd);

        return false;
    }

    /*
     * If force-window/idle already left an HWND alive, focusing can
     * succeed immediately without waiting for playback to start.
     */
    process_focus_request(listener_hwnd, true);

    return true;
}

/* =========================================================================
 * 14. Processing WM_CLIPBOARDUPDATE
 * ========================================================================= */

static void process_pending_clipboard(HWND hwnd)
{
    KillTimer(hwnd, CLIPBOARD_RETRY_TIMER_ID);

    if (atomic_get_bool(&g_shutting_down) || !listener_armed)
    {
        cancel_clipboard_retry(hwnd);
        return;
    }

    DWORD current_sequence = GetClipboardSequenceNumber();

    /*
     * The clipboard changed again while we were waiting for
     * OpenClipboard(); the newer WM_CLIPBOARDUPDATE is authoritative.
     */
    if (listener_pending_sequence != 0 && current_sequence != listener_pending_sequence)
    {
        cancel_clipboard_retry(hwnd);
        return;
    }

    char *url = NULL;
    enum clipboard_result result = read_clipboard_url(hwnd, &url);

    switch (result)
    {
    case CLIPBOARD_RESULT_URL:
        cancel_clipboard_retry(hwnd);

        if (listener_clipboard_url_is_unchanged(url))
        {
            /*
             * The sequence number changed but the URL text didn't -- this
             * happens when a copy publishes formats in stages, or another
             * program republishes the existing clipboard contents.
             */
            free(url);
            break;
        }

        if (!listener_remember_clipboard_url(url))
        {
            LOG_WARN("could not remember clipboard URL for deduplication");
        }

        LOG_INFO("clipboard change detected");
        queue_url_load(hwnd, url);
        free(url);
        break;

    case CLIPBOARD_RESULT_NOT_URL:
        cancel_clipboard_retry(hwnd);

        /*
         * A non-URL clipboard value breaks the dedup chain, so copying the
         * same URL again afterward is treated as a new URL.
         */
        listener_remember_clipboard_url(NULL);
        LOG_INFO("clipboard changed, but it is not an HTTP/HTTPS URL");
        break;

    case CLIPBOARD_RESULT_ERROR:
        cancel_clipboard_retry(hwnd);
        LOG_WARN("could not read clipboard text");
        break;

    case CLIPBOARD_RESULT_BUSY:
        if (listener_clipboard_retry_count >= CLIPBOARD_RETRY_MAX)
        {
            LOG_WARN("clipboard remained locked after change notification");
            cancel_clipboard_retry(hwnd);
            return;
        }

        ++listener_clipboard_retry_count;

        if (!SetTimer(hwnd, CLIPBOARD_RETRY_TIMER_ID, CLIPBOARD_RETRY_MS, NULL))
        {
            LOG_WARN("could not schedule clipboard retry: Windows error %lu", GetLastError());
            cancel_clipboard_retry(hwnd);
        }

        break;
    }
}

static void handle_clipboard_update(HWND hwnd)
{
    DWORD sequence = GetClipboardSequenceNumber();

    if (sequence == listener_last_sequence)
    {
        return;
    }

    listener_last_sequence = sequence;
    cancel_clipboard_retry(hwnd);

    /*
     * Changes during normal playback are ignored, but the sequence number
     * above is still updated so they don't look "new" once monitoring
     * resumes later.
     */
    if (!listener_armed)
    {
        return;
    }

    listener_pending_sequence = sequence;
    listener_clipboard_retry_count = 0;

    process_pending_clipboard(hwnd);
}

/* =========================================================================
 * 15. Hidden Win32 listener window
 * ========================================================================= */

static LRESULT CALLBACK clipboard_window_proc(HWND hwnd, UINT message, WPARAM wparam,
                                              LPARAM lparam)
{
    (void)lparam;

    switch (message)
    {
    case WM_CLIPBOARDUPDATE:
        handle_clipboard_update(hwnd);
        return 0;

    case WM_APP_MONITOR_STATE:
        listener_apply_monitor_state(hwnd);
        return 0;

    case WM_APP_FOCUS_MPV:
        process_focus_request(hwnd, true);
        return 0;

    case WM_TIMER:
        if (wparam == CLIPBOARD_RETRY_TIMER_ID)
        {
            process_pending_clipboard(hwnd);
            return 0;
        }

        if (wparam == FOCUS_RETRY_TIMER_ID)
        {
            process_focus_request(hwnd, false);
            return 0;
        }

        break;

    case WM_CLOSE:
        cancel_clipboard_retry(hwnd);
        cancel_focus_retry(hwnd);
        RemoveClipboardFormatListener(hwnd);
        DestroyWindow(hwnd);
        return 0;

    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;

    default:
        break;
    }

    return DefWindowProcW(hwnd, message, wparam, lparam);
}

/* =========================================================================
 * 16. Listener thread
 * ========================================================================= */

static DWORD WINAPI clipboard_listener_main(void *userdata)
{
    (void)userdata;

    HINSTANCE instance = GetModuleHandleW(NULL);
    wchar_t class_name[128];

    swprintf(class_name, sizeof(class_name) / sizeof(class_name[0]),
             L"mpv_clipboard_url_loader_%lu", GetCurrentThreadId());

    WNDCLASSW wc;
    memset(&wc, 0, sizeof(wc));
    wc.lpfnWndProc = clipboard_window_proc;
    wc.hInstance = instance;
    wc.lpszClassName = class_name;

    if (!RegisterClassW(&wc))
    {
        g_listener_error = GetLastError();
        SetEvent(g_listener_ready);
        return 1;
    }

    /*
     * Message-only window: invisible, no taskbar entry, exists solely to
     * receive WM_CLIPBOARDUPDATE and our private app messages.
     */
    HWND hwnd = CreateWindowExW(0, class_name, L"", 0, 0, 0, 0, 0,
                                HWND_MESSAGE, NULL, instance, NULL);

    if (!hwnd)
    {
        g_listener_error = GetLastError();
        UnregisterClassW(class_name, instance);
        SetEvent(g_listener_ready);
        return 1;
    }

    if (!AddClipboardFormatListener(hwnd))
    {
        g_listener_error = GetLastError();
        DestroyWindow(hwnd);
        UnregisterClassW(class_name, instance);
        SetEvent(g_listener_ready);
        return 1;
    }

    listener_last_sequence = GetClipboardSequenceNumber();
    set_listener_hwnd(hwnd);
    g_listener_error = ERROR_SUCCESS;
    SetEvent(g_listener_ready);

    LOG_INFO("Win32 clipboard listener started");

    /* Apply any monitor state that was requested just before we became ready. */
    listener_apply_monitor_state(hwnd);

    MSG message;

    for (;;)
    {
        BOOL r = GetMessageW(&message, NULL, 0, 0);

        if (r == 0)
        {
            break;
        }

        if (r == -1)
        {
            LOG_ERROR("GetMessage failed: Windows error %lu", GetLastError());
            break;
        }

        TranslateMessage(&message);
        DispatchMessageW(&message);
    }

    if (IsWindow(hwnd))
    {
        cancel_clipboard_retry(hwnd);
        cancel_focus_retry(hwnd);
        RemoveClipboardFormatListener(hwnd);
        DestroyWindow(hwnd);
    }

    set_listener_hwnd(NULL);

    free(listener_last_clipboard_url);
    listener_last_clipboard_url = NULL;

    UnregisterClassW(class_name, instance);

    return 0;
}

/* =========================================================================
 * 17. Listener startup/shutdown
 * ========================================================================= */

static bool start_clipboard_listener(void)
{
    g_listener_ready = CreateEventW(NULL, TRUE, FALSE, NULL);

    if (!g_listener_ready)
    {
        LOG_ERROR("CreateEvent failed: Windows error %lu", GetLastError());
        return false;
    }

    g_listener_thread = CreateThread(NULL, 0, clipboard_listener_main, NULL, 0,
                                     &g_listener_thread_id);

    if (!g_listener_thread)
    {
        LOG_ERROR("CreateThread failed: Windows error %lu", GetLastError());
        CloseHandle(g_listener_ready);
        g_listener_ready = NULL;
        return false;
    }

    WaitForSingleObject(g_listener_ready, INFINITE);

    if (!get_listener_hwnd())
    {
        LOG_ERROR("could not initialize Win32 clipboard listener: Windows error %lu",
                  g_listener_error);

        WaitForSingleObject(g_listener_thread, INFINITE);
        CloseHandle(g_listener_thread);
        g_listener_thread = NULL;

        CloseHandle(g_listener_ready);
        g_listener_ready = NULL;

        return false;
    }

    return true;
}

static void stop_clipboard_listener(void)
{
    InterlockedExchange(&g_shutting_down, 1);
    InterlockedExchange(&g_monitor_wanted, 0);
    InterlockedExchange(&g_focus_pending, 0);

    HWND hwnd = get_listener_hwnd();

    if (hwnd)
    {
        if (!PostMessageW(hwnd, WM_CLOSE, 0, 0) && g_listener_thread_id != 0)
        {
            /* Last-resort shutdown if the window vanished between lookup and post. */
            PostThreadMessageW(g_listener_thread_id, WM_QUIT, 0, 0);
        }
    }
    else if (g_listener_thread_id != 0)
    {
        PostThreadMessageW(g_listener_thread_id, WM_QUIT, 0, 0);
    }

    if (g_listener_thread)
    {
        WaitForSingleObject(g_listener_thread, INFINITE);
        CloseHandle(g_listener_thread);
        g_listener_thread = NULL;
    }

    if (g_listener_ready)
    {
        CloseHandle(g_listener_ready);
        g_listener_ready = NULL;
    }

    g_listener_thread_id = 0;
}

/* =========================================================================
 * 18. mpv property/event glue
 * ========================================================================= */

static void update_monitor_state(bool idle_active, bool eof_reached)
{
    if (atomic_get_bool(&g_shutting_down))
    {
        request_monitor_state(false);
        return;
    }

    request_monitor_state(idle_active || eof_reached);
}

static void handle_property_change(mpv_event *event, bool *idle_active, bool *eof_reached)
{
    mpv_event_property *property = (mpv_event_property *)event->data;

    if (!property)
    {
        return;
    }

    switch (event->reply_userdata)
    {
    case OBS_IDLE_ACTIVE:
        *idle_active = property->format == MPV_FORMAT_FLAG && property->data &&
                       (*(int *)property->data) != 0;
        update_monitor_state(*idle_active, *eof_reached);
        break;

    case OBS_EOF_REACHED:
        *eof_reached = property->format == MPV_FORMAT_FLAG && property->data &&
                       (*(int *)property->data) != 0;
        update_monitor_state(*idle_active, *eof_reached);
        break;

    case OBS_WINDOW_ID:
        /*
         * We don't need event->data here -- the change itself tells us an
         * HWND may now exist. The focus path re-reads window-id itself.
         */
        if (atomic_get_bool(&g_focus_pending))
        {
            request_focus();
        }
        break;

    default:
        break;
    }
}

/* =========================================================================
 * 19. mpv plugin entry point
 * ========================================================================= */

MPV_EXPORT int mpv_open_cplugin(mpv_handle *handle)
{
    g_mpv = handle;

    LOG_INFO("plugin loaded");
    LOG_INFO("clipboard monitoring mode: event-driven WM_CLIPBOARDUPDATE");

    if (mpv_observe_property(handle, OBS_IDLE_ACTIVE, "idle-active", MPV_FORMAT_FLAG) < 0)
    {
        LOG_ERROR("cannot observe idle-active");
        g_mpv = NULL;
        return -1;
    }

    if (mpv_observe_property(handle, OBS_EOF_REACHED, "eof-reached", MPV_FORMAT_FLAG) < 0)
    {
        LOG_ERROR("cannot observe eof-reached");
        g_mpv = NULL;
        return -1;
    }

    /* URL loading still works without this one; FILE_LOADED and
     * VIDEO_RECONFIG also trigger focus attempts. */
    if (mpv_observe_property(handle, OBS_WINDOW_ID, "window-id", MPV_FORMAT_INT64) < 0)
    {
        LOG_WARN("cannot observe window-id");
    }

    mpv_request_event(handle, MPV_EVENT_START_FILE, 1);
    mpv_request_event(handle, MPV_EVENT_FILE_LOADED, 1);
    mpv_request_event(handle, MPV_EVENT_END_FILE, 1);
    mpv_request_event(handle, MPV_EVENT_VIDEO_RECONFIG, 1);
    mpv_request_event(handle, MPV_EVENT_COMMAND_REPLY, 1);
    mpv_request_event(handle, MPV_EVENT_PROPERTY_CHANGE, 1);

    if (!start_clipboard_listener())
    {
        LOG_ERROR("plugin initialization failed");
        g_mpv = NULL;
        return -1;
    }

    bool idle_active = false;
    bool eof_reached = false;

    /*
     * A C plugin must stay inside mpv_open_cplugin() for its whole
     * lifetime, so this loop is our normal mpv event loop.
     */
    for (;;)
    {
        mpv_event *event = mpv_wait_event(handle, -1);

        switch (event->event_id)
        {
        case MPV_EVENT_PROPERTY_CHANGE:
            handle_property_change(event, &idle_active, &eof_reached);
            break;

        case MPV_EVENT_START_FILE:
            /* Disable monitoring immediately rather than waiting for
             * idle-active/eof-reached notifications to catch up. */
            idle_active = false;
            eof_reached = false;
            request_monitor_state(false);

            LOG_INFO("file loading started");

            if (atomic_get_bool(&g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_COMMAND_REPLY:
            if (event->reply_userdata == REQ_LOAD_URL)
            {
                if (event->error < 0)
                {
                    LOG_ERROR("loadfile failed: %s", mpv_error_string(event->error));
                    InterlockedExchange(&g_focus_pending, 0);
                    update_monitor_state(idle_active, eof_reached);
                }
                else
                {
                    LOG_INFO("loadfile command accepted");

                    if (atomic_get_bool(&g_focus_pending))
                    {
                        request_focus();
                    }
                }
            }
            /* REQ_PRINT_TEXT replies are intentionally ignored. */
            break;

        case MPV_EVENT_FILE_LOADED:
            LOG_INFO("file loaded");

            if (atomic_get_bool(&g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_VIDEO_RECONFIG:
            /* Another good point at which the Win32 video window likely exists. */
            if (atomic_get_bool(&g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_END_FILE:
            /* idle-active/eof-reached observations decide whether
             * monitoring needs to resume. */
            break;

        case MPV_EVENT_SHUTDOWN:
            goto shutdown;

        default:
            break;
        }
    }

shutdown:
    LOG_INFO("plugin shutting down");

    stop_clipboard_listener();

    /* mpv owns the handle passed to mpv_open_cplugin(); do NOT call mpv_destroy(). */
    g_mpv = NULL;

    return 0;
}