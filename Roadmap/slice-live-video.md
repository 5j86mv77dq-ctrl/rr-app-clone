# Slice — Live Video In-App (Home Screen) · ACTIVE (foundational)

- **Branch:** `prd/live-video-in-app-home-screen`
- **Preview:** https://prd-live-video-in-app-home-screen--relevantradio.netlify.app/
- **Builds toward:** the prayer-reminders slice **and** `main` (vision pieces funnel up to both).
- **Status:** **Active** — the foundational PRD. The prayer-reminders slice is the stage *after*
  this one and builds on it.

## What this is
The Live Video on Home Screen PRD: in-app live video on the Home screen + 11:45 / 2:45 / 6:45 CT
live triggers, scoped to the PRD surface (4-item Home/Explore/Menu/Pray nav, limited video
player — share + cast only, FRAA-specific post-live end screen).

## Funnel direction
This is the foundational slice. Work done here funnels **up into two places**:
1. the **prayer-reminders slice** (`prd/on-device-prayer-reminders-watch-tab`), which builds on
   top of live video, and
2. **`main`** (production / vision).

Because all three lines diverged (the prayer slice re-implemented this work in parallel, and
`main` is ~7 weeks ahead on feature code with its full video library), funneling is a **hand-port
that Claude owns**, not a clean merge. Meta/infrastructure files (`CLAUDE.md`, `Roadmap/`,
`session-log.md`) are kept in sync across branches; only `index.html` feature code diverges.

See [README.md](README.md) for the branch model and workflow.
