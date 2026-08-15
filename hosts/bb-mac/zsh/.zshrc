# PATH and brew env are set in .zprofile (login shells), not here.
source "$HOME/.zsh/base.zsh"

export AI_CLI=claude
brew() { sudo -Hu magnetic-needle /opt/homebrew/bin/brew "$@"; }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bb/softwares/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/bb/softwares/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bb/softwares/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/bb/softwares/google-cloud-sdk/completion.zsh.inc'; fi
