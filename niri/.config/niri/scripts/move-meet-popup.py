#!/usr/bin/env python3
"""Move Google Chrome's Google Meet pop-out to the HDMI-A-1 monitor.

When you switch focus away from a Meet tab, Chrome spawns a small pop-out
window showing the meeting. We want it floating on the second (vertical)
monitor without stealing focus from the main window.

A static niri window-rule can't do this: niri decides a window's output only
once, at map time (see send_initial_configure in src/handlers/xdg_shell.rs),
and Chrome maps the pop-out with a placeholder title, renaming it to
"Meet - ..." a moment later. By then the placement decision is done and it
has landed next to its parent window. open-floating/open-focused still work
because those are re-applied on title change, but output/workspace are not.

So instead we watch niri's event stream and relocate the pop-out once its
title identifies it. move-window-to-workspace with --focus false keeps focus
on the original window; the "vert" workspace lives on HDMI-A-1.
"""
import json
import re
import subprocess
import sys

WORKSPACE = "vert"          # named workspace pinned to HDMI-A-1 in config.kdl
APP_ID = "google-chrome"
# The pop-out title is "Meet - <name>". The normal browser tab is
# "Meet - <name> - Google Chrome" and must be left alone.
TITLE_RE = re.compile(r"^Meet - ")


def is_meet_popout(w):
    title = w.get("title") or ""
    return (
        w.get("app_id") == APP_ID
        and TITLE_RE.match(title)
        and not title.endswith(" - Google Chrome")
    )


def move_to_second_monitor(window_id):
    subprocess.run(
        [
            "niri", "msg", "action", "move-window-to-workspace",
            "--window-id", str(window_id),
            "--focus", "false",
            WORKSPACE,
        ],
        check=False,
    )


def main():
    proc = subprocess.Popen(
        ["niri", "msg", "--json", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )

    # Window ids we've already relocated, so title-change churn on an
    # already-moved pop-out doesn't yank it back every event. Each new
    # pop-out gets a fresh id, and we clear ids when they close or stop
    # matching, so re-opening a meeting pop-out relocates it again.
    moved = set()

    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue

        if "WindowOpenedOrChanged" in event:
            w = event["WindowOpenedOrChanged"]["window"]
            wid = w["id"]
            if is_meet_popout(w):
                if wid not in moved:
                    moved.add(wid)
                    move_to_second_monitor(wid)
            else:
                moved.discard(wid)
        elif "WindowClosed" in event:
            moved.discard(event["WindowClosed"]["id"])

    return proc.wait()


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(0)
