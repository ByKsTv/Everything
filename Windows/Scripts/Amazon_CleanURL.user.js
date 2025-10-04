// ==UserScript==
// @name            Amazon - Shorten URL
// @version         1.0
// @match           https://*.amazon.*/*
// @downloadURL     https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Amazon_CleanURL.user.js
// @run-at          document-start
// ==/UserScript==

(function () {
  const m = location.pathname.match(/(?:dp|gp\/product)\/([A-Z0-9]{10})/i);
  if (m && (location.pathname !== `/dp/${m[1]}` || location.search)) {
    location.replace(`https://${location.hostname}/dp/${m[1]}`);
  }
})();
