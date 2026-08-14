# Relevant Radio App — Visual Prototype (Vision + Slices)

## What This Is
This is a **visual prototype** for the Relevant Radio mobile app. It is NOT production code. It exists to iterate on UX/UI designs quickly, get stakeholder approval, and generate a visual spec for the development team.

## Tech Stack
- Single-file React (JSX) with inline styles
- Fonts: Crimson Pro (serif headings) + DM Sans (UI text) via Google Fonts CDN
- No external dependencies beyond React hooks (useState, useMemo)
- All data is hardcoded dummy content
- Mobile viewport: 375 x 812px (iPhone frame with rounded corners)

## How to Work With This
- **Each page is a single self-contained JSX file** — do not split into multiple components/files
- **Inline styles only** — no CSS files, no Tailwind, no styled-components
- **Keep it self-contained** — anyone should be able to drop a page into a React sandbox and see it immediately
- **Prioritize visual fidelity over code quality** — this is a prototype, not production
- When adding new pages/views, add them as new states in the existing `view` state machine

---

## Peter's Daily Flow (VS Code retired — Claude Code owns git)
Peter works in the **Claude Code desktop app** pointed at this folder. He never runs git;
Claude owns every commit, push, port, and cleanup. VS Code is optional and read-only.

1. Say **"open session"** → recap, page table, confirm the target file.
2. Ask for changes in **product language** ("make the prayer card bigger") — Claude edits,
   verifies the render locally, commits, pushes, and hands back the live URL (~30s).
3. Review on the **live Netlify URLs** (Peter and Father Rocky both — never frozen permalinks).
4. New idea? Just describe it — Claude must ask *"new slice, or straight into the Vision?"*
   before creating anything.
5. Say **"funnel to main"** anytime to port slice work into the Vision.
6. Say **"close session"** to end → session log, changelog triage, roadmap update, push.

---

## Rituals live in skills — invoke them by name

Each ritual is a skill in `.claude/skills/<name>/SKILL.md`, loaded only when its phrase is
said. **These pointers are the trigger — follow them rather than handling the ritual from
memory.** Approximating "close session" is exactly how the changelog triage silently doesn't
happen, which is the unrecorded-work failure this file exists to prevent.

- When Peter says **"open session"** / **"start session"** / `/open-session <page>`, invoke the **open-session** skill.
- When Peter says **"close session"**, invoke the **close-session** skill.
- When Peter says **"funnel to main"** or **"what should we port?"**, invoke the **funnel-to-main** skill.
- When Peter says **"new slice"** or describes a new feature to build, invoke the **new-slice** skill.
- When Peter says **"chop up <feature>"**, invoke the **chop-up-feature** skill.
- When Peter says **"serve local"**, invoke the **serve-local** skill.
- When Peter announces **"X is now production"**, **"X shipped"**, **"X is frozen for dev"**, or **"retire X"** / **"archive X"**, invoke the **slice-announcements** skill.
- When a slice is stale and Peter says **"reintegration"** or **"assess staleness"**, invoke the **reintegrate-slice** skill.
- When Peter says **"add loading + error states"**, invoke the **loading-error-states** skill.

Proto's Skills tab lists these and shows the full text of each.

---

## The Vision + Slices Model (ONE branch — canon lives in `Roadmap/proto-prd.md`)

Everything lives on **`main`** — the only branch. There is no branch-per-slice anymore
(migrated 2026-08-01; see Legacy Branches below).

| Page | What it is | URL |
|---|---|---|
| `index.html` | **The Vision** — the complete end-state prototype. What Father Rocky approves and the dev team builds toward. | https://relevantradio.netlify.app/ |
| `slices/<name>.html` | **A slice** — a self-contained stage of development, copied from the closest base and iterated. What the dev team builds *next*. | `https://relevantradio.netlify.app/slices/<name>.html` |
| `dashboard.html` | **Mission Control** — task-list rows (base/deps/funnel chips, updated date, local + Netlify + ⧉ links) for the Vision and every slice, plus the User Manual. Peter's bookmark. Workflow status lives in ClickUp, not here. | https://relevantradio.netlify.app/dashboard.html |

