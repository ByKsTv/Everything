/*
 * clipboard-url-loader.c — native mpv C plugin (Windows)
 *
 * While mpv is idle or at end-of-file, watches the clipboard by event
 * (AddClipboardFormatListener -> WM_CLIPBOARDUPDATE, no polling). When an
 * http(s) URL is copied, it's loaded with `loadfile <url> replace`, and the
 * mpv window is restored, raised, and focused.
 *
 * Build (MSYS2 MinGW-w64 gcc). Requires mpv/client.h on the include path:
 *   https://raw.githubusercontent.com/mpv-player/mpv/master/include/mpv/client.h
 *   save as ./mpv/client.h next to this file, hence -I.
 *
 * gcc -std=c17 -O2 -Wall -Wextra -shared -static -I. -o
 * clipboard-url-loader.dll clipboard-url-loader.c -luser32
 */

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#define MPV_CPLUGIN_DYNAMIC_SYM
#include <mpv/client.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wctype.h>

enum {
  TIMER_CLIPBOARD_RETRY = 1,
  TIMER_FOCUS_RETRY = 2,
  RETRY_DELAY_MS = 25,
  MAX_RETRY_ATTEMPTS = 15,
  MAX_URL_CHARS = 32768,
  LOG_BUFFER_SIZE = 1024,
  WINDOW_CLASS_NAME_CHARS = 64,
  MSG_SET_MONITORING = WM_APP + 1,
  MSG_REQUEST_FOCUS = WM_APP + 2,
  PROPERTY_ID_IDLE = 1,
  PROPERTY_ID_EOF = 2,
  LOAD_REQUEST_ID = 1,
  HTTP_PREFIX_CHARS = 7,  /* strlen("http://") */
  HTTPS_PREFIX_CHARS = 8, /* strlen("https://") */
  ASCII_CONTROL_LIMIT = 0x20,
  ASCII_DELETE = 0x7f,
};

/* Shared between mpv's plugin thread and the Win32 listener thread: mpv's
 * C-plugin ABI gives no per-plugin context pointer to thread through, so
 * this has to be mutable global state instead of locals owned by one side. */
// NOLINTBEGIN(cppcoreguidelines-avoid-non-const-global-variables)
static mpv_handle *g_mpv_handle;
static PVOID volatile g_listener_window_handle;
static volatile LONG g_quitting, g_should_monitor, g_focus_wanted;
static HANDLE g_listener_thread, g_listener_ready_event;
static DWORD g_listener_thread_id;

/* Touched only from the listener thread. */
static bool g_currently_monitoring;
static DWORD g_last_clipboard_sequence;
static UINT g_retry_attempts;
static char *g_last_loaded_url; /* dedupe spurious re-renders (e.g. an app
                                    exiting and force-flushing delayed-render
                                    clipboard data with no real content
                                    change) */
// NOLINTEND(cppcoreguidelines-avoid-non-const-global-variables)

static HWND get_listener_window(void) {
  return (HWND)InterlockedCompareExchangePointer(&g_listener_window_handle,
                                                 NULL, NULL);
}

static void set_listener_window(HWND window) {
  InterlockedExchangePointer(&g_listener_window_handle, window);
}

static bool flag_is_set(volatile LONG *flag) {
  return InterlockedCompareExchange(flag, 0, 0) != 0;
}

static void log_message(const char *format, ...) {
  if (!g_mpv_handle || flag_is_set(&g_quitting))
    return;

  char message[LOG_BUFFER_SIZE];
  int prefix_length =
      snprintf(message, sizeof message, "[clipboard-url-loader] ");
  if (prefix_length < 0 || (size_t)prefix_length >= sizeof message)
    return;

  va_list arguments; /* NOLINT(cppcoreguidelines-init-variables): va_start
                        initializes it. */
  va_start(arguments, format);
  vsnprintf(message + prefix_length, sizeof message - (size_t)prefix_length,
            format, arguments);
  va_end(arguments);

  const char *command[] = {"print-text", message, NULL};
  mpv_command_async(g_mpv_handle, 0, command);
}

