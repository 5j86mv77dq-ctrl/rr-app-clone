# Relevant Radio App — Audiobooks Visual Prototype

## What This Is
This is a **visual prototype** for the audiobooks section of the Relevant Radio mobile app. It is NOT production code. It exists to iterate on UX/UI designs quickly, get stakeholder approval, and generate a visual spec for the development team.

## Tech Stack
- Single-file React (JSX) with inline styles
- Fonts: Crimson Pro (serif headings) + DM Sans (UI text) via Google Fonts CDN
- No external dependencies beyond React hooks (useState, useMemo)
- All data is hardcoded dummy content
- Mobile viewport: 375 x 812px (iPhone frame with rounded corners)

## How to Work With This
- **All changes should stay in a single JSX file** — do not split into multiple components/files
- **Inline styles only** — no CSS files, no Tailwind, no styled-components
- **Keep it self-contained** — anyone should be able to drop this file into a React sandbox and see it immediately
- **Prioritize visual fidelity over code quality** — this is a prototype, not production
- When adding new pages/views, add them as new states in the existing `view` state machine

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

## Git / Deployment Workflow
- **Always push to GitHub after every change** — the app is hosted via Netlify, which auto-deploys on every push
- After every edit to `index.html`, commit and push to the **current branch** (not hardcoded `main`). Use: `git add index.html && git commit -m "..." && git push origin $(git rev-parse --abbrev-ref HEAD)`
- Remote: `https://github.com/5j86mv77dq-ctrl/rr-app-clone.git`
- `main` is the stable/production version. PRD work happens on branches named `prd/<kebab-case-name>`.

### Netlify Hosting
The app is hosted on **Netlify** (site name: `relevantradio`). Netlify auto-deploys on every `git push` — no build command or config needed (static HTML).

**URLs:**
- **Production** (`main`): `https://relevantradio.netlify.app/`
- **Branch deploys**: `https://<branch-slug>--relevantradio.netlify.app/`
  - Example: `https://prd-live-video-in-app-home-screen--relevantradio.netlify.app/`
  - Slug = branch name with `/` replaced by `-`

**Key facts:**
- Branch deploys are **enabled for all branches** in Site configuration → Build & deploy → Branches and deploy contexts.
- Each branch deploy is **independent** — pushing to `main` does NOT affect a branch URL. A branch URL only updates when you push to that specific branch.
- Every deploy also gets a **permanent permalink** (`https://<deploy-hash>--relevantradio.netlify.app/`) that never changes, even if more commits land on the branch. Use these to freeze a version for stakeholder review.
- Deploys take ~20–30 seconds after push. Check status in the Netlify dashboard → Deploys tab.

**How to deploy:**
- Just `git push`. That's it. Netlify's webhook fires automatically.
- If a branch deploy isn't appearing, verify branch deploys are set to "All" in Netlify site config (see above).
- To force a redeploy without code changes: `git commit --allow-empty -m "Retrigger Netlify deploy" && git push`

**Creating a new branch and deploying it:**
1. `git checkout -b prd/<name>` — create the branch
2. `git push -u origin prd/<name>` — push to GitHub; Netlify picks it up automatically
3. Add a `branchTitles` entry in `index.html` (see Branch Tab Title Rule below)
4. Branch preview URL will be live within ~30 seconds

### Branch Tab Title Rule (IMPORTANT — auto-apply)
Whenever you push to `main` OR push to a new branch for the first time, make sure the `branchTitles` mapping in `index.html` (inside the `<head>` script block near the top) has an entry for the current branch's Netlify slug. This makes the browser tab show a human-readable branch prefix instead of the raw slug.

**How it works:** Netlify branch deploys use hostnames like `<branch-slug>--<site>.netlify.app`. The slug is the branch name with `/` → `-`. For example, branch `prd/live-video-in-app-home-screen` → slug `prd-live-video-in-app-home-screen`.

**What to do:**
1. Compute the slug from the current branch name (`git rev-parse --abbrev-ref HEAD` → replace `/` with `-`).
2. Check `branchTitles` in `index.html`. If the slug isn't a key, add one entry mapping it to a human-readable title.
3. Conventions for the readable title:
   - `prd/...` branches → `"PRD Title Case With Proper Casing (Parentheses If The Branch Name Implies Them)"`. Ask Peter to confirm the exact capitalization/punctuation if there's any doubt (e.g. "In-App" vs "in app", acronyms, parentheses).
   - `main` needs no entry — it's the production deploy and shows the plain title.
   - Other branches (e.g. `experiment/...`, `demo/...`) → Title Case with the prefix spelled out: "Experiment: ..." or "Demo: ...".
4. Commit the `branchTitles` update in the same commit as the feature work (or a standalone commit if the feature is already pushed).

**Never** leave a new branch deployed without a `branchTitles` entry — the tab will fall back to showing the raw slug, which is ugly but still works, so this rule is a quality bar, not a safety mechanism.

## Branch / Roadmap Workflow (Slices → Vision)

**The full model lives in `Roadmap/` — read `Roadmap/README.md` first every session.**
Quick summary:

- `main` is the **production / long-term vision** prototype — the most-complete end-state
  the dev team builds *toward*. Slices funnel their vision pieces **into** `main`; `main` is
  **never** overwritten or fast-forwarded *to* a slice.
- Each change is **🌐 Vision** (funnel into `main`) or **🔀 Transitional / slice-only**
  (stays on its slice). **❓ TBD** = needs Peter's call.
- **Build + verify on the integration branch (`prd/watch-tab-synthesis`) off `main`, then
  `git merge --ff-only` into `main`.** Never experiment directly on `main`.
