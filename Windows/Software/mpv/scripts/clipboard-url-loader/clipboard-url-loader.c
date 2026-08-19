/*
 * clipboard-url-loader.c
 *
 * Native Windows mpv C plugin.
 *
 * Behavior:
 *   - Watches clipboard changes only while mpv is idle or at EOF.
 *   - Clipboard monitoring is event-driven:
 *
 *         AddClipboardFormatListener()
 *             -> WM_CLIPBOARDUPDATE
 *
 *   - Newly copied HTTP/HTTPS URLs are loaded with:
 *
 *         loadfile <url> replace
 *
 *   - mpv is restored, brought to the foreground, activated, and given
 *     keyboard focus.
 *
 *   - Progress is printed through mpv's "print-text" command, so it appears
 *     on mpv's terminal/stdout rather than relying on the DLL's stderr.
 *
 * Windows build:
 *
 *   gcc -std=c17 -O2 -Wall -Wextra -Wpedantic \
 *       -I".\include" \
 *       -shared -static-libgcc \
 *       ".\clipboard-url-loader.c" \
 *       -o ".\clipboard-url-loader.dll" \
 *       -luser32
 */

#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0600
#endif

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

#define MPV_CPLUGIN_DYNAMIC_SYM
#include <mpv/client.h>

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <wchar.h>
#include <wctype.h>
#include <limits.h>

/* -------------------------------------------------------------------------
 * Configuration
 * ------------------------------------------------------------------------- */

#define MAX_URL_CHARS 32768

/*
 * OpenClipboard() can temporarily fail because the application which just
 * changed the clipboard still has it open.
 *
 * These retries happen ONLY after WM_CLIPBOARDUPDATE. This is not clipboard
 * polling.
 */
#define CLIPBOARD_RETRY_TIMER_ID 1
#define CLIPBOARD_RETRY_MS 20
#define CLIPBOARD_RETRY_MAX 15

/*
 * A short bounded retry is useful if Windows brings mpv forward first and
 * updates activation/focus state slightly afterward.
 *
 * This timer has nothing to do with clipboard monitoring.
 */
#define FOCUS_RETRY_TIMER_ID 2
#define FOCUS_RETRY_MS 30
#define FOCUS_RETRY_MAX 15

/* Custom messages processed by our hidden Win32 message window. */
#define WM_APP_MONITOR_STATE (WM_APP + 1)
#define WM_APP_FOCUS_MPV (WM_APP + 2)

/* -------------------------------------------------------------------------
 * mpv identifiers
 * ------------------------------------------------------------------------- */

enum
{
    OBS_IDLE_ACTIVE = 1,
    OBS_EOF_REACHED = 2,
    OBS_WINDOW_ID = 3
};

#define REQ_LOAD_URL UINT64_C(0x434C5501)
#define REQ_PRINT_TEXT UINT64_C(0x434C5502)

/* -------------------------------------------------------------------------
 * Shared state
 * ------------------------------------------------------------------------- */

static mpv_handle *g_mpv = NULL;

/*
 * Accessed from multiple threads.
 *
 * LONG values are manipulated only through Interlocked*.
 */
static volatile LONG g_shutting_down = 0;
static volatile LONG g_monitor_wanted = 0;
static volatile LONG g_focus_pending = 0;

/*
 * HWND is pointer-sized, so use Interlocked*Pointer rather than assuming
 * pointer writes are synchronised by volatile.
 */
static PVOID volatile g_listener_hwnd_atomic = NULL;

static HANDLE g_listener_thread = NULL;
static HANDLE g_listener_ready = NULL;
static DWORD g_listener_thread_id = 0;
static DWORD g_listener_error = ERROR_SUCCESS;

/* -------------------------------------------------------------------------
 * State owned exclusively by the Win32 listener thread
 * ------------------------------------------------------------------------- */

static bool listener_armed = false;
static DWORD listener_last_sequence = 0;

/*
 * Last HTTP/HTTPS URL observed while monitoring.  Clipboard sequence numbers
 * can change more than once for one logical copy operation, and some programs
 * can rewrite the same clipboard contents later.  Remembering the URL value
 * prevents those sequence-only changes from replaying it.
 *
 * Owned exclusively by the listener thread.
 */
static char *listener_last_clipboard_url = NULL;

static DWORD listener_pending_sequence = 0;
static UINT listener_clipboard_retry_count = 0;

static UINT listener_focus_retry_count = 0;

/* -------------------------------------------------------------------------
 * Atomic helpers
 * ------------------------------------------------------------------------- */

static bool atomic_get_bool(volatile LONG *value)
{
    return InterlockedCompareExchange(value, 0, 0) != 0;
}

static HWND get_listener_hwnd(void)
{
    return (HWND)InterlockedCompareExchangePointer(
        &g_listener_hwnd_atomic,
        NULL,
        NULL);
}

static void set_listener_hwnd(HWND hwnd)
{
    InterlockedExchangePointer(
        &g_listener_hwnd_atomic,
        (PVOID)hwnd);
}

/* -------------------------------------------------------------------------
 * Console logging
 * ------------------------------------------------------------------------- */

