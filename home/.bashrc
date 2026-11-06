# shellcheck shell=bash
# Ryu-dots .bashrc: kept fast on purpose (measure with ryu-bench).
[[ $- != *i* ]] && return
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias ff='fastfetch'   # run it when you want it; it no longer starts with every terminal
PS1='[\u@\h \W]\$ '

# starship: cache its init script instead of spawning starship on every shell
if command -v starship >/dev/null 2>&1; then
  _c="$HOME/.cache/ryu/starship.bash"
  if [ ! -s "$_c" ] || [ "$(command -v starship)" -nt "$_c" ]; then
    mkdir -p "${_c%/*}"; starship init bash --print-full-init > "$_c"
  fi
  # shellcheck disable=SC1090
  source "$_c"
  unset _c
fi
