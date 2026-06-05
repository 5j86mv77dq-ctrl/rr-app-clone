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

| 2026-06-05 | Home live card: added a 4th demo toggle **"Event"** — a generic *Relevant Radio Live* event ("Live Now" heading, `special-event-livestream.mp4` clip, RR-blue hero bar, brands the video player + end screen on tap-through; end-screen RR logo centered/padded so it isn't clipped). **Hand-port** to `main` + prayer slice (branches diverged). | ⬜ pending |

_Feature changes get appended below as ⬜ pending until triaged for funnel to prayer-reminders + `main`._