- **Verify by rendering, not git archaeology.** Headless-render `index.html`
  (`--screenshot` / `--dump-dom`), check for `SyntaxError`/`Unexpected token`, and look at
  the actual screen before claiming anything. (Reading commit messages / grep counts caused
  real errors early on.)
- **Father Rocky gates production** — freeze a Netlify permalink of the `main` deploy for him
  to review each stage.
- **Claude owns all git** (branches, splices, merges, conflicts, asset pulls, promotions).
  **Peter never resolves a conflict** — he makes product calls and reviews visually.

### Meta/infrastructure files are SHARED — propagate to every active branch (STANDARD BEHAVIOR)
- **Meta files = `CLAUDE.md`, `Roadmap/`, `session-log.md`, `.gitignore`, `MEMORY`.** These are
  project infrastructure, **not** feature code — they are meant to be **identical on every
  branch**. Only `index.html` (feature code) is allowed to diverge per slice.
- **Whenever a meta file changes, propagate it to ALL active branches** — don't leave it on one
  branch. Active branches = `main`, the live `prd/...` slices, and the integration branch
  (`prd/watch-tab-synthesis`). **Skip frozen/stale archives** (the Feb-2026 `Video-In-App-Demo`
  / `Audiobooks-Demo` demos) unless Peter asks.
- **How (Claude owns it):** commit the meta change on the working branch, then for each other
  active branch `git checkout <branch>` → `git checkout <source-branch> -- CLAUDE.md Roadmap/
  session-log.md .gitignore` → verify it's a **superset** (no branch-specific meta content lost;
  `session-log.md`/`CHANGELOG.md` accumulate, never shrink) → commit + push. Return to the
  working branch when done.
- This keeps the "start session" branch table, the full session-log, and the workflow rules
  consistent no matter which branch Peter opens a session on.

### Branching a new slice — branch from the CLOSEST base, and CONFIRM first
- **Default base = `main`** (the most complete line → cleanest funnel back). But you may
  branch from a **slice** if it's structurally/visually closer to what you're building
  (faster to vibe-code). Tradeoff: funneling back to `main` is then a hand-port (Claude owns
  it), and that slice's own good work should eventually funnel to `main` too.
- **NEVER assume the base or auto-create a branch.** Before creating a branch, ask Peter:
  *"New slice? What's it building toward? Branch from `main` or from <closest slice>?"* and
  confirm.

### Before editing — confirm the branch (every time work begins)
- At the start of any work (and when a clearly-new feature starts mid-session), **check the
  current branch and confirm it's the intended one.** If Peter is on `main`, or on a slice
  that doesn't match the work, **stop and ask** — e.g. *"You're on `main` — want me to spin
  up a new slice first? From which base?"* or *"This looks like new-feature work — new branch,
  or keep editing `<branch>`? Are you sure?"* **Do not start editing until the branch is
  confirmed.**

### Changelog — log every change, then triage to `main`
- Maintain **`Roadmap/CHANGELOG.md`** — a running, per-branch list of every feature / UI /
  UX change. **Append an entry as each change is made** (date · description · status
  ⬜ pending / 🌐 ported to `main` / 🔀 slice-only).
- Triage on demand or at close session: **list the ⬜ pending entries and ask Peter which to
  port to `main`.** Funnel the chosen ones (build → verify → ff into `main`), then mark them
  🌐; mark the rest 🔀.

**Roadmap files:** `Roadmap/README.md` (model + workflow), `Roadmap/CHANGELOG.md` (running
per-branch change log + port status), `Roadmap/main-production-vision.md` (full feature
inventory of `main`), `Roadmap/slice-live-video.md` (**active slice** — Live Video on Home
Screen, the foundational slice), `Roadmap/slice-prayer-reminders.md` (the next slice, builds
on live video).

## Session Management
- **"open session" / "start session"** — Read `session-log.md`, `Roadmap/README.md` (+ linked
  docs), and `Roadmap/CHANGELOG.md`. Greet Peter with a brief recap, then **present a table of
  all active branches and ask Peter to select which one he's working on:**
  - Build the table from `git for-each-ref --sort=-committerdate refs/heads/`. Columns:
    **Branch · Last commit (date) · Role** (production/vision, active slice, integration branch,
    etc. — pull the role from `Roadmap/README.md` §2). Mark the current branch (`← you are here`).
  - **Omit stale/archived branches** (e.g. the Feb 2026 `Video-In-App-Demo` / `Audiobooks-Demo`
    one-off demos) — show only `main`, the live `prd/...` slices, and the integration branch.
  - After Peter picks, **checkout that branch** (if not already on it) and **confirm the working
    context before any editing:**
    1. *Are we continuing on `<selected branch>`, or starting a new slice?*
    2. *If new: what is it building toward, and which base do we branch from (main or a slice)?*
    3. *Is this part of the roadmap, and are we on the right branch?*
  Don't edit until the branch is selected and the context confirmed.
- **"close session"** — Run this sequence:
  1. Append the session's commits + a 3-5 sentence summary to `session-log.md`.
  2. **Triage `Roadmap/CHANGELOG.md`** — list the ⬜ pending changes and ask Peter which to
     port to `main`; funnel the 🌐 ones (build → verify → ff), mark statuses.
  3. **Update the Roadmap docs** to match what's now true (feature inventory of `main`,
     slice status, changelog).
  4. Commit and push.
- Peter can also trigger the port ritual anytime ("funnel to main" / "what should we port?").

---

## Stakeholder Context
- **Father Rocky** (senior leader) needs to approve visuals — keep designs simple, polished, and demo-ready
- **Peter** (VP Marketing) is iterating on UX decisions — expect frequent changes to layout, copy, and information architecture
- **Dev team** (Brian + contractors) will eventually implement from this prototype — keep the visual spec clear and consistent