/* Extracts a trimmed http(s) URL from the clipboard. Returns 1 with
 * *url_utf8_out set (caller frees it); 0 if the clipboard holds text that
 * isn't a URL; -1 if the clipboard couldn't be opened (retry shortly);
 * -2 if the clipboard doesn't hold text at all (e.g. an image was copied). */
static int try_read_clipboard_url(HWND owner_window, char **url_utf8_out) {
  *url_utf8_out = NULL;
  if (!IsClipboardFormatAvailable(CF_UNICODETEXT))
    return -2;
  if (!OpenClipboard(owner_window))
    return -1;

  int result = 0;
  HGLOBAL clipboard_handle = (HGLOBAL)GetClipboardData(CF_UNICODETEXT);
  wchar_t *clipboard_text =
      clipboard_handle ? GlobalLock(clipboard_handle) : NULL;

  if (clipboard_text) {
    size_t length =
        wcsnlen(clipboard_text, GlobalSize(clipboard_handle) / sizeof(wchar_t));
    while (length && iswspace((wint_t)clipboard_text[length - 1]))
      length--;
    while (length && iswspace((wint_t)*clipboard_text)) {
      clipboard_text++;
      length--;
    }

    bool looks_like_url =
        length > 0 && length <= MAX_URL_CHARS &&
        (_wcsnicmp(clipboard_text, L"http://", HTTP_PREFIX_CHARS) == 0 ||
         _wcsnicmp(clipboard_text, L"https://", HTTPS_PREFIX_CHARS) == 0);
    for (size_t i = 0; looks_like_url && i < length; i++)
      if (iswspace((wint_t)clipboard_text[i]) ||
          clipboard_text[i] < ASCII_CONTROL_LIMIT ||
          clipboard_text[i] == ASCII_DELETE)
        looks_like_url = false;

    if (looks_like_url) {
      int bytes_needed =
          WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, clipboard_text,
                              (int)length, NULL, 0, NULL, NULL);
      /* Freed by the caller (check_clipboard_now) once it's done with it. */
      char *utf8_url =
          bytes_needed > 0 ? malloc((size_t)bytes_needed + 1) : NULL;
      if (utf8_url) {
        WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, clipboard_text,
                            (int)length, utf8_url, bytes_needed, NULL, NULL);
        utf8_url[bytes_needed] = '\0';
        *url_utf8_out = utf8_url;
        result = 1;
      }
    }
    GlobalUnlock(clipboard_handle);
  }

  CloseClipboard();
  return result;
}

static void apply_monitoring_state(HWND listener_window);

static void check_clipboard_now(HWND listener_window) {
  KillTimer(listener_window, TIMER_CLIPBOARD_RETRY);
  if (flag_is_set(&g_quitting) || !g_currently_monitoring)
    return;

  char *url = NULL;
  switch (try_read_clipboard_url(listener_window, &url)) {
  case 1: {
    /* Some apps use delayed-render clipboard data and force a flush when
     * they exit (e.g. Firefox closing while it still owns the clipboard).
     * That produces a genuine WM_CLIPBOARDUPDATE / sequence-number bump
     * with no actual change in content, which would otherwise cause us to
     * reload the same URL. Guard against that by comparing to the last URL
     * we actually loaded. */
    if (g_last_loaded_url && strcmp(g_last_loaded_url, url) == 0) {
      log_message("Clipboard changed but URL is unchanged; ignoring.");
      free(url);
      break;
    }

    log_message("Loading URL: %s.", url);
    InterlockedExchange(&g_should_monitor, 0);
    g_currently_monitoring = false;

    const char *command[] = {"loadfile", url, "replace", NULL};
    if (mpv_command_async(g_mpv_handle, LOAD_REQUEST_ID, command) < 0) {
      InterlockedExchange(&g_should_monitor,
                          1); /* queueing failed; keep watching */
      apply_monitoring_state(listener_window);
      free(url);
    } else {
      InterlockedExchange(&g_focus_wanted, 1);
      free(g_last_loaded_url);
      g_last_loaded_url = url; /* ownership transferred; freed on next
                                   successful load or plugin shutdown */
    }
    break;
  }
  case -1:
    if (++g_retry_attempts <= MAX_RETRY_ATTEMPTS)
      SetTimer(listener_window, TIMER_CLIPBOARD_RETRY, RETRY_DELAY_MS, NULL);
    break;
  case -2:
    log_message("Clipboard changed; no text was copied.");
    break;
  default:
    log_message("Clipboard changed; not a URL.");
    break;
  }
}

