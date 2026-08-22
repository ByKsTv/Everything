/*
 * clipboard-url-loader.c — minimal native mpv C plugin (Windows)
 *
 * While mpv is idle or at EOF, watches the clipboard purely by event
 * (AddClipboardFormatListener -> WM_CLIPBOARDUPDATE, no polling). A newly
 * copied http(s) URL is loaded with `loadfile <url> replace`, then mpv's
 * window is restored, raised, and given keyboard focus.
 *
 * Build (MSYS2 MinGW-w64, gcc). Requires mpv/client.h on the include path
 * (get it from
 * https://raw.githubusercontent.com/mpv-player/mpv/master/include/mpv/client.h,
 * saved as ./mpv/client.h next to this file, hence -I.):
 *   gcc -std=c17 -O2 -Wall -Wextra -shared -static -I. -o
 * clipboard-url-loader.dll clipboard-url-loader.c -luser32
 */

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#define MPV_CPLUGIN_DYNAMIC_SYM
#include <limits.h>
#include <mpv/client.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wctype.h>

#define CLIP_RETRY_ID 1
#define FOCUS_RETRY_ID 2
#define CLIP_RETRY_MS 20
#define FOCUS_RETRY_MS 30
#define MAX_RETRIES 15
#define MAX_URL_CHARS 32768

#define WM_MONITOR (WM_APP + 1)
#define WM_FOCUS (WM_APP + 2)

enum { OBS_IDLE = 1, OBS_EOF = 2 };
#define REQ_LOAD UINT64_C(1)

static mpv_handle *g_mpv;
static volatile LONG g_quit, g_want_monitor, g_want_focus;
static PVOID volatile g_hwnd_atomic;
static HANDLE g_thread, g_ready;
static DWORD g_thread_id;

/* listener-thread-only state */
static bool armed;
static DWORD last_seq, pending_seq;
static UINT clip_retries, focus_retries;

static HWND hwnd_get(void) {
  return (HWND)InterlockedCompareExchangePointer(&g_hwnd_atomic, NULL, NULL);
}
static void hwnd_set(HWND h) { InterlockedExchangePointer(&g_hwnd_atomic, h); }
static bool flagged(volatile LONG *v) {
  return InterlockedCompareExchange(v, 0, 0) != 0;
}

static void logmsg(const char *fmt, ...) {
  if (!g_mpv || flagged(&g_quit))
    return; /* no mpv handle to log through yet/anymore */

  char buf[1024];
  int n = snprintf(buf, sizeof buf, "[clipboard-url-loader] ");
  va_list ap;
  va_start(ap, fmt);
  vsnprintf(buf + n, sizeof buf - (size_t)n, fmt, ap);
  va_end(ap);

  const char *args[] = {"print-text", buf, NULL};
  mpv_command_async(g_mpv, 0, args);
}

static bool is_http(const wchar_t *s, size_t n) {
  return (n > 7 && _wcsnicmp(s, L"http://", 7) == 0) ||
         (n > 8 && _wcsnicmp(s, L"https://", 8) == 0);
}

static char *wide_to_utf8(const wchar_t *s, size_t n) {
  if (!n || n > (size_t)INT_MAX)
    return NULL;
  int need = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, s, (int)n, NULL,
                                 0, NULL, NULL);
  if (need <= 0)
    return NULL;
  char *out = malloc((size_t)need + 1);
  if (!out)
    return NULL;
  if (WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, s, (int)n, out, need,
                          NULL, NULL) != need) {
    free(out);
    return NULL;
  }
  out[need] = '\0';
  return out;
}

/* returns 1 = url in *out, 0 = not a url, -1 = clipboard busy */
static int read_clipboard_url(HWND owner, char **out) {
  *out = NULL;
  if (!IsClipboardFormatAvailable(CF_UNICODETEXT))
    return 0;
  if (!OpenClipboard(owner))
    return -1;

  int result = 0;
  HGLOBAL h = (HGLOBAL)GetClipboardData(CF_UNICODETEXT);
  if (h) {
    SIZE_T bytes = GlobalSize(h);
    const wchar_t *text = (bytes >= sizeof(wchar_t)) ? GlobalLock(h) : NULL;
    if (text) {
      size_t max = bytes / sizeof(wchar_t), n = 0;
      while (n < max && text[n])
        n++;
      size_t a = 0, b = n;
      while (a < b && iswspace((wint_t)text[a]))
        a++;
      while (b > a && iswspace((wint_t)text[b - 1]))
        b--;
      size_t len = b - a;
      if (len && len <= MAX_URL_CHARS && is_http(text + a, len)) {
        bool ok = true;
        for (size_t i = a; i < b; i++) {
          wchar_t c = text[i];
          if (iswspace((wint_t)c) || c < 0x20 || c == 0x7f) {
            ok = false;
            break;
          }
        }
        if (ok) {
          *out = wide_to_utf8(text + a, len);
          result = *out ? 1 : 0;
        }
      }
      GlobalUnlock(h);
    }
  }
  CloseClipboard();
  return result;
}

