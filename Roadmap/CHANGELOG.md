# Roadmap Changelog

A running, per-branch log of **every feature / UI / UX change**. Claude appends an entry as
each change is made; the **port ritual** (on demand or at close session) lists the ⬜ pending
items and asks Peter which to port to `main`.

**Status key:** ⬜ pending decision · 🌐 ported to `main` · 🔀 slice-only (won't port)

> How it works: edit/iterate on a slice → each change logged here as ⬜ → at close session (or
> when Peter asks "what should we port?") Claude lists the ⬜ items → Peter picks → Claude
> funnels the chosen ones into `main` (build → verify → fast-forward) and marks them 🌐, the
> rest 🔀. See `README.md` for the full workflow.

---

## `main` (production / vision)
Changes here are the funnel destination; they're not logged as pending. See
`main-production-vision.md` for the current full feature inventory and `session-log.md` for
history.

---

## `prd/on-device-prayer-reminders-watch-tab` (prayer slice — active)

| Date | Change | Status |
|---|---|---|
| 2026-06-04 | Entire Session 16 Watch-tab synthesis + live/countdown/reminders/toggles/colors/data | 🌐 ported to `main` |
| 2026-06-04 | Give Now → red button | 🌐 |
| 2026-06-04 | Limited video player (remind/play/pause/share/cast only) | 🔀 slice-only |

_New changes get appended below as ⬜ pending until triaged._

---

## `prd/live-video-in-app-home-screen` (live-video slice — ACTIVE, foundational)

The foundational PRD (Live Video on Home Screen). Changes here funnel up into **both** the
prayer-reminders slice and `main` (hand-port — Claude owns it).

| Date | Change | Status |
|---|---|---|
| 2026-06-05 | Synced meta-infrastructure from `main` (rich CLAUDE.md + Roadmap/) onto this branch; rebuilt complete 1–16 session-log (union of all branches); reactivated this slice as foundational | meta (not a feature port) |
| 2026-06-05 | Skill update: "start session" now presents a table of active branches for Peter to select | meta |

| 2026-06-05 | Home live card: added a 4th demo toggle **"Event"** — a generic *Relevant Radio Live* event ("Live Now" heading, `special-event-livestream.mp4` clip, RR-blue hero bar, brands the video player + end screen on tap-through; end-screen RR logo centered/padded so it isn't clipped). **Hand-port** to `main` + prayer slice (branches diverged). | 🌐 ported (hand-port → `main` `415cb2c`, prayer slice; adapted to each branch's image-based / countdown architecture; Babel-parse verified, visual review pending) |
| 2026-06-05 | Video end screens: removed the top-right "Done" pill; both end screens now use the same centered top **down-arrow** (`collapseToMini`) as the active player — unified close/minimize gesture across the whole player flow. | 🌐 ported (`main` + prayer slice) |
| 2026-06-05 | **Mini player plays the live video clip** (autoPlay/loop/muted) instead of a frozen thumbnail when the series has one; falls back to static series image for on-demand. | 🌐 ported (`main` + prayer slice; added a `getLiveClip` helper on each, since their players were image-based) |

_Feature changes get appended below as ⬜ pending until triaged for funnel to prayer-reminders + `main`._

---

## `prd/beta-feedback` (beta-feedback slice — off `main`)

In-app Beta Feedback (PRD "Beta Testers Feedback Form"), built as a visual prototype — UI/UX
only; the ClickUp / Lambda / Firebase backend is the dev team's. Discrete app-wide menu chrome.

| Date | Change | Status |
|---|---|---|
| 2026-06-05 → 06 | **Beta Feedback flow** — orange mood-board **card** (grain + bloom, "Help shape the app", white "Submit Feedback" pill) at the top of the More menu; branded **form** (orange PageHeader-style banner, titled fields w/ in-field placeholders, orange Send Feedback); orange **confirmation** (orange checkmark + kicker, "Thank you" + bolded mission, orange Done). `BETA_BUILD`-gated (kept visible on `main`). Iterated heavily on the menu entry (in-line button → solid orange → white-outline → titled section → final card) and copy. | 🌐 ported (`main` `5dc0706`, ff via integration branch) |
| 2026-06-05 | **Give Now** button red softened `#d32f2f` → `#cc4b4b` (only that button; global `colors.red` unchanged). | 🌐 ported (`main` `5dc0706`) |
