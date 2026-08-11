# PRD — Video On Demand + User Accounts (one feature, one release)

> **Scope decision 2026-08-04 (Peter):** Video On Demand and User Accounts are the
> **same feature and ship together**. This supersedes the earlier plan of a separate
> `user-accounts` slice depending on VOD (see `decisions.md`).
>
> **Scope decision 2026-08-05 (Peter):** the gated set is narrowed to **three** —
> daily prayer reminders · video resume (Continue Watching) · audio resume (Continue
> Listening). **Favorites/My List is deferred** (not built in this release) and
> **My Downloads stays local-only and ungated** (existing behavior untouched). The
> account menu is specified in §6, including a dedicated **Daily Prayer Reminders page
> inside the menu** — a deliberate visual duplicate of the Watch-tab section.

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
| My Downloads | ✅ Local to this device (existing behavior, untouched) | ✅ Same — account-tied downloads deferred |
| Favorites / My List | — deferred; not built in this release | — |

Everything not marked 🔒 is free-anonymous by principle #2 and is never gated.

## 4. Sign-in methods

- **Email-first with a magic link** (primary path, 2026-08-11 — Hallow-pattern):
  "Continue with Email" → "What's your email?" → **"What's your name?"** (one
  full-name field, parsed to first/last — captured while the link is on its way) →
  "Check your email!" — "We sent a link to {email}. Tap it to sign in — if you're
  new, the same link creates your account." (one honest message for both cases) →
  password fallbacks: "Prefer a password? **Log in** or **create one**." A **Help**
  affordance on the email/name/password screens offers **Forgot Password** (neutral
  "if a matching account was found…" confirmation) and **Contact Us** (opens an
  email to info@relevantradio.com).
- **Names from providers:** Apple/Google sign-in supplies the name automatically.
  Caveat for dev: Apple with Hide My Email may omit the name — fall back to the
  name screen after first sign-in.
- **Sign in with Apple** · **Google** — one-tap secondary options. App Store guideline
  4.8: offering any third-party login (Google) **requires** offering Sign in with
  Apple as an equivalent option — so Apple is non-optional.
- **Minimal capture:** name + email only; the magic-link path needs exactly one field.
  No phone number, no birthday, no survey. Every extra field costs conversion.