static void process_clipboard(
    HWND hwnd); /* defined below; used by apply_monitor_state's race fix */

static void apply_monitor_state(HWND hwnd, DWORD arm_seq) {
  bool want = flagged(&g_want_monitor);
  if (want == armed)
    return;
  KillTimer(hwnd, CLIP_RETRY_ID);
  clip_retries = 0;
  if (want) {
    armed = true;
    DWORD now_seq = GetClipboardSequenceNumber();
    if (now_seq == arm_seq) {
      /* Nothing changed since we decided to arm: whatever's in the
         clipboard now predates monitoring, so leave it alone. Any
         later change will get a new sequence number and be caught
         by on_clipboard_update()/process_clipboard() normally. */
      last_seq = now_seq;
    } else {
      /* The clipboard changed while the arm request was crossing
         threads (e.g. a URL copied right as EOF hit). That change's
         WM_CLIPBOARDUPDATE was likely already delivered and dropped
         because we weren't armed yet -- evaluate it now instead of
         losing it. */
      pending_seq = now_seq;
      process_clipboard(hwnd);
      last_seq = now_seq;
    }
    logmsg("Waiting for URL.");
  } else {
    armed = false;
    logmsg("Stopped watching clipboard.");
  }
}

static void request_monitor(bool enable) {
  LONG v = enable ? 1 : 0;
  if (InterlockedExchange(&g_want_monitor, v) == v)
    return;
  HWND h = hwnd_get();
  if (h)
    PostMessageW(h, WM_MONITOR,
                 (WPARAM)(enable ? GetClipboardSequenceNumber() : 0), 0);
}

/*
 * mpv has no usable "window-id" property on Windows (it's X11-only, see
 * mpv PR #10919), so we can't just ask mpv for its HWND. Since this plugin
 * is loaded into mpv.exe's own process, EnumWindows() filtered to our own
 * process id reliably finds mpv's top-level window instead.
 */
static BOOL CALLBACK find_own_window(HWND h, LPARAM out) {
  DWORD pid = 0;
  GetWindowThreadProcessId(h, &pid);
  if (pid != GetCurrentProcessId())
    return TRUE;
  if (!IsWindowVisible(h))
    return TRUE; /* skips our own hidden listener window too */
  if (GetWindow(h, GW_OWNER))
    return TRUE; /* only top-level, unowned windows */
  *(HWND *)out = h;
  return FALSE;
}

static HWND mpv_window(void) {
  if (!g_mpv || flagged(&g_quit))
    return NULL;
  HWND found = NULL;
  EnumWindows(find_own_window, (LPARAM)&found);
  return found;
}

static bool try_focus(void) {
  HWND target = mpv_window();
  if (!target)
    return false;

  DWORD me = GetCurrentThreadId();
  DWORD target_tid = GetWindowThreadProcessId(target, NULL);

  HWND old_fg = GetForegroundWindow();
  DWORD fg_tid = old_fg ? GetWindowThreadProcessId(old_fg, NULL) : 0;

  /*
   * Windows generally refuses to let a background process steal the
   * foreground outright. The documented workaround is to attach our
   * input queue to whichever thread currently *owns* the foreground
   * (not just to our target) before calling SetForegroundWindow. This
   * is why a fresh/newly-created mpv window focuses trivially but a
   * reused one, with focus already sitting elsewhere, does not without
   * this attach.
   */
  BOOL attached_fg = (fg_tid && fg_tid != me && fg_tid != target_tid)
                         ? AttachThreadInput(me, fg_tid, TRUE)
                         : FALSE;
  BOOL attached_target = (target_tid && target_tid != me)
                             ? AttachThreadInput(me, target_tid, TRUE)
                             : FALSE;

  if (IsIconic(target))
    ShowWindowAsync(target, SW_RESTORE);
  SetWindowPos(target, HWND_TOP, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW);
  SetForegroundWindow(target);
  BringWindowToTop(target);
  SetActiveWindow(target);
  SetFocus(target);
  SetForegroundWindow(target);

  if (attached_target)
    AttachThreadInput(me, target_tid, FALSE);
  if (attached_fg)
    AttachThreadInput(me, fg_tid, FALSE);

  HWND fg = GetForegroundWindow();
  return fg == target || GetAncestor(fg, GA_ROOT) == target;
}

