# Roadmap Changelog

A running, per-slice log of **every feature / UI / UX change**. Claude appends an entry as
each change is made; the **port ritual** (on demand or at close session) lists the ⬜ pending
items and asks Peter which to port into the Vision (`index.html`).

**Status key:** ⬜ pending decision · 🌐 ported to the Vision · 🔀 slice-only (won't port)

> How it works: edit/iterate on a slice page → each change logged here as ⬜ → at close
> session (or when Peter asks "what should we port?") Claude lists the ⬜ items → Peter
> picks → Claude ports the chosen ones into `index.html` (build → verify render → push)
> and marks them 🌐, the rest 🔀. See `README.md` for the full workflow.

> **2026-08-01 — Vision + Slices migration:** slices moved from git branches to pages on
> `main` (`slices/<name>.html`). Entries below predating the migration reference the old
> `prd/...` branches; their content now lives in the corresponding slice page.

---

## `index.html` (the Vision — production)
Changes here are the funnel destination; they're not logged as pending. See
`main-production-vision.md` for the current full feature inventory and `session-log.md` for
history.

---

## `slices/video-on-demand.html` (Video On Demand + User Accounts — one feature, one release)

Copied from the Vision 2026-08-01 (it already contains the full video-library /
on-demand experience). **2026-08-04: VOD and User Accounts merged into one feature that
ships together** (see `decisions.md`); this slice is the single prototype home for both.
The planned separate `user-accounts` slice is dead. Spec: `prd-vod-user-accounts.md`
(its §8 release scope settles this slice's scope-trim debt).

| Date | Change | Status |
|---|---|---|
| 2026-08-01 | Slice created as a copy of the Vision (`index.html`). | meta (creation, not a feature port) |
| 2026-08-03 | Base re-pinned @ 5d6b62c — cosmetic reintegration (base gained meta-only front matter/title changes; no design change). | meta |
| 2026-08-03 | Base re-pinned @ ea6a41a — statuses-removal meta edit; cosmetic. | meta |
| 2026-08-04 | Scope merged with User Accounts (ship together; no separate accounts slice). PRD written: `Roadmap/prd-vod-user-accounts.md`. No file/design change yet — gating UX to be built here per the PRD. | meta (scope + spec, not a feature port) |
| 2026-08-05 | Demo sidebar: **BETA pill** (orange, under EVENT, Home tab) toggles `BETA_BUILD` — the beta-feedback card in the More menu shows only when on (default on). Prototype chrome, not app design. | 🌐 ported (applied to the Vision in the same commit — chrome skipped the funnel wait per Peter) |
| 2026-08-05 | **User accounts — the whole PRD build.** `signedIn` state + demo user (Mary Thompson). **In-place gates** (blur + gold lock + "It's optional" + Join Free pill) on Watch **Continue Watching** and Listen **Continue Listening**; reminder toggles (all entry points, incl. hero pill + end screen) gate via **moment-of-action Join sheet**, with the tapped reminder auto-set after joining. | ⬜ |
| 2026-08-05 | **Join Free sheet** — Apple / Google / email+password, contextual headline (reminder intent vs. generic), "Not now", "Free forever · No spam" footnote. Any method signs in instantly (prototype). | ⬜ |
| 2026-08-05 | **Notification prime-then-prompt** (PRD §7) — after the first reminder is set: "Never miss a prayer" priming card (with the prayer's time) → mock iOS permission dialog. Fires once per session. | ⬜ |
| 2026-08-05 | **Account menu reorg** — identity header first (signed out: blue Join Free card; signed in: MT avatar + name/email + Sign out), then Prayer Requests · Give Now · beta card (moved below Give Now) · **Daily Prayer Reminders page inside the menu** (blue header + the exact Watch-tab rows, "N on" count on the row) · rest of menu + toggles untouched. Header person icon shows **initials** when signed in. | ⬜ |
| 2026-08-05 | Signed-out display state: reminders/resume data hidden while signed out (gates return); anonymous reminders default all-off (was Mass-on). | ⬜ |

_New changes get appended below as ⬜ pending until triaged._

---

## `slices/prayer-reminders.html` (prayer slice — formerly `prd/on-device-prayer-reminders-watch-tab`)

| Date | Change | Status |
|---|---|---|
| 2026-06-04 | Entire Session 16 Watch-tab synthesis + live/countdown/reminders/toggles/colors/data | 🌐 ported to the Vision |
| 2026-06-04 | Give Now → red button | 🌐 |
| 2026-06-04 | Limited video player (remind/play/pause/share/cast only) | 🔀 slice-only |
| 2026-08-03 | Base re-pinned @ e1dc175 — cosmetic reintegration (meta-only base changes). | meta |
| 2026-08-03 | Base re-pinned @ 7014064 — converging re-pin (base's front matter moved in the prior re-pin commit). | meta |

_New changes get appended below as ⬜ pending until triaged._

---

## `slices/live-video.html` (live-video slice — foundational; formerly `prd/live-video-in-app-home-screen`)

The foundational PRD (Live Video on Home Screen). Its changes fed **both** the
prayer-reminders slice and the Vision (hand-port — Claude owns it).

| Date | Change | Status |
|---|---|---|
| 2026-06-05 | Synced meta-infrastructure from `main` (rich CLAUDE.md + Roadmap/) onto this branch; rebuilt complete 1–16 session-log (union of all branches); reactivated this slice as foundational | meta (not a feature port) |
| 2026-06-05 | Skill update: "start session" now presents a table of active branches for Peter to select | meta |
| 2026-06-05 | Home live card: added a 4th demo toggle **"Event"** — a generic *Relevant Radio Live* event ("Live Now" heading, `special-event-livestream.mp4` clip, RR-blue hero bar, brands the video player + end screen on tap-through; end-screen RR logo centered/padded so it isn't clipped). **Hand-port** to `main` + prayer slice (branches diverged). | 🌐 ported (hand-port → `main` `415cb2c`, prayer slice; adapted to each branch's image-based / countdown architecture; Babel-parse verified, visual review pending) |
| 2026-06-05 | Video end screens: removed the top-right "Done" pill; both end screens now use the same centered top **down-arrow** (`collapseToMini`) as the active player — unified close/minimize gesture across the whole player flow. | 🌐 ported (`main` + prayer slice) |
| 2026-06-05 | **Mini player plays the live video clip** (autoPlay/loop/muted) instead of a frozen thumbnail when the series has one; falls back to static series image for on-demand. | 🌐 ported (`main` + prayer slice; added a `getLiveClip` helper on each, since their players were image-based) |
| 2026-08-03 | Base re-pinned @ 5d6b62c — cosmetic reintegration (meta-only base changes). | meta |
| 2026-08-03 | Base re-pinned @ ea6a41a — statuses-removal meta edit; cosmetic. | meta |

_Feature changes get appended below as ⬜ pending until triaged for funnel to prayer-reminders + the Vision._

---

## `slices/beta-feedback.html` (beta-feedback slice — formerly `prd/beta-feedback`)

In-app Beta Feedback (PRD "Beta Testers Feedback Form"), built as a visual prototype — UI/UX
only; the ClickUp / Lambda / Firebase backend is the dev team's. Discrete app-wide menu chrome.

| Date | Change | Status |
|---|---|---|
| 2026-06-05 → 06 | **Beta Feedback flow** — orange mood-board **card** (grain + bloom, "Help shape the app", white "Submit Feedback" pill) at the top of the More menu; branded **form** (orange PageHeader-style banner, titled fields w/ in-field placeholders, orange Send Feedback); orange **confirmation** (orange checkmark + kicker, "Thank you" + bolded mission, orange Done). `BETA_BUILD`-gated (kept visible on `main`). Iterated heavily on the menu entry (in-line button → solid orange → white-outline → titled section → final card) and copy. | 🌐 ported (`main` `5dc0706`, ff via integration branch) |
| 2026-06-05 | **Give Now** button red softened `#d32f2f` → `#cc4b4b` (only that button; global `colors.red` unchanged). | 🌐 ported (`main` `5dc0706`) |
| 2026-08-03 | Base re-pinned @ 5d6b62c — cosmetic reintegration (meta-only base changes). | meta |
| 2026-08-03 | Base re-pinned @ ea6a41a — statuses-removal meta edit; cosmetic. | meta |
