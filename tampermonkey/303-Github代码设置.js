// ==UserScript==
// @name         GitHub代码字体设置
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  将 GitHub 网页中的代码字体替换为 Google Sans Code / JetBrains Mono / Fira Code
// @author       You
// @match        https://github.com/*
// @match        https://gist.github.com/*
// @run-at       document-start
// @grant        GM_addStyle
// @updateURL    https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/303-Github%E4%BB%A3%E7%A0%81%E8%AE%BE%E7%BD%AE.js
// @downloadURL  https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/303-Github%E4%BB%A3%E7%A0%81%E8%AE%BE%E7%BD%AE.js
// ==/UserScript==

(function() {
    'use strict';

    const fontStack = '"Google Sans Code", "Fira Code", "JetBrains Mono", monospace';

    const css = `
        :root {
            --fontStack-monospace: ${fontStack} !important;
        }

        .blob-code-inner,
        .blob-code,
        .react-code-text,
        .react-code-lines,
        .react-blob-print-hide,
        [data-selector="codeBlockContent"],
        div[data-testid="code-cell"] *,
        pre,
        code,
        tt {
            font-family: ${fontStack} !important;
        }
    `;

    if (typeof GM_addStyle !== 'undefined') {
        GM_addStyle(css);
    } else {
        const style = document.createElement('style');
        style.textContent = css;
        document.head.appendChild(style);
    }
})();