/*
 * Fallback only.
 *
 * Normally log_message() uses mpv's print-text command. This fallback is
 * useful if mpv is already shutting down or the command cannot be queued.
 */
static void fallback_console_write(const char *line)
{
    if (!line)
        return;

    HANDLE output = GetStdHandle(STD_OUTPUT_HANDLE);

    if (output &&
        output != INVALID_HANDLE_VALUE)
    {
        DWORD ignored = 0;

        WriteFile(
            output,
            line,
            (DWORD)strlen(line),
            &ignored,
            NULL);

        WriteFile(
            output,
            "\r\n",
            2,
            &ignored,
            NULL);
    }

    OutputDebugStringA(line);
    OutputDebugStringA("\n");
}

/*
 * Equivalent in purpose to Lua's msg.info()/msg.warn() for this plugin.
 *
 * mpv's "print-text" command writes through mpv's normal stdout handling.
 */
static void log_message(const char *level, const char *fmt, ...)
{
    char body[2048];
    char line[2304];

    va_list ap;
    va_start(ap, fmt);

    vsnprintf(
        body,
        sizeof(body),
        fmt,
        ap);

    va_end(ap);

    body[sizeof(body) - 1] = '\0';

    snprintf(
        line,
        sizeof(line),
        "[clipboard-url-loader] %s: %s",
        level,
        body);

    line[sizeof(line) - 1] = '\0';

    /*
     * Also make every message visible to tools such as DebugView.
     */
    OutputDebugStringA(line);
    OutputDebugStringA("\n");

    if (!g_mpv ||
        atomic_get_bool(&g_shutting_down))
    {
        fallback_console_write(line);
        return;
    }

    /*
     * Array-form mpv commands do not perform property expansion by default,
     * so clipboard strings containing '$', braces, etc. are harmless here.
     */
    const char *args[] = {
        "print-text",
        line,
        NULL};

    int r = mpv_command_async(
        g_mpv,
        REQ_PRINT_TEXT,
        args);

    if (r < 0)
        fallback_console_write(line);
}

#define LOG_INFO(...) log_message("info", __VA_ARGS__)
#define LOG_WARN(...) log_message("warn", __VA_ARGS__)
#define LOG_ERROR(...) log_message("error", __VA_ARGS__)

/* -------------------------------------------------------------------------
 * URL helpers
 * ------------------------------------------------------------------------- */

static bool trim_space(wchar_t c)
{
    return iswspace((wint_t)c) != 0;
}

static bool forbidden_url_character(wchar_t c)
{
    if (iswspace((wint_t)c))
        return true;

    if (c < 0x20 || c == 0x7f)
        return true;

    return false;
}

static bool has_http_scheme(
    const wchar_t *text,
    size_t length)
{
    /*
     * Require at least one character after "http://" / "https://".
     *
     * Scheme matching is deliberately case-insensitive.
     */
    if (length > 7 &&
        _wcsnicmp(text, L"http://", 7) == 0)
    {
        return true;
    }

    if (length > 8 &&
        _wcsnicmp(text, L"https://", 8) == 0)
    {
        return true;
    }

    return false;
}

static char *utf16_to_utf8(
    const wchar_t *text,
    size_t length)
{
    if (!text ||
        length == 0 ||
        length > INT_MAX)
    {
        return NULL;
    }

    int needed = WideCharToMultiByte(
        CP_UTF8,
        WC_ERR_INVALID_CHARS,
        text,
        (int)length,
        NULL,
        0,
        NULL,
        NULL);

    if (needed <= 0)
        return NULL;

    char *result = malloc((size_t)needed + 1);

    if (!result)
        return NULL;

    int written = WideCharToMultiByte(
        CP_UTF8,
        WC_ERR_INVALID_CHARS,
        text,
        (int)length,
        result,
        needed,
        NULL,
        NULL);

    if (written != needed)
    {
        free(result);
        return NULL;
    }

    result[written] = '\0';

    return result;
}

/* -------------------------------------------------------------------------
 * Clipboard
 * ------------------------------------------------------------------------- */

enum clipboard_result
{
    CLIPBOARD_RESULT_URL,
    CLIPBOARD_RESULT_NOT_URL,
    CLIPBOARD_RESULT_BUSY,
    CLIPBOARD_RESULT_ERROR
};

