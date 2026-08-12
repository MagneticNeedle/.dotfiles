# Login-shell environment, read by every `zsh -l` -- interactive or not.
# PATH lives here rather than in .zshrc so non-interactive login shells
# (e.g. the `zsh -lc "zj"` that raycast/scripts/zj.sh runs inside a fresh
# Alacritty) find zj and uv in ~/.local/bin.
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH
export AI_CLI="claude"
