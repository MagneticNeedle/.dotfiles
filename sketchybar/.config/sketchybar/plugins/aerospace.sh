#!/usr/bin/env bash
# Repaints every workspace item: focused one gets a lime pill and shows its
# name, workspaces holding windows stay white, empty ones go grey.

PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/theme.sh"

# Aerospace passes the focused workspace in with the event. On the initial
# `sketchybar --update` there is no event, so ask aerospace directly.
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

# Padded with spaces on both ends so the match below cannot hit a prefix,
# e.g. workspace "1" inside "10".
occupied=" $(aerospace list-workspaces --monitor all --empty no | tr '\n' ' ')"

# Collected into one sketchybar call so the whole row changes in a single
# frame instead of flickering item by item.
args=()
for ws in $(aerospace list-workspaces --all); do
  if [ "$ws" = "$focused" ]; then
    args+=(--set "space.$ws" background.drawing=on background.color="$LIME"
                             icon.color="$BLACK" label.color="$BLACK"
                             label.drawing=on)
  elif [ "${occupied#* $ws }" != "$occupied" ]; then
    args+=(--set "space.$ws" background.drawing=off icon.color="$WHITE"
                             label.drawing=off)
  else
    args+=(--set "space.$ws" background.drawing=off icon.color="$DIM"
                             label.drawing=off)
  fi
done

sketchybar "${args[@]}"
