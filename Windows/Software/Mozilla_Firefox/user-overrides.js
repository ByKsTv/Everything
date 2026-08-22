// about:preferences > General > Startup > Always check if Firefox is your default browser > Off
user_pref("browser.shell.checkDefaultBrowser", false);

// about:preferences > General > Tabs > Use AI to suggest tabs and a name for tab groups > Off
user_pref("browser.tabs.groups.smart.userEnabled", false);

// about:preferences > General > Tabs > Enable Container Tabs > Off
user_pref("privacy.userContext.enabled", false);

// about:preferences > General > Browser Layout > Horizontal tabs
user_pref("sidebar.verticalTabs", false);

// about:preferences > General > Browser Layout > Show sidebar > off
user_pref("sidebar.revamp", false);
user_pref("sidebar.visibility", "hide-sidebar");

// about:preferences > General > Files and Applications > Downloads > Always ask you where to save files > Off
user_pref("browser.download.useDownloadDir", true);

// about:preferences > General > Files and Applications > Applications > What should Firefox do with other files? > Save files
user_pref("browser.download.always_ask_before_handling_new_types", false);

// about:preferences > General > Performance > Use recommended performance settings > Off
user_pref("browser.preferences.defaultPerformanceSettings.enabled", false);

// about:preferences > General > Performance > Use hardware acceleration when available > On
user_pref("layers.acceleration.disabled", false);

// about:preferences > General > Browsing > Use smooth scrolling > Off
user_pref("general.smoothScroll", false);

// about:preferences > General > Browsing > Enable Picture-in-Picture video controls > Off
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

// about:preferences#home > Home > Firefox Home Content > Web Search > Off
user_pref("browser.newtabpage.activity-stream.showSearch", false);

// about:preferences#home > Home > Firefox Home Content > Shortcuts > Off
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// about:preferences#search > Search > Search Suggestions > Show recent searches > Off
user_pref("browser.urlbar.suggest.recentsearches", false);

// about:preferences#search > Search > Address Bar > Browsing history > On
user_pref("browser.urlbar.suggest.history", true);

// about:preferences#search > Search > Address Bar > Bookmarks > On
user_pref("browser.urlbar.suggest.bookmark", true);

// about:preferences#search > Search > Address Bar > Open tabs > Off
user_pref("browser.urlbar.suggest.openpage", false);

// about:preferences#search > Search > Address Bar > Shortcuts > Off
user_pref("browser.urlbar.suggest.topsites", false);

// about:preferences#search > Search > Address Bar > Search engines > Off
user_pref("browser.urlbar.suggest.engines", false);

// about:preferences#search > Search > Address Bar > Quick actions > Off
user_pref("browser.urlbar.suggest.quickactions", false);

// about:preferences#privacy > Privacy & Security > Website Privacy Preferences > Tell websites not to sell or share my data > On
user_pref("privacy.globalprivacycontrol.enabled", true);

// about:preferences#privacy > Privacy & Security > Passwords > Suggest strong passwords > Off
user_pref("signon.generation.enabled", false);

// about:preferences#privacy > Privacy & Security > Passwords > Suggest Firefox Relay email masks to protect your email address > Off
user_pref("signon.firefoxRelay.feature", "disabled");

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Off
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Browsing & download history > Off
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Cookies and site data > Off
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Temporary cached files and pages > Off
user_pref("privacy.clearOnShutdown_v2.cache", false);

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Saved form info > Off
user_pref("privacy.clearOnShutdown_v2.formdata", false);

// about:preferences#privacy > Privacy & Security > Firefox Data Collection and Use > Send daily usage ping to Mozilla > Off
user_pref("datareporting.usage.uploadEnabled", false);

// about:preferences#privacy > Privacy & Security > DNS over HTTPS > Off
user_pref("doh-rollout.disable-heuristics", true);
user_pref("network.trr.mode", 5);

// Vertical tabs > Firefox tools > Tabs from other devices + History
user_pref("sidebar.main.tools", "syncedtabs,history");

// Disable Recommended by Pocket
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Disable search tabs
user_pref("browser.tabs.tabmanager.enabled", false);

// Always Show Bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Disable shortcuts bookmark
user_pref("browser.urlbar.shortcuts.bookmarks", false);

// Disable shortcuts history
user_pref("browser.urlbar.shortcuts.history", false);

// Disable shortcuts tabs
user_pref("browser.urlbar.shortcuts.tabs", false);

// Disable Firefox Default Browser
user_pref("default-browser-agent.enabled", false);

