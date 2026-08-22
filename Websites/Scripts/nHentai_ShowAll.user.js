// ==UserScript==
// @name            nHentai - Show all
// @version         1.2
// @downloadURL     https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/nHentai_ShowAll.user.js
// @match           *://nhentai.net/*
// @grant           none
// ==/UserScript==

(function () {
  "use strict";

  function clickShowAllButton() {
    const buttons = document.querySelectorAll("button.btn.btn-secondary");

    for (const button of buttons) {
      const text = button.textContent.replace(/\s+/g, " ").trim();
      if (text === "Show all") {
        console.log('Clicking "Show all" button...');
        button.click();
        return true;
      }
    }

    return false;
  }

  function waitForButton() {
    if (clickShowAllButton()) return;

    const observer = new MutationObserver(() => {
      if (clickShowAllButton()) {
        observer.disconnect();
      }
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true,
    });
  }

  window.addEventListener("load", waitForButton);
})();
