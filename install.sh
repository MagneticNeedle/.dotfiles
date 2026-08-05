#!/usr/bin/env bash
# Symlink this repo's config packages into $HOME with GNU stow.
#
# Usage: ./install.sh [host]    (host = a directory name under hosts/)
# With no argument the host is guessed from the machine.
#
# Each host gets the shared packages listed in hosts/<host>/packages, plus
# every package directory under hosts/<host>/ itself (host-specific files
# such as alacritty.toml or niri's config.kdl).
#
# --no-folding makes stow symlink individual files instead of folding whole
# directories, so installers that write into e.g. ~/.local/bin land in a real
# directory on the machine instead of inside this repo.
set -euo pipefail
cd "$(dirname "$0")"

# Hosts are named <user>-<os>, e.g. bb-mac, magnetic-needle-linux.
host="${1:-}"
if [[ -z "$host" ]]; then
  case "$(uname -s)" in
    Darwin) os=mac ;;
    Linux)  os=linux ;;
    *) echo "cannot guess host; usage: $0 <host>" >&2; exit 1 ;;
  esac
  host="$(id -un)-$os"
fi
[[ -f "hosts/$host/packages" ]] || {
  echo "unknown host '$host' (no hosts/$host/packages)" >&2
  exit 1
}

# shellcheck disable=SC2046
stow --no-folding --restow --target "$HOME" $(grep -v '^#' "hosts/$host/packages")

for dir in "hosts/$host"/*/; do
  [[ -d "$dir" ]] || continue
  stow --no-folding --restow --dir "hosts/$host" --target "$HOME" "$(basename "$dir")"
done

echo "stowed for host: $host"
