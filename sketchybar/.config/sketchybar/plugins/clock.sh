#!/usr/bin/env bash

source "$CONFIG_DIR/theme.sh"

sketchybar --set "$NAME" icon="$NF_CLOCK" label="$(date '+%a %d %b  %H:%M')"
