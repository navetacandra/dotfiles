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

PS1='[\u@\h \W] % '

export PATH=$HOME/.local/bin:$PATH
