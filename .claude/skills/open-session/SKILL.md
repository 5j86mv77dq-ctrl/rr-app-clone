---
name: open-session
description: Start a working session on the prototype — recap where things stand, show the table of the Vision and slice pages, and confirm which file we're working on before any editing. Use when Peter says "open session", "start session", "/open-session", "let's get going", or pastes a session prompt naming a slice path.
---

# Open session

Peter is starting work. He works in the Claude Code desktop app pointed at this folder and
never runs git — Claude owns every commit, push, port, and cleanup.

## 1. Read the records first

- `session-log.md` — what happened last time and the "Next Up" list at the end
- `Roadmap/README.md` and the docs it links
- `Roadmap/CHANGELOG.md` — per-slice change log, and any ⬜ pending items
- If a specific page was named (e.g. `/open-session slices/video-on-demand.html`), read that
  slice's changelog section and front matter too.

If `Roadmap/prds.md` shows as modified in `git status`, that is normal — Peter edits PRDs
inside Proto and Proto does not commit. Commit it as part of this session; never revert it.

## 2. Give a brief recap

Two or three sentences on where things stand. Lead with anything that blocks work: a stale
slice, an unrecorded change, a frozen spec, an open funnel decision.

## 3. Present the page table

From the dashboard `MANIFEST` plus `git log -1 --format=%cs -- <page>` for dates. Exclude
archived slices from the main table; mention the archived count in one line if it matters.

| Page | Last touched | Role |
|---|---|---|

Flag on the row: the designation (`current beta` / `current production`), and `stale` where
the base has moved.

## 4. Confirm the working context — before editing anything

1. Which page are we working on — the Vision (`index.html`) or a slice?
2. If it's something new: new slice, or straight into the Vision? Copied from which base?
3. Is this part of the roadmap?

Do not edit a file until Peter has answered question 1. If the request looks like new-feature
work, stop and ask rather than assuming it belongs on the page currently open.

## Then

Iterate in product language. Every change gets logged in `Roadmap/CHANGELOG.md` as ⬜ pending
(or 🌐 / 🔀 if the call is already obvious), verified by rendering, committed and pushed.

When Peter says "close session", invoke the close-session skill.
