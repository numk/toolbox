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

油猴脚本。在浏览器安装 Tampermonkey 后，点击「安装 / 更新」即可从 GitHub RAW 地址安装。脚本均配置了 `@updateURL` 和 `@downloadURL`，便于后续更新。

| 脚本 | 功能 | 适用网站 | 安装地址 |
| --- | --- | --- | --- |
| [301-Notion代码块字体设置.js](https://github.com/numk/toolbox/blob/main/tampermonkey/301-Notion%E4%BB%A3%E7%A0%81%E5%9D%97%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE.js) | 将 Notion 代码块字体替换为 JetBrains Mono | Notion | [安装 / 更新](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/301-Notion%E4%BB%A3%E7%A0%81%E5%9D%97%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE.js) |
| [302-百度翻译净化.js](https://github.com/numk/toolbox/blob/main/tampermonkey/302-%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91%E5%87%80%E5%8C%96.js) | 清理百度翻译页面中的广告和推广 | 百度翻译 | [安装 / 更新](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/302-%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91%E5%87%80%E5%8C%96.js) |
| [303-Github代码设置.js](https://github.com/numk/toolbox/blob/main/tampermonkey/303-Github%E4%BB%A3%E7%A0%81%E8%AE%BE%E7%BD%AE.js) | 设置 GitHub 代码字体（Google Sans Code / Fira Code / JetBrains Mono） | GitHub、Gist | [安装 / 更新](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/303-Github%E4%BB%A3%E7%A0%81%E8%AE%BE%E7%BD%AE.js) |
| [304-X时间线广告屏蔽.js](https://github.com/numk/toolbox/blob/main/tampermonkey/304-X%E6%97%B6%E9%97%B4%E7%BA%BF%E5%B9%BF%E5%91%8A%E5%B1%8F%E8%94%BD.js) | 根据广告标签、页眉按钮及时间/曝光节点识别并隐藏时间线广告，支持滚动加载 | X / Twitter | [安装 / 更新](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/tampermonkey/304-X%E6%97%B6%E9%97%B4%E7%BA%BF%E5%B9%BF%E5%91%8A%E5%B1%8F%E8%94%BD.js) |
### scripts/

其他脚本，按用途放在子目录里。

| 脚本 | 功能 | 适用环境 |
| --- | --- | --- |
| [21-alias_bash/alias.sh](scripts/21-alias_bash/alias.sh) | 安装并更新 Shell alias；维护 `aliases.sh`，重复执行不重复追加 | Ubuntu Bash、Windows Git Bash |
| [22-prompt/prompt.sh](scripts/22-prompt/prompt.sh) | 配置彩色终端提示符，显示用户、主机、路径、Git 分支和 Python 虚拟环境 | Ubuntu Bash、Windows Git Bash、macOS Zsh |

以下保留各脚本的安装命令和详细配置说明。

- [21-alias_bash/alias.sh](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/alias.sh)：读取同目录的 [aliases.sh](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/aliases.sh)，写入 `~/.bashrc` 的标记区块。Ubuntu 与 Windows Git Bash 都适用。重复执行只更新该区块。要改 alias，编辑 `aliases.sh`。

```bash
curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/alias.sh | bash
source ~/.bashrc
```

当前终端立刻生效：

```bash
source <(curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/alias.sh)
```


- [22-prompt/prompt.sh](https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/22-prompt/prompt.sh)：256 色提示符，显示用户名、主机、路径、Git 分支（游离 HEAD 显示短提交号）及已激活的 Python 虚拟环境。支持 Windows Git Bash、Ubuntu Bash、macOS Zsh。

默认 Bash + 双行（写入 `~/.bashrc`）：

```bash
curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/22-prompt/prompt.sh | bash
source ~/.bashrc
```

Bash + 单行：

```bash
curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/22-prompt/prompt.sh | bash -s -- --lines 1
source ~/.bashrc
```

macOS Zsh + 单行（写入 `${ZDOTDIR:-$HOME}/.zshrc`，通常为 `~/.zshrc`）：

```bash
curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/22-prompt/prompt.sh | bash -s -- --shell zsh --lines 1
source "${ZDOTDIR:-$HOME}/.zshrc"
```

参数：`--shell bash|zsh` 默认 `bash`；`--lines 1|2` 默认 `2`。Zsh 双行使用 `--shell zsh --lines 2`。本地运行：`bash scripts/22-prompt/prompt.sh --shell zsh --lines 2`。安装器始终用 Bash 执行，再在对应的 Bash/Zsh 终端里 `source` 配置文件。

配置写入 `# >>> toolbox prompt >>>` / `# <<< toolbox prompt <<<` 标记区块；再次运行会替换该区块，不重复追加，区块外配置保留。后续调整脚本并重新执行即可更新，也可直接修改区块中的 `TOOLBOX_PROMPT_LINES=1` 或 `2` 后重新加载。

Python 虚拟环境仍使用 `source .venv/bin/activate` 激活（Windows Git Bash 为 `source .venv/Scripts/activate`）；提示符自动显示 `py:.venv`，`deactivate` 后隐藏。兼容 `venv`、`virtualenv`、`uv venv`，不自动创建或激活环境。安装时若已激活环境，先 `deactivate`，再加载配置并重新激活，避免旧环境恢复之前的 PS1。

Git Bash 登录启动需由 `~/.bash_profile` 加载 `~/.bashrc`；若已有 `.bash_profile` 却未加载，可加入 `[[ -f ~/.bashrc ]] && source ~/.bashrc`。如使用 Oh My Zsh、Starship 或其他提示符主题，请停用其提示符设置，避免覆盖本区块。