static void process_focus(HWND hwnd, bool fresh) {
  if (!flagged(&g_want_focus) || flagged(&g_quit)) {
    KillTimer(hwnd, FOCUS_RETRY_ID);
    focus_retries = 0;
    return;
  }
  if (fresh) {
    KillTimer(hwnd, FOCUS_RETRY_ID);
    focus_retries = 0;
    logmsg("Attempting to focus the mpv window.");
  }

  if (try_focus()) {
    InterlockedExchange(&g_want_focus, 0);
    KillTimer(hwnd, FOCUS_RETRY_ID);
    logmsg("Successfully focused the mpv window.");
    return;
  }
  if (!mpv_window())
    return; /* no HWND yet; wait for the next trigger, don't poll */

  if (++focus_retries > MAX_RETRIES) {
    InterlockedExchange(&g_want_focus, 0);
    logmsg("Focus failed after %u attempts.", MAX_RETRIES + 1);
    return;
  }
  SetTimer(hwnd, FOCUS_RETRY_ID, FOCUS_RETRY_MS, NULL);
}

static void request_focus(void) {
  HWND h = hwnd_get();
  if (h)
    PostMessageW(h, WM_FOCUS, 0, 0);
}

static void queue_load(HWND hwnd, const char *url) {
  logmsg("Loading URL: %s.", url);
  InterlockedExchange(&g_want_monitor, 0);
  apply_monitor_state(hwnd, 0); /* disarm: arm_seq is unused on this path */
  InterlockedExchange(&g_want_focus, 1);

  const char *args[] = {"loadfile", url, "replace", NULL};
  if (mpv_command_async(g_mpv, REQ_LOAD, args) < 0) {
    InterlockedExchange(&g_want_focus, 0);
    InterlockedExchange(&g_want_monitor, 1);
    apply_monitor_state(hwnd, GetClipboardSequenceNumber());
    return;
  }
  /* Focus is requested once mpv actually confirms the load is under way
     (COMMAND_REPLY/START_FILE/FILE_LOADED/VIDEO_RECONFIG in
     mpv_open_cplugin), not here -- loading takes real time, so
     attempting focus immediately would race ahead of it. */
}

static void process_clipboard(HWND hwnd) {
  KillTimer(hwnd, CLIP_RETRY_ID);
  if (flagged(&g_quit) || !armed)
    return;

  DWORD seq = GetClipboardSequenceNumber();
  if (pending_seq && seq != pending_seq)
    return; /* a newer change supersedes this one */

  char *url;
  int r = read_clipboard_url(hwnd, &url);

  if (r == 1) {
    queue_load(hwnd, url);
    free(url);
  } else if (r == 0) {
    logmsg("Clipboard changed; ignored (not a URL).");
  } else { /* busy */
    if (++clip_retries > MAX_RETRIES)
      return;
    SetTimer(hwnd, CLIP_RETRY_ID, CLIP_RETRY_MS, NULL);
  }
}

static void on_clipboard_update(HWND hwnd) {
  DWORD seq = GetClipboardSequenceNumber();
  if (seq == last_seq)
    return;
  last_seq = seq;
  KillTimer(hwnd, CLIP_RETRY_ID);
  if (!armed)
    return;
  pending_seq = seq;
  clip_retries = 0;
  process_clipboard(hwnd);
}

static LRESULT CALLBACK wnd_proc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
  switch (msg) {
  case WM_CLIPBOARDUPDATE:
    on_clipboard_update(hwnd);
    return 0;
  case WM_MONITOR:
    apply_monitor_state(hwnd, (DWORD)wp);
    return 0;
  case WM_FOCUS:
    process_focus(hwnd, true);
    return 0;
  case WM_TIMER:
    if (wp == CLIP_RETRY_ID) {
      process_clipboard(hwnd);
      return 0;
    }
    if (wp == FOCUS_RETRY_ID) {
      process_focus(hwnd, false);
      return 0;
    }
    break;
  case WM_CLOSE:
    RemoveClipboardFormatListener(hwnd);
    DestroyWindow(hwnd);
    return 0;
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;
  }
  return DefWindowProcW(hwnd, msg, wp, lp);
}

