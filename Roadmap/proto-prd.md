# Proto — Product Requirements Document

**Status:** CANON. This document supersedes `prototype-system-v3.md` and is the single
definition of the prototyping system and the Proto control room.
**Owner:** Peter Atkinson (product lead). **Maintained by:** Claude, per the rituals in §5.
**Normative visual spec:** `design_process/basis-mockup.html` (live:
https://relevantradio.netlify.app/design_process/basis-mockup.html) — the final clickable
mockup, approved 2026-08-03. Where prose and mockup disagree, the mockup wins for visuals
and this document wins for data and behavior.
**Ships in two stages:** the *system* (repo data model + rituals + the dashboard acting as
interim Proto) ships now; the native macOS app ships later against the same read contract
(§7). Rollout milestones and exit criteria: §9.

---

## 1. What Proto is

Proto is the control room for the Relevant Radio visual-prototyping pipeline: one place to
see every slice, what it's based on, what blocks it, whether its ideas have been funneled
to the Vision, its lifecycle status, its session history — and to start correctly-scoped
Claude Code sessions with one click. It exists in two forms that render the same truth:

- **Interim Proto (now):** `dashboard.html`, deployed at
  https://relevantradio.netlify.app/dashboard.html — the team's front door and Peter's
  bookmark.
- **Proto.app (later):** a personal, single-user native macOS app (SwiftUI), Peter's
  private cockpit. The dev team never needs it.

## 2. Principles (non-negotiable)

1. **Prototypes are the deliverable — and never the codebase.** Stakeholders approve
   pixels. The dev team builds every feature natively in the real app's stack, using slices
   purely as visual specs. Prototype code never ships; that is what makes prototypes cheap
   to create, modify recklessly, and throw away.
2. **The repo is the database. Proto stores nothing.** Every fact on every surface is
   derived from the prototype repo: the PROTO front matter in each slice file, the
   `MANIFEST` in `dashboard.html`, `Roadmap/CHANGELOG.md`, `session-log.md`, and git
   itself. There is no app state to desync.
3. **Rituals write; surfaces read.** Only Claude Code sessions (run under the rituals in
   CLAUDE.md) change the truth. Proto's only "write" actions are launching sessions and
   copying prompts. No form field in Proto edits a slice's facts — re-basing is a
   reintegration *session*, not a dropdown.
4. **Two-repo boundary.** This system touches only the prototype repo
   (`rr-app-clone`). The real app's codebase is the dev team's. Reality enters the system
   exactly one way: Peter announces it ("X shipped", "X is now production").
5. **Two relationships, kept separate.** `base` is LINEAGE — the file a slice was copied
   from, pinned in time; it drives staleness and says nothing about ship order. `dependsOn`
   is SHIP ORDER — what must ship first. Stale ≠ blocked. Chains do not exist as a concept;
   a big feature is just slices linked by dependencies, MVP first.

## 3. Data model (normative)

### 3.1 Slice front matter — the per-file record
Every slice file opens, immediately after `<!DOCTYPE html>`, with:

```
<!--PROTO
name: <Pretty Name>
stage: draft | in-review | in-dev | shipped | archived
production: true | false
base: <path> @ <7-char sha> (<YYYY-MM-DD>[, note])
dependsOn: none | <path>[, <path>…]
-->
```

Rules: `production: true` on **exactly one** slice at any time (the mirror of the real
app; default base for one-offs; moves only when Peter says "X is now production").
`base` is written at creation, pinned to the then-current commit of the base file, and
re-pinned only by a reintegration (§5.6). The Vision (`index.html`) carries a reduced
block (`name: The Vision · stage: vision`); it has no base and is never a slice.

### 3.2 The MANIFEST — the index
The `MANIFEST` object in `dashboard.html` mirrors the front matter and adds display/derived
fields. Per entry: `page` (path = join key), `pretty`, `role` (one sentence), `stage`,
`isMain` (Vision only), `isProduction`, `base` (short display name), `basePath` (path of
the base file), `baseCommit` (7-char sha), `dependsOn` (array of paths, optional),
`funnel` (summary string, e.g. `"3🌐 1🔀 2⬜"`, tallied from the changelog).
**Sync rule: front matter and MANIFEST update in the same commit, always.** A mismatch
between them is a bug in the ritual, surfaced by the integrity check (§5.7).

### 3.3 Derived data (computed, never stored)
- **Staleness** — a slice is stale when (a) its base file has commits after `baseCommit`
  (mechanical: git history of `basePath` since the pin), or (b) the production designation
  moved off its base (announced; Claude flags dependents when the green tag moves). A
  stale flag says *that*, not *how bad* — assessment is §5.6.
- **Funnel status** — per-slice tallies of `Roadmap/CHANGELOG.md` entry statuses
  (⬜ pending / 🌐 ported / 🔀 slice-only). Board shows binary **done** (no ⬜) /
  **open** (⬜ > 0); detail shows the counts.
- **Sessions** — from `session-log.md`: which sessions touched this slice, their dates,
  and whether the open and close rituals ran (a session that changed slice files but has
  no session-log/changelog entries = "not run" in red).
- **URLs** — derived from paths, never stored: local = `http://localhost:8000/<path>`
  (requires "serve local"); Netlify = `https://relevantradio.netlify.app/<path>`.
- **History** — every past state of every page exists in git; the history scrubber renders
  `git show <sha>:<path>` to a temp file and embeds it.

### 3.4 Statuses and badges
`vision` (the Vision only, permanent) · `draft` (edit freely) · `in-review` (with Father
Rocky; light edits only) · `in-dev` (with the dev team; **frozen spec** — no edits without
Peter's explicit OK) · `shipped` (live in the real app) · `archived` (file in
`slices/archive/` or deleted; git preserves) · `planned` (MANIFEST entry with no file yet;
renders ghosted). Overlays, not stages: **prod** (green; the designation) and **stale**
(red; computed).

## 4. Surfaces (spec = final mockup; key behaviors restated)

### 4.1 Chrome
macOS window. Titlebar: traffic lights, **◧** toggles the left sidebar (slides, Apple
Notes style), **◨** (top right) toggles the right sidebar. No app name or repo path in the
titlebar. Floating **⚙** bottom-left opens the Settings modal (centered): repo folder +
Choose…, branch + clean/dirty, data freshness, "stores nothing" note, Refresh-from-repo.
Left sidebar: WORKSPACE → Slices, Graph, Vision, User Manual. No per-slice items.

### 4.2 Slices board (home)
One row per page. Columns: **Slice** (name; green `prod` tag and red `stale` badge attach
here) · **Based on** (display-only chip) · **Depends on** (chip per dependency, or —) ·
**Funneled** (green `done` / amber `open`) · **Status** (stage badge) · **Links**
(`local` pill · `Netlify` pill). Planned entries render ghosted with no links. "Shipped &
archived" collapsed below. Rows open the slice detail.

### 4.3 Slice detail
Single column: header (name, path, stage badges) with actions **Local ↗**, **Netlify ↗**,
**⧉ Start Session** — which **copies the session prompt to the clipboard** (template §5.2;
in Proto.app it may also open Claude Code). Facts trio: Based on (pin + stale warning +
"Assess staleness…" when stale), Depends on, Funneled (counts + pending note). Panels:
**Changelog** (AI-maintained, status chip per entry), **Sessions** (Session · Date ·
Opened · Closed; red "⚠ not run" when a ritual was skipped), **Persona flags**
(Accept / Dismiss; dismissals logged).

### 4.4 Graph
Obsidian-style network: one draggable card per page (name + stacked badges; Vision card
accented blue, production card green-bordered, planned ghosted). Edges: **solid blue →
based on**, **dashed amber → depends on**; arrows track drags live; a clean click (< ~4px
movement) opens the card's page. Legend pinned below. Layout positions are ephemeral in
the mockup; Proto.app may persist them locally (positions are cosmetic, not truth — the
one permitted local preference).

### 4.5 Vision
`vision.md` rendered (the tie-breaker: what the app is for, 3–5 pillars, what it
deliberately will not be) with **Edit deliberately…** (opens a Claude session; every
change logged in `decisions.md`). The Vision prototype itself is viewed via the right
sidebar embed. The Vision page (`index.html`) is durable and AI-maintained — never
regenerated from the doc; it is the accumulated approval artifact.

### 4.6 Right sidebar (◨)
Full-height panel that pushes content left; available on Vision and slice detail. Top:
**history scrubber** — dropdown of versions ("Latest — working tree" + dated commits from
`git log -- <path>`); selecting a version renders `git show <sha>:<path>`. Below: the
**local embed** — the current page live from `localhost:8000` in a phone frame. Local
only, never Netlify.

### 4.7 User Manual
Single column. Ritual step cards (1 Pick a slice → 2 Open the session (⧉ copies the
prompt) → 3 Iterate → 4 Close the session), then panels: Commands, Rules, Statuses,
Terms, **Slice front matter** (the §3.1 block, verbatim). Matter-of-fact tone throughout.

### 4.8 Assess modal
For a stale slice: shows the pin vs current base, agent's diff verdict options —
**🎨 Cosmetic** (restyle in one prompt) / **🧱 Structural** (re-copy base, re-apply the
slice's feature delta from its changelog) / **🧭 Conceptual** (app evolved past the
premise; back to Peter) — and **Reintegrate ▸** which launches the reintegration session.

## 5. Rituals (the write path — encoded in CLAUDE.md, executed by Claude)

1. **open session** — recap from the records; present the board; confirm the target file
   before any edit.
2. **Session prompt** (what ⧉ copies), template:
   `open session — I'm working on <path> (<name>). Recap this slice from
   Roadmap/CHANGELOG.md and session-log.md, confirm the target file with me before
   editing, then we iterate in product language. When I say "close session", run the full
   close ritual: log, funnel triage, board update, push.`
3. **Iterate** — product language only; every change logged ⬜ in the changelog; every
   touched page render-verified before push.
4. **close session** — session log entry; funnel triage (⬜ → Peter decides 🌐/🔀;
   🌐 items hand-ported into `index.html`, element by element, never bulk); MANIFEST +
   front matter synced; push. Includes the **integrity check** (§5.7).
5. **Freeze (→ in-dev)** — Claude drafts the **gap note** from the changelog: Vision
   shows / production has / this slice ships / **deliberately deferred, and why**. The
   slice URL + gap note go to the dev team **as a question** ("what's wrong with it?
   what's expensive?"), never an order.
6. **Staleness & reintegration** — stale flag = detection only. On demand, an assessment
   returns Cosmetic / Structural / Conceptual (§4.8). Reintegration = one prompt: re-copy
   the current base, re-apply the slice's intent from its changelog, re-pin `base`, flag
   what no longer fits. Never hand-patch a stale slice.
7. **Integrity check** — at close: any slice file changed this session without a matching
   changelog entry ⇒ "unrecorded session" warning; front matter ⇄ MANIFEST mismatch ⇒
   same. The system polices its own record-keeping.
8. **Announcements** (only Peter moves reality): "Father Rocky has X" → in-review ·
   "dev team started X" → in-dev · "X shipped" → shipped (+ offer: refresh dependents'
   bases; does the green tag move?) · "X is now production" → designation moves (+ flag
   draft slices based on the old production) · "retire X" → archived.
9. **Creation** — never auto-create. Ask: one-off (copy current production — default), a
   piece of a big feature (copy the piece it depends on), or off the Vision (allowed only
   when the feature exists nowhere else; owes a scope-trim before leaving draft). Copy →
   `slices/<kebab>.html`, set `<title>`, keep `<base href="/">`, write front matter with
   pinned base, add MANIFEST entry, log, push. **Never stack more than 3 unshipped slices
   deep in a dependency line.**

## 6. Non-goals (v1)

No in-app editing of any truth (base, stage, dependencies — all display-only). No embedded
agent (Proto launches Claude Code; Agent-SDK embedding is a later decision). No Netlify
management. No multi-user features. No ClickUp sync (candidate later: a synced, read-only
mirror maintained at close-session). Personas ship as a gated milestone (§9 M4), not v1
core.

## 7. Build notes for Proto.app (macOS, later)

- SwiftUI; single window per §4.1. **Read contract** (stable formats — breaking any
  requires updating this PRD): PROTO front matter (§3.1), MANIFEST (§3.2),
  `Roadmap/CHANGELOG.md` per-slice tables with ⬜/🌐/🔀, `session-log.md` `## Session N —
  date` headings, git (`log`, `show`).
- Actions: clipboard write (⧉), open URLs (local/Netlify), launch Claude Code in the repo
  with a pre-filled prompt, spawn/reuse `python3 -m http.server 8000` for the embed,
  `git show <sha>:<path>` → temp file for the scrubber.
- Rigidity is a feature: the workflow is hardcoded; reopening it requires a dated
  `decisions.md` entry.
- Build order: only after the milestones below have run one real slice end-to-end — Proto
  renders a proven system; it doesn't create one.

## 8. Acceptance criteria (system, i.e. interim Proto)

1. Every page's front matter and MANIFEST entry agree field-for-field, pins included.
2. The deployed dashboard shows: based-on chips, depends-on chips, done/open funnel state,
   computed stale badges, and a working ⧉ session-prompt copy per slice.
3. A deliberate base edit (commit touching a base file) flips the dependent slice's badge
   to STALE on the live dashboard within one refresh.
4. One full open → iterate → close session leaves changelog, session log, front matter,
   and MANIFEST all updated in one push, with the integrity check passing.
5. `vision.md`, `decisions.md`, `slices/archive/` exist; the Vision carries front matter;
   no current-guidance references to chains or the branch model anywhere in the docs.

## 9. Rollout milestones

- **M1 — Canon:** this PRD committed; v3 bannered as superseded; chain/branch leftovers
  purged from current guidance; CLAUDE.md carries every §5 ritual.
- **M2 — Records:** vision.md + decisions.md + slices/archive/; Vision front matter +
  legacy branchTitles script removed; MANIFEST pinned (`basePath`/`baseCommit`), `funnel`
  added; session log current.
- **M3 — Interim Proto:** dashboard computes staleness (git, via GitHub API) and renders
  funnel/depends chips + ⧉ prompt copy. Exit test = acceptance criterion 3.
- **M4 — Personas (gated on Peter providing the documents):** import to `personas/`,
  activate the Persona Pass at session close (a lint, not user research; beta data
  outranks it).
- **M5 — Validation:** VOD scope-trim → in-review → freeze with gap note → handoff as a
  question; legacy `prd/` branches deleted after 2026-08-15; one full ritual loop passes
  the integrity check.