static enum clipboard_result read_clipboard_url(
    HWND owner,
    char **url_out)
{
    if (!url_out)
        return CLIPBOARD_RESULT_ERROR;

    *url_out = NULL;

    /*
     * This includes clipboard changes involving images, files, etc.
     */
    if (!IsClipboardFormatAvailable(CF_UNICODETEXT))
        return CLIPBOARD_RESULT_NOT_URL;

    if (!OpenClipboard(owner))
        return CLIPBOARD_RESULT_BUSY;

    enum clipboard_result result =
        CLIPBOARD_RESULT_ERROR;

    HGLOBAL block = NULL;
    const wchar_t *text = NULL;

    block = (HGLOBAL)GetClipboardData(
        CF_UNICODETEXT);

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
        goto done;

    size_t max_chars =
        bytes / sizeof(wchar_t);

    size_t length = 0;

    /*
     * Do not blindly trust clipboard data to be terminated correctly.
     */
    while (length < max_chars &&
           text[length] != L'\0')
    {
        ++length;
    }

    if (length == max_chars)
    {
        LOG_WARN(
            "clipboard Unicode text was not NUL-terminated");

        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    size_t first = 0;
    size_t last = length;

    while (first < last &&
           trim_space(text[first]))
    {
        ++first;
    }

    while (last > first &&
           trim_space(text[last - 1]))
    {
        --last;
    }

    size_t url_length =
        last - first;

    if (url_length == 0)
    {
        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    if (url_length > MAX_URL_CHARS)
    {
        LOG_WARN(
            "clipboard text is too large to be treated as a URL");

        result = CLIPBOARD_RESULT_NOT_URL;
        goto unlock;
    }

    if (!has_http_scheme(
            text + first,
            url_length))
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

    *url_out = utf16_to_utf8(
        text + first,
        url_length);

    if (!*url_out)
    {
        LOG_ERROR(
            "could not convert clipboard URL from UTF-16 to UTF-8");

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

static bool listener_remember_clipboard_url(
    const char *url)
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
        return false;

    memcpy(
        copy,
        url,
        length + 1);

    free(listener_last_clipboard_url);
    listener_last_clipboard_url = copy;

    return true;
}

static bool listener_clipboard_url_is_unchanged(
    const char *url)
{
    return url &&
           listener_last_clipboard_url &&
           strcmp(
               url,
               listener_last_clipboard_url) == 0;
}

static void listener_refresh_clipboard_baseline(
    HWND hwnd)
{
    char *url = NULL;

    enum clipboard_result result =
        read_clipboard_url(
            hwnd,
            &url);

    switch (result)
    {
    case CLIPBOARD_RESULT_URL:
        if (!listener_remember_clipboard_url(url))
        {
            LOG_WARN(
                "could not remember clipboard URL baseline");
        }

        free(url);
        break;

    case CLIPBOARD_RESULT_NOT_URL:
        listener_remember_clipboard_url(NULL);
        break;

    case CLIPBOARD_RESULT_BUSY:
        /*
         * Keep the previous remembered URL.  This is safer than forgetting it:
         * forgetting could allow a later sequence-only update to replay it.
         */
        break;

    case CLIPBOARD_RESULT_ERROR:
        /*
         * Likewise, keep the previous value on a transient read error.
         */
        break;
    }
}

/* -------------------------------------------------------------------------
 * Clipboard retry state
 * ------------------------------------------------------------------------- */

static void cancel_clipboard_retry(HWND hwnd)
{
    KillTimer(
        hwnd,
        CLIPBOARD_RETRY_TIMER_ID);

    listener_pending_sequence = 0;
    listener_clipboard_retry_count = 0;
}

/* -------------------------------------------------------------------------
 * Monitor state
 * ------------------------------------------------------------------------- */

static void listener_apply_monitor_state(
    HWND hwnd)
{
    bool wanted =
        atomic_get_bool(&g_monitor_wanted);

    if (wanted == listener_armed)
        return;

    cancel_clipboard_retry(hwnd);

    if (wanted)
    {
        /*
         * Establish a baseline at the exact moment monitoring starts.
         *
         * Therefore the URL which was already in the clipboard while
         * playback was running is NOT automatically loaded.
         */
        listener_last_sequence =
            GetClipboardSequenceNumber();

        /*
         * Remember the clipboard contents that already exist when monitoring
         * starts.  A later WM_CLIPBOARDUPDATE that merely republishes the same
         * URL must not make mpv replay it.
         */
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

static void request_monitor_state(
    bool enable)
{
    LONG wanted = enable ? 1 : 0;

    LONG previous =
        InterlockedExchange(
            &g_monitor_wanted,
            wanted);

    if (previous == wanted)
        return;

    HWND hwnd = get_listener_hwnd();

    if (hwnd)
    {
        PostMessageW(
            hwnd,
            WM_APP_MONITOR_STATE,
            0,
            0);
    }
}

/* -------------------------------------------------------------------------
 * mpv window lookup
 * ------------------------------------------------------------------------- */

static HWND get_mpv_window(void)
{
    if (!g_mpv ||
        atomic_get_bool(&g_shutting_down))
    {
        return NULL;
    }

    int64_t raw_window_id = 0;

    int r = mpv_get_property(
        g_mpv,
        "window-id",
        MPV_FORMAT_INT64,
        &raw_window_id);

    if (r < 0 ||
        raw_window_id == 0)
    {
        return NULL;
    }

    HWND hwnd =
        (HWND)(intptr_t)raw_window_id;

    if (!IsWindow(hwnd))
        return NULL;

    /*
     * "window-id" should already be the main mpv window on Windows, but use
     * the root defensively in case the backend ever returns a child.
     */
    HWND root =
        GetAncestor(hwnd, GA_ROOT);

    if (root &&
        IsWindow(root))
    {
        hwnd = root;
    }

    return hwnd;
}

/* -------------------------------------------------------------------------
 * Focus handling
 * ------------------------------------------------------------------------- */

enum focus_result
{
    FOCUS_RESULT_SUCCESS,
    FOCUS_RESULT_NO_WINDOW,
    FOCUS_RESULT_FAILED
};

static bool window_has_keyboard_focus(
    HWND target,
    DWORD target_thread_id)
{
    GUITHREADINFO info;

    memset(
        &info,
        0,
        sizeof(info));

    info.cbSize =
        sizeof(info);

    if (!GetGUIThreadInfo(
            target_thread_id,
            &info))
    {
        return false;
    }

    if (info.hwndFocus == target)
        return true;

    /*
     * Accept focus on a child of mpv as keyboard focus belonging to mpv.
     */
    if (info.hwndFocus &&
        IsChild(target, info.hwndFocus))
    {
        return true;
    }

    return false;
}

static enum focus_result focus_mpv_once(void)
{
    HWND target = get_mpv_window();

    if (!target)
        return FOCUS_RESULT_NO_WINDOW;

    DWORD current_thread_id =
        GetCurrentThreadId();

    DWORD target_thread_id =
        GetWindowThreadProcessId(
            target,
            NULL);

    if (target_thread_id == 0)
        return FOCUS_RESULT_FAILED;

    HWND old_foreground =
        GetForegroundWindow();

    DWORD foreground_thread_id = 0;

    if (old_foreground)
    {
        foreground_thread_id =
            GetWindowThreadProcessId(
                old_foreground,
                NULL);
    }

    BOOL attached_foreground = FALSE;
    BOOL attached_target = FALSE;

    /*
     * This function is deliberately executed on our hidden-window message
     * thread. That guarantees the caller owns a Win32 message queue.
     *
     * First attach to whichever thread currently owns foreground input.
     */
    if (foreground_thread_id != 0 &&
        foreground_thread_id != current_thread_id &&
        foreground_thread_id != target_thread_id)
    {
        attached_foreground =
            AttachThreadInput(
                current_thread_id,
                foreground_thread_id,
                TRUE);

        if (!attached_foreground)
        {
            LOG_WARN(
                "AttachThreadInput(foreground) failed: Windows error %lu",
                GetLastError());
        }
    }

    /*
     * Attach our message queue to mpv's window thread. This is the important
     * part for SetFocus().
     */
    if (target_thread_id != current_thread_id)
    {
        attached_target =
            AttachThreadInput(
                current_thread_id,
                target_thread_id,
                TRUE);

        if (!attached_target)
        {
            LOG_WARN(
                "AttachThreadInput(mpv) failed: Windows error %lu",
                GetLastError());
        }
    }

    if (IsIconic(target))
    {
        ShowWindowAsync(
            target,
            SW_RESTORE);
    }
    else if (!IsWindowVisible(target))
    {
        ShowWindowAsync(
            target,
            SW_SHOW);
    }

    /*
     * Make sure it is at the top of normal Z order.
     */
    SetWindowPos(
        target,
        HWND_TOP,
        0,
        0,
        0,
        0,
        SWP_NOMOVE |
            SWP_NOSIZE |
            SWP_SHOWWINDOW);

    /*
     * SetForegroundWindow activates the top-level window if Windows permits
     * foreground activation.
     */
    BOOL foreground_result =
        SetForegroundWindow(target);

    BringWindowToTop(target);

    /*
     * SetActiveWindow and SetFocus need the input queues connected when
     * target belongs to another GUI thread.
     */
    if (target_thread_id == current_thread_id ||
        attached_target)
    {
        SetActiveWindow(target);
        SetFocus(target);
    }

    /*
     * A second call after SetFocus is intentional. In practice this helps
     * synchronize activation/focus if restoration caused an activation
     * transition.
     */
    SetForegroundWindow(target);

    /*
     * Detach in reverse order.
     */
    if (attached_target)
    {
        AttachThreadInput(
            current_thread_id,
            target_thread_id,
            FALSE);
    }

    if (attached_foreground)
    {
        AttachThreadInput(
            current_thread_id,
            foreground_thread_id,
            FALSE);
    }

    HWND current_foreground =
        GetForegroundWindow();

    bool foreground_ok =
        current_foreground == target;

    if (!foreground_ok &&
        current_foreground)
    {
        HWND root =
            GetAncestor(
                current_foreground,
                GA_ROOT);

        foreground_ok =
            root == target;
    }

    bool focus_ok =
        window_has_keyboard_focus(
            target,
            target_thread_id);

    if (foreground_ok &&
        focus_ok)
    {
        LOG_INFO(
            "mpv focused successfully "
            "(foreground=yes, keyboard-focus=yes)");

        return FOCUS_RESULT_SUCCESS;
    }

    LOG_WARN(
        "focus attempt incomplete "
        "(SetForegroundWindow=%s, foreground=%s, keyboard-focus=%s)",
        foreground_result ? "yes" : "no",
        foreground_ok ? "yes" : "no",
        focus_ok ? "yes" : "no");

    return FOCUS_RESULT_FAILED;
}

static void cancel_focus_retry(
    HWND hwnd)
{
    KillTimer(
        hwnd,
        FOCUS_RETRY_TIMER_ID);

    listener_focus_retry_count = 0;
}

static void process_focus_request(
    HWND hwnd,
    bool new_request)
{
    if (!atomic_get_bool(&g_focus_pending))
    {
        cancel_focus_retry(hwnd);
        return;
    }

    if (atomic_get_bool(&g_shutting_down))
    {
        cancel_focus_retry(hwnd);
        return;
    }

    if (new_request)
    {
        cancel_focus_retry(hwnd);

        LOG_INFO(
            "attempting to focus mpv window");
    }

    enum focus_result result =
        focus_mpv_once();

    if (result == FOCUS_RESULT_SUCCESS)
    {
        InterlockedExchange(
            &g_focus_pending,
            0);

        cancel_focus_retry(hwnd);
        return;
    }

    /*
     * If mpv has not created its HWND yet, don't blindly poll for it.
     *
     * window-id/file-loaded/video-reconfig events will send another
     * WM_APP_FOCUS_MPV later.
     */
    if (result == FOCUS_RESULT_NO_WINDOW)
    {
        cancel_focus_retry(hwnd);

        LOG_INFO(
            "mpv window is not available yet; "
            "waiting for window creation");

        return;
    }

    if (listener_focus_retry_count >=
        FOCUS_RETRY_MAX)
    {
        cancel_focus_retry(hwnd);

        InterlockedExchange(
            &g_focus_pending,
            0);

        LOG_WARN(
            "could not acquire keyboard focus after %u attempts",
            FOCUS_RETRY_MAX + 1);

        return;
    }

    ++listener_focus_retry_count;

    if (!SetTimer(
            hwnd,
            FOCUS_RETRY_TIMER_ID,
            FOCUS_RETRY_MS,
            NULL))
    {
        LOG_WARN(
            "could not schedule focus retry: Windows error %lu",
            GetLastError());

        cancel_focus_retry(hwnd);

        InterlockedExchange(
            &g_focus_pending,
            0);
    }
}

static void request_focus(void)
{
    if (!atomic_get_bool(&g_focus_pending))
        return;

    HWND hwnd = get_listener_hwnd();

    if (hwnd)
    {
        PostMessageW(
            hwnd,
            WM_APP_FOCUS_MPV,
            0,
            0);
    }
}

/* -------------------------------------------------------------------------
 * Loading URLs
 * ------------------------------------------------------------------------- */

static bool queue_url_load(
    HWND listener_hwnd,
    const char *url)
{
    if (!g_mpv ||
        !url ||
        atomic_get_bool(&g_shutting_down))
    {
        return false;
    }

    LOG_INFO(
        "loading URL: %s",
        url);

    /*
     * Stop accepting clipboard URLs immediately.
     */
    InterlockedExchange(
        &g_monitor_wanted,
        0);

    listener_apply_monitor_state(
        listener_hwnd);

    InterlockedExchange(
        &g_focus_pending,
        1);

    const char *args[] = {
        "loadfile",
        url,
        "replace",
        NULL};

    int r = mpv_command_async(
        g_mpv,
        REQ_LOAD_URL,
        args);

    if (r < 0)
    {
        LOG_ERROR(
            "could not queue loadfile: %s",
            mpv_error_string(r));

        InterlockedExchange(
            &g_focus_pending,
            0);

        /*
         * We were armed immediately before this failed command, so restore
         * monitoring.
         */
        InterlockedExchange(
            &g_monitor_wanted,
            1);

        listener_apply_monitor_state(
            listener_hwnd);

        return false;
    }

    /*
     * If force-window/idle already left an HWND alive, focusing can succeed
     * immediately without waiting for playback.
     */
    process_focus_request(
        listener_hwnd,
        true);

    return true;
}

/* -------------------------------------------------------------------------
 * Processing clipboard notifications
 * ------------------------------------------------------------------------- */

static void process_pending_clipboard(
    HWND hwnd)
{
    KillTimer(
        hwnd,
        CLIPBOARD_RETRY_TIMER_ID);

    if (atomic_get_bool(&g_shutting_down) ||
        !listener_armed)
    {
        cancel_clipboard_retry(hwnd);
        return;
    }

    DWORD current_sequence =
        GetClipboardSequenceNumber();

    /*
     * Clipboard changed again while we were waiting for OpenClipboard().
     * The newer WM_CLIPBOARDUPDATE is authoritative.
     */
    if (listener_pending_sequence != 0 &&
        current_sequence != listener_pending_sequence)
    {
        cancel_clipboard_retry(hwnd);
        return;
    }

    char *url = NULL;

    enum clipboard_result result =
        read_clipboard_url(
            hwnd,
            &url);

    switch (result)
    {
    case CLIPBOARD_RESULT_URL:
        cancel_clipboard_retry(hwnd);

        if (listener_clipboard_url_is_unchanged(url))
        {
            /*
             * The clipboard sequence changed, but the URL did not.  This can
             * happen when one copy operation publishes formats in stages or
             * when another program republishes the existing clipboard data.
             */
            free(url);
            break;
        }

        if (!listener_remember_clipboard_url(url))
        {
            LOG_WARN(
                "could not remember clipboard URL for deduplication");
        }

        LOG_INFO(
            "clipboard change detected");

        queue_url_load(
            hwnd,
            url);

        free(url);
        break;

    case CLIPBOARD_RESULT_NOT_URL:
        cancel_clipboard_retry(hwnd);

        /*
         * A non-URL clipboard value breaks the deduplication chain, so copying
         * the same URL again afterward is considered a new URL.
         */
        listener_remember_clipboard_url(NULL);

        LOG_INFO(
            "clipboard changed, but it is not an HTTP/HTTPS URL");
        break;

    case CLIPBOARD_RESULT_ERROR:
        cancel_clipboard_retry(hwnd);

        LOG_WARN(
            "could not read clipboard text");
        break;

    case CLIPBOARD_RESULT_BUSY:
        if (listener_clipboard_retry_count >=
            CLIPBOARD_RETRY_MAX)
        {
            LOG_WARN(
                "clipboard remained locked after change notification");

            cancel_clipboard_retry(hwnd);
            return;
        }

        ++listener_clipboard_retry_count;

        if (!SetTimer(
                hwnd,
                CLIPBOARD_RETRY_TIMER_ID,
                CLIPBOARD_RETRY_MS,
                NULL))
        {
            LOG_WARN(
                "could not schedule clipboard retry: Windows error %lu",
                GetLastError());

            cancel_clipboard_retry(hwnd);
        }

        break;
    }
}

static void handle_clipboard_update(
    HWND hwnd)
{
    DWORD sequence =
        GetClipboardSequenceNumber();

    if (sequence == listener_last_sequence)
        return;

    listener_last_sequence =
        sequence;

    cancel_clipboard_retry(hwnd);

    /*
     * Changes during normal playback are deliberately ignored, but updating
     * the sequence number here ensures they don't become "new" later.
     */
    if (!listener_armed)
        return;

    listener_pending_sequence =
        sequence;

    listener_clipboard_retry_count = 0;

    process_pending_clipboard(hwnd);
}

/* -------------------------------------------------------------------------
 * Hidden Win32 listener window
 * ------------------------------------------------------------------------- */

static LRESULT CALLBACK clipboard_window_proc(
    HWND hwnd,
    UINT message,
    WPARAM wparam,
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
        process_focus_request(
            hwnd,
            true);
        return 0;

    case WM_TIMER:
        if (wparam ==
            CLIPBOARD_RETRY_TIMER_ID)
        {
            process_pending_clipboard(hwnd);
            return 0;
        }

        if (wparam ==
            FOCUS_RETRY_TIMER_ID)
        {
            process_focus_request(
                hwnd,
                false);

            return 0;
        }

        break;

    case WM_CLOSE:
        cancel_clipboard_retry(hwnd);
        cancel_focus_retry(hwnd);

        RemoveClipboardFormatListener(
            hwnd);

        DestroyWindow(hwnd);
        return 0;

    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;

    default:
        break;
    }

    return DefWindowProcW(
        hwnd,
        message,
        wparam,
        lparam);
}

/* -------------------------------------------------------------------------
 * Listener thread
 * ------------------------------------------------------------------------- */

static DWORD WINAPI clipboard_listener_main(
    void *userdata)
{
    (void)userdata;

    HINSTANCE instance =
        GetModuleHandleW(NULL);

    wchar_t class_name[128];

    swprintf(
        class_name,
        sizeof(class_name) /
            sizeof(class_name[0]),
        L"mpv_clipboard_url_loader_%lu",
        GetCurrentThreadId());

    WNDCLASSW wc;

    memset(
        &wc,
        0,
        sizeof(wc));

    wc.lpfnWndProc =
        clipboard_window_proc;

    wc.hInstance =
        instance;

    wc.lpszClassName =
        class_name;

    ATOM atom =
        RegisterClassW(&wc);

    if (!atom)
    {
        g_listener_error =
            GetLastError();

        SetEvent(g_listener_ready);
        return 1;
    }

    /*
     * Message-only window.
     *
     * It is invisible, has no taskbar entry, and exists only to receive
     * WM_CLIPBOARDUPDATE and our private messages.
     */
    HWND hwnd =
        CreateWindowExW(
            0,
            class_name,
            L"",
            0,
            0,
            0,
            0,
            0,
            HWND_MESSAGE,
            NULL,
            instance,
            NULL);

    if (!hwnd)
    {
        g_listener_error =
            GetLastError();

        UnregisterClassW(
            class_name,
            instance);

        SetEvent(g_listener_ready);
        return 1;
    }

    if (!AddClipboardFormatListener(hwnd))
    {
        g_listener_error =
            GetLastError();

        DestroyWindow(hwnd);

        UnregisterClassW(
            class_name,
            instance);

        SetEvent(g_listener_ready);
        return 1;
    }

    listener_last_sequence =
        GetClipboardSequenceNumber();

    set_listener_hwnd(hwnd);

    g_listener_error =
        ERROR_SUCCESS;

    SetEvent(g_listener_ready);

    LOG_INFO(
        "Win32 clipboard listener started");

    /*
     * Apply any monitor state requested just before the window became ready.
     */
    listener_apply_monitor_state(hwnd);

    MSG message;

    for (;;)
    {
        BOOL r = GetMessageW(
            &message,
            NULL,
            0,
            0);

        if (r == 0)
            break;

        if (r == -1)
        {
            LOG_ERROR(
                "GetMessage failed: Windows error %lu",
                GetLastError());

            break;
        }

        TranslateMessage(&message);
        DispatchMessageW(&message);

        if (atomic_get_bool(
                &g_shutting_down))
        {
            /*
             * Normally WM_CLOSE -> WM_DESTROY -> WM_QUIT handles this.
             */
        }
    }

    if (IsWindow(hwnd))
    {
        cancel_clipboard_retry(hwnd);
        cancel_focus_retry(hwnd);

        RemoveClipboardFormatListener(
            hwnd);

        DestroyWindow(hwnd);
    }

    set_listener_hwnd(NULL);

    free(listener_last_clipboard_url);
    listener_last_clipboard_url = NULL;

    UnregisterClassW(
        class_name,
        instance);

    return 0;
}

/* -------------------------------------------------------------------------
 * Listener startup/shutdown
 * ------------------------------------------------------------------------- */

static bool start_clipboard_listener(void)
{
    g_listener_ready =
        CreateEventW(
            NULL,
            TRUE,
            FALSE,
            NULL);

    if (!g_listener_ready)
    {
        LOG_ERROR(
            "CreateEvent failed: Windows error %lu",
            GetLastError());

        return false;
    }

    g_listener_thread =
        CreateThread(
            NULL,
            0,
            clipboard_listener_main,
            NULL,
            0,
            &g_listener_thread_id);

    if (!g_listener_thread)
    {
        LOG_ERROR(
            "CreateThread failed: Windows error %lu",
            GetLastError());

        CloseHandle(
            g_listener_ready);

        g_listener_ready = NULL;

        return false;
    }

    WaitForSingleObject(
        g_listener_ready,
        INFINITE);

    if (!get_listener_hwnd())
    {
        LOG_ERROR(
            "could not initialize Win32 clipboard listener: "
            "Windows error %lu",
            g_listener_error);

        WaitForSingleObject(
            g_listener_thread,
            INFINITE);

        CloseHandle(
            g_listener_thread);

        g_listener_thread = NULL;

        CloseHandle(
            g_listener_ready);

        g_listener_ready = NULL;

        return false;
    }

    return true;
}

static void stop_clipboard_listener(void)
{
    InterlockedExchange(
        &g_shutting_down,
        1);

    InterlockedExchange(
        &g_monitor_wanted,
        0);

    InterlockedExchange(
        &g_focus_pending,
        0);

    HWND hwnd =
        get_listener_hwnd();

    if (hwnd)
    {
        if (!PostMessageW(
                hwnd,
                WM_CLOSE,
                0,
                0))
        {
            /*
             * Last-resort shutdown path if the window disappeared between
             * lookup and PostMessage().
             */
            if (g_listener_thread_id != 0)
            {
                PostThreadMessageW(
                    g_listener_thread_id,
                    WM_QUIT,
                    0,
                    0);
            }
        }
    }
    else if (g_listener_thread_id != 0)
    {
        PostThreadMessageW(
            g_listener_thread_id,
            WM_QUIT,
            0,
            0);
    }

    if (g_listener_thread)
    {
        WaitForSingleObject(
            g_listener_thread,
            INFINITE);

        CloseHandle(
            g_listener_thread);

        g_listener_thread = NULL;
    }

    if (g_listener_ready)
    {
        CloseHandle(
            g_listener_ready);

        g_listener_ready = NULL;
    }

    g_listener_thread_id = 0;
}

/* -------------------------------------------------------------------------
 * mpv state helpers
 * ------------------------------------------------------------------------- */

static void update_monitor_state(
    bool idle_active,
    bool eof_reached)
{
    if (atomic_get_bool(
            &g_shutting_down))
    {
        request_monitor_state(false);
        return;
    }

    request_monitor_state(
        idle_active ||
        eof_reached);
}

static void handle_property_change(
    mpv_event *event,
    bool *idle_active,
    bool *eof_reached)
{
    mpv_event_property *property =
        (mpv_event_property *)event->data;

    if (!property)
        return;

    switch (event->reply_userdata)
    {
    case OBS_IDLE_ACTIVE:
        if (property->format ==
                MPV_FORMAT_FLAG &&
            property->data)
        {
            *idle_active =
                (*(int *)property->data) != 0;
        }
        else
        {
            *idle_active = false;
        }

        update_monitor_state(
            *idle_active,
            *eof_reached);

        break;

    case OBS_EOF_REACHED:
        if (property->format ==
                MPV_FORMAT_FLAG &&
            property->data)
        {
            *eof_reached =
                (*(int *)property->data) != 0;
        }
        else
        {
            *eof_reached = false;
        }

        update_monitor_state(
            *idle_active,
            *eof_reached);

        break;

    case OBS_WINDOW_ID:
        /*
         * We do not need to trust/use event->data here.
         *
         * The change itself tells us an HWND may have appeared. The focus
         * thread retrieves the current window-id property itself.
         */
        if (atomic_get_bool(
                &g_focus_pending))
        {
            request_focus();
        }

        break;

    default:
        break;
    }
}

/* -------------------------------------------------------------------------
 * mpv plugin entry
 * ------------------------------------------------------------------------- */

MPV_EXPORT int mpv_open_cplugin(
    mpv_handle *handle)
{
    g_mpv = handle;

    LOG_INFO(
        "plugin loaded");

    LOG_INFO(
        "clipboard monitoring mode: "
        "event-driven WM_CLIPBOARDUPDATE");

    int r;

    r = mpv_observe_property(
        handle,
        OBS_IDLE_ACTIVE,
        "idle-active",
        MPV_FORMAT_FLAG);

    if (r < 0)
    {
        LOG_ERROR(
            "cannot observe idle-active: %s",
            mpv_error_string(r));

        g_mpv = NULL;
        return -1;
    }

    r = mpv_observe_property(
        handle,
        OBS_EOF_REACHED,
        "eof-reached",
        MPV_FORMAT_FLAG);

    if (r < 0)
    {
        LOG_ERROR(
            "cannot observe eof-reached: %s",
            mpv_error_string(r));

        g_mpv = NULL;
        return -1;
    }

    r = mpv_observe_property(
        handle,
        OBS_WINDOW_ID,
        "window-id",
        MPV_FORMAT_INT64);

    if (r < 0)
    {
        /*
         * URL loading still works without this observation.
         * FILE_LOADED and VIDEO_RECONFIG also trigger focus attempts.
         */
        LOG_WARN(
            "cannot observe window-id: %s",
            mpv_error_string(r));
    }

    /*
     * Explicitly enable the events used by this plugin.
     */
    mpv_request_event(
        handle,
        MPV_EVENT_START_FILE,
        1);

    mpv_request_event(
        handle,
        MPV_EVENT_FILE_LOADED,
        1);

    mpv_request_event(
        handle,
        MPV_EVENT_END_FILE,
        1);

    mpv_request_event(
        handle,
        MPV_EVENT_VIDEO_RECONFIG,
        1);

    mpv_request_event(
        handle,
        MPV_EVENT_COMMAND_REPLY,
        1);

    mpv_request_event(
        handle,
        MPV_EVENT_PROPERTY_CHANGE,
        1);

    if (!start_clipboard_listener())
    {
        LOG_ERROR(
            "plugin initialization failed");

        g_mpv = NULL;
        return -1;
    }

    bool idle_active = false;
    bool eof_reached = false;

    /*
     * A C plugin must remain inside mpv_open_cplugin() for the lifetime of
     * the plugin, so this is our normal mpv event loop.
     */
    for (;;)
    {
        mpv_event *event =
            mpv_wait_event(
                handle,
                -1);

        switch (event->event_id)
        {
        case MPV_EVENT_PROPERTY_CHANGE:
            handle_property_change(
                event,
                &idle_active,
                &eof_reached);

            break;

        case MPV_EVENT_START_FILE:
            /*
             * Disable monitoring immediately instead of waiting for
             * idle-active/eof-reached property notifications to catch up.
             */
            idle_active = false;
            eof_reached = false;

            request_monitor_state(
                false);

            LOG_INFO(
                "file loading started");

            if (atomic_get_bool(
                    &g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_COMMAND_REPLY:
            if (event->reply_userdata ==
                REQ_LOAD_URL)
            {
                if (event->error < 0)
                {
                    LOG_ERROR(
                        "loadfile failed: %s",
                        mpv_error_string(
                            event->error));

                    InterlockedExchange(
                        &g_focus_pending,
                        0);

                    /*
                     * Restore monitoring according to current playback state.
                     */
                    update_monitor_state(
                        idle_active,
                        eof_reached);
                }
                else
                {
                    LOG_INFO(
                        "loadfile command accepted");

                    if (atomic_get_bool(
                            &g_focus_pending))
                    {
                        request_focus();
                    }
                }
            }

            /*
             * REQ_PRINT_TEXT replies are intentionally ignored.
             */
            break;

        case MPV_EVENT_FILE_LOADED:
            LOG_INFO(
                "file loaded");

            if (atomic_get_bool(
                    &g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_VIDEO_RECONFIG:
            /*
             * Another useful point at which the Win32 video window is likely
             * to exist.
             */
            if (atomic_get_bool(
                    &g_focus_pending))
            {
                request_focus();
            }

            break;

        case MPV_EVENT_END_FILE:
            /*
             * idle-active/eof-reached observations determine whether
             * monitoring needs to resume.
             */
            break;

        case MPV_EVENT_SHUTDOWN:
            goto shutdown;

        default:
            break;
        }
    }

shutdown:
    LOG_INFO(
        "plugin shutting down");

    stop_clipboard_listener();

    /*
     * mpv owns the handle supplied to mpv_open_cplugin().
     * Do NOT call mpv_destroy(handle).
     */
    g_mpv = NULL;

    return 0;
}