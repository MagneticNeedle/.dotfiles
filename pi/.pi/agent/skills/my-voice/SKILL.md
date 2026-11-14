---
name: my-voice
description: Write docs, issue bodies, bug reports, READMEs, and posts in the user's own voice. Use whenever the user asks to write, draft, or rewrite any document on their behalf.
---

# Writing in my voice

The user gives you raw information (measurements, logs, notes, context). Shape it into a doc
in their voice — don't add to it, don't polish it.

First person, casual, technically exact. Write like someone posting to a GitHub issue from
memory, not like someone drafting a report. The prose is loose; the data is not.

## Voice

- **Plain, slightly clunky sentences.** Don't balance clauses or refine rhythm.
  - Not: "It decided when to charge and when to stop, which is what I wanted it to do: it charged up and then reported `Not charging` once it paused."
  - Yes: "It worked fine when deciding when to charge and when to stop it. It would charge up and then report `Not charging` when it was supposed to be paused."
- **Comma splices and run-ons are fine.** "So it wasn't idling it was running off the battery while plugged in."
- **Fragments to close a thought.** "Which makes the tab end in the discharging state"
- **Lowercase continuations.** Start a sentence or paragraph with "and because…", "also on this hardware:", "but the charge level kept dropping…" — don't capitalize these openers into formal transitions.
- **Informal shorthand.** "rn", "the tab", "manually edited it". Refer to the device casually once it's been introduced.
- **"i" vs "I" is inconsistent.** Don't systematically fix or force it.
- **No AI framing devices.** Avoid "One caveat I hit while testing:", "In practice", "Worth noting", "which is exactly what I wanted", tricolons, and "X: it does Y" restatements of the previous sentence.
- **Few em-dashes.** Prefer commas and periods. Don't use the "— parenthetical —" pattern more than once or twice in a doc.

## Structure

- Short intro paragraph: device/hardware, versions, what it's used for, and why the topic matters.
- Then a handful of `##` sections for the main flow (e.g. *What I measured / Reason for this behaviour / Proposed Fix / Reproducing*). Keep it to ~4.
- **Don't over-sectionize.** If something is a note or afterthought, append it to the end of an existing section with a casual lead-in ("For reference, this is what the tab has rn:", "also this is necessary but not sufficient…") instead of giving it its own heading.
- If a title is needed, offer 2 bullet options at the top.
- Tables for measured data: yes, keep verbatim.
- Config/code blocks exact, with brief inline comments.
- Suggested fixes as minimal diffs, with a short parenthetical on why the simplest option was chosen.

## Content rules

- **Only state what's in the info the user gave.** Don't invent timings, measurements, or
  specifics that sound plausible ("6–9 s here", "over tens of minutes") — generalize instead
  ("a few seconds", "the 10 or so minutes I applied the changes"). If crucial info is
  missing, say so instead of filling the gap.
- **Don't pad with explanatory asides** that bridge or restate what the data already shows.
- **Don't editorialize at the audience** ("Worth a line in the docs if…"). Give facts; the
  user decides what to suggest to maintainers.
- **Keep dead ends**, but as one-liners: "also on this hardware: `/sys/…/disable` exists but
  is a no-op, `echo 1` still leaves `status=Charging`, so it couldn't be used as a switch."
- **Trim secondary detail.** If a fact isn't needed to understand the issue or reproduce it,
  leave it out. Shorter beats more complete.
- Caveats and non-obvious behavior go after the fix, as an "also…" note — not woven into the
  main narrative with a setup sentence.

## Review pass

Before finishing: read the draft and remove anything that sounds like it was written *about*
the user rather than *by* them — polished rhythm, framing phrases, invented specifics, extra
headings. Every sentence should sound dictated, not composed.
