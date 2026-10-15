# toolbox

一些自用脚本。

## 地址

- 仓库：https://github.com/numk/toolbox
- 克隆：`git clone https://github.com/numk/toolbox.git`
- 默认分支：`main`
- RAW Base URL：

```text
https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/
```

某个文件的 RAW 地址 = RAW Base URL + 该文件在仓库中的相对路径。路径里的中文等非 ASCII 字符要做百分号编码。

页面地址与 RAW 地址的对应关系：

```text
https://github.com/numk/toolbox/blob/main/<相对路径>
https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/<相对路径>
```

例如 `tampermonkey/301-Notion代码块字体设置.js`：

- 页面：https://github.com/numk/toolbox/blob/main/tampermonkey/301-Notion%E4%BB%A3%E7%A0%81%E5%9D%97%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE.js
- RAW：https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/301-Notion%E4%BB%A3%E7%A0%81%E5%9D%97%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE.js

油猴脚本头部的 `@updateURL`、`@downloadURL` 使用 RAW 地址。

## 目录

### tampermonkey/

油猴脚本。下面的链接是 RAW 地址，可在 Tampermonkey 里从 URL 安装。

- [301-Notion代码块字体设置.js](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/301-Notion%E4%BB%A3%E7%A0%81%E5%9D%97%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE.js)：Notion 代码块字体改为 JetBrains Mono
- [302-百度翻译净化.js](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/302-%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91%E5%87%80%E5%8C%96.js)：去掉百度翻译页面上的广告和推广
- [303-Github代码设置.js](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/303-Github%E4%BB%A3%E7%A0%81%E8%AE%BE%E7%BD%AE.js)：GitHub 代码字体改为 Google Sans Code / Fira Code / JetBrains Mono

### scripts/

其他脚本，按用途放在子目录里。
