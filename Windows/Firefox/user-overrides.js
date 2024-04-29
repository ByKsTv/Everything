// What should Firefox do with other files? > Save files
user_pref("browser.download.always_ask_before_handling_new_types", false);
// Always ask you where to save files > Off
user_pref("browser.download.useDownloadDir", true);
// Disable Recommended by Pocket
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
// Disable Shortcuts
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
// Disable Web Search
user_pref("browser.newtabpage.activity-stream.showSearch", false);
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
// Disable Use smooth scrolling
user_pref("general.smoothScroll", false);
// Hide Account Icon with Letters
user_pref("identity.fxaccounts.toolbar.enabled", false);
// Disable Autoplay and use click to play
user_pref("media.autoplay.blocking_policy", 2);
// Enable picture-in-picture video controls > Off
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
// Don't auto delete cookies
user_pref("privacy.clearOnShutdown.cookies", false);
// Don't auto delete history
user_pref("privacy.clearOnShutdown.history", false);
// Maximize Window
user_pref("privacy.resistFingerprinting", false);
// Disable letterbox inner window
user_pref("privacy.resistFingerprinting.letterboxing", false);
// Disable container tabs
user_pref("privacy.userContext.enabled", false);
// Fix slow performance issues and high memory usage
user_pref("webgl.disabled", false);
// Custom UI
user_pref(
  "browser.uiCustomization.state",
  '{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","unified-extensions-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":5}'
);
