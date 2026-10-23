---
name: prototype
description: Run a Prototype.app design — start it (3 looks or build in the app), pick a look, work on it, send it to testers, keep it, mark it shipped. Use when a message starts with "Prototype ·" (or "/prototype"), or when Peter talks about a design that has a record in prototype.json.
---

# Prototype designs — ARCHIVED

This repo is archived. Prototype designs now live in `~/Documents/Software/Prototype/Designs`;
do not work on them here. Tell Peter to use Prototype.app.

<!-- previous rules kept below for history -->



Prototype.app (source in `~/Documents/Software/Prototype`, outside this repo) is Peter's
one-sentence workflow. He clicks a button and a new Claude Code session opens in the Claude
desktop app, in this repo, with `Prototype · <action> <id> …` typed in. He presses Enter.
**Everything below happens without him asking for it.** No rituals, no "open session", no "new slice or Vision?" — the
button already answered that. Never ask him to run git, open a file, or say a phrase.

## The record — `prototype.json` (repo root)

`{ "about": …, "designs": [ … ] }`. One object per design; keys are sorted and the file is
pretty-printed (keep it that way — Prototype rewrites it with the same encoder).

| key | meaning |
|---|---|
| `id` | kebab slug; also the slice filename |
| `name`, `request` | the ClickUp item name and Peter's one sentence |
| `start` | `"looks"` or `"build"` |
| `clickupTaskId`, `clickupURL` | the ClickUp item (read only — **never change ClickUp**) |
| `page` | `slices/<id>.html` (Prototype pre-fills it; the file doesn't exist until you make it) |
| `stage` | `looks` · `building` · `testing` · `kept` · `shipped` · `archived` |
| `frozen` | absent/null, `"testers"` or `"dev"` |
| `baseCommit` | 7-char sha of the **Current app** file this design last caught up to |
| `looks` | `["looks/<id>/a.html", "looks/<id>/b.html", "looks/<id>/c.html"]` |
| `pickedLook` | `"a"` / `"b"` / `"c"` |
| `testerPage` | path of the frozen tester copy |
| `created` | `YYYY-MM-DD` |
| `hypothesis`, `goal` | the ClickUp card's 🧭 Hypothesis and 🎯 Goal — the design brief |
| `basePath` | the file staleness is measured against; absent = the Current app |

Prototype shows **every** MANIFEST slice as a card. A slice without a record gets one the first
time Peter presses a button on it (Prototype writes it, with `basePath` from the MANIFEST).

Prototype writes the record at Start, writes `Roadmap/CHANGELOG.md` checklist ticks, and
archives on its own. It never commits anything except an archive. So `prototype.json` and
`CHANGELOG.md` may be dirty when you start: **commit them with your work, never revert them.**

**The Current app** = the MANIFEST entry with `isProduction: true` in `dashboard.html` (today
`slices/live-video.html`). It is a hand-kept replica of the real app, not real code. It
changes only on **shipped** (or when Peter says something shipped).

## Rules on every action

0. **Live preview first.** Peter watches the design while you talk. Make sure the repo is
   served on port 8000 (`python3 -m http.server 8000` from the repo root in the background if
   nothing answers), then open the design's page in this session's **Browser pane**
   (`preview_start` with `url: http://localhost:8000/<page>`; for 3 looks, open look A and
   switch tabs for B and C). After every saved change, reload the pane so he sees it at once.
   Do this silently — no narration about servers or panes.
1. **Find the design** by `id` in `prototype.json`. If Peter just starts talking instead, work
   out which design he means and confirm it in one line ("Working on TMB Content Library.").
2. **Catch up before working (staleness is automatic).** If the design is not frozen and its
   slice exists: when its base (`basePath`, else the Current app) has real (non-front-matter)
   changes since `baseCommit`, bring those changes into the design first (re-copy the Current app and re-apply this
   design's delta from its changelog section when that's cleaner), then set `baseCommit` to
   the Current app's latest commit and re-pin the PROTO `base:` line and MANIFEST
   `baseCommit`. Mention it in one line. **Frozen designs are never refreshed.**
3. **Frozen = edits make a new version.** If `frozen` is set and Peter asks for changes, unset
   `frozen` and change the design slice. The tester copy (`testerPage`) or dev handoff stays
   exactly as it was. If he says it was handed to Brian / frozen for dev, set
   `frozen: "dev"` (and run the slice-announcements "frozen for dev" gap note).
4. **Log every change** in the design's `Roadmap/CHANGELOG.md` section as you make it, status
   `⬜`. Rows Peter ticked in Prototype read `⏫ to Vision (date)`; unticked ones read
   `🔀 slice-only`. **Whenever you work in the repo, port every `⏫` row into `index.html`
   and change it to `🌐 ported`.** Leave `🔀` alone.
5. **Keep Proto's records in step.** A new slice gets the PROTO front matter, a MANIFEST
   entry and a changelog section, exactly as the new-slice skill describes (skip its
   questions — the button answered them).
6. **Verify, commit, push, hand back the link.** Render every touched page locally (serve the
   repo root on port 8000, headless screenshot, check for `SyntaxError`), commit, `git push
   origin main`, then end with the tappable link, e.g.
   `https://relevantradio.netlify.app/slices/<id>.html`. Peter never runs git.

## Where this sits in AppOS (App Playbook, ClickUp)

Design list: Open → create prd → **develop prototype** ⇄ **user prototype testing** → fr. rocky
design review → move to roadmap. Prototype covers the two bold statuses: designing is
develop prototype; **Send to testers** is the build Damien's survey and 5 interviews use (gate:
4/5 complete the core task unaided, 4/5 rate "miss it" ≥ 7, 0 new problems). A failed round
means more work on the design (it unfreezes); **Copy Link** is what Fr. Rocky reviews. Peter
moves ClickUp cards himself — never touch ClickUp.

