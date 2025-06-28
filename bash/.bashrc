#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(fzf --bash)"
export PATH="$HOME/.local/bin:$PATH"

export EDITOR=nvim
export OPENER=xdg-open

function proxy_on() {
    export ALL_PROXY="http://127.0.0.1:8118"
    export HTTP_PROXY="http://127.0.0.1:8118"
    export HTTPS_PROXY="http://127.0.0.1:8118"
    echo "Proxy enabled: $HTTP_PROXY"
}

function proxy_off() {
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
    echo "Proxy disabled"
}

function proxy_status() {
    echo "ALL_PROXY=$ALL_PROXY"
    echo "HTTP_PROXY=$HTTP_PROXY"
    echo "HTTPS_PROXY=$HTTPS_PROXY"
}