// Disable Pocket
user_pref("extensions.pocket.enabled", false);

// No fade animation to enter full screen
user_pref("full-screen-api.transition-duration.enter", "0 0");

// No fade animation to leave full screen
user_pref("full-screen-api.transition-duration.leave", "0 0");

// Hide Account Icon with Letters
user_pref("identity.fxaccounts.toolbar.enabled", false);

// Enable media autoplay
user_pref("media.autoplay.blocking_policy", 2);
user_pref("media.autoplay.default", 1);
user_pref("media.autoplay.allow-muted", true);

// Maximize Window
user_pref("privacy.resistFingerprinting", false);

// Disable letterbox inner window
user_pref("privacy.resistFingerprinting.letterboxing", false);

// Disable session restore
user_pref("browser.sessionstore.resume_from_crash", false);

// Disable More from Mozilla
user_pref("browser.preferences.moreFromMozilla", false);

// Disable Firefox is full screen
user_pref("full-screen-api.warning.timeout", 0);

// Disable tab image preview
user_pref("browser.tabs.hoverPreview.enabled", false);

// Disable Firefox Labs
user_pref("browser.preferences.experimental", false);

// Enable Downloads Pop-up when finished downloading (for quick open downloaded files)
user_pref("browser.download.alwaysOpenPanel", true);

// Stop pausing media when the window is minimized
user_pref("widget.windows.window_occlusion_tracking.enabled", false);

// Prevents Firefox from stopping video decoding ~10s after a tab goes background
user_pref("media.suspend-background-video.enabled", false);

// Avoid tab unloading on low memory
user_pref("browser.tabs.unloadOnLowMemory", false);

// Undo process priority downgrades
user_pref("dom.ipc.processPriorityManager.enabled", false);
user_pref("dom.ipc.processPriorityManager.backgroundUsesEcoQoS", false);

// Enable Custom userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Dark mode
user_pref("browser.display.background_color", "#000000");
user_pref("browser.display.background_color.dark", "#000000");
// Firefox tells pages that your prefers-color-scheme is dark, so sites that honor this setting will render their dark themes regardless of your OS/browser theme. This is the same as choosing Website Appearance → Dark in Firefox.
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// Disable auto-hiding overlay scrollbar
user_pref("widget.windows.overlay-scrollbars.enabled", false);

// Change style of scrollbar
user_pref("widget.non-native-theme.scrollbar.style", 4);

// Firefox (on Windows) shows a pre-XUL “skeleton” window using cached theme colors and basic chrome (title bar/tab strip/url bar placeholders). Once the real UI finishes loading, the skeleton is replaced by the actual window.
user_pref("browser.startup.preXulSkeletonUI", true);
// Firefox shows an about:blank window as early as possible so you get instant visual feedback while the real UI is still loading. It’s just a plain placeholder, not the full chrome.
user_pref("browser.startup.blankWindow", true);

// master switch for Firefox’s built-in chatbot hooks. Turning this off removes the chatbot integrations broadly.
user_pref("browser.ml.chat.enabled", false);
// explicitly controls the context-menu “Ask an AI chatbot” item.
user_pref("browser.ml.chat.menu", false);
// disables the floating shortcut / mini popup that appears when selecting text.
user_pref("browser.ml.chat.shortcuts", false);
// hides the AI Chat tool in the sidebar.
user_pref("browser.ml.chat.sidebar", false);
// disables the on-device ML runtime used by Firefox’s AI features.
user_pref("browser.ml.enable", false);
// turns off AI “Link previews.”
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.linkPreview.optin", false);
// disables AI “Smart tab groups.”
user_pref("browser.tabs.groups.smart.enabled", false);
// suppress badges/promo UI around the chatbot.
user_pref("sidebar.notification.badge.aichat", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.chat.page.menuBadge", false);
user_pref("browser.ml.chat.page.footerBadge", false);

// Disable "Split View" feature (Right-Click on a URL)
user_pref("browser.tabs.splitView.enabled", false);

// Don't use temp folder to save files
user_pref("browser.download.start_downloads_in_tmp_dir", false);

// Custom UI
user_pref(
  "browser.uiCustomization.state",
  '{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","vertical-spacer","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","unified-extensions-button","ublock0_raymondhill_net-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"],"unified-extensions-area":[]},"seen":["ublock0_raymondhill_net-browser-action","developer-button"],"dirtyAreaCache":["unified-extensions-area","nav-bar"],"currentVersion":22,"newElementCount":3}',
);
