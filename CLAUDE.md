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

1. Say **"open session"** → Claude recaps where things stand and shows the table of the
   Vision + slice pages; Peter picks what he's working on.
2. Ask for changes in **product language** ("make the prayer card bigger") — Claude edits,
   verifies the render locally, commits, pushes, and hands back the live URL (~30s).
3. Review on the **live Netlify URLs** (Peter and Father Rocky both — never frozen permalinks).
4. New idea? Just describe it — Claude must ask *"new slice, or straight into the Vision?"*
   before creating anything.
5. Say **"funnel to main"** anytime to run the port ritual (slice → Vision).
6. Say **"close session"** to end → session log, changelog triage, roadmap update, push.

---

## The Vision + Slices Model (ONE branch — canon lives in `Roadmap/proto-prd.md`)

Everything lives on **`main`** — the only branch. There is no branch-per-slice anymore
(migrated 2026-08-01; see Legacy Branches below).

| Page | What it is | URL |
|---|---|---|
| `index.html` | **The Vision** — the complete end-state prototype. What Father Rocky approves and the dev team builds toward. | https://relevantradio.netlify.app/ |
| `slices/<name>.html` | **A slice** — a self-contained stage of development, copied from the closest base and iterated. What the dev team builds *next*. | `https://relevantradio.netlify.app/slices/<name>.html` |
| `dashboard.html` | **Mission Control** — task-list rows (status, updated date, local + share links) for the Vision and every slice, plus the User Manual. Peter's bookmark. | https://relevantradio.netlify.app/dashboard.html |

- **Slices funnel their vision pieces INTO `index.html`.** The Vision is never overwritten
  by a slice wholesale — porting is a deliberate, per-feature hand-edit (Claude owns it).
- Each change on a slice is **🌐 Vision** (port into `index.html`) or **🔀 slice-only**;
  ❓ TBD = needs Peter's call. Logged in `Roadmap/CHANGELOG.md`, triaged at close session.
- **Slice lifecycle** (tracked as `stage` in the dashboard `MANIFEST`):
  `draft` (iterating) → `in-review` (Father Rocky has the URL) → `in-dev` (handed to the dev
  team — the file is now a **frozen spec; don't edit it**) → `shipped` (live in the real app)
  → `archived` (file deleted or moved to `slices/archive/`; git history preserves it).
- **Current-production designation** — exactly ONE slice carries `isProduction: true` in the
  `MANIFEST` (green tag + green accent on the dashboard, pinned under the Vision). It is the
  closest mirror of the real app today (currently `slices/live-video.html`, in beta) and the
  **default base for one-off slices**. Move it only when Peter says *"X is now production."*
- **Two relationships, kept separate** (chains were removed as a concept 2026-08-02):
  - **`base`** — LINEAGE: the file a slice was copied from, pinned in time. Drives staleness;
    says nothing about ship order (a one-off can sit on an old production pin with no
    dependency at all — stale ≠ blocked).
  - **`dependsOn`** (optional, in the `MANIFEST`) — SHIP ORDER: slice(s) that must ship before
    this one can.
- **Slice front matter** — every slice file opens (right after `<!DOCTYPE html>`) with a
  `<!--PROTO ... -->` comment block: `name` · `stage` · `production` · `base` (path @ commit
  + date) · `dependsOn`. It is the **per-file record**; the dashboard `MANIFEST` is its
  index. **Update both, in the same commit**, on any stage change, production move, rebase,
  or dependency change.
- **One-offs vs. big features:**
  - **One-off** (small feature, e.g. a call-in button): copy the current-production slice;
    it inherits everything real and adds one thing. Usually no `dependsOn`.
  - **Big feature**: chop into pieces with Peter (MVP first). Only the MVP gets built now;
    each later piece `dependsOn` the previous one and is created by **copying it once it
    stabilizes**. Never stack more than 3 unshipped slices deep in a dependency line. When a
    piece ships, offer to refresh dependents' bases and ask whether the production
    designation moves.

### Creating a new slice — confirm first, then copy a file
- **NEVER auto-create a slice.** Ask Peter: *"New slice? One-off (copy the current-production
  slice — default), a piece of a bigger feature (copy the piece it depends on), or off the
  Vision (vision-level design work)?"*
- **"Chop up <big feature>"** — define the pieces with Peter first (the MVP that can ship
  fastest comes first), then create only the MVP; later pieces get created as earlier ones
  stabilize.
