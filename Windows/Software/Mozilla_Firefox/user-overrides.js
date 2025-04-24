// about:preferences > General > Startup > Always check if Firefox is your default browser > Off
user_pref("browser.shell.checkDefaultBrowser", false);

// about:preferences > General > Tabs > Enable Container Tabs > Off
user_pref("privacy.userContext.enabled", false);

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

// about:preferences#privacy > Privacy & Security > Website Privacy Preferences > Tell websites not to sell or share my data > On
user_pref("privacy.globalprivacycontrol.enabled", true);

// about:preferences#privacy > Privacy & Security > Passwords > Suggest strong passwords > Off
user_pref("signon.generation.enabled", false);

// about:preferences#privacy > Privacy & Security > Passwords > Suggest Firefox Relay email masks to protect your email address > Off
user_pref("signon.firefoxRelay.feature", "disabled");

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Browsing & download history > Off
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);

// about:preferences#privacy > Privacy & Security > History > Clear history when Firefox closes > Settings > Cookies and site data > Off
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);

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
user_pref("media.autoplay.blocking_policy", 0);
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

// Enable Custom userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Custom UI
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"unified-extensions-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":5}");
