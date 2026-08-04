# PRD — Video On Demand + User Accounts (one feature, one release)

> **Scope decision 2026-08-04 (Peter):** Video On Demand and User Accounts are the
> **same feature and ship together**. This supersedes the earlier plan of a separate
> `user-accounts` slice depending on VOD (see `decisions.md`).

**Status:** Draft — awaiting Peter's review, then Father Rocky.
**Owner:** Peter (product) · Claude (document + prototype).
**Prototype home:** `slices/video-on-demand.html` — the single slice for both the VOD
experience and the accounts/gating UX.
**Reference pattern:** EWTN's in-place soft gate (screenshots reviewed 2026-08-04) —
locked row visible with blurred preview, "It's optional" reassurance, Join Free button.

---

## 1. What this is

One release: the **on-demand video library** (Watch tab: series, episodes, live-prayer
replays) together with **free user accounts** that remember things for you. The product
philosophy, from `vision.md` Pillar 4:

> **Accounts serve continuity.** Resume, favorites, downloads — never a wall before
> first play. · **Not a paywall.**

Everything in the app is free. An account is never required to watch, listen, or pray.
What an account adds is **memory**: the app remembering your place, your reminders, and
your list — on every device you sign in to. The account is the mechanism of continuity,
not a gate on content.

Why this works (research grounding): "gradual engagement" — letting a user reach real
value before any sign-up ask — measurably beats sign-up walls, which leak users at every
forced prompt; apps that defer the ask and show the benefit first see materially higher
conversion and retention. Tubi is the canonical free-video precedent: watch everything
without an account; a free account adds "save your place." That is exactly our model.

## 2. Principles (non-negotiable)

1. **Everything is free, forever.** No paywall, no premium tier, nothing priced.
2. **Never a wall before first play.** The app never asks for an account at launch,
   at first open, or before any playback. First session = zero prompts.
3. **Gate the memory, not the content.** Accounts gate persistence and sync (your
   place, your list, your reminders) — never playback, browse, or search.
4. **Show the value before the ask.** A gate always previews what it unlocks (blurred
   row of real content, named benefit) — the user sees exactly what joining gives them.
5. **Optional forever.** A signed-out app is fully functional for live + on-demand
   playback. Gates are furniture, not interruptions — no modals on open, no nagging,
   no growth tricks.
6. **One identity, every device.** Sign in anywhere and your continuity follows.

## 3. Feature matrix

| Feature | Signed out (free) | With free account |
|---|---|---|
| Live streams (radio, video, prayer) | ✅ Full access | ✅ Same |
| On-demand playback (all series & episodes) | ✅ Full access, always playable | ✅ Same |
| Browse / search / series detail | ✅ Full access | ✅ Same |
| Audiobooks — first play | ✅ Plays | ✅ Same |
| Prayer requests · Give | ✅ Full access | ✅ Same |
| **Daily prayer reminders** (Mass 12 PM · Chaplet 3 PM · Rosary 7 PM) | 🔒 Gate on the toggle | ✅ Set once, fires on every signed-in device |
| **Continue Watching** (video resume) | 🔒 Row gated; episodes still playable from start | ✅ Resume where you left off, cross-device |
| **Continue Listening** (audio resume) | 🔒 Row gated; audio still playable from start | ✅ Same as video |
| **Favorites / My List** | 🔒 Gate on row + save action | ✅ Personal list across the app |
| **My Downloads** | 🔒 Gate on download action | ✅ Downloads tied to the account |

Everything above the line is free-anonymous by principle #2 and is never gated.

## 4. Sign-in methods

- **Sign in with Apple** · **Google** · **email + password** — the 2026 consumer
  baseline. App Store guideline 4.8: offering any third-party login (Google) **requires**
  offering Sign in with Apple as an equivalent option — so Apple is non-optional.
- **Minimal capture:** name + email only. Email sign-up asks for exactly two fields
  (email, password). No phone number, no birthday, no survey. Every extra field costs
  conversion.
- **Hide My Email** (Apple relay addresses) fully supported — a relay address is a
  first-class account.
- **No data-for-ads.** Account data personalizes nothing except the user's own
  continuity; no interaction tracking for advertising (also a 4.8 requirement for
  login-service parity).
- Copy convention: the app already speaks this dialect — the audiobook detail page's
  "**Create Free Account to Listen**" pill. All gating copy leads with **free**.

## 5. The gate pattern (EWTN-style, in-place)

