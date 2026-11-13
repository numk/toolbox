// ==UserScript==
// @name         时间线广告屏蔽 (cellInnerDiv)
// @namespace    https://tampermonkey.net/
// @version      1.0.0
// @description  根据「广告」标签 + 相邻“更多”按钮结构 + 无发布时间/曝光像素 综合判断并隐藏广告卡片，支持滚动动态加载
// @match        https://x.com/*
// @match        https://twitter.com/*
// @run-at       document-start
// @grant        none
// @updateURL    https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/304-X%E6%97%B6%E9%97%B4%E7%BA%BF%E5%B9%BF%E5%91%8A%E5%B1%8F%E8%94%BD.js
// @downloadURL  https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/304-X%E6%97%B6%E9%97%B4%E7%BA%BF%E5%B9%BF%E5%91%8A%E5%B1%8F%E8%94%BD.js
// ==/UserScript==

(function () {
  'use strict';

  /* ================= 配置 ================= */
  const DEBUG = false;      // true：不隐藏，只用红框标出广告，方便核对有没有误判
  const FAST_CSS = true;    // true：额外用纯 CSS :has() 预先隐藏，节点一插入就生效、无闪烁
  // 广告标签文字（精确匹配，切换界面语言时也能用）
  const AD_LABELS = ['广告', '廣告', '推广', 'Ad', 'Promoted', 'プロモーション', '광고', 'Реклама', 'Anzeige', 'Publicidad', 'Sponsorisé'];

  const CELL = 'div[data-testid="cellInnerDiv"]';
  const MARK = 'data-tm-ad';
  const PIXEL = '[data-testid="placementTracking"], [data-testid$="impression-pixel"]';
  const labelSet = new Set(AD_LABELS);

  /* ================= 1. 注入样式 ================= */
  const hideRule = DEBUG
    ? 'outline:3px solid red !important; opacity:.45 !important;'
    : 'display:none !important;';
  let css = CELL + '[' + MARK + '] { ' + hideRule + ' }\n';
  if (FAST_CSS) {
    // 三个条件同时满足才命中：是推文 + 有曝光像素 + 没有发布时间
    css += CELL + ':has(article[data-testid="tweet"]):has([data-testid$="impression-pixel"]):not(:has(time)) { ' + hideRule + ' }\n';
  }
  const style = document.createElement('style');
  style.textContent = css;
  // document-start 阶段 head 可能尚未建立
  const styleHost = document.head || document.documentElement;
  if (styleHost) {
    styleHost.appendChild(style);
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      (document.head || document.documentElement).appendChild(style);
    }, { once: true });
  }

  /* ================= 2. 判断单个节点是否是广告 ================= */
  function isAdCell(cell) {
    const article = cell.querySelector('article[data-testid="tweet"]');
    if (!article) return false;

    // 快速过滤：整段文字里都没有标签词，直接跳过
    const text = article.textContent;
    if (!AD_LABELS.some(l => text.includes(l))) return false;

    // 条件 A（必须）：广告标签位于页眉，旁边有“更多”按钮
    let labelOk = false;
    for (const span of article.querySelectorAll('span')) {
      if (span.childElementCount) continue;                    // 只看叶子 span
      if (!labelSet.has(span.textContent.trim())) continue;     // 精确匹配
      // 排除正文、用户名、卡片里恰好出现的“广告”二字
      if (span.closest('[data-testid="tweetText"], [data-testid="User-Name"], [data-testid^="card."]')) continue;

      const labelBox = span.closest('div[dir]') || span.parentElement;
      const row = labelBox && labelBox.parentElement;
      if (!row) continue;
      const caretBeside = [...row.children].some(sib =>
        sib !== labelBox &&
        (sib.matches('[data-testid="caret"]') || sib.querySelector('[data-testid="caret"]'))
      );
      if (caretBeside) { labelOk = true; break; }
    }
    if (!labelOk) return false;

    // 条件 B（至少一个）：没有发布时间 <time>，或带有广告曝光统计节点
    const noTime = !article.querySelector('time');
    const hasPixel = !!cell.querySelector(PIXEL);
    return noTime || hasPixel;
  }

  /* ================= 3. 处理与动态加载监听 ================= */
  let hiddenCount = 0;

  function check(cell) {
    const ad = isAdCell(cell);
    if (ad) {
      if (!cell.hasAttribute(MARK)) {
        cell.setAttribute(MARK, '1');
        hiddenCount++;
        if (DEBUG) console.log('[广告屏蔽] 命中 #' + hiddenCount, cell);
      }
    } else if (cell.hasAttribute(MARK)) {
      // 虚拟列表可能复用节点，内容变成正常推文时要还原
      cell.removeAttribute(MARK);
    }
  }

  const dirty = new Set();
  let scheduled = false;

  function flush() {
    scheduled = false;
    for (const cell of dirty) if (cell.isConnected) check(cell);
    dirty.clear();
  }

  function markDirty(node) {
    if (!(node instanceof Element)) node = node && node.parentElement;
    if (!node) return;
    const own = node.closest(CELL);
    if (own) dirty.add(own);
    else node.querySelectorAll(CELL).forEach(c => dirty.add(c));
    if (!scheduled && dirty.size) {
      scheduled = true;
      requestAnimationFrame(flush);
    }
  }

  const observer = new MutationObserver(records => {
    for (const r of records) {
      markDirty(r.target);
      for (const n of r.addedNodes) if (n.nodeType === 1) markDirty(n);
    }
  });

  function start() {
    observer.observe(document.body, { childList: true, subtree: true });
    document.querySelectorAll(CELL).forEach(c => dirty.add(c));
    flush();
  }

  if (document.body) start();
  else document.addEventListener('DOMContentLoaded', start, { once: true });
})();
