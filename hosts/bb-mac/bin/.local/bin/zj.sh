#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title zj
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "project", "optional": true }

# Documentation:
# @raycast.description launches zellij with a custom layout in a new Alacritty window
# @raycast.author MagneticNeedle
# @raycast.authorURL https://github.com/MagneticNeedle

set -euo pipefail

project="${1:-}"

# zsh -lc so the login profile puts ~/.local/bin (zj, uv) and brew on PATH:
# Alacritty's -e runs the command directly, without a shell.
cmd="zj"
[ -n "$project" ] && cmd="zj $(printf '%q' "$project")"

# -n forces a fresh instance so every invocation gets its own window instead of
# being swallowed by an already-running Alacritty.
open -na Alacritty --args -e zsh -lc "$cmd"

echo "zj ${project:-\$PWD}"
