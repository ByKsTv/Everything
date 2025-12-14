// ==UserScript==
// @name            nHentai - Show all
// @version         1.1
// @downloadURL     https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/nHentai_ShowAll.user.js
// @match           *://nhentai.net/*
// @grant           none
// ==/UserScript==

(function () {
    'use strict';

    function clickShowAllButton() {
        // Find the span with text "Show all"
        const spans = document.querySelectorAll('span.text');
        for (const span of spans) {
            if (span.textContent.trim() === 'Show all') {
                const clickable = span.closest('button, a, div');
                if (clickable) {
                    console.log('Clicking "Show all" button...');
                    clickable.click();
                    return;
                }
            }
        }

        // Try again after a short delay
        setTimeout(clickShowAllButton, 500);
    }

    window.addEventListener('load', clickShowAllButton);
})();