/* mpv exposes no usable window handle on Windows ("window-id" is X11-only).
 * Since this plugin runs inside mpv.exe's own process, EnumWindows()
 * filtered to our process id reliably finds mpv's top-level window. */
static BOOL CALLBACK match_own_toplevel_window(HWND candidate, LPARAM out_ptr) {
  DWORD owning_process = 0;
  GetWindowThreadProcessId(candidate, &owning_process);
  if (owning_process != GetCurrentProcessId() || !IsWindowVisible(candidate) ||
      GetWindow(candidate, GW_OWNER))
    return TRUE; /* keep looking; also skips our own hidden listener window */

  *(HWND *)out_ptr = candidate; // NOLINT(performance-no-int-to-ptr)
  return FALSE;
}

static HWND find_mpv_window(void) {
  HWND found = NULL;
  if (!flag_is_set(&g_quitting))
    EnumWindows(match_own_toplevel_window, (LPARAM)&found);
  return found;
}

/* Windows normally blocks a background process from stealing the
 * foreground, so briefly attach our input queue to the foreground window's
 * thread before calling SetForegroundWindow. */
static bool try_focus_window(HWND target_window) {
  DWORD this_thread = GetCurrentThreadId();
  DWORD target_thread = GetWindowThreadProcessId(target_window, NULL);
  HWND foreground_window = GetForegroundWindow();
  DWORD foreground_thread =
      foreground_window ? GetWindowThreadProcessId(foreground_window, NULL) : 0;

  bool attached_foreground =
      foreground_thread && foreground_thread != this_thread &&
      foreground_thread != target_thread &&
      AttachThreadInput(this_thread, foreground_thread, TRUE);
  bool attached_target = target_thread && target_thread != this_thread &&
                         AttachThreadInput(this_thread, target_thread, TRUE);

  if (IsIconic(target_window))
    ShowWindowAsync(target_window, SW_RESTORE);
  SetWindowPos(target_window, HWND_TOP, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW);
  SetForegroundWindow(target_window);
  BringWindowToTop(target_window);
  SetActiveWindow(target_window);
  SetFocus(target_window);
  SetForegroundWindow(target_window);

  if (attached_target)
    AttachThreadInput(this_thread, target_thread, FALSE);
  if (attached_foreground)
    AttachThreadInput(this_thread, foreground_thread, FALSE);

  HWND resulting_foreground = GetForegroundWindow();
  return resulting_foreground == target_window ||
         GetAncestor(resulting_foreground, GA_ROOT) == target_window;
}

static void pursue_focus(HWND listener_window, bool is_fresh_request) {
  if (!flag_is_set(&g_focus_wanted) || flag_is_set(&g_quitting)) {
    KillTimer(listener_window, TIMER_FOCUS_RETRY);
    return;
  }
  if (is_fresh_request) {
    KillTimer(listener_window, TIMER_FOCUS_RETRY);
    g_retry_attempts = 0;
    log_message("Attempting to focus the mpv window.");
  }

  HWND target_window = find_mpv_window();
  if (target_window && try_focus_window(target_window)) {
    InterlockedExchange(&g_focus_wanted, 0);
    KillTimer(listener_window, TIMER_FOCUS_RETRY);
    log_message("Focused the mpv window.");
  } else if (target_window && ++g_retry_attempts <= MAX_RETRY_ATTEMPTS) {
    SetTimer(listener_window, TIMER_FOCUS_RETRY, RETRY_DELAY_MS, NULL);
  } else if (target_window) {
    InterlockedExchange(&g_focus_wanted, 0);
    log_message("Giving up on focusing the mpv window.");
  } /* else: no window yet; wait for the next trigger instead of polling */
}

