---
name: close-session
description: End a working session properly — write the session log, triage the changelog and port the winners into the Vision, update the roadmap docs, sync Mission Control, run the integrity check, then commit and push. Use when Peter says "close session", "end session", "wrap up", "/close-session", or "we're done for today".
---

# Close session

Skipping this is what breaks the system: work done outside the ritual is not recorded, and
the changelog, the staleness pins and the board go wrong silently. Run all five steps.

## 1. Session log

Append to `session-log.md`: the session's commits (short SHAs) and a 3–5 sentence summary
of what changed and why. Write the *why* — the reasoning is the part that isn't recoverable
from git. End with a "Next Up" list if anything is outstanding.

Keep the existing heading format — Proto parses these headings.

## 2. Triage the changelog

Open `Roadmap/CHANGELOG.md` and list every ⬜ pending item. Peter picks which ones belong in
the Vision. Then, for each 🌐 winner:

- port it into `index.html` by hand, per feature — never copy a slice over the Vision wholesale
- verify by rendering (see the constraint in CLAUDE.md), then push
- mark it 🌐; mark the rest 🔀 slice-only

Update the slice's `funnel` tally in the dashboard `MANIFEST` to match.

## 3. Update the roadmap docs

Make `Roadmap/README.md`, `Roadmap/proto-prd.md` and any slice docs match what is now true.
Log any deliberate design decision in `decisions.md` with its reasoning.

## 4. Sync Mission Control

If a slice was created, renamed, archived, re-pinned, or the designation moved, update the
`MANIFEST` in `dashboard.html` — and the slice's PROTO front matter, in the same commit.

## 5. Integrity check — then commit and push

Warn "unrecorded session" and repair before pushing if any of these are true:

- a slice file changed this session with no matching changelog entry
- front matter and `MANIFEST` disagree (production flag, base pin, dependsOn, archived)
- a MANIFEST entry has `archived: true` but its changelog section has no archive row —
  Proto can archive from the board and deliberately does not write the changelog
- a slice moved to `slices/archive/` but its changelog section heading still points at the
  old path

Then: `git add -A && git commit -m "..." && git push origin main`.
Do not `git add -A` blindly if `rr_shows/new/` or similar large untracked directories are
present — stage deliberately instead.
