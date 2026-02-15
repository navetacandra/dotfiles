# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias histclear='history -c && history -w'

cfwarp_status() {
	curl -fsL https://cloudflare.com/cdn-cgi/trace | grep warp=
}

update_dns() {
	sudo resolvconf -u
}

nixenv() {
	nix develop ~/nix#$1
}

PS1='[\033[1m\033[0;36m\u\033[0m@\033[1;32m\h \033[1;34m\W\033[0m] % '

export PATH=$HOME/.local/bin:$PATH
