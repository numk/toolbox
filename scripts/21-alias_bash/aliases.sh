g_init() {
    if [ -z "$1" ]; then
        echo "错误：请输入项目名称"
        echo "用法：g-init <项目名称>"
        return 1
    fi
    REPO_NAME="$1"
    echo "正在创建 GitHub 私有仓库：$REPO_NAME"
    if ! gh repo create "$REPO_NAME" --private --clone; then
        echo "错误：GitHub 仓库创建失败"
        return 1
    fi
    cd "$REPO_NAME" || return 1
    echo "正在初始化 uv 项目..."
    if ! uv init; then
        echo "错误：uv 初始化失败"
        return 1
    fi
    git add .
    git commit -m "初始化 uv 项目"
    git push
    echo "项目初始化完成：$(pwd)"
}

alias sys="systemctl"
alias sysr="systemctl restart"
alias syss="systemctl status"
alias sysp="systemctl stop"
alias ipconfig="ifconfig"
# 过滤注释的行和空行
alias car="grep -Ev '^\s*#|^\s*$'"

alias act='[ -f .venv/Scripts/activate ] && source .venv/Scripts/activate'
alias open='start'

alias oo='start .'
alias g-init='g_init'
alias note='notepad3'
alias notepad='notepad3'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias grep='grep --color=auto'

alias ..='cd ..'
alias 。。='cd ..'
alias ...='cd ../..'

alias gs='git status'
#alias ga='git add'
#alias gc='git commit'
alias gp='git pull'
alias gl='git lg'

alias ur='uv run'
alias ua='uv add'
alias py='uv run python'

alias dp='docker ps'
alias di='docker images'
alias dpa='docker ps -a'
alias dl='docker logs'
