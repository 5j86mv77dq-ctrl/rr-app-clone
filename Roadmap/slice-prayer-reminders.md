> **SUPERSEDED (2026-08-01 migration).** This document describes the retired branch-per-slice model and is kept as history only. Slices are now pages on `main` (`slices/<name>.html`); the canonical system definition is `Roadmap/proto-prd.md`. Do not follow this file as guidance.

# Slice — On-Device Prayer Reminders (Watch Tab) · ACTIVE SLICE

- **Branch:** `prd/on-device-prayer-reminders-watch-tab`
- **Preview:** https://prd-on-device-prayer-reminders-watch-tab--relevantradio.netlify.app/
- **Builds toward:** `main`
- **Status:** Active slice — the up-to-date live-prayer experience.

## Purpose
The working slice for the live prayer experience: daily prayer reminders, the countdown to
the next live stream, the live-stream player, and the adaptive end screen.

## What has been funneled INTO `main` (🌐 Vision — already live in production)
These were developed/refined here and are now in `main`:
- Daily Prayer Reminders **horizontal rows**.
- The **live + countdown hero** experience, now as the **first slide of the Watch carousel**
  (4 swipeable items) — live video card and ticking **HH:MM:SS** countdown with a **Remind Me**
  pill.
- **Adaptive post-live end screen**.
- **6 Watch time toggles** + **11:45 / 2:45 / 6:45 broadcast start times** (so "live" triggers).
- **Home** time-aware live card + 3 toggles.
- **Per-show hero colors** (Mass gold / Chaplet red / Rosary blue) and **16:9** hero sizing.
- Show data: Chaplet = "Divine Mercy Chaplet" / "Drew Mariani"; Rosary detail = "Fr. Rocky".
- Assets: `visual_elements/shows/ShowThumbnail_*`, `visual_elements/show_clips/*`,
  `rr_shows/reminder_cards/*`.

## What stays here only — does NOT funnel up (🔀 Transitional)
- **Limited video player** — only Remind Me / play / pause / share / cast (no sleep timer,
  prayer cues, series icon, or skip buttons). `main` keeps the **full** player. This is the
  intentional reduced player for the prayer slice.

## Tech note for Claude
This branch was forked from `main` and re-implemented earlier slice work, so it has
**diverged**. Funneling a piece into `main` is usually Claude hand-applying that specific
change directly on `main` and verifying by local render, not a clean auto-merge. **New slices
should branch from `main`** (now the most complete line), not
from this slice — this slice lacks `main`'s video library.

## Related docs / assets
- `watch-screen-decision-log.md`, `watch-screen-todo-v2.md`, `design_process/`
