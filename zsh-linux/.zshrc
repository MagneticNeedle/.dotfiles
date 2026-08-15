# .zshrc shared by both linux hosts, layered on the zsh package's base.
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000

plugins=(git)
source "$HOME/.zsh/base.zsh"

export EDITOR=nvim
alias vim="nvim"
alias v="nvim"
alias ls="ls -hoag --color=auto"

. "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/pycharm-eap/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export GPG_TTY=$(tty)