static DWORD WINAPI listener_main(void *unused) {
  (void)unused;
  HINSTANCE inst = GetModuleHandleW(NULL);
  wchar_t cls[64];
  swprintf(cls, 64, L"mpv_clip_url_%lu", GetCurrentThreadId());

  WNDCLASSW wc = {0};
  wc.lpfnWndProc = wnd_proc;
  wc.hInstance = inst;
  wc.lpszClassName = cls;

  HWND hwnd = NULL;
  if (RegisterClassW(&wc)) {
    hwnd = CreateWindowExW(0, cls, L"", 0, 0, 0, 0, 0, HWND_MESSAGE, NULL, inst,
                           NULL);
    if (hwnd && !AddClipboardFormatListener(hwnd)) {
      DestroyWindow(hwnd);
      hwnd = NULL;
    }
  }

  last_seq = GetClipboardSequenceNumber();
  hwnd_set(hwnd);
  SetEvent(g_ready);
  if (!hwnd)
    return 1;

  logmsg("Listener started.");
  apply_monitor_state(hwnd, GetClipboardSequenceNumber());

  MSG msg;
  while (GetMessageW(&msg, NULL, 0, 0) > 0) {
    TranslateMessage(&msg);
    DispatchMessageW(&msg);
  }

  if (IsWindow(hwnd)) {
    RemoveClipboardFormatListener(hwnd);
    DestroyWindow(hwnd);
  }
  hwnd_set(NULL);
  UnregisterClassW(cls, inst);
  return 0;
}

static bool start_listener(void) {
  g_ready = CreateEventW(NULL, TRUE, FALSE, NULL);
  if (!g_ready)
    return false;
  g_thread = CreateThread(NULL, 0, listener_main, NULL, 0, &g_thread_id);
  if (!g_thread) {
    CloseHandle(g_ready);
    g_ready = NULL;
    return false;
  }
  WaitForSingleObject(g_ready, INFINITE);
  return hwnd_get() != NULL;
}

static void stop_listener(void) {
  InterlockedExchange(&g_quit, 1);
  InterlockedExchange(&g_want_monitor, 0);
  InterlockedExchange(&g_want_focus, 0);

  HWND h = hwnd_get();
  if (h)
    PostMessageW(h, WM_CLOSE, 0, 0);
  else if (g_thread_id)
    PostThreadMessageW(g_thread_id, WM_QUIT, 0, 0);

  if (g_thread) {
    WaitForSingleObject(g_thread, INFINITE);
    CloseHandle(g_thread);
    g_thread = NULL;
  }
  if (g_ready) {
    CloseHandle(g_ready);
    g_ready = NULL;
  }
}

static void sync_monitor(bool idle, bool eof) {
  request_monitor(!flagged(&g_quit) && (idle || eof));
}

MPV_EXPORT int mpv_open_cplugin(mpv_handle *handle) {
  g_mpv = handle;
  logmsg("Plugin loaded.");

  if (mpv_observe_property(handle, OBS_IDLE, "idle-active", MPV_FORMAT_FLAG) <
          0 ||
      mpv_observe_property(handle, OBS_EOF, "eof-reached", MPV_FORMAT_FLAG) <
          0) {
    g_mpv = NULL;
    return -1;
  }
  if (!start_listener()) {
    logmsg("Plugin initialization failed.");
    g_mpv = NULL;
    return -1;
  }

  bool idle = false, eof = false;

  for (;;) {
    mpv_event *ev = mpv_wait_event(handle, -1);
    switch (ev->event_id) {
    case MPV_EVENT_PROPERTY_CHANGE: {
      mpv_event_property *p = ev->data;
      if (!p)
        break;
      if (ev->reply_userdata == OBS_IDLE) {
        idle = p->format == MPV_FORMAT_FLAG && p->data && *(int *)p->data;
        sync_monitor(idle, eof);
      } else if (ev->reply_userdata == OBS_EOF) {
        eof = p->format == MPV_FORMAT_FLAG && p->data && *(int *)p->data;
        sync_monitor(idle, eof);
      }
      break;
    }
    case MPV_EVENT_COMMAND_REPLY:
      if (ev->reply_userdata == REQ_LOAD) {
        if (ev->error < 0) {
          logmsg("Loadfile failed: %s.", mpv_error_string(ev->error));
          InterlockedExchange(&g_want_focus, 0);
          sync_monitor(idle, eof);
        } else if (flagged(&g_want_focus)) {
          request_focus();
        }
      }
      break;
    case MPV_EVENT_START_FILE:
      idle = eof = false;
      request_monitor(false);
      if (flagged(&g_want_focus))
        request_focus();
      break;
    case MPV_EVENT_FILE_LOADED:
    case MPV_EVENT_VIDEO_RECONFIG:
      if (flagged(&g_want_focus))
        request_focus();
      break;
    case MPV_EVENT_SHUTDOWN:
      goto done;
    default:
      break;
    }
  }

done:
  logmsg("Plugin shutting down.");
  stop_listener();
  g_mpv = NULL; /* mpv owns the handle; do not mpv_destroy() it */
  return 0;
}
