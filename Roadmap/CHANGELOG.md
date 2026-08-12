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
| 2026-08-05 | **Resume memory gated everywhere it appears** (Peter's catch): the per-series **Continue Watching block on Series Detail** gets the same in-place gate (lock + blur + Join Free); episode-list progress bars / % / ✓ Watched markers hidden while signed out; hero carousel CONTINUE slides hidden while signed out. All restore on join. | ⬜ |
| 2026-08-12 | **Build PRD written** — `prd-vod-user-accounts.md` rewritten in the house PRD template as the engineering handoff for the bundle (VOD + accounts + account-based reminders; player ships share+cast only — sleep timer, queue button, prayer-request submission cut). Published to ClickUp (PRDs → Drafts). Slice = normative visual spec. | meta (spec, not a feature change) |
| 2026-08-12 | **"Log in to your free account" reframe** (Peter): all gate + sheet headlines now log-in-led ("…to save your place" on gates; "…to continue watching / continue listening / save your place in audiobooks / enable prayer reminders" on the sheet); menu card headline "Log in to your free account" with the person glyph in a circle. | ⬜ |
| 2026-08-12 | **Smart email flow**: recognized emails (demo: mary.thompson@gmail.com) skip the name screen and get "Prefer to use a password? Log in or create one"; new emails get name capture and "Create one" only. **Forgot your password?** link on the password screen → Reset-your-password screen (email + Continue → neutral confirmation); Help's Forgot Password routes there too. | ⬜ |
| 2026-08-12 | **Sheet buttons re-tiered to match Hallow**: Continue with Email black (primary), Apple + Google white. | ⬜ |
| 2026-08-12 | **Signed-in identity card v2**: gradient (matches the signed-out card), avatar + name only — no email, no inline sign-out; tapping opens Account. **Account page**: Edit Profile / Update Email / Change Password, then separated **Sign Out** above **Delete My Account**. | ⬜ |
| 2026-08-12 | Series page: divider under the buttons row removed. | ⬜ |
| 2026-08-11 | **Name capture + honest magic-link copy**: email path gains a "What's your name?" screen (one full-name field, parsed to first/last; Apple/Google supply the name); check-email copy now serves new + returning users ("We sent a link… if you're new, the same link creates your account"); "Prefer a password? Log in or **create one**" → new Create-a-password screen. Typed name/email become the signed-in identity (header initials update live). | ⬜ |
| 2026-08-11 | **Account area**: identity row opens **Account** (identity summary + Edit Profile · Update Email · Change Password · Delete My Account). Edit Profile: avatar color gallery (6 RR-palette presets) + Your Photos/Camera (visual), first/last name fields, Save — header + menu update live. Delete: iOS-style confirm → resets to signed-out. | ⬜ |
| 2026-08-11 | **Per-surface gate/sheet headlines** (Peter): "…to continue watching" (Watch) · "…to continue listening" (Home) · "…to save your place in audiobooks" (Listen) · "…to track progress" (series) · "…to enable **prayer** reminders" (reminders). Gate card + sheet always use identical wording. | ⬜ |
| 2026-08-11 | **Series-page polish**: LIVE DAILY chip moved off the hero to below the description; Remind me pill white (was grey — bled into the page bg); series gate breathing room (subtitle dropped, taller padding). | ⬜ |
| 2026-08-11 | **Account sheet rebuilt as a Hallow-style 4-screen flow** (Peter's reference; RR-styled, not cloned): options (contextual headline + ✓ benefits + **Continue with Email** primary / Apple / Google) → "What's your email?" → "Check your email!" **magic link** (+ "log in with your existing password here") → password screen w/ eye toggle. **Help** on email/password → iOS action sheet: Forgot Password (neutral success alert) · Contact Us (mailto info@relevantradio.com). Tapping the magic-link glyph completes sign-in (demo). | ⬜ |
| 2026-08-11 | **Contextual sheet headlines** — "Create your free account to enable reminders / to save progress / to track progress" depending on entry point; default "Create your free account". | ⬜ |
| 2026-08-11 | **One CTA everywhere: "Sign up or log in"** — gate pills, menu account card (replaces Sign up + Log in pair). Gate copy rework: headline "Create your free account to …" + feature-benefit subtitle ("Pick up right where you left off." / "Your audio, right where you paused it." / "Keep your place in every episode."); "It's optional…" line retired. | ⬜ |
| 2026-08-11 | **Home tab: Continue Listening row** (under Articles — the real app has an under-designed version): 3 audio cards (cover, play overlay, green progress bar, time left), account-gated with the same bounded blur module. | ⬜ |
| 2026-08-11 | **Series Detail cleanup** (Peter): single back button (sticky-bar back removed), title bar hairline removed, title enlarged to a real title (22px), host line removed (description only). **Live-prayer series (Mass / Divine Mercy / Family Rosary): Subscribe replaced by the daily-prayer "Remind me" pill** — same look as the Watch rows, same shared state (gates + priming flow included); Subscribe remains for non-prayer series. | ⬜ |
| 2026-08-07 | Menu spacing: card-to-rows gap halved (card marginBottom 18→10, row list marginTop 8→0); beta card keeps its own 18px offset when visible. | ⬜ |
| 2026-08-07 | **Account card v4** (Peter): person icon + "Create your free account" on one line; more negative space (headline→checks 16px, checks→Sign up 20px). **Stock glyphs** replace the custom drawings: Prayer Requests = Lucide message-circle-heart (blue), Give Now = Lucide hand-heart (red). | ⬜ |
| 2026-08-07 | **Account card v3 + menu flattened** (Peter): card headline is now "Create your free account" (21px, kicker removed), person icon enlarged (26px, top-left), checkmark text up to 14px (fills card width). Red **Give Now banner removed** — menu rows now open with **Prayer Requests** (blue praying-hands icon) · **Give Now** (red heart-in-hand icon) · **Daily Prayer Reminders** (gray bell) — colorized icons carry the hierarchy, gray for everything else. | ⬜ |
| 2026-08-07 | **Gates become bounded locked modules** (Peter + UX review): rounded-rect card container (16px, hairline border, soft shadow) around the blurred content, plus a **white scrim (82%)** so headline/reassurance text always clears contrast. Reassurance text darkened. Applies to all three gates (Watch row, Listen grid, Series Detail). | ⬜ |
| 2026-08-07 | **Account card + sheet aligned**: three ✓ benefits now on the menu card (copy simplified per Peter: save your progress while watching · daily prayer reminders · pick up where you left off listening); sheet retitled **"Create your free account"** with the same three checks (echoes the card kicker). | ⬜ |
| 2026-08-07 | **Menu hierarchy**: Prayer Requests demoted from blue banner to a plain menu row (heart icon, next to Daily Prayer Reminders) — one blue object (account card), one red (Give Now), one orange (beta). | ⬜ |
| 2026-08-07 | **BETA demo pill visible on every screen** (was Home-only — made its state invisible elsewhere and looked buggy): sidebar restructured so tab-specific time pills come and go while BETA always renders at the bottom of the stack. Applied to the Vision same-commit (chrome). | 🌐 ported (chrome, same-commit) |
| 2026-08-05 | **Accounts UI copy/type pass (Peter's review):** all serif headlines → DM Sans (gates, sheet, priming card, in-menu reminders header). Account sheet rebuilt benefit-first: headline "Sign in or create an account to track and save your progress", three ✓ benefits, primary **Sign up** + "Already have an account? **Log in**", footnote removed. Gates: pill → "Sign up", reassurance → "It's optional, but it enhances your experience." Menu card: kicker "CREATE YOUR FREE ACCOUNT", benefit headline, Sign up pill + Log in link, "Everything stays free." removed. PRD §5/§6 synced. | ⬜ |

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
