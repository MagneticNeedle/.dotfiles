#!/usr/bin/env bash
# Name of the focused app. $INFO carries it on front_app_switched; on the first
# run there is no event yet, so ask the system.

app="$INFO"
if [ -z "$app" ]; then
  app="$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')"
fi

sketchybar --set "$NAME" label="$app"
