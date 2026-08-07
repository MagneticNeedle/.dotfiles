#!/usr/bin/env bash
# Track SwipeAeroSpace's settings in this repo.
#
# SwipeAeroSpace (github.com/MediosZ/SwipeAeroSpace) has no config file: it uses
# SwiftUI @AppStorage, i.e. macOS UserDefaults under club.mediosz.SwipeAeroSpace,
# backed by ~/Library/Preferences/club.mediosz.SwipeAeroSpace.plist. That plist
# can't be stowed -- cfprefsd rewrites it atomically (replacing a symlink with a
# real file) and caches values in memory -- so we drive it with `defaults`.
#
# Usage: ./macos/swipeaerospace.sh {apply|export|diff}
#
#   apply    write swipeaerospace.defaults into UserDefaults
#   export   overwrite swipeaerospace.defaults from the live UserDefaults
#   diff     show where the two disagree, changing nothing
#
# Quit SwipeAeroSpace before `apply`: a running instance holds its own copy of
# the values and will write them back over yours on the next change.
#
# Written for the bash 3.2 macOS ships, so no associative arrays.
set -euo pipefail
cd "$(dirname "$0")"

domain="club.mediosz.SwipeAeroSpace"
file="swipeaerospace.defaults"

# <key>:<type>:<app default>, in the order the Settings window lists them.
# Writing a key with the wrong type makes @AppStorage silently fall back to its
# default, so the types have to match SettingsView.swift. The app defaults are
# what we report for a key that has never been set on this machine, since
# UserDefaults only persists what you actually changed. Keys left out here
# (menu bar state, the settings window frame) are UI leftovers, not settings.
settings=(
  "threshold:float:1.0"
  "fingers:string:Three"
  "natrual:bool:true"
  "wrap:bool:false"
  "skip-empty:bool:false"
  "multiSwipe:bool:true"
  "maxSteps:int:5"
  "swipeUpOverview:bool:true"
  "swipeUpFingers:string:Three"
  "show-empty-workspaces:bool:false"
)

# The value for `key` in the tracked file, or "" if it isn't listed there.
tracked_value() {
  awk -v key="$1" '$1 == key { print $2; exit }' "$file"
}

# `defaults read` prints bools as 0/1; normalize so both sides compare equal.
live_value() {
  local key=$1 default=$2 value
  value=$(defaults read "$domain" "$key" 2>/dev/null) || { printf '%s\n' "$default"; return; }
  case "$value" in
    0) printf 'false\n' ;;
    1) printf 'true\n' ;;
    *) printf '%s\n' "$value" ;;
  esac
}

cmd=${1:-}
case "$cmd" in
  apply)
    for entry in "${settings[@]}"; do
      IFS=: read -r key type default <<<"$entry"
      value=$(tracked_value "$key")
      [[ -n "$value" ]] || value=$default
      defaults write "$domain" "$key" "-$type" "$value"
    done
    echo "applied $file to $domain (restart SwipeAeroSpace to pick it up)"
    ;;

  export)
    {
      # Keep the file's comment header, rewrite only the values below it.
      while IFS= read -r line; do
        [[ "$line" == \#* || -z "$line" ]] || break
        printf '%s\n' "$line"
      done <"$file"
      for entry in "${settings[@]}"; do
        IFS=: read -r key _ default <<<"$entry"
        printf '%-21s %s\n' "$key" "$(live_value "$key" "$default")"
      done
    } >"$file.tmp"
    mv "$file.tmp" "$file"
    echo "exported $domain to $file"
    ;;

  diff)
    clean=1
    for entry in "${settings[@]}"; do
      IFS=: read -r key _ default <<<"$entry"
      want=$(tracked_value "$key")
      [[ -n "$want" ]] || want=$default
      have=$(live_value "$key" "$default")
      if [[ "$want" != "$have" ]]; then
        printf '%-21s tracked=%-8s live=%s\n' "$key" "$want" "$have"
        clean=0
      fi
    done
    ((clean)) && echo "in sync"
    ;;

  *)
    echo "usage: $0 {apply|export|diff}" >&2
    exit 1
    ;;
esac
