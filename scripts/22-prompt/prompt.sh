#!/usr/bin/env bash
# 安装彩色提示符：bash prompt.sh [--shell bash|zsh] [--lines 1|2]
# 使用 Bash 执行安装器；--shell 仅选择目标配置文件。
set -euo pipefail

usage() {
    printf '%s\n' '用法: bash prompt.sh [--shell bash|zsh] [--lines 1|2]' \
        '默认: --shell bash --lines 2；重复执行只更新 toolbox prompt 区块。'
}

shell_name=bash
lines=2
while [[ $# -gt 0 ]]; do
    case "$1" in
        --shell|--lines)
            [[ $# -ge 2 ]] || { usage >&2; exit 1; }
            case "$1" in
                --shell) shell_name=$2 ;;
                --lines) lines=$2 ;;
            esac
            shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) printf '未知参数: %s\n' "$1" >&2; usage >&2; exit 1 ;;
    esac
done
[[ "$shell_name" == bash || "$shell_name" == zsh ]] || { usage >&2; exit 1; }
[[ "$lines" == 1 || "$lines" == 2 ]] || { usage >&2; exit 1; }
[[ -n "${HOME:-}" && -d "$HOME" ]] || { printf '找不到 HOME\n' >&2; exit 1; }

rc="${HOME}/.bashrc"
if [[ "$shell_name" == zsh ]]; then
    rc="${ZDOTDIR:-$HOME}/.zshrc"
fi
[[ -d "$(dirname "$rc")" ]] || { printf '配置目录不存在: %s\n' "$rc" >&2; exit 1; }
mark_begin='# >>> toolbox prompt >>>'
mark_end='# <<< toolbox prompt <<<'
tmp=$(mktemp)
block=$(mktemp)
trap 'rm -f "$tmp" "$block"' EXIT

{
    printf '%s\n' "$mark_begin" "TOOLBOX_PROMPT_LINES=$lines"
    cat <<'PAYLOAD'
# 不让 venv/virtualenv 在 PS1 前再加一份环境名；仍需手动激活环境。
export VIRTUAL_ENV_DISABLE_PROMPT=1

__toolbox_prompt_git() {
    local branch
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        branch=$(git rev-parse --short HEAD 2>/dev/null) || return 0
    # Zsh 会继续解释命令替换结果里的 % 提示符转义。
    if [ -n "${ZSH_VERSION:-}" ]; then branch=${branch//\%/%%}; fi
    printf ' git:%s' "$branch"
}

__toolbox_prompt_venv() {
    local name
    [ -n "${VIRTUAL_ENV:-}" ] || return 0
    name=${VIRTUAL_ENV%/}
    name=${name##*/}
    if [ -n "${ZSH_VERSION:-}" ]; then name=${name//\%/%%}; fi
    printf ' py:%s' "$name"
}
PAYLOAD
    if [[ "$shell_name" == bash ]]; then
        cat <<'BASH_PROMPT'
shopt -s promptvars
PS1='\[\e[38;5;39m\]╭─\[\e[1;38;5;82m\]\u\[\e[38;5;247m\]@\[\e[1;38;5;214m\]\h \[\e[38;5;141m\]\w\[\e[38;5;220m\]$(__toolbox_prompt_git)\[\e[38;5;213m\]$(__toolbox_prompt_venv)\[\e[0m\]'
if [ "$TOOLBOX_PROMPT_LINES" = 2 ]; then
    PS1+='\n\[\e[38;5;39m\]╰─'
else
    PS1+=' '
fi
PS1+='\[\e[1;38;5;82m\]\$\[\e[0m\] '
BASH_PROMPT
    else
        cat <<'ZSH_PROMPT'
setopt PROMPT_SUBST PROMPT_PERCENT
PROMPT='%F{39}╭─%B%F{82}%n%b%F{247}@%B%F{214}%m%b %F{141}%~%F{220}$(__toolbox_prompt_git)%F{213}$(__toolbox_prompt_venv)%f'
if [ "$TOOLBOX_PROMPT_LINES" = 2 ]; then
    PROMPT+=$'\n%F{39}╰─'
else
    PROMPT+=' '
fi
PROMPT+='%B%F{82}%#%b%f '
ZSH_PROMPT
    fi
    printf '%s\n' "$mark_end"
} > "$block"

# 先生成完整结果，标记残缺时拒绝写入，避免吞掉用户配置。
in_block=0
found=0
if [[ -e "$rc" ]]; then
    while true; do
        newline=1
        IFS= read -r line || { newline=0; [[ -n "$line" ]] || break; }
        stripped=${line%$'\r'}
        if [[ "$stripped" == "$mark_begin" ]]; then
            [[ "$in_block" == 0 ]] || { printf '区块标记嵌套，未修改配置\n' >&2; exit 1; }
            if [[ "$found" == 0 ]]; then cat "$block"; found=1; fi
            in_block=1
        elif [[ "$stripped" == "$mark_end" ]]; then
            [[ "$in_block" == 1 ]] || { printf '区块结束标记缺少开头，未修改配置\n' >&2; exit 1; }
            in_block=0
        elif [[ "$in_block" == 0 ]]; then
            printf '%s' "$line"
            # 保留区块外原有的末行是否带换行。
            if [[ "$newline" == 1 ]]; then printf '\n'; fi
        fi
    done < "$rc" > "$tmp"
fi
[[ "$in_block" == 0 ]] || { printf '区块缺少结束标记，未修改配置\n' >&2; exit 1; }
if [[ "$found" == 0 ]]; then
    [[ ! -s "$tmp" ]] || printf '\n' >> "$tmp"
    cat "$block" >> "$tmp"
fi
# 原地写入以保留现有文件权限及符号链接。
cat "$tmp" > "$rc"
printf '已更新 %s 的 toolbox prompt 区块（%s 行）。\n' "$rc" "$lines"
printf '在目标 %s 终端执行: source %q\n' "$shell_name" "$rc"
