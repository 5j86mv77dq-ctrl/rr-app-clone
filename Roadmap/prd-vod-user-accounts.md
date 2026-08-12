# PRD: Video On Demand + User Accounts (Watch Tab, Accounts, Prayer Reminders)

> **This is the build PRD for the feature bundle** — on-demand video in the Watch tab,
> free user accounts, and account-based daily prayer reminders, shipping together.
> It supersedes the earlier product-spec draft of this file (2026-08-04 → 08-12; see
> git history) and **replaces the "On-Device Prayer Reminders (Watch Tab)" PRD**,
> which was nixed: reminders ship account-based, with accounts, so we never build
> throwaway on-device infrastructure or the risky preference migration that PRD
> flagged as a do-not-ship risk.
>
> **Normative visual spec:** https://relevantradio.netlify.app/slices/video-on-demand.html

# Problem & Strategy:
## One-Liner:
Ship on-demand video, free user accounts, and daily prayer reminders as one bundle, so users can watch any broadcast anytime, keep their place on every device, and get a daily invitation back to live prayer.
## Why Now:
*   Live Video In-App (PRD 1) opened the front door, but everything we broadcast still evaporates after the stream ends — replays live on YouTube, building someone else's audience with content we paid to produce.
*   Live video gives users a reason to open the app today; reminders give them a reason to come back tomorrow; on-demand gives them something to do whenever they arrive. The habit loop needs all three.
*   Every feature we cut from PRD 1 "until after user accounts" (queue, offline, favorites, cross-device anything) is still blocked. Accounts are the foundation; nothing personal ships until identity exists.
*   Merging reminders into accounts (instead of shipping on-device first) eliminates the migration risk the old reminders PRD called out as a do-not-ship condition — there are no on-device preferences to port because we never shipped them.
*   Hallow and Amen already do accounts + daily habit formation. Our unique advantage — live, communal prayer — stays invisible without a return path to it.
## User Problem:
*   **The re-watcher:**
    *   I am a faithful listener who missed today's noon Mass, trying to watch it tonight, but the app only has live — so I hunt for the replay on YouTube, which makes me feel like the app is a radio dial, not a library.
*   **The habit-seeker:**
    *   I am a committed Catholic trying to pray the Chaplet at 3 and the Rosary at 7 with Relevant Radio, but I keep forgetting when broadcasts start, which makes me feel like I'm failing at the daily prayer rhythm I actually want.
*   **The multi-device faithful:**
    *   I am a regular user who watches on my phone and listens on my iPad, but nothing follows me between devices — no saved place, no reminders — which makes me feel like the app forgets me every time I open it.
*   **The wary newcomer:**
    *   I am a first-time user who's been burned by apps demanding sign-up before showing anything, so if this app walls content behind an account I'll close it, which makes me feel relief when everything just plays.
## Hypothesis:
If we ship an on-demand Watch tab with free accounts that remember progress and fire daily prayer reminders, then one-time live viewers become daily returning users. We will know we are right when reminder-driven sessions and resumed plays grow while anonymous playback stays healthy.
## Success Metrics:
_Primary metric highlighted in yellow._

| Metric | Target | How We Measure |
| ---| ---| --- |
| **Reminder → session conversion (PRIMARY)** | % of fired reminders producing an app open within 15 min | reminder_fired × app_open events |
| Account adoption | % of monthly actives signed in within 60 days of launch | signed-in MAU ÷ total MAU |
| Gate → sign-in conversion | Conversion per gate surface (reminders, continue watching, continue listening, audiobooks) | gate_impression / gate_tap / account_created funnel |
| Resume usage | % of on-demand plays starting from a saved position | resume_play ÷ vod_play |
| On-demand consumption | VOD plays per weekly active user | vod_play events |
| **Guardrail:** anonymous playback | Playback starts per signed-out user must NOT decline post-launch | playback_start by auth state, pre/post |

