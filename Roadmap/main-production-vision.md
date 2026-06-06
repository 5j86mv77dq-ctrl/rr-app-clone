# `main` — Production / Long-Term Vision (Full Feature Inventory)

**Branch:** `main` · **Preview:** https://relevantradio.netlify.app/

`main` is the canonical end-state the dev team builds toward. This is the complete,
current inventory of what it contains. (Verified by rendering, 2026-06-04.) See
[README.md](README.md) for how branches relate to `main`.

---

## Navigation (5 tabs)
**Home · Listen · LIVE** (center red waveform) **· Watch · Pray**
- **Listen** → leads to the **Audiobooks** section.
- **Pray** → "coming soon" placeholder.

## Header
- Logo + status strip; **profile icon** top-right opens the More/Settings screen.

## Home tab
- Promo banner carousel (hidden when a live card is showing).
- **"Now Praying" live card — time-aware.** Driven by **3 demo time toggles (11:45 / 2:45 /
  6:45 CT)**. Each shows the prayer that's live at that time (Mass / Chaplet / Rosary) with
  that show's video clip, **16:9** card, **per-show hero-bar color**, dark overlay.
- **"Live Now" Event card — generic broadcast.** A **demo toggle ("EVENT", all-caps)** shows a
  generic *Relevant Radio Live* event ("Live Now" heading, `special-event-livestream.mp4` clip,
  RR-blue `#3b6fa0` hero bar). Not tied to a scheduled prayer; brands the player + end screen on
  tap-through (player tile / mini / end-screen share use the RR logo via `getSeriesImage`). The
  **Watch tab also has an EVENT toggle** (below 6:45 PM CT) → synthetic special-event live state in
  the Watch hero, same player/end-screen flow. *(Funneled 2026-06-05 from the live-video slice;
  Watch EVENT toggle + all-caps label added 2026-06-06 — S20.)*
- Featured 3-tile row · Articles carousel.

## Watch tab — the video library + live prayer experience
This is the central synthesis. Top to bottom:

1. **Hero = a swipeable carousel (always).** It is NOT replaced when live.
   - When a prayer is **live** (11:45 / 2:45 / 6:45): the **live video card** is the **first
     of 4 slides** — 16:9 autoplaying clip, LIVE badge, per-show colored bottom bar; the 3
     featured items follow. Swipeable, 4 dots.
   - When a prayer is **coming up** (within ~3h; e.g. 9:00 / 1:00 / 4:00 toggles): a
     **countdown card** is the first slide — "UP NEXT", a **ticking HH:MM:SS** countdown,
     a **REMIND ME / REMINDER SET** pill (wired to reminders), the show-thumbnail image,
     per-show colored bottom bar. No "until live" text.
   - Otherwise: just the 3 featured items.
   - Selecting a toggle resets the carousel to slide 1 (the special card) automatically.
2. **Daily Prayer Reminders** — **horizontal rows** (Mass 12:00 / Chaplet 3:00 / Rosary 7:00)
   with a Remind-me / Reminder-set toggle each.
3. **Video library** — ~11 thematic carousel rows (Continue Watching, New This Week,
   Featured Series, Fr. Rocky Teaching, RR Live Prayer, RR Shows, Conferences, Formation,
   Documentaries…), plus **All Series** (2-col grid + filters) and **Series Detail** (hero +
   episode list).

### Hero card bottom-bar copy (live + countdown share this format)
`{label}` on top, `{detail} · {time-or-"Streaming now"}` below, on the per-show color:

| Prayer | Title (label) | Detail | Color | Live window |
|---|---|---|---|---|
| Mass | Daily Mass | Live from the Chapel | gold `#b8922e` | 11:45 AM, 60 min |
| Chaplet | Divine Mercy Chaplet | Drew Mariani | red `#722023` | 2:45 PM, 35 min |
| Rosary | Family Rosary Across America | Fr. Rocky | blue `#009fe0` | 6:45 PM, 40 min |

- Display reminder times are 12:00 / 3:00 / 7:00; broadcasts (live triggers) start 15 min
  earlier at **11:45 / 2:45 / 6:45 CT**.
- Hero countdown/live images use the show thumbnails in `visual_elements/shows/`.

## Video player
- **FULL controls** — portrait/landscape with skip buttons, sleep timer, prayer cues, series
  icon; plus mini player. (The *limited* player is a prayer-slice-only trait — see that doc.)
- **Both the mini player AND the full-screen player play the live clip** (`getLiveClip`) when one
  exists, not a frozen thumbnail; `PlayerVideoTile` (portrait + live) and the landscape player all
  render the `<video>`, falling back to the static series image for on-demand. *(Mini funneled
  2026-06-05; full-screen `clip` prop fixed 2026-06-06 — S20.)*
- **Adaptive post-live end screen** — "Thank you for praying with us!"; shows a reminder card
  if no reminder was set, or a share card if one was already set. **The special-event broadcast
  (no prayer reminder) always shows the share card** with "Broadcast" wording ("Share the Broadcast
  with a friend" / "Special Broadcast" / "Share Broadcast"). **Close control is the same
  centered top down-arrow (`collapseToMini`) as the active player** — unified gesture, no
  separate "Done" pill. Share-card RR logo is centered/padded (`#44628f`) so it isn't clipped.
  *(Funneled 2026-06-05; event share card fixed 2026-06-06 — S20.)*

## Listen tab
- Audiobooks, fully built (Spiritual Reading + Classic Fiction rows, Continue Listening grid,
  All Titles, title detail pages).

## More / Settings
- **App Beta Feedback card (top, BETA_BUILD-gated)** → Prayer Requests banner → **Give Now**
  button (`#cc4b4b`, softened) → menu list (Find a Station, Live Show Schedule, Contact, My
  Downloads, Parish Ambassadors, About) → settings toggles → version footer.
- **Beta Feedback flow** *(funneled 2026-06-06 from the `prd/beta-feedback` slice):*
  - **Card** — a saturated **orange gradient** card with grain/noise overlay + light bloom
    (the quarterly-email "electric skin" recipe): ALL-CAPS "APP BETA FEEDBACK" kicker, bold
    "Help shape the app" headline, tester subline, white "Submit Feedback →" pill. Gated by
    `BETA_BUILD` (true here; flips off for real production builds).
  - **Form** (`settingsView` sub-view) — orange banner header (PageHeader-style + grain),
    titled fields with in-field placeholders (open text + optional email, real controlled
    inputs), orange **Send Feedback**. Submit is visual-only (the PRD's ClickUp/Lambda
    backend is the dev team's, not in the prototype).
  - **Confirmation** — orange checkmark + "FEEDBACK SENT" kicker, "Thank you" + body with the
    bolded mission line, orange **Done**.

## Demo controls (both Home and Watch)
- Floating time toggles (off-frame, right) flip the simulated clock so live/countdown states
  can be previewed: Watch has 6 (9:00–6:45), Home has 3 (11:45 / 2:45 / 6:45). A 1-second
  ticker drives the live HH:MM:SS countdown.

---

## What is NOT in `main` (and why)
- The **limited video player** (remind/play/pause/share/cast only) — that's a prayer-slice
  trait; `main` keeps the full player. See [slice-prayer-reminders.md](slice-prayer-reminders.md).
