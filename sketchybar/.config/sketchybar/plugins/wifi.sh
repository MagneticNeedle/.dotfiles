#!/usr/bin/env bash
# Local address, then the network name: "10.0.0.2  <glyph> homewifi".

source "$CONFIG_DIR/theme.sh"

device="$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/ { getline; print $NF; exit }')"
ip="$(ipconfig getifaddr "$device")"

# Every live source for the network name (ipconfig, scutil, system_profiler)
# answers "<redacted>" unless the asking process holds Location Services, which
# a homebrew binary cannot be granted. The saved network list is not gated, and
# macOS moves the network it just joined to the top of it, so line one is the
# one we are on -- as long as the link is actually up, which the list itself
# says nothing about.
ssid=""
if ifconfig "$device" 2>/dev/null | grep -q "status: active"; then
  ssid="$(networksetup -listpreferredwirelessnetworks "$device" | sed -n '2s/^\t//p')"
fi

if [ -n "$ssid" ]; then
  sketchybar --set "$NAME" icon.color="$WHITE" label="$ssid" \
             --set "$NAME.ip" label="$ip" drawing=on
else
  sketchybar --set "$NAME" icon.color="$DIM" label="offline" \
             --set "$NAME.ip" drawing=off
fi