- Then: copy the base file to `slices/<kebab-name>.html`, set its `<title>` to
  `Slice: <Pretty Name> — Relevant Radio`, **keep the `<base href="/">` tag** (slice pages
  live in a subfolder; assets are root-relative and break without it), **write the PROTO
  front-matter block** (stage: draft, base pinned to the current commit of the base file),
  add a matching `MANIFEST` entry in `dashboard.html` (pretty name, role, `stage`, `base`,
  and `dependsOn` if it can't ship until another slice does), log it in the changelog, push.

### Before editing — confirm the target page (every time work begins)
- At the start of any work (and when a clearly-new feature starts mid-session), confirm
  **which file** the work belongs to: the Vision (`index.html`) or which slice. If it's
  ambiguous or looks like new-feature work, **stop and ask** before editing.
- A slice in `in-dev` or later is a frozen spec — changes to it need Peter's explicit OK.

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

### Changelog — log every change, then triage to the Vision
- Maintain **`Roadmap/CHANGELOG.md`** — a running, per-slice list of every feature / UI /
  UX change (date · description · status ⬜ pending / 🌐 ported to the Vision / 🔀 slice-only).
- Triage on demand ("funnel to main") or at close session: list ⬜ items, Peter picks,
  Claude ports the winners into `index.html` (verify render → push), marks statuses.

### Staleness, reintegration, freeze & handoff (canon: `Roadmap/proto-prd.md` §5)
- **Session prompt** (what the dashboard's ⧉ button copies), template: `open session — I'm
  working on <path> (<name>). Recap this slice from Roadmap/CHANGELOG.md and
  session-log.md, confirm the target file with me before editing, then we iterate in
  product language. When I say "close session", run the full close ritual: log, funnel
  triage, board update, push.`
- **Stale = detection, not verdict.** A slice is stale when its base file has commits
  after its front-matter pin, or the production designation moved off its base. On demand,
  assess and report one verdict: **Cosmetic** (restyle in one prompt) · **Structural**
  (re-copy the current base, re-apply this slice's feature delta from its changelog) ·
  **Conceptual** (the app evolved past the premise — back to Peter). Reintegration
  re-pins `base` in front matter + MANIFEST. **Never hand-patch a stale slice.**
- **Freeze (→ in-dev): draft the gap note** from the changelog — four parts: Vision shows /
  production has / this slice ships / **deliberately deferred, and why**. It travels with
  the slice URL to the dev team.
- **Handoff as a question, never an order** — "here's the intent; what's wrong with it?
  what's expensive? what does the foundation make hard?" Pushback lands before native
  code; the slice adjusts or the constraint enters the funnel.
- **Integrity check at close session** — any slice file changed this session without a
  matching changelog entry, or any front matter ⇄ MANIFEST mismatch → warn "unrecorded
  session" and repair before pushing.

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
  `prd/on-device-prayer-reminders-watch-tab`, `prd/beta-feedback` — are **frozen**; their
  content lives on in `slices/`. **Delete them (local + remote) after ~2026-08-15.**
- `Audiobooks-Demo` / `Video-In-App-Demo` are Feb-2026 frozen archives — leave unless Peter asks.
- The `branchTitles` script in `index.html` is legacy (it only fires on branch-deploy
  hostnames) — harmless; remove whenever convenient. Slice pages carry their own `<title>`.

---

## Session Management
- **"open session" / "start session"** — Read `session-log.md`, `Roadmap/README.md` (+ linked
  docs), and `Roadmap/CHANGELOG.md`. Greet Peter with a brief recap, then **present a table
  of the Vision + slice pages** (from the dashboard `MANIFEST` + `git log -1 --format=%cs --
  <page>` for last-touched dates). Columns: **Page · Stage · Last touched · Role**. Then
  confirm the working context before any editing:
  1. *Which page are we working on — the Vision or a slice?*
  2. *If something new: new slice or straight into the Vision? Copy from which base?*
  3. *Is this part of the roadmap?*
- **"close session"** — Run this sequence:
  1. Append the session's commits + a 3–5 sentence summary to `session-log.md`.
  2. **Triage `Roadmap/CHANGELOG.md`** — list ⬜ pending changes, Peter picks, port the 🌐
     ones into the Vision (build → verify render → push), mark statuses.
  3. **Update the Roadmap docs** to match what's now true.
  4. **Sync Mission Control** — if a slice was created/staged/renamed/retired, update the
     `MANIFEST` in `dashboard.html`.
  5. Commit and push.
- Peter can also trigger the port ritual anytime ("funnel to main" / "what should we port?").

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
