// ==UserScript==
// @name         Notion代码块字体设置 (JetBrains Mono)
// @namespace    http://tampermonkey.net/
// @version      1.2
// @description  强制将 Notion 代码块字体更改为 JetBrains Mono
// @author       You
// @match        https://www.notion.so/*
// @match        https://*.notion.so/*
// @match        https://app.notion.com/*
// @match        https://*.notion.site/*
// @run-at       document-start
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

    // 1. 动态载入 Google Fonts 在线字体（本地未安装 JetBrains Mono 也能正常显示）
    const fontLink = document.createElement('link');
    fontLink.rel = 'stylesheet';
    fontLink.href = 'https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&display=swap';
    document.head.appendChild(fontLink);

    // 2. 注入全局 CSS 规则，覆盖代码块及内部所有语法高亮 span
    const css = `
        div.notion-code-block,
        div.notion-code-block * {
            font-family: "JetBrains Mono", monospace !important;
        }
    `;

    // 优先使用 Tampermonkey 原生样式注入，备选原生 DOM 注入
    if (typeof GM_addStyle !== 'undefined') {
        GM_addStyle(css);
    } else {
        const style = document.createElement('style');
        style.textContent = css;
        document.head.appendChild(style);
    }
})();