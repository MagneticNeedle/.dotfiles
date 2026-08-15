# Shared zsh config for every host, stowed as ~/.zsh/base.zsh.
# A host's .zshrc sets its overrides (ZSH_THEME, plugins, HISTFILE) first,
# sources this file, then adds host-specific aliases/paths after it.

export LANG=en_US.UTF-8

# oh-my-zsh -- hosts pick a theme/plugins by setting these before sourcing.
# The default theme ships in this package as .oh-my-zsh/custom/edvardm-custom.zsh-theme.
export ZSH="$HOME/.oh-my-zsh"
: "${ZSH_THEME:=edvardm-custom}"
(( ${+plugins} )) || plugins=(git vi-mode)
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':completion:*' rehash true
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit && compinit
fi

bindkey -v
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

alias ls="ls -A --color=auto"
alias ll="ls -lA --color=auto"
