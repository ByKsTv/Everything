// ==UserScript==
// @name            Amazon - Clean URL
// @version         1.1
// @downloadURL     https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/Amazon_CleanURL.user.js
// @match           https://*.amazon.*/*
// @run-at          document-start
// ==/UserScript==

(function () {
  const m = location.pathname.match(/(?:dp|gp\/product)\/([A-Z0-9]{10})/i);
  if (m && (location.pathname !== `/dp/${m[1]}` || location.search)) {
    location.replace(`https://${location.hostname}/dp/${m[1]}`);
  }
})();