## Business Case:
*   Completes the habit loop PRD 1 started: live video (front door) + reminders (return path) + on-demand (depth). Daily users drive retention, LPC, and donations.
*   Recaptures replay traffic we currently hand to YouTube, converting produced-and-paid-for content into in-app engagement.
*   Accounts create an owned audience relationship (name + email) and unblock the entire deferred roadmap: queue, offline downloads, favorites, personalization.
*   Everything stays free — accounts gate *memory*, never content. This is our trust posture with an older, donation-driven audience: generosity and prayer are never behind a wall (vision Pillar 4: "Accounts serve continuity… never a wall before first play").
*   Reminder notifications are daily mission moments with our brand on the lock screen — the cheapest re-engagement channel we will ever own.
# Feature Specs:
## Primary User Action:
*   Watch any Relevant Radio broadcast on demand in the Watch tab — and pick up exactly where you left off.
## Secondary User Actions:
*   Create a free account or log in (email magic link, Apple, Google) — one CTA everywhere: "Sign up or log in"
*   Set daily prayer reminders (Mass · Divine Mercy Chaplet · FRAA) that follow the account to every device
*   Resume audio the same way (Continue Listening on Home; audiobook resume on Listen)
*   Browse and subscribe to series; share or cast from the player
*   Manage the account: edit profile (name + avatar), update email, change password, sign out, delete account
## MVP Feature Scope:
*   **Watch Tab — on-demand library:** Hero carousel (live/countdown prayer card first when a broadcast is live or imminent, then featured content), Daily Prayer Reminders rows, Continue Watching row, New This Week, Featured Series, themed rows (Fr. Rocky Teaching, RR Shows, Conferences & Events, Formation, Documentaries), and an All Series page with search + category filters.
*   **Series pages:** Hero image, title, description; live-prayer series show a LIVE DAILY time chip under the description and a **Remind me** pill (same control as everywhere else); non-prayer series show Subscribe. Episode list newest-first with per-episode progress bars, % labels, and Watched badges (signed in); per-series Continue Watching block; one back button.
*   **On-demand video player:** Play/pause, scrub, fullscreen/landscape rotation, **Share and Cast only**. Mini-player on minimize; audio continues with screen locked (parity with the live player).
*   **Post-live end screen:** When a live prayer broadcast ends: prompt to set that prayer's reminder (if not set) or a share card (if set). No other actions.
*   **Free user accounts — email-first, Hallow-pattern:** "Sign up or log in" opens a sheet: contextual headline + three benefit checkmarks + **Continue with Email** (primary) / **Continue with Apple** / **Continue with Google** / "Not now". Email path: "What's your email?" → *new* emails get "What's your name?" (one full-name field) → "Check your email!" magic link ("Tap it to sign in — if you're new, the same link creates your account"). Password fallbacks: recognized emails may "Log in" (Hello again! screen, show/hide toggle, "Forgot your password?" → reset screen → neutral confirmation); anyone may "Create one" (create-a-password screen). Help on every input screen: Forgot Password · Contact Us (opens email to info@relevantradio.com). Apple/Google are one-tap and supply the name.
*   **Account-gated continuity (the free model):** Signed-out users see in-place "locked module" gates — the real content blurred inside a rounded card behind a white scrim, headline "Log in to your free account to save your place," one-line benefit, "Sign up or log in" button. Gated surfaces: Continue Watching (Watch), Continue Listening (Home), audiobook resume (Listen), per-series progress. Reminder toggles gate via a moment-of-action sheet instead ("…to enable prayer reminders"). The tapped intent completes automatically after sign-in (the reminder sets itself; no repeated taps). **Playback, browse, search, and live streams are never gated.** First session shows zero prompts.
*   **Account-based daily prayer reminders:** One tap on any Remind me control (Watch rows, hero countdown pill, series page, post-live end screen, in-menu reminders page) sets a reminder that syncs to the account and fires shortly before each broadcast on every signed-in device. Tapping the notification opens the live broadcast. OS permission uses prime-then-prompt: never at launch — only after the first reminder is set, with a value-framing card before the system dialog. If permission is denied, the reminder stays set on the account (fires on other devices; quiet settings hint shown).
*   **Account menu (person icon):** Signed out: gradient identity card — "Log in to your free account" + benefit checks + "Sign up or log in." Signed in: same gradient card with avatar + name only → opens **Account** (Edit Profile · Update Email · Change Password, then separated: Sign Out, Delete My Account). Edit Profile: preset avatar colors (photo upload later), first/last name. Menu rows below the card: Prayer Requests and Give Now (colorized icons), **Daily Prayer Reminders page** (same rows as the Watch tab, one shared state), Find a Station, Live Show Schedule, Contact, My Downloads (unchanged, local), Parish Ambassadors, About, existing settings toggles.
*   **Home tab — Continue Listening:** A resume row for audio (talks/prayers) under Articles, account-gated like everything else. Replaces the under-designed section in the current production app.
## What We're Not Building & Why:
_Protects against scope creep. Every cut needs a reason and info on future phases._