- **One CTA everywhere:** every entry point reads **"Sign up or log in"** — the flow
  itself resolves which one the user needs; the user never has to know in advance.
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
- Centered over the blur, three lines (**all sans-serif — no serif type anywhere in
  the accounts UI**; Peter 2026-08-05):
  - **Headline** (DM Sans, bold): "Create your free account to …" — contextual per
    surface ("…to save progress" on Continue Watching/Listening; "…to track
    progress" on Series Detail).
  - **Subtitle** (DM Sans, muted): the feature's benefit in one line — "Pick up
    right where you left off." / "Your audio, right where you paused it." / "Keep
    your place in every episode."
  - **Sign up or log in** pill: RR accent blue `#3b6fa0` (not EWTN red), white text,
    person glyph. Tapping opens the account sheet (§6) with a matching contextual
    headline.
- A signed-out gate never blocks anything around it — rows above and below behave
  normally.

**Per-surface spec:**

| Surface | Where | Headline | Preview behind blur |
|---|---|---|---|
| Continue Watching | Watch tab, first carousel row | "Sign in to resume your progress" | 2–3 episode cards w/ progress bars |
| Continue Listening | Listen tab, 2×2 grid | "Sign in to pick up where you left off" | Grid w/ green progress bars |
| Prayer reminders | Watch tab "Daily Prayer Reminders" rows + the in-menu reminders page | Rows fully visible (they advertise live prayer); gate fires on the toggle → moment-of-action sheet | n/a — rows not blurred |

**Moment-of-action variant** — for the one verb with no row to blur (tapping
**Remind me**, on any of its entry points): a bottom sheet, same three-line anatomy, plus
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
4. **Account sheet — four screens (Hallow-pattern, RR-styled; 2026-08-11):**
   - *Options:* contextual headline ("Create your free account [to enable
     reminders / to save progress / to track progress]") + three ✓ benefits +
     **Continue with Email** (primary, RR blue) · **Continue with Apple** ·
     **Continue with Google** · "Not now". One tap for Apple/Google.
   - *Email:* "What's your email?" — one field, Continue. Help (top-right).
   - *Name:* "What's your name?" — one full-name field (parsed to first/last).
   - *Check your email:* "We sent a link to {email}. Tap it to sign in — if you're
     new, the same link creates your account." + "Prefer a password? **Log in** or
     **create one**."
   - *Password / Create a password:* "Hello again! Enter your password to log in." /
     "Create a password" — show/hide toggle, Continue. Help → iOS action sheet:
     **Forgot Password** (neutral success alert) · **Contact Us** (mailto
     info@relevantradio.com) · Cancel.
5. **Success** — sheet closes back to where the user was; the gated row populates in
   place (first visit: friendly empty state — "Your progress will appear here as you
   watch"). If a tapped intent triggered the join, it completes now (§5).
6. **On-device state migrates** — anything set anonymously on this device before
   joining (e.g. a prayer reminder toggled during a beta build) silently attaches to
   the new account. Nothing is lost by joining late; joining is never punished.
7. **Signed-in surfaces** — the account menu, specified below.
8. **Sign out / lapse** — continuity data stays server-side; gates return in place.
   Signing back in restores everything.

**The account menu** (person icon, top-right of Home — the More sheet), top to bottom:

1. **Identity header — always first.** Signed out: a compact card — kicker
   "CREATE YOUR FREE ACCOUNT", benefit headline "Save your progress across every
   device", body "Videos, audio, and daily prayer reminders — right where you left
   them.", one **"Sign up or log in"** pill. This is the one permanent join
   invitation in the app (a menu the user opens deliberately — not nagging).
   Signed in: initials avatar · name · email · quiet "Sign out" text link.
2. **Prayer Requests** · **Give Now** — unchanged, immediately below identity.
3. **Beta feedback card** — moves here from the top (beta builds only).
4. **Daily Prayer Reminders — a page inside the menu.** A menu row ("Daily Prayer
   Reminders · N on") opening a dedicated page within the account menu that is a
   **deliberate visual duplicate of the Watch-tab section** — same rows, same bell
   pills, same state underneath (toggling in either place is the same toggle).
   Chosen over a pointer-to-Watch-tab for findability: notification controls are
   expected behind the person icon (Peter, 2026-08-05).
5. **The rest of the menu, untouched:** Find a Station · Live Show Schedule · Contact ·
   My Downloads (local, ungated, not moving) · Parish Ambassadors · About · the three
   SETTINGS toggles · version footer.
6. The Home-header person icon shows **initials on the user's avatar color** when
   signed in, the generic glyph when signed out.
7. **Account area (signed in; 2026-08-11).** Tapping the identity row opens
   **Account**: identity summary + rows **Edit Profile** · **Update Email** ·
   **Change Password** · **Delete My Account** (red). Edit Profile: avatar (initials
   on a color) with a **gallery of 6 preset RR-palette colors** + Your Photos /
   Camera (visual only in the prototype — no photo upload at signup, ever; the
   avatar is an edit-later affair), first/last name fields, Save. Update Email sends
   a confirmation link to the new address. Delete My Account: iOS-style confirm
   ("permanently removes your progress, reminders, and saved places") → account and
   continuity data erased, app returns to the signed-out state. No phone capture,
   no tracking-management screen (out of scope).

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
- Accounts: Join Free sheet (Apple/Google/email), the three gates (§3), the account
  menu (§6) including the in-menu Daily Prayer Reminders page, sign out.
- Continuity backend behaviors: video + audio resume positions, reminders sync,
  anonymous-state migration.
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
- No phone-number auth, no SMS (this release). (Magic links moved from non-goal to
  the primary email path, 2026-08-11.)
- No Favorites/My List and no account-tied downloads (both deferred, 2026-08-05).

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
  Continue Listening grid · moment-of-action sheet · Join Free sheet · account-menu
  identity header (signed out/in) · in-menu Daily Prayer Reminders page ·
  notification priming card · post-join populated states.
- Handoff is a question, not an order: what's expensive here? Apple/Google auth,
  cross-device sync, and anonymous-state migration are the likely cost centers —
  dev pushback lands before native code, and the slice adjusts.
