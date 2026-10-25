export PATH="$HOME/.local/bin:$PATH"
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
command -v starship >/dev/null && eval "$(starship init bash)"
command -v fastfetch >/dev/null && fastfetch
