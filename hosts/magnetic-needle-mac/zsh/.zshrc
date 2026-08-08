
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="edvardm-custom"

HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time



COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8


alias ls="ls -A --color=auto"
alias ll="ls -lA --color=auto"
