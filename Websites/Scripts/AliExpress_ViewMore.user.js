// ==UserScript==
// @name            AliExpress - View More
// @version         2.1
// @downloadURL     https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/AliExpress_ViewMore.user.js
// @match           *://*.aliexpress.com/item/*
// @match           *://aliexpress.com/item/*
// @grant           none
// ==/UserScript==

(function () {
  "use strict";

  // Consider only buttons that look like the spec/extend expanders (works across locales)
  function isTargetButton(btn) {
    if (btn.dataset._vmClicked) return false; // already clicked
    if (btn.disabled) return false; // disabled
    const hasClassPattern = Array.from(btn.classList).some((cls) =>
      /^(specification|extend)--btn--/.test(cls),
    );
    if (!hasClassPattern) return false;
    const expanded = btn.getAttribute("aria-expanded"); // skip if already expanded
    if (expanded && expanded !== "false") return false;
    // visible?
    return !!(btn.offsetParent || btn.getClientRects().length);
  }

  function clickViewMore() {
    document.querySelectorAll("button").forEach((btn) => {
      if (!isTargetButton(btn)) return;
      btn.dataset._vmClicked = "1";
      btn.click();
    });
  }

  // Run now and when DOM finishes, plus on dynamic changes
  clickViewMore();
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", clickViewMore, {
      once: true,
    });
  } else {
    queueMicrotask(clickViewMore);
  }

  const observer = new MutationObserver((mutations) => {
    for (const m of mutations) {
      if (m.addedNodes && m.addedNodes.length) {
        clickViewMore();
        break;
      }
    }
  });
  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });
})();