## Actions

### `start <id>` (the lines after it give the request, how to start, Hypothesis, Goal, ClickUp link)

Design for the Hypothesis and Goal — they are what the AppOS design gate tests.

**How to start: Build it in the app now**
- Copy the Current app to `slices/<id>.html` (title `Slice: <name> — Relevant Radio`, keep
  `<base href="/">`, PROTO front matter with `base: <current app path> @ <sha> (<date>)`).
- Build the feature into it. The full app stays tappable and every other tab still works.
- Set `stage: "building"` and `baseCommit`. Then rule 6.

**How to start: Show me 3 looks first**
- Make 3 distinct visual directions for **only the new feature's key screens** at
  `looks/<id>/a.html`, `b.html`, `c.html`. They are static (no navigation needed) and use the
  app's real look: copy the Current app's fonts, colours, header and nav styles, the same
  375×812 phone frame and dark surround, so a screenshot reads like the app. Add a small
  caption at the top of each saying what the direction is.
- Set `looks` and keep `stage: "looks"`. Push and hand back all 3 links. Tell Peter he can
  press **Pick** on the one he likes in Prototype.

### `pick <id> <letter>`
Set `pickedLook`, then do "Build it in the app now" using that look's design. Set
`stage: "building"`. The looks files stay (they are the record of the choice).

### `work <id>`
Rules 1–3, then ask what to change in one line, or just take the next message.

### `catch up <id>`
Peter pressed **Catch Up** because Prototype showed the design as behind its base. Do rule 2
now (even though nothing else was asked), then rule 6, and finish with one line saying what
came over. Then wait for whatever he wants next.

### `testers <id>`
- Copy the design to `slices/user-testing-<id>.html`, the way the existing user-testing
  slices were cut (see commit f4cf864). Strip operator chrome: the demo/LOADING/ERROR/BETA
  pills, the Dashboard link, demo-time toggles and the branch-title script. Wire every
  dead-end control to an existing view or make it visibly disabled. Keep demo state intact.
- Front matter and MANIFEST get `purpose: user-testing`. Base = the design slice @ its sha.
- Set `testerPage`, `stage: "testing"` and `frozen: "testers"`. Rule 6. Finish by copying the
  link to the clipboard (`printf %s <url> | pbcopy`) and saying so.

### `keep <id>`
Port this design into the Vision (`index.html`) now: every row that isn't `🔀` (`⬜` and `⏫`)
→ port it and mark it `🌐 ported`. Set `stage: "kept"`. Rule 6 with the **Vision link**
(`https://relevantradio.netlify.app/`).

### `shipped <id>`
Copy this design's screens into the Current app slice so it matches what shipped. Ask one
line only if it's unclear which parts shipped. Log it in the Current app's changelog section,
set `stage: "shipped"`, and offer to bump `productionLabel` if the release went to everyone.
Every other non-frozen design is now behind; they catch up the next time they're worked on.
Rule 6 with the Current app link.

### Archive
Prototype does this itself (moves the file to `slices/archive/`, flags front matter and
MANIFEST, sets `stage: "archived"`, commits and pushes). If you find it half-done, finish
those steps. Don't add a changelog row unless the section exists.
