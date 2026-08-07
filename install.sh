#!/usr/bin/env bash
# Symlink this repo's config packages into $HOME with GNU stow.
#
# Usage: ./install.sh [-n] [host]    (host = a directory name under hosts/)
# With no host argument the host is guessed from the machine.
# -n simulates: prints what stow would change without touching anything.
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

sim=""
host=""
for arg in "$@"; do
  case "$arg" in
    -n|--simulate) sim="--simulate --verbose" ;;
    *) host="$arg" ;;
  esac
done

# Hosts are named <user>-<os>, e.g. bb-mac, magnetic-needle-linux.
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

# The stow package ships ~/.stow-global-ignore (e.g. so Finder's .DS_Store
# droppings never conflict). Stow it on its own first: later invocations in
# this run already honor it, including the first ever run on a new machine.
# shellcheck disable=SC2086
stow $sim --no-folding --restow --target "$HOME" stow

# shellcheck disable=SC2046,SC2086
stow $sim --no-folding --restow --target "$HOME" $(grep -v '^#' "hosts/$host/packages")

for dir in "hosts/$host"/*/; do
  [[ -d "$dir" ]] || continue
  # shellcheck disable=SC2086
  stow $sim --no-folding --restow --dir "hosts/$host" --target "$HOME" "$(basename "$dir")"
done

if [[ -n "$sim" ]]; then
  echo "simulated for host: $host (nothing changed)"
else
  echo "stowed for host: $host"
fi

# Whatever a host needs beyond symlinks. It runs from the repo root and prints
# the steps that are still yours to do, so it goes last, after the stow summary.
if [[ -x "hosts/$host/post-install" ]]; then
  if [[ -n "$sim" ]]; then
    echo "would run hosts/$host/post-install"
  else
    echo
    "./hosts/$host/post-install"
  fi
fi