- **Slices funnel their vision pieces INTO `index.html`.** The Vision is never overwritten
  by a slice wholesale — porting is a deliberate, per-feature hand-edit (Claude owns it).
- Each change on a slice is **🌐 Vision** (port into `index.html`) or **🔀 slice-only**;
  ❓ TBD = needs Peter's call. Logged in `Roadmap/CHANGELOG.md`, triaged at close session.
- **Workflow status lives in ClickUp, NOT in the repo** (statuses removed 2026-08-03 —
  Peter refuses dual maintenance). The repo tracks only technical truth: the production
  designation, `base` pins, `dependsOn`, and funnel bookkeeping. The lifecycle still
  *happens* (draft → review → dev → shipped) — it's just tracked in ClickUp. Rules that
  survive here: a slice the dev team is building from is a **frozen spec** (Peter
  announces *"X is frozen for dev"* → draft the gap note; don't edit the file after);
  *"X shipped"* → offer to refresh dependents' bases + ask about the production tag (and
  flip `productionLabel` to `"prod"` if the designated slice is the one that shipped);
  *"retire X"* / *"archive X"* → run the archive steps above (move the file, flag it in both
  records, keep the MANIFEST entry).
- **The designation** — exactly ONE slice carries `isProduction: true` in the `MANIFEST`
  (tinted accent, pinned under the Vision). It is the closest mirror of the real app today
  and the **default base for one-off slices**. Move it only when Peter says *"X is now
  production."* A separate field, `productionLabel`, says what that mirror *is* right now:
  `"beta"` (in the real app, not shipped to everyone — amber tag reading **current beta**)
  or `"prod"` (shipped — green **current production**; the default when the field is absent).
  Currently `slices/live-video.html` @ `productionLabel: "beta"`. Flipping the label when a
  slice ships is part of the *"X shipped"* / *"X is now production"* announcements.
- **Archive** — one state, no sub-types: **the slice is no longer a live workspace.** Shipped
  and done, merged into another slice, abandoned — all the same flag; a free-text
  `archivedNote` (with the date) says which. The file lives in `slices/archive/` and the
  MANIFEST entry is **kept, never deleted** (deleting it hides the slice from Proto and
  breaks lineage). Archived slices collapse into *Archived (n)* on both surfaces, are never
  stale, never raise integrity warnings, and keep working URLs. Procedure:
  **slice-announcements**.
- **Two relationships, kept separate** (chains were removed as a concept 2026-08-02):
  - **`base`** — LINEAGE: the file a slice was copied from, pinned in time. Drives staleness;
    says nothing about ship order (a one-off can sit on an old production pin with no
    dependency at all — stale ≠ blocked).
  - **`dependsOn`** (optional, in the `MANIFEST`) — SHIP ORDER: slice(s) that must ship before
    this one can.
- **Slice front matter** — every slice file opens (right after `<!DOCTYPE html>`) with a
  `<!--PROTO ... -->` comment block: `name` · `production` · `base` (path @ commit
  + date) · `dependsOn` · `archived` (only once archived: the same one-line why-and-when).
  It is the **per-file record**; the dashboard `MANIFEST` is its index. **Update both, in the
  same commit**, on any production move, rebase, dependency change, or archiving.
- **PRDs** — `Roadmap/prds.md` is the register: `| PRD | ClickUp | Slices |`. A slice carries
  several PRDs; a PRD specs one slice. The PRD itself lives in ClickUp — Peter does not open
  markdown PRDs. Proto reads *and writes* this file, so it may be dirty at session start;
  commit it, never revert it. The column order is a parse contract shared with `Repo.swift`.
- **One-offs vs. big features:**
  - **One-off** (small feature, e.g. a call-in button): copy the current-production slice;
    it inherits everything real and adds one thing. Usually no `dependsOn`.
  - **Big feature**: chop into pieces with Peter (MVP first). Only the MVP gets built now;
    each later piece `dependsOn` the previous one and is created by **copying it once it
    stabilizes**. Never stack more than 3 unshipped slices deep in a dependency line. When a
    piece ships, offer to refresh dependents' bases and ask whether the production
    designation moves.

