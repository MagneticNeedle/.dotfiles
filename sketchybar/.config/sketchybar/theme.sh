#!/usr/bin/env bash
# Colors, fonts and icons shared by sketchybarrc and every plugin.
# Sourced, never run on its own.
#
# The palette is the one from ~/.config/borders (the `borders` stow package):
# lime marks what has focus, pink marks what wants attention, grey is
# everything idle. Bar and window border then read as one thing.

# 0xAARRGGBB -- the leading pair is alpha, not a normal web hex color.
LIME=0xffafff00
PINK=0xffff00a8
WHITE=0xffe4e4e7
DIM=0xff585c66
BLACK=0xff0a0a0a
BAR_BG=0x99000000

# Text is Iosevka, same as the terminal; icons come from Hack Nerd Font, which
# Iosevka has no glyphs for. Sketchybar takes a separate font per half of an
# item, so the two never have to agree.
#
# Fonts live in ~/Library/Fonts and are per-user: this machine has two accounts
# and each needs its own copy of Hack (brew install --cask font-hack-nerd-font).
ICON_FONT="Hack Nerd Font:Regular:15.0"
LABEL_FONT="Iosevka Term:Semibold:13.0"

# Every glyph the bar uses, kept here because they are unreadable in place --
# each is a single character from the Nerd Font's private use area, and the
# codepoint in the comment is the only way to tell them apart in an editor.
NF_CLOCK=""     # f017
NF_BATT_100=""  # f240
NF_BATT_75=""   # f241
NF_BATT_50=""   # f242
NF_BATT_25=""   # f243
NF_BATT_0=""    # f244
NF_CHARGING=""  # f0e7
NF_VOL_HIGH=""  # f028
NF_VOL_LOW=""   # f027
NF_VOL_MUTE=""  # f026
NF_WIFI=""      # f1eb
