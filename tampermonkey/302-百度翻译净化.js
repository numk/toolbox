// ==UserScript==
// @name         百度翻译去广告
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  页面加载完毕后,删除百度翻译页面上的指定广告/推广元素
// @match        https://fanyi.baidu.com/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
    'use strict';

    // 需要删除的元素(XPath)
    const XPATHS = [
        '//div[@id="multiContent"]//div/ul/../..',
        '//div/div[@class="GXuSnnox"]/..',
        '//div/div[@class="Hu5qsRSB"]/..',
        '//div/a[@href="/mtpe-individual/transText"]/../../..',
    ];

    function removeAds() {
        for (const xp of XPATHS) {
            try {
                const snapshot = document.evaluate(
                    xp,
                    document,
                    null,
                    XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
                    null
                );
                for (let i = 0; i < snapshot.snapshotLength; i++) {
                    const node = snapshot.snapshotItem(i);
                    if (node && node.parentNode) {
                        node.parentNode.removeChild(node);
                    }
                }
            } catch (e) {
                console.error('[百度翻译去广告] XPath 执行出错:', xp, e);
            }
        }
    }

    // 页面是单页应用,部分元素会在加载后动态插入,
    // 因此监听 DOM 变化,防抖后再次清理(如不需要可删除此段)
    function observeDom() {
        let timer = null;
        const observer = new MutationObserver(() => {
            clearTimeout(timer);
            timer = setTimeout(removeAds, 300);
        });
        observer.observe(document.body, { childList: true, subtree: true });
    }

    function init() {
        removeAds();
        observeDom();
    }

    // 页面加载完毕后执行
    if (document.readyState === 'complete') {
        init();
    } else {
        window.addEventListener('load', init);
    }
})();