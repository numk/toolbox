#!/usr/bin/env bash
# 把同目录 aliases.sh 写入 ~/.bashrc 的标记区块，然后 source ~/.bashrc。
# 再次执行只替换标记之间的内容，区块以外的行保持原样。
# Ubuntu 与 Windows Git Bash 都写入 ~/.bashrc。
# Git Bash 启动时会读 ~/.bash_profile，其中再 source ~/.bashrc。
# 本机执行时读取旁边的 aliases.sh；通过 curl 管道执行时再下载该文件。
#
# 执行:
#   curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/alias.sh | bash
#   source ~/.bashrc
#
# 当前终端立刻生效:
#   source <(curl -fsSL https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/alias.sh)
#
# 标记:
#   # >>> toolbox aliases >>>
#   # <<< toolbox aliases <<<
# 若 ~/.bashrc 里区块以外已经有同样的函数或 alias，第一次写入后请自行删掉旧副本。

_toolbox_aliases_sourced=0
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
  _toolbox_aliases_sourced=1
fi

_toolbox_aliases_install() {
  (
    set -euo pipefail

    if [[ -z "${HOME:-}" || ! -d "$HOME" ]]; then
      printf '找不到 HOME，无法写入 ~/.bashrc\n' >&2
      exit 1
    fi

    mark_begin="# >>> toolbox aliases >>>"
    mark_end="# <<< toolbox aliases <<<"
    bashrc="${HOME}/.bashrc"
    payload_url="https://raw.githubusercontent.com/numk/toolbox/refs/heads/main/scripts/21-alias_bash/aliases.sh"
    payload_file=""

    if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
      payload_file="$(dirname "${BASH_SOURCE[0]}")/aliases.sh"
    fi

    if [[ -n "$payload_file" && -f "$payload_file" ]]; then
      payload="$(cat "$payload_file")"
    else
      payload="$(curl -fsSL "$payload_url")"
    fi
    payload="${payload//$'\r'/}"

    if [[ -z "$payload" ]]; then
      printf '没有读到 alias 内容\n' >&2
      exit 1
    fi

    block="${mark_begin}
${payload}
${mark_end}"

    if [[ ! -s "$bashrc" ]]; then
      printf '%s\n' "$block" >"$bashrc"
      exit 0
    fi

    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' EXIT

    in_block=0
    found=0
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
      stripped="${line%$'\r'}"
      if [[ "$stripped" == "$mark_begin" ]]; then
        if [[ "$found" -eq 0 ]]; then
          printf '%s\n' "$block"
          found=1
        fi
        in_block=1
        continue
      fi
      if [[ "$in_block" -eq 1 ]]; then
        if [[ "$stripped" == "$mark_end" ]]; then
          in_block=0
        fi
        continue
      fi
      printf '%s\n' "$line"
    done <"$bashrc" >"$tmp"

    if [[ "$found" -eq 0 ]]; then
      printf '\n%s\n' "$block" >>"$tmp"
    fi

    cat "$tmp" >"$bashrc"
  )
}

_toolbox_aliases_install
_toolbox_aliases_status=$?
unset -f _toolbox_aliases_install

if [[ "$_toolbox_aliases_status" -ne 0 ]]; then
  printf '写入 ~/.bashrc 失败。\n' >&2
  if [[ "$_toolbox_aliases_sourced" -eq 1 ]]; then
    unset _toolbox_aliases_sourced _toolbox_aliases_status
    return 1
  fi
  unset _toolbox_aliases_sourced _toolbox_aliases_status
  exit 1
fi

if builtin source "${HOME}/.bashrc"; then
  _toolbox_aliases_loaded=1
else
  _toolbox_aliases_loaded=0
fi

if [[ "$_toolbox_aliases_loaded" -ne 1 ]]; then
  printf '已写入 %s，但 source 失败，请检查该文件。\n' "${HOME}/.bashrc" >&2
elif [[ "$_toolbox_aliases_sourced" -eq 1 ]]; then
  printf '已更新 %s 中的 toolbox aliases 区块，当前终端已生效。\n' "${HOME}/.bashrc"
else
  printf '已更新 %s 中的 toolbox aliases 区块。\n' "${HOME}/.bashrc"
  printf '当前命令在子进程中执行，这个终端要生效请再运行：\n'
  printf '  source ~/.bashrc\n'
fi

unset _toolbox_aliases_sourced _toolbox_aliases_status _toolbox_aliases_loaded
