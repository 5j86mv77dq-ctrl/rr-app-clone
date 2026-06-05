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

## `prd/live-video-in-app-home-screen` (live-video slice — superseded)
No active changes; features re-implemented in the prayer slice and funneled to `main`.
