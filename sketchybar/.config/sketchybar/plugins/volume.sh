#!/usr/bin/env bash
# Output volume. $INFO carries the percentage on volume_change; on the first
# run there is no event yet, so ask the system.

source "$CONFIG_DIR/theme.sh"

volume="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"

case "$volume" in
  0)                icon="$NF_VOL_MUTE" ;;
  [1-9]|[1-4][0-9]) icon="$NF_VOL_LOW" ;;
  *)                icon="$NF_VOL_HIGH" ;;
esac

sketchybar --set "$NAME" icon="$icon" label="$volume%"