**Anatomy of a gate** (restyled from EWTN to RR's design system):

- Row keeps its normal section title + a small gold lock (🔒) beside it.
- Behind the gate: a **blurred preview of real content** (actual episode cards at ~60%
  blur) — the row demonstrates itself.
- Centered over the blur, three lines:
  - **Headline** (Crimson Pro, bold): names the benefit — "Sign in to resume your
    progress."
  - **Reassurance** (DM Sans, muted): "It's optional — everything stays free."
  - **Join Free** pill: RR accent blue `#3b6fa0` (not EWTN red), white text, person
    glyph. Tapping opens the Join sheet (§6).
- A signed-out gate never blocks anything around it — rows above and below behave
  normally.

**Per-surface spec:**

| Surface | Where | Headline | Preview behind blur |
|---|---|---|---|
| Continue Watching | Watch tab, first carousel row | "Sign in to resume your progress" | 2–3 episode cards w/ progress bars |
| Continue Listening | Listen tab, 2×2 grid | "Sign in to pick up where you left off" | Grid w/ green progress bars |
| Favorites / My List | Watch + Listen ("My List" row) | "Sign in to see your list" | Mixed covers |
| Prayer reminders | Watch tab "Daily Prayer Reminders" rows | Rows fully visible (they advertise live prayer); gate fires on the toggle → moment-of-action sheet | n/a — rows not blurred |
| My Downloads | More sheet → My Downloads | "Sign in to keep your downloads" | Download list mock |

**Moment-of-action variant** — for verbs with no row to blur (tapping **Remind me**,
tapping **Download**, tapping ♥ save): a bottom sheet, same three-line anatomy, plus
"Not now" text link that dismisses without penalty. The tapped intent is remembered and
completed immediately after a successful join (the reminder gets set; the download
starts) — the user never repeats the action.

**Hero countdown "REMIND ME" pill** and the **post-live end-screen reminder card**
(the prayer slice's other reminder entry points) both use the moment-of-action sheet.

## 6. User journeys

1. **First run** — no sign-up ask, no modal. Straight to Home. (Principle #2.)
2. **Anonymous use** — watch, listen, browse freely. Gates sit quietly in place.
3. **First gate encounter** — user scrolls past the blurred Continue Watching row or
   taps "Remind me." They see the benefit, the reassurance, and Join Free.
4. **Join Free sheet** — one screen: Apple button · Google button · "or use email"
   (two fields). One tap for Apple/Google; no interstitials.
5. **Success** — sheet closes back to where the user was; the gated row populates in
   place (first visit: friendly empty state — "Your progress will appear here as you
   watch"). If a tapped intent triggered the join, it completes now (§5).
6. **On-device state migrates** — anything set anonymously on this device before
   joining (e.g. a prayer reminder toggled during a beta build) silently attaches to
   the new account. Nothing is lost by joining late; joining is never punished.
7. **Signed-in surfaces** — the More sheet (profile icon, top-right of Home) gains an
   account row at the top: name, email, "Sign out." No separate profile page in this
   release.
8. **Sign out / lapse** — continuity data stays server-side; gates return in place.
   Signing back in restores everything.

## 7. Notification permission flow

Prayer reminders are the one gated feature that also needs an **OS permission**. The
OS prompt is a one-shot resource — burned if asked cold.

- **Never ask at launch.** The OS notification prompt appears only after the user sets
  their **first** reminder (post-join).
- **Prime, then prompt:** after the first reminder toggles on, show a small card —
  "We'll remind you at 3:00 PM each day. Allow notifications so the reminder can reach
  you." → **Allow** triggers the real OS dialog.
- If the OS permission is declined, the reminder stays set in the account (it still
  syncs; it fires on other devices that allowed) and the Watch row shows a quiet
  "notifications off" hint linking to Settings.

## 8. Release scope

This section doubles as the VOD slice's scope definition (the "scope-trim debt" from
`decisions.md` 2026-08-01).

**Ships in this release:**
- Watch tab: hero carousel, Daily Prayer Reminders rows, Continue Watching, Featured
  Series + All Series, series detail w/ episode progress, the video player.
- Accounts: Join Free sheet (Apple/Google/email), the five gates (§3), account row in
  the More sheet, sign out.
- Continuity backend behaviors: video + audio resume positions, favorites, reminders
  sync, downloads-to-account, anonymous-state migration.
- Notification prime-then-prompt flow.

**Stays Vision-only (not this release):**
- Everything outside the Watch tab + accounts scope that the slice inherited from its
  Vision copy (audiobooks library, Pray tab, etc.) — present in the prototype file
  today only because the slice began as a Vision copy; not part of this release's
  build order.
- Profile page / avatar / preferences beyond the More-sheet account row.
- Cross-device "continue on your phone" handoff prompts, watch-party, any social layer.

## 9. Success measures

- % of monthly actives with an account (target: meaningful, not maximal — accounts are
  a service, not a KPI to force).
- Gate→join conversion per surface (which benefit actually converts).
- Reminder opt-in rate and reminder→live-tune-in rate.
- Resume usage: % of on-demand plays that start from a saved position.
- Guardrail metric: playback starts per anonymous user must **not** decline after gates
  ship (proof the gates aren't walls).
- No growth via nagging: zero unsolicited join prompts is a feature, verified in QA.

## 10. Non-goals

- **Not a paywall** — no paid tier, ever, in this design.
- No social features (comments, sharing accounts, community).
- No ad personalization or sale of account data.
- No gating of playback, browse, search, or live streams — under any future pressure,
  that line holds unless `vision.md` itself is amended (a logged decision).
- No phone-number auth, no SMS, no passwordless magic links (this release).

## 11. Prototype & handoff notes

- **The gating UX gets built into `slices/video-on-demand.html`** — there is no
  separate accounts slice (2026-08-04 decision). The slice becomes the visual spec for
  this entire release.
- The prototype shows **UX states only**: signed-out gates, the Join Free sheet, the
  signed-in populated states, the priming card. Real auth (Apple/Google SDKs, token
  storage, backend sync) is the dev team's; prototype code never ships.
- Existing components to reuse in the prototype: `WatchProgressBar`, the Watch
  reminder rows (`WatchPrayerCards`), the Continue Listening grid, the More sheet.
- Screens the slice needs: gated Continue Watching row (blur treatment) · gated
  Continue Listening grid · My List row (gated + populated) · moment-of-action sheet ·
  Join Free sheet · More-sheet account row (signed out/in) · notification priming card ·
  post-join empty states.
- Handoff is a question, not an order: what's expensive here? Apple/Google auth,
  cross-device sync, and anonymous-state migration are the likely cost centers —
  dev pushback lands before native code, and the slice adjusts.
