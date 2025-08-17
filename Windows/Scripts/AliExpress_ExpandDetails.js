// ==UserScript==
// @name         AliExpress Auto “View more”
// @namespace    https://example.com/
// @version      0.1
// @description  Auto-click the “View more” for specifications & extended description on AliExpress listings.
// @match        https://www.aliexpress.com/item/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    // Click any un-clicked “View more” button whose class starts with "specification--btn--" or "extend--btn--"
    function clickViewMore() {
        document.querySelectorAll('button').forEach(btn => {
            // Only buttons whose visible text is exactly “View more”
            if (btn.textContent.trim() !== 'View more') return;

            // Skip if we've already auto-clicked it
            if (btn.dataset._vmClicked) return;

            // Look for the spec/extend class pattern
            const shouldClick = Array.from(btn.classList).some(cls =>
                /^(specification|extend)--btn--/.test(cls)
            );
            if (!shouldClick) return;

            // Mark it, then click
            btn.dataset._vmClicked = '1';
            btn.click();
        });
    }

    // Run immediately once
    clickViewMore();

    // And again whenever new nodes are added (to catch dynamically-loaded sections)
    const observer = new MutationObserver(clickViewMore);
    observer.observe(document.body, { childList: true, subtree: true });
})();