| Cut | Reason | Future Phase? |
| ---| ---| --- |
| Sleep timer on the player | Different infrastructure; not needed for this slice (Peter, 2026-08-12) | Yes, own feature |
| Player queue / series button (bottom-right list icon) | Queue infrastructure not built; keep player minimal: share + cast only | Yes, with queue |
| Submit a Prayer Request (player/end screen) | Different infrastructure; its own feature release per PRD 1 | Yes, own PRD |
| Favorites / My List | Deferred 2026-08-05 to keep the gated set tight | Yes, after accounts ship |
| Account-tied downloads | My Downloads stays local-only; syncing files is a separate problem | Yes |
| Offline videos | Cut in PRD 1; still blocked on downloads infrastructure | Yes |
| Profile photo upload | Preset avatar colors only in v1 (buttons are visual in the prototype) | Yes |
| Phone-number auth / SMS | Email + Apple + Google is the 2026 baseline; SMS adds cost & abuse surface | Unsure |
| Streaks / gamification | Future habit layer once reminders prove out | Yes |
| Personalized reminder times | Fixed pre-broadcast timing for MVP | Unsure |
| Live chat, social features | Complex; moderation burden; not the mission | Unknown |
| Paid tier / paywall | Never. Philosophy: everything free; accounts gate memory, not content | No |

