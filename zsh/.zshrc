
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

zstyle :compinstall filename '/home/magnetic-needle/.zshrc'
zstyle ':completion:*' rehash true
autoload -Uz compinit
compinit


export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="eastwood"
plugins=(git)
source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias v="nvim"
alias ls="ls -hoag --color=auto"

. "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/pycharm-eap/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export GPG_TTY=$(tty)
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward 