static void apply_monitoring_state(HWND listener_window) {
  bool should_monitor = flag_is_set(&g_should_monitor);
  if (should_monitor == g_currently_monitoring)
    return;

  KillTimer(listener_window, TIMER_CLIPBOARD_RETRY);
  g_retry_attempts = 0;
  g_currently_monitoring = should_monitor;

  if (should_monitor) {
    g_last_clipboard_sequence =
        GetClipboardSequenceNumber(); /* ignore prior contents */
    log_message("Watching clipboard for a URL.");
  } else {
    log_message("Stopped watching clipboard.");
  }
}

static void request_monitoring(bool enable) {
  LONG value = enable ? 1 : 0;
  if (InterlockedExchange(&g_should_monitor, value) == value)
    return;
  HWND listener_window = get_listener_window();
  if (listener_window)
    PostMessageW(listener_window, MSG_SET_MONITORING, 0, 0);
}

static void request_focus(void) {
  HWND listener_window = get_listener_window();
  if (listener_window)
    PostMessageW(listener_window, MSG_REQUEST_FOCUS, 0, 0);
}

static LRESULT CALLBACK listener_window_proc(HWND window, UINT message,
                                             WPARAM wparam, LPARAM lparam) {
  switch (message) {
  case WM_CLIPBOARDUPDATE: {
    DWORD sequence = GetClipboardSequenceNumber();
    if (sequence == g_last_clipboard_sequence)
      return 0;
    g_last_clipboard_sequence = sequence;
    g_retry_attempts = 0;
    if (g_currently_monitoring)
      check_clipboard_now(window);
    return 0;
  }
  case MSG_SET_MONITORING:
    apply_monitoring_state(window);
    return 0;
  case MSG_REQUEST_FOCUS:
    pursue_focus(window, true);
    return 0;
  case WM_TIMER:
    if (wparam == TIMER_CLIPBOARD_RETRY)
      check_clipboard_now(window);
    else if (wparam == TIMER_FOCUS_RETRY)
      pursue_focus(window, false);
    return 0;
  case WM_CLOSE:
    RemoveClipboardFormatListener(window);
    DestroyWindow(window);
    return 0;
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;
  default:
    return DefWindowProcW(window, message, wparam, lparam);
  }
}

static DWORD WINAPI listener_thread_main(void *unused) {
  (void)unused;
  HINSTANCE instance = GetModuleHandleW(NULL);
  wchar_t class_name[WINDOW_CLASS_NAME_CHARS];
  swprintf(class_name, WINDOW_CLASS_NAME_CHARS, L"mpv_clip_url_%lu",
           GetCurrentThreadId());

  WNDCLASSW window_class = {.lpfnWndProc = listener_window_proc,
                            .hInstance = instance,
                            .lpszClassName = class_name};
  HWND window = NULL;
  if (RegisterClassW(&window_class)) {
    window = CreateWindowExW(0, class_name, L"", 0, 0, 0, 0, 0, HWND_MESSAGE,
                             NULL, instance, NULL);
    if (window && !AddClipboardFormatListener(window)) {
      DestroyWindow(window);
      window = NULL;
    }
  }

  g_last_clipboard_sequence = GetClipboardSequenceNumber();
  set_listener_window(window);
  SetEvent(g_listener_ready_event);
  if (!window)
    return 1;

  log_message("Listener started.");
  apply_monitoring_state(window);

  MSG message;
  while (GetMessageW(&message, NULL, 0, 0) > 0) {
    TranslateMessage(&message);
    DispatchMessageW(&message);
  }

  if (IsWindow(window)) {
    RemoveClipboardFormatListener(window);
    DestroyWindow(window);
  }
  set_listener_window(NULL);
  UnregisterClassW(class_name, instance);
  return 0;
}