## Technical Considerations:
*   **Auth stack:** Magic-link email (provider, deliverability, link expiry, deep-link/universal-link into the app incl. cold start), Sign in with Apple (**required** by App Store guideline 4.8 once Google is offered; support Hide My Email relay as first-class; Apple may omit the name → fall back to asking post-sign-in), Google Sign-In.
*   **Account enumeration:** The prototype shows recognized emails skipping the name screen and offering password login. Production must resolve known-vs-new **server-side after email submission** without leaking account existence pre-auth (neutral copy is already written this way).
*   **Progress sync:** Resume positions for video + audio and reminder preferences on the account. Define write cadence (heartbeat), cross-device conflict policy (likely last-write-wins), and offline queueing.
*   **Reminders become server-backed:** Account-based reminders imply push (APNs/FCM) or hybrid local+sync — not the pure on-device model from the nixed PRD. Carry-over requirements: time-zone correctness (broadcast origin is CT; never show "CT" in copy), remote schedule control for holy days/schedule changes, and a **remote kill switch** so reminders never fire when we aren't streaming.
*   **Permission flow:** One-shot OS prompt — prime-then-prompt only after first reminder; denial can't be re-prompted, only deep-linked to Settings.
*   **VOD pipeline:** Where do replays live (Vimeo?), who clips/uploads after each broadcast, how fast post-broadcast, and who owns metadata quality (titles were flagged "CRAP" in PRD 1 — needs a Programming SOP).
*   **Account deletion:** In-app deletion is an App Store requirement (5.1.1(v)); define erasure scope (identity + continuity data) and grace period if any.
*   **Feature toggle:** The bundle ships behind toggles (ideally severable: VOD / accounts / reminders) — Brian controls the flip, Peter makes the call.
*   **Analytics:** account_created (by method), login, gate_impression/gate_tap (by surface), reminder_set/fired/tapped/disabled, resume_play, vod_play, watch_tab_opened, deletion. Keep the guardrail measurable: playback_start by auth state.
*   **Platform parity:** iOS and Android for auth SDKs, push, casting, and universal links.
# Feature Design:
## Design Consideration:
*   Design for grandma — large tap targets, high contrast, minimal cognitive load. Our audience skews older; accounts are the scariest thing we will ever ask of them.
*   Everything is free and must *feel* free: zero prompts in the first session; gates are furniture, not interruptions; playback is never interrupted by identity.
*   One gate anatomy everywhere: blurred real content in a rounded card + white scrim, contextual headline ("Log in to your free account to save your place / …to enable prayer reminders / …in audiobooks"), one-line benefit, single **"Sign up or log in"** button. The user never has to know whether they're signing up or logging in — the flow resolves it.
*   Sheet follows the Hallow pattern deliberately (email-first black primary, white Apple/Google, one field per screen, name captured while the link is in flight) — restyled to RR, not cloned.
*   Reminder control is identical in all five locations — grey/white bell pill → green "Reminder set." One tap on, one tap off, everywhere.
*   All accounts UI is sans-serif (DM Sans); no serif type anywhere in the flows.
*   Menu hierarchy by color: one blue object (identity card), orange beta card, colorized icons only on Prayer Requests + Give Now, grey for everything else.
*   Notification copy is a mission moment, not a system message ("FRAA starts soon — join Father Rocky"); route through Marketing.
*   Account management stays shallow: Account page is 5 rows; Edit Profile is one screen. No profile "hub," no settings maze.
## Design References:
*   **The prototype (normative spec, execute against this):** [https://relevantradio.netlify.app/slices/video-on-demand.html](https://relevantradio.netlify.app/slices/video-on-demand.html)
    *   Every flow above is clickable: gates, full sign-up/sign-in paths (email → name → magic link; passwords; forgot password; Help), reminders incl. priming + mock OS dialog, account area, series pages, Home Continue Listening. Demo affordance: tapping the paper-plane on "Check your email!" simulates following the magic link.
*   Hallow login/account screens (Peter's screenshots, 2026-08-11/12) — pattern reference for the email-first flow and Account page.
*   EWTN's gated Continue Watching rows — origin of the in-place blurred gate pattern.
# Risks & Mitigation:
_Every risk needs a mitigation._

| Risk | Mitigation | Owner | Status |
| ---| ---| ---| --- |
| Father Rocky doesn't like the design | Full clickable prototype exists (link above); get sign-off before build | Peter |  |
| Older users are scared off by accounts, or gates read as a paywall | Gates never block playback; guardrail metric on anonymous playback; copy leads with "free"; test with Trusted Testers/Interview Pool before launch | Peter (copy) + Damien (testing) |  |
| Magic-link emails land in spam / never arrive | Reputable transactional provider, monitored deliverability, password fallback always available | Brian |  |
| Magic link doesn't open the app reliably (universal links, cold start) | Validate deep linking on both platforms before committing; fallback web page with instructions | Brian |  |
| Apple Hide My Email breaks the email relationship | Treat relay addresses as first-class; never require the real address; name fallback post-sign-in | Brian |  |
| Reminders fire at wrong times (DST, schedule changes, holy days) or when we aren't streaming | Server-controlled schedule + remote kill switch; never hardcode times on device; test across time zones | Brian |  |
| Users deny the notification permission | Prime-then-prompt after first reminder only; reminder persists on account; settings deep-link hint | Brian |  |
| Cross-device sync conflicts lose someone's place | Last-write-wins with tested tolerance; resume is forgiving (rewind a few seconds on resume) | Brian |  |
| Account deletion compliance (App Store) missed | In-app Delete My Account is in scope from day one; legal review of erasure scope | Brian + Rick |  |
| Bundle is too big and slips | Severable feature toggles (VOD / accounts / reminders); staged beta; no public date commitments | Peter + Brian |  |
| VOD replays don't get uploaded promptly or titled well | Programming SOP for post-broadcast ingestion + metadata; monitoring alert | Damien + Programming |  |
| Low account adoption | End-screen reminder prompt, on-air callouts from Father Rocky, gate copy A/B if needed | Peter (marketing) + Damien (monitor) |  |

# Open Questions:
_Unanswered questions about feature._

| Category | Question | Answer | Owner | Status |
| ---| ---| ---| ---| --- |
| Technical | Auth backend — Firebase Auth vs. alternative? What does the magic-link + Apple + Google stack look like concretely? |  | Brian | Unresolved |
| Technical | Push vs. hybrid local notifications for account-based reminders? What fires when the device is offline? |  | Brian | Unresolved |
| Technical | Magic-link expiry window and single-use policy? Rate limiting / abuse protection on the email endpoint? |  | Brian | Unresolved |
| Technical | Resume heartbeat interval and cross-device latency target? |  | Brian | Unresolved |
| Technical | VOD hosting: Vimeo library? Who uploads replays and how fast after broadcast ends? |  | Brian + Damien | Unresolved |
| Technical | Can Programming remotely adjust the reminder schedule for holy days without an app update? (carryover) |  | Brian | Unresolved |
| Design | Default reminder timing — 5, 10, 15 min before broadcast? (carryover) |  | Peter | Unresolved |
| Design | Notification sound — default or custom? (carryover) |  | Peter | Unresolved |
| Design | DST transition handling in reminder copy/timing (carryover) |  | Peter | Unresolved |
| Cross-dept | Magic-link + reset email templates: who writes/designs? Where does Contact Us (info@relevantradio.com) route internally? |  | Peter + Marketing | Unresolved |
| Testing | When do Trusted Testers / Interview Pool see this? Key assumptions to check: do older users accept the gates as "free"? Does the email-first flow complete without help? |  | Damien | Unresolved |
| Technical | What, if anything, migrates for existing beta users when accounts launch? (No on-device reminders shipped, so presumed: nothing) | Presumed nothing — confirm | Brian | Unresolved |
