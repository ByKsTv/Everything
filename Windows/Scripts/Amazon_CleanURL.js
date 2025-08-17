// ==UserScript==
// @name         Amazon → /dp/ canonical
// @match        https://*.amazon.*/*
// @run-at       document-start
// ==/UserScript==
(function () {
  const m = location.pathname.match(/(?:dp|gp\/product)\/([A-Z0-9]{10})/i);
  if (m && (location.pathname !== `/dp/${m[1]}` || location.search)) {
    location.replace(`https://${location.hostname}/dp/${m[1]}`);
  }
})();
