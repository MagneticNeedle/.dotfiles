#!/usr/bin/env bash
# Battery level, pink once it is low enough to care about.

source "$CONFIG_DIR/theme.sh"

batt="$(pmset -g batt)"
percent="$(echo "$batt" | grep -Eo '[0-9]+%' | tr -d '%')"
[ -z "$percent" ] && exit 0

color="$WHITE"
case "$percent" in
  100|9[0-9]|8[0-9]) icon="$NF_BATT_100" ;;
  7[0-9]|6[0-9])     icon="$NF_BATT_75" ;;
  5[0-9]|4[0-9])     icon="$NF_BATT_50" ;;
  3[0-9]|2[0-9])     icon="$NF_BATT_25" ;;
  *)                 icon="$NF_BATT_0"; color="$PINK" ;;
esac

# Charging overrides the level icon -- what matters then is that it is plugged
# in, not how full it is.
case "$batt" in
  *"AC Power"*) icon="$NF_CHARGING"; color="$LIME" ;;
esac

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="$percent%"