static bool start_listener(void) {
  g_listener_ready_event = CreateEventW(NULL, TRUE, FALSE, NULL);
  if (!g_listener_ready_event)
    return false;

  g_listener_thread = CreateThread(NULL, 0, listener_thread_main, NULL, 0,
                                   &g_listener_thread_id);
  if (!g_listener_thread) {
    CloseHandle(g_listener_ready_event);
    g_listener_ready_event = NULL;
    return false;
  }

  WaitForSingleObject(g_listener_ready_event, INFINITE);
  if (get_listener_window())
    return true;

  WaitForSingleObject(g_listener_thread, INFINITE);
  CloseHandle(g_listener_thread);
  CloseHandle(g_listener_ready_event);
  g_listener_thread = g_listener_ready_event = NULL;
  g_listener_thread_id = 0;
  return false;
}

static void stop_listener(void) {
  InterlockedExchange(&g_quitting, 1);
  InterlockedExchange(&g_should_monitor, 0);
  InterlockedExchange(&g_focus_wanted, 0);

  HWND listener_window = get_listener_window();
  if (listener_window)
    PostMessageW(listener_window, WM_CLOSE, 0, 0);
  else if (g_listener_thread_id)
    PostThreadMessageW(g_listener_thread_id, WM_QUIT, 0, 0);

  if (g_listener_thread) {
    WaitForSingleObject(g_listener_thread, INFINITE);
    CloseHandle(g_listener_thread);
    g_listener_thread = NULL;
  }
  if (g_listener_ready_event) {
    CloseHandle(g_listener_ready_event);
    g_listener_ready_event = NULL;
  }
  g_listener_thread_id = 0;
}

MPV_EXPORT int mpv_open_cplugin(mpv_handle *handle) {
  g_mpv_handle = handle;
  log_message("Plugin loaded.");

  if (mpv_observe_property(handle, PROPERTY_ID_IDLE, "idle-active",
                           MPV_FORMAT_FLAG) < 0 ||
      mpv_observe_property(handle, PROPERTY_ID_EOF, "eof-reached",
                           MPV_FORMAT_FLAG) < 0 ||
      !start_listener()) {
    log_message("Plugin initialization failed.");
    g_mpv_handle = NULL;
    return -1;
  }

  bool is_idle = false, at_eof = false;
  for (;;) {
    mpv_event *event = mpv_wait_event(handle, -1);

    switch (event->event_id) {
    case MPV_EVENT_PROPERTY_CHANGE: {
      mpv_event_property *property = event->data;
      if (!property || property->format != MPV_FORMAT_FLAG || !property->data)
        break;
      bool value = *(int *)property->data;
      if (event->reply_userdata == PROPERTY_ID_IDLE)
        is_idle = value;
      else if (event->reply_userdata == PROPERTY_ID_EOF)
        at_eof = value;
      request_monitoring(!flag_is_set(&g_quitting) && (is_idle || at_eof));
      break;
    }
    case MPV_EVENT_COMMAND_REPLY:
      if (event->reply_userdata != LOAD_REQUEST_ID)
        break;
      if (event->error < 0) {
        log_message("Loadfile failed: %s.", mpv_error_string(event->error));
        InterlockedExchange(&g_focus_wanted, 0);
        request_monitoring(!flag_is_set(&g_quitting) && (is_idle || at_eof));
      } else {
        request_focus();
      }
      break;
    case MPV_EVENT_START_FILE:
      is_idle = at_eof = false;
      request_monitoring(false);
      break;
    case MPV_EVENT_FILE_LOADED:
    case MPV_EVENT_VIDEO_RECONFIG:
      if (flag_is_set(&g_focus_wanted))
        request_focus();
      break;
    case MPV_EVENT_SHUTDOWN:
      log_message("Plugin shutting down.");
      stop_listener();
      free(g_last_loaded_url);
      g_last_loaded_url = NULL;
      g_mpv_handle = NULL; /* mpv owns the handle; do not mpv_destroy() it */
      return 0;
    default:
      break;
    }
  }
}