### Never auto-create a slice
A new idea gets a question, not a file — *"new slice, or straight into the Vision?"* — and a
slice is only created after Peter answers. Procedure: the **new-slice** skill.

### Before editing — confirm the target page (every time work begins)
- At the start of any work (and when a clearly-new feature starts mid-session), confirm
  **which file** the work belongs to: the Vision (`index.html`) or which slice. If it's
  ambiguous or looks like new-feature work, **stop and ask** before editing.
- A slice the dev team is building from is a frozen spec (Peter announces *"X is frozen
  for dev"*) — changes to it need Peter's explicit OK.

### Verify by rendering, not git archaeology (before EVERY push)
- Headless-render the touched page(s) (`--screenshot` / `--dump-dom`), check for
  `SyntaxError`/`Unexpected token`, and look at the actual screen before claiming anything.
- Local check: serve the repo root (`python3 -m http.server`) so `<base href="/">` resolves,
  then render `http://localhost:<port>/<page>`.
- **"serve local"** (Peter's phrase) — start `python3 -m http.server 8000` at the repo root
  and leave it running; the dashboard's **local** links point at `localhost:8000`.
- **Always port 8000** — the dashboard's local links are hardcoded to it. Serving on any
  other port silently breaks them.
- **Peter's machine has no Node/npm** (and needs none — React/Babel come from unpkg CDNs,
  so there is no build step). Verify with Python + the browser, never `npx`/`npm`.
- **Start the server from a normal Bash shell.** The Claude Code *preview-server* launcher
  (`.claude/launch.json`) runs its subprocess in a sandbox that cannot read `~/Documents`
  and fails with `Operation not permitted`. Don't reach for `launch.json` here.

### Changelog — log every change as it is made
Maintain **`Roadmap/CHANGELOG.md`** — a running, per-slice list of every feature / UI / UX
change (date · description · status ⬜ pending / 🌐 ported to the Vision / 🔀 slice-only).
Log as you go; don't batch it to the end. Triage is the **funnel-to-main** and
**close-session** skills.

### Stale slices — never hand-patch one
Stale is detection, not a verdict: the base file changed after this slice's pin (meta-only
commits don't count), or the designation moved off its base. Assessment and reintegration:
the **reintegrate-slice** skill. Frozen specs, gap notes and handoff: **slice-announcements**.

### Proto.app — the native macOS control room
- Source: `proto-app/` (SwiftUI, Swift Package). Rebuild: `./scripts/build-proto.sh` →
  `Proto.app` at the repo root (gitignored; launch with `open Proto.app`).
- Sidebar, top to bottom: **North Star · Slices · PRDs · Personas · Skills · User Manual.**
  ("Vision" was renamed North Star 2026-08-14 — the tab collided with *the Vision*,
  `index.html`. `vision.md` calls itself the North Star in its own H1.)
- **Reads** (repo is the database): PROTO front matter, dashboard `MANIFEST`,
  `Roadmap/CHANGELOG.md`, `Roadmap/prds.md`, `vision.md`, `decisions.md`,
  `.claude/skills/*/SKILL.md`, `personas/*.md`, local git (staleness pins, history scrubber
  via `git show`). Spawns `python3 -m http.server 8000` if not running.
- **Two newer parse formats, both part of the read contract:**
  - **Skills** — `.claude/skills/<kebab-name>/SKILL.md`, YAML front matter delimited by `---`
    lines with `name:` and `description:` keys, then the procedure as the markdown body.
    Proto lists name + description and renders the body verbatim. Keep the front matter as
    plain `key: value` on single lines.
  - **Personas** — `personas/*.md` (the directory need not exist; Proto shows an empty state).
    First `# H1` is the persona's name; the rest renders as markdown. These are **audience**
    personas — Relevant Radio listeners — not coworkers or contacts.
- **Writes `Roadmap/prds.md`** (its own file precisely so a Proto edit and a Claude Code
  session can never collide), plus the clipboard and `proto-tmp/` previews.
- **Archiving from Proto** (archivebox on a board row) is its only other write: `git mv` into
  `slices/archive/`, `archived:` into the front matter, and a repointed + flagged MANIFEST
  entry. Each edit is anchored on an exact string and the whole action aborts before moving
  anything if an anchor is missing. It refuses to archive the Vision, the designated slice,
  or a slice something still depends on. **Proto does not commit and does not write the
  changelog** — at close session, any `archived: true` entry whose changelog section has no
  archive row needs one adding.
- Headless checks after changes: `proto-app/.build/debug/Proto --dump` prints the parsed
  model; `--prd-roundtrip` proves the PRD register survives read → edit → write → read
  without touching disk. The parse formats (front matter, MANIFEST, changelog tables,
  session-log headings, the prds.md table) are a **stable read/write contract** — changing
  them means updating Proto too.

### Mission Control — `dashboard.html`
- Self-contained page at the repo root, served at **/dashboard.html** (Peter's bookmark).
- The **`MANIFEST` object inside it is the source of truth** for slice roles, stages, and
  the funnel diagram. Update it whenever a slice is created, changes stage, is renamed,
  or retired — same commit as the change when possible. Last-updated dates and the
  stray-branch strip come live from the GitHub API in-browser.

---

## Git / Deployment Workflow
- **One branch: `main`.** Commit and push after every change — Netlify auto-deploys in
  ~20–30s. Use: `git add -A && git commit -m "..." && git push origin main`
- Remote: `https://github.com/5j86mv77dq-ctrl/rr-app-clone.git`
- Netlify site: `relevantradio`. No build command — static HTML. To force a redeploy:
  `git commit --allow-empty -m "Retrigger Netlify deploy" && git push`
- **Throwaway branches** are allowed ad hoc when a risky change to the Vision wants a
  *deployed* preview before touching production (branch deploys are still enabled:
  `https://<branch-slug>--relevantradio.netlify.app/`). Delete the branch after. Never
  long-lived; slices are files, not branches.
- If production looks frozen while pushes succeed, check Netlify → Deploys for
  "auto publishing off" / a locked deploy (a dashboard setting Claude can't reach).

### Legacy branches (migration 2026-08-01)
- The old slice branches — `prd/live-video-in-app-home-screen`,
  `prd/on-device-prayer-reminders-watch-tab`, `prd/beta-feedback` — were **deleted
  2026-08-14** (local + remote); their content lives on in `slices/`. Tip SHAs are recorded
  in `session-log.md` under Session 26 if they are ever needed.
- `Audiobooks-Demo` / `Video-In-App-Demo` are Feb-2026 frozen archives — leave unless Peter asks.
- The `branchTitles` script in `index.html` is legacy (it only fires on branch-deploy
  hostnames) — harmless; remove whenever convenient. Slice pages carry their own `<title>`.

---

## Design System

### Colors (from Relevant Radio's existing app)
```
Header/Nav blue:    #3b6fa0
Card blue:          #4a7fb3
Page background:    #f5f5f5
Content cards:      #ffffff
Dark nav bar:       #0a1929
Accent blue:        #3b6fa0
Light accent:       #5b9bd5
Body text:          #2a2a2a
Muted text:         #7a7a7a
Live button red:    #d32f2f
Now Playing green:  #2e7d32
```

### Typography
- **Page titles:** Crimson Pro, 24-26px, bold, white (on blue headers)
- **Section headings:** Crimson Pro, 19px, bold, dark
- **Body/UI text:** DM Sans, 12-13px
- **Small labels:** DM Sans, 9-11px, muted gray
- **Cover art titles:** Crimson Pro, 13-14px, bold, white with text shadow

### Components Already Built
- `SearchBar` — dark variant (on blue headers) and light variant (on white)
- `SquareCover` — 140x140 horizontal scroll cover
- `GridCover` — responsive 2-up grid cover
- `SearchResultItem` — compact list item for search results
- `HorizontalRow` — category row with title, optional subtitle, See All link, horizontal scroll
- `PageHeader` — blue header with back arrow, title, optional right element
- `TitleDetailPage` — full detail view with hero, summary, credits, suggestions
- `StaticWaveform` — 5-bar static waveform for LIVE button

---

## App Architecture (Views)

The app uses a `view` state variable to control what's shown:

```
"main"          → Browse page: search bar + horizontal rows (Spiritual Reading, Fiction)
"allTitles"     → All Titles: 2x2 grid of everything + search bar
"allSpiritual"  → Spiritual Reading grid + search bar
"allFiction"    → Fiction grid + search bar
"detail"        → Individual title detail page
```

Navigation flow:
```
Main Page
├── Search bar → filters all titles into list view (inline, no page change)
├── "All Titles →" (header) → allTitles page
├── Spiritual Reading "See All →" → allSpiritual page
├── Fiction "See All →" → allFiction page
└── Tap any cover → detail page
    └── "You Might Also Enjoy" → tap to navigate to another detail page

Every sub-page has a back arrow returning to the previous view.
```

---

## Bottom Navigation (persistent across all views)
1. **Home** — house icon
2. **Listen** — headphones icon
3. **LIVE** — red circle (#d32f2f) with static 5-bar white waveform, centered, same height as other items, NOT animated, NOT elevated above the bar
4. **Watch** — play triangle icon
5. **Pray** — icon

Plus a green "Now Playing" mini-bar floating above the nav showing current live stream.

---

## Content Rules

### Categorization
- **Spiritual Reading** = nonfiction, devotional (e.g., Confessions, Interior Castle, Story of a Soul)
- **Fiction** = literary fiction with Catholic themes (e.g., Brideshead Revisited, Power and the Glory)
- These are the ONLY two categories in audiobooks
- Audio dramas are a completely separate section of the app (not in this prototype)

### The Merry Beggars Branding
The Merry Beggars is the production company that makes all this content. Branding rules:
- **NO badge or logo on any audiobook cover**
- **NO "from The Merry Beggars" on Spiritual Reading** titles
- **YES: "from The Merry Beggars"** as italic gray subtitle under the **Fiction category heading only** — explains why a Catholic radio app has literary fiction
- **YES: Full credits on every title's detail page** under "Details & Credits" (Producer, Director, Audio Editor, Sound Design, Music, Production)
- The Merry Beggars gets full branding only in the audio dramas section (not this prototype)

### Title Detail Page Structure
1. Blue hero section: cover art, preview button, title, duration, author + narrator
2. White content area with rounded top corners overlapping hero
3. "Download to Play" button (blue, full width, rounded)
4. Summary (paragraph text)
5. Divider
6. Details & Credits (label/value pairs: Producer, Director, Audio Editor, Sound Design, Music, Production)
7. Divider
8. "You Might Also Enjoy" — 2 randomly selected titles from the library as square covers

### Dummy Data
- 5 Spiritual Reading titles, 4 Fiction titles
- All have full summaries and credits
- Credits use placeholder names (Michael Torres, Sarah Chen, etc.)

---

## What Needs to Be Built Next (Future Iterations)
- [ ] Listen page (what you see when you tap "Listen" in nav — audiobooks would be a sub-section here)
- [ ] Home page
- [ ] Watch page
- [ ] Pray page
- [ ] Audio dramas section (separate from audiobooks, full Merry Beggars branding)
- [ ] Playback/player UI
- [ ] "Continue Listening" row on main audiobooks page
- [ ] Download progress states
- [ ] Empty states (no search results already handled)
- [ ] Onboarding or first-time experience

---

## Stakeholder Context
- **Father Rocky** (senior leader) needs to approve visuals — keep designs simple, polished, and demo-ready
- **Peter** (VP Marketing) is iterating on UX decisions — expect frequent changes to layout, copy, and information architecture
- **Dev team** (Brian + contractors) will eventually implement from this prototype — keep the visual spec clear and consistent
