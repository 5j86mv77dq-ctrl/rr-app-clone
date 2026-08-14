# PRD: Video On Demand + User Accounts (Watch Tab, Accounts, Prayer Reminders)

> **This is the build PRD for the core bundle** — on-demand video in the Watch tab, free
> user accounts, and account-based daily prayer reminders, shipping together as one release.
> The in-app **App Feedback form and Contact page ship in the same release but are specced
> separately** in `Roadmap/prd-feedback-contact.md` (split 2026-08-14 at Peter's direction —
> different owners, different open questions, different downstream teams).
> This PRD **replaces the "On-Device Prayer Reminders (Watch Tab)" PRD**, which was nixed:
> reminders ship account-based, with accounts, so we never build throwaway on-device
> infrastructure or the risky preference migration that PRD flagged as a do-not-ship risk.
>
> **Normative visual spec:** https://relevantradio.netlify.app/slices/video-on-demand.html
> Where this document and the prototype disagree, **the prototype wins.**
>
> **Current as of 2026-08-14** — includes the full polish pass: the resume/progress system,
> the series-page rework, Continue Listening + Listening History, loading/error states,
> unified gate copy, and the account-menu reorganization (Daily Prayer Reminders now lives
> inside Account).
>
> **⚠️ Engineers: read §Engineer Walkthroughs and click every flow in the prototype before
> estimating or building anything.** This feature's complexity is in its *states* — signed
> out vs. in, password vs. no-password, permission default/granted/denied, started vs.
> unstarted — and most of them are invisible unless you walk the exact paths listed there.

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
_Primary metric highlighted._

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
*   Resume audio the same way — Continue Listening on Home **and leading the Listen tab**, with a full Listening History page behind See All
*   Browse series; search Watch (series *and* episodes); share or cast from the player
*   Manage the account: Daily Prayer Reminders, edit profile (name + avatar), update email, create/change password, sign out, delete account

## MVP Feature Scope:
*   **Watch Tab — on-demand library:** Blue-strip header ("Watch" · All Series link · expanding search), hero carousel (live/countdown prayer card first when a broadcast is live or imminent; featured browse slides; **continue slides** for signed-in users — see resume system), Daily Prayer Reminders rows, Continue Watching row, **New Episodes** (renamed from "New This Week"), Featured Series, themed rows (Fr. Rocky Teaching, RR Live Prayer, RR Shows, Conferences & Events, Formation, Documentaries & Films), and an All Series page (blue subpage header, category chips, expanding inline search).
*   **Watch search — series and episodes:** the Watch-tab magnifying glass replaces the browse content with a search surface. Empty state prompts; results come back in two grouped sections with counts — **Series** (matches title / host / category → opens the series page) and **Episodes** (matches episode or series title → plays) — deduped, episodes capped at 20 with an overflow note.
*   **Series pages (reworked 2026-08-13):** **No blue strip at the series level** — deliberate exception: series pages are content, not navigation. Full-bleed hero artwork to the top of the scroll area; persistent back/share discs (dark over artwork, crossfading to white-on-blue when the **scroll-triggered title bar** fades in — Spotify pattern, so Back stays reachable deep in a 40-episode list). Hero is **pure branding — not tappable**; playback always starts from a labeled origin. Info block: title (wraps, never truncates) → "host · N episodes" meta line → description (black, body copy) → **Remind me** pill on prayer series only. Shared 18px section headers ("Continue Watching", "Episodes" — no ordering label; sequential series still run in order, everything else newest-first). Episode list rows: title, meta line ("Ep. 3 · 11min left" / "Feb 21 · 15:41" / "· Watched"), and a progress track with **reserved track space** on unstarted rows so titles hold a constant baseline.
*   **The resume system — one progress language (see §Feature Design):** progress lives in the text block, never on artwork; accent blue always means "you stopped here"; green means LIVE only. Surfaces: hero continue slides (episode-led, tap plays the episode), Watch Continue Watching cards, series-page card + episode rows, Home + Listen Continue Listening rows, Listening History.
*   **Continue Listening (redesigned) + Listening History:** three stacked full-width rows — 48px square artwork, three lines (title = the unit of playback: episode for a show, book for an audiobook; gray subtitle = the show or author; progress row "8min left") — on **Home** and **leading the Listen tab** above Audiobooks, one shared data source. Shows and audiobooks mix in one list ("what was I in the middle of" is not a type-shaped question). **Ranking (product decision):** slots 1–2 go to the most recently played items; slot 3 is reserved for a long-form title in progress, so daily-show churn can never evict a half-finished audiobook. "See All →" (signed in) opens the **Listening History** page — full list, same row anatomy plus a chevron, back returns to the tab it came from. ⚠️ Rows are inert in the prototype (no audio player exists there); production rows must open the audio player at the saved position.
*   **On-demand video player:** Play/pause, scrub, fullscreen/landscape rotation, **Share and Cast only**. Mini-player on minimize; audio continues with screen locked (parity with the live player).
*   **End screens:** Live prayer broadcasts end with a prompt to set that prayer's reminder (if not set) or a share card (if set). On-demand videos end with a Share hero + Next Up card (signed in). **Signed out, the account prompt takes the hero** — with Next Up kept below (an account ask must never cost a play) and Share demoted to a small pill. End-of-video is the highest-intent account moment in the app. After joining, the end screen resolves to the signed-in layout in place.
*   **Free user accounts — email-first, magic-link (Slack/Hallow pattern):** "Sign up or log in" opens a sheet: contextual headline + three benefit checkmarks + **Continue with Email** (primary) / **Continue with Apple** / **Continue with Google** / "Not now" / green "Create your free account." line. Email path is **one neutral flow for everyone** — "What's your email?" → "Check your email!" ("We sent a link to {email}. Tap it to sign in — if you're new, the same link creates your account." + "Or log in with your existing password here" → Hello again! screen, show/hide toggle, "Forgot your password?" → reset → neutral confirmation). The link authenticates; the server decides sign-in vs. create. **Brand-new accounts then get one post-auth "What's your name?" screen.** Password *creation* is post-auth only, in Account → Create a Password — see §Feature Design for why this ordering is load-bearing. Help on every input screen. Apple/Google are one-tap and supply the name.
*   **Account-gated continuity (the free model):** Signed-out users see in-place frosted gates — the real content blurred inside the card behind a white scrim, headline **"Save your place with an account."**, sub **"Login or create your free account."** (series page: headline only), one **"Sign up or log in"** button. **No padlock iconography anywhere** — a lock reads as a paywall, and everything here is free. Gated surfaces: Continue Watching (Watch + series pages), Continue Listening (Home + Listen), audiobook resume, per-episode progress, hero continue slides, Listening History. Reminder toggles gate via a moment-of-action sheet; the tapped intent completes automatically after sign-in. **Playback, browse, search, and live streams are never gated.** First session shows zero prompts.
*   **Account-based daily prayer reminders:** One tap on any Remind me control (Watch rows, hero countdown pill, series page, post-live end screen, Account → Daily Prayer Reminders) sets a reminder that syncs to the account and fires shortly before each broadcast on every signed-in device. OS permission uses **prime-then-prompt with a real permission state machine** (default / granted / denied — see WF-7): the benefit-specific priming card ("Never miss daily Mass") appears *every* time a reminder is armed without permission; declining **unsets the reminder** (a reminder that can't fire is a broken promise); an OS-level denial flips the card to a Settings variant, because iOS will never re-show its dialog.
*   **Account menu (person icon):** Signed out: gradient identity card — "Create or log in to your free account" + benefit checks + "Sign up or log in." Signed in: same card with avatar + name → opens **Account** (rows in order: **Daily Prayer Reminders** — moved here from the main menu 2026-08-14; reminders are per-account settings and the main menu holds destinations only — · Edit Profile · Update Email · **Create a Password / Change Password** (one state-aware row) — then separated: Sign Out, Delete My Account). Account sub-pages step back to the Account hub, not the menu. Menu rows below the card: Prayer Requests, Give Now, **App Feedback**, **Contact** (both specced in the Feedback & Contact PRD), Find a Station, Live Show Schedule, My Downloads, Parish Ambassadors, About, settings toggles. The Home sponsor banner hides while the menu is open, and the player bar drops flush to the nav with it.
*   **Loading & error states (pattern, all data-backed regions):** every fetched region has a skeleton (the real card greyed out — same footprint, radius, border; darker 16:9 artwork area over a white body; one shared left-to-right shimmer on a fixed `#dfe3e7` base) and a per-region inline error (slashed-wifi glyph, "Couldn't load <thing>", blue "Try again" that replays error → skeleton → loaded). **Never a full-screen error.** Chrome (headers, nav, section headings, Now Playing) never skeletons. Signed-out gates take precedence — not having an account isn't a failed fetch. Demo: LOADING/ERROR pills in the prototype's right gutter, state persists across tabs. Twenty regions are wired in the prototype as the reference.

## What We're Not Building & Why:
_Protects against scope creep. Feedback/Contact cuts live in the Feedback & Contact PRD._

| Cut | Reason | Future Phase? |
| ---| ---| --- |
| Sleep timer on the player | Different infrastructure; not needed for this slice (Peter, 2026-08-12) | Yes, own feature |
| Player queue / series button | Queue infrastructure not built; keep player minimal: share + cast only | Yes, with queue |
| Submit a Prayer Request (player/end screen) | Different infrastructure; its own feature release per PRD 1 | Yes, own PRD |
| Favorites / My List | Deferred 2026-08-05 to keep the gated set tight | Yes, after accounts ship |
| Account-tied downloads | My Downloads stays local-only; syncing files is a separate problem | Yes |
| Offline videos | Cut in PRD 1; still blocked on downloads infrastructure | Yes |
| Profile photo upload | Preset avatar colors only in v1 | Yes |
| Pre-auth password creation | A password can only be set after the email is verified (the magic link is the proof) — creation lives in Account | No — by design |
| Phone-number auth / SMS | Email + Apple + Google is the 2026 baseline; SMS adds cost & abuse surface | Unsure |
| An audio player for Continue Listening taps *in the prototype* | The prototype has no audio playback machinery; the rows are the spec for entry points + saved position. **Production must build the tap-to-resume behavior** — this is scope, not a cut | — (production scope) |
| Audiobook resume restyle (green bars, 2×2 grid, See All page) | Deliberately untouched — separate feature, separate conversation. Known inconsistency: audiobook surfaces stay green/old-format while everything else is blue | Yes, own pass |
| Per-episode still artwork | Series title-cards repeat down episode lists and are unreadable at 110×64. Accepted for launch pending real per-episode assets | Yes — asset pipeline |
| Streaks / gamification | Future habit layer once reminders prove out | Yes |
| Personalized reminder times | Fixed pre-broadcast timing for MVP | Unsure |
| Live chat, social features | Complex; moderation burden; not the mission | Unknown |
| Paid tier / paywall | Never. Philosophy: everything free; accounts gate memory, not content | No |

# Feature Design:
## The resume system — one progress language (do not improvise here):
*   **Color is semantic and non-negotiable:** accent blue `#3b6fa0` = "you stopped here." Green `#2e7d32` = **LIVE / Now Playing only.** "You paused here" and "on the air right now" must never share a color. (Exception, deliberate: legacy audiobook surfaces keep green until their own pass.)
*   **Nothing is printed on artwork.** No progress bars, duration stamps, badges, or play buttons over images (sole exception: the LIVE hero card's play circle). Progress is information; information lives in the text block.
*   **The track:** 4px tall, radius 2, rail `rgba(22,32,44,0.13)`, blue fill, in-flow below the meta line. Returning nothing at progress 0 *is* the "not started" state.
*   **Reserved track space:** episode lists mix started and unstarted rows; unstarted rows render an invisible spacer of the track's exact height so every title lands on the same baseline. The spacer height is **coupled to the track height** — change one, change the other. It looks like dead markup; it is not. (Signed out: neither track nor spacer.)
*   **Meta line:** one left-aligned string, slots joined by "·", tail never shrinks: `Feb 21 · 7min left` (episodic) / `Ep. 3 · 7min left` (sequential) / `The Vatican Today · 27:14` (browse). All-black text.
*   **Time format:** abbreviated, no comma — `17min`, `1hr 26min`, `7hr 53min`. **Whether "left" appears is decided by width, deliberately:** full-width rows have room ("4hr 28min left"); the 155px cards do not ("17min") — the section header carries the meaning. Do not "fix" one to match the other.
*   **Resume cards are two lines** (title, then track + time); Continue Listening rows are three (title / gray subtitle / track + time). Title is always the **unit of playback** — the thing that plays when you tap.
## Design Considerations:
*   Design for grandma — large tap targets, high contrast, minimal cognitive load. Our audience skews older; accounts are the scariest thing we will ever ask of them.
*   Everything is free and must *feel* free: zero prompts in the first session; gates are furniture, not interruptions; **no padlocks anywhere** — the brand is open-handed, and a lock implies a paywall.
*   One gate anatomy everywhere: blurred real content + white scrim, "Save your place with an account." / "Login or create your free account.", single button. The user never has to know whether they're signing up or logging in — the flow resolves it.
*   **Why password-after-magic-link (the Slack pattern) — this ordering is load-bearing:** the magic link is the email verification. Letting someone set a password *before* proving they own the inbox would let anyone claim any address. So: email → link → (new accounts) name → *then, optionally, discoverable in Account:* Create a Password. The client is also **enumeration-safe** — one neutral "Check your email!" screen for everyone; the server resolves sign-in vs. create when the link is tapped; the UI never reveals whether an address has an account.
*   **Change Password requires the current password** (three fields: current, then the new pair, visually separated; "Forgot your password?" escape). **Create a Password does not** (there is nothing to prove — the magic link already verified the email). One state-aware row, two behaviors.
*   Sheet follows the Hallow pattern (email-first primary, Apple/Google secondary, one field per screen), restyled to RR. All accounts UI is DM Sans.
*   Reminder control is identical in all five locations — bell pill → green "Reminder set." Notification copy is a mission moment, not a system message; benefit-specific ("Never miss daily Mass"), route through Marketing.
*   Menu hierarchy by color: one blue object (identity card), colorized icons only on Prayer Requests + Give Now, grey for everything else. Account management stays shallow.
## Design References:
*   **The prototype (normative, execute against this):** https://relevantradio.netlify.app/slices/video-on-demand.html — every flow in §Engineer Walkthroughs is clickable there.
*   Hallow login/account screens (Peter's screenshots, 2026-08-11/12); Slack's magic-link flow (the password-after-verification model); EWTN's gated Continue Watching rows (origin of the in-place gate); Spotify (Continue Listening row anatomy; series-page scroll-in title bar).

# Engineer Walkthroughs — click every one of these before you build
_The prototype is the spec. Demo affordances: right-gutter pills (clock times, EVENT, BETA, LOADING, ERROR); any method on the join sheet signs you in as the demo user (Mary Thompson, `mary.thompson@gmail.com` = the "existing account"); tapping the **paper-plane circle** on "Check your email!" simulates following the magic link._

**WF-1 · New user via email (the flow to internalize).** Signed out → tap any gate's "Sign up or log in" → **Continue with Email** → type a *new* address → "Check your email!" (note the copy: the same link signs in *or* creates — the screen is identical for everyone, on purpose) → tap the paper-plane → **"What's your name?"** (new accounts only) → signed in. Now open Account: the password row reads **"Create a Password"** — single field, no current-password box. *Why: the link verified the email; a password may only be added after that proof, and it's optional forever.*

**WF-2 · Returning user via email.** Same path but enter `mary.thompson@gmail.com` → identical neutral screen (no "welcome back" — enumeration-safe) → paper-plane → **no name screen** → signed in. Account row now reads **"Change Password."**

**WF-3 · Password fallback.** From "Check your email!" → "Or log in with your existing password **here**" → "Hello again!" screen: password field with show/hide, "Forgot your password?", Continue. A user without a password who tries this path gets the standard neutral failure in production.

**WF-4 · Forgot password.** From WF-3 → reset screen → neutral confirmation (again: reveals nothing about whether the account exists).

**WF-5 · Apple / Google.** One tap, name supplied by the provider; Hide My Email relay addresses are first-class.

**WF-6 · Gate → intent completion.** Signed out, tap **Remind me** on Mass → the join sheet opens with a contextual headline → complete any sign-in → the Mass reminder is *already set* when you land back. The tapped intent always completes; the user never re-taps.

**WF-7 · Notification permission state machine (default / granted / denied).** Signed in with no permission decision: arm any reminder → benefit-specific prime card ("**Never miss daily Mass**" + the time). (a) **Don't Remind Me** → card closes **and the reminder is unset** — then tap Remind me again and the *same card returns* (no "already asked once" escape hatch; a reminder that can't fire is a broken promise). (b) **Allow Notifications** → mock OS dialog → **Don't Allow** → reminder unset, permission = denied → arm again: the card is now the **Settings variant** ("Notifications are turned off… Open Settings"), because iOS will never re-show its dialog. (c) OS **Allow** → granted → every later reminder arms silently, no prompts.

**WF-8 · Signed-out sweep.** Sign out, then walk Home → Watch → a series page → Listen: every resume surface shows the frosted gate; episode lists show durations but **no progress, no Watched marks, no reserved spacers**; hero continue slides are gone entirely. Turn on the LOADING or ERROR pill while signed out: **gates win** over demo states on gated surfaces.

**WF-9 · The resume surfaces, signed in.** (1) Hero continue slide: *episode* title + track + "17min left"; **tapping plays that episode**, not the series page. (2) Watch Continue Watching cards: two lines, time without "left". (3) Series page: Continue Watching card ("Ep. 3 · 11min left") and the episode list — find a watched row ("· Watched"), an in-progress row ("· 3min left" + track), and an unstarted row ("· 15:41", no track) and confirm every title sits at the same height. (4) End of an on-demand video signed out: the account hero.

**WF-10 · Continue Listening + Listening History.** Home and Listen both lead with the same three rows (mixed shows + audiobooks; ranking: recency for slots 1–2, slot 3 reserved for the long-form title). "See All →" → Listening History (full list, chevrons); Back returns to the tab you came from. ⚠️ The rows themselves are inert in the prototype — there is no audio player there. **In production a tap opens the audio player at the saved position.** Build that; don't copy the inertness.

**WF-11 · Watch structure.** Blue strip on Watch home and All Series (chips + inline expanding search); Watch search returns Series and Episodes groups; series page: full-bleed hero (not tappable), scroll down a long series and watch the blue title bar fade in while back/share stay pinned in place (same discs, fill crossfades).

**WF-12 · Loading & error.** LOADING pill: skeletons are the real cards greyed (Articles keeps its header-band anatomy; Continue Listening keeps the square art block), one synchronized shimmer, chrome stays live. ERROR pill: per-region containers, correct labels ("Couldn't load episodes/prayers/series…"), each with its own **Try again** that plays error → skeleton → loaded. State persists as you switch tabs.

**WF-13 · Account hub.** Menu → identity card → Account: **Daily Prayer Reminders** (above Edit Profile — it moved out of the main menu), Edit Profile, Update Email, Create/Change Password, Sign Out, Delete My Account. Sub-pages back-navigate to the Account hub, not the menu. On Home, note the sponsor banner hides and the player drops flush while the menu is open.

**WF-14 · Change Password security.** With a password: three fields — **Current password** (separated), then New + Confirm grouped, plus "Forgot your password?". Without one (fresh WF-1 account): "Create a Password," two fields, no current-password box.

# Technical Considerations:
*   **Auth stack:** Magic-link email (provider, deliverability, link expiry, deep-link/universal-link into the app incl. cold start), Sign in with Apple (**required** by App Store guideline 4.8 once Google is offered; Hide My Email first-class; Apple may omit the name → post-auth name screen is the fallback), Google Sign-In.
*   **No client-side account detection:** the client never knows or hints whether an email has an account (enumeration-safe). One neutral check-email screen; the server resolves sign-in vs. create on link tap; the name screen is post-auth, new accounts only.
*   **Magic-link landing page:** links are single-use and short-lived — handle used/expired tokens gracefully (hand off to the app when installed; otherwise "This link was already used or has expired" + resend). **Never a raw 404** — Peter reproduced exactly this failure in Hallow.
*   **Password rules:** creation requires a verified session (post-magic-link or OAuth). Change requires the current password server-side, not just in UI. Reset flow is the same neutral email machinery.
*   **Progress sync:** resume positions for video + audio and reminder preferences on the account. Define write cadence (heartbeat), cross-device conflict policy (likely last-write-wins, resume rewinds a few seconds), offline queueing. One store feeds every surface: hero slides, Watch row, series pages, Continue Listening, Listening History.
*   **Continue Listening ranking:** implement the reserved-slot rule (recency ×2 + one long-form guarantee), not a plain recency sort — recency alone silently evicts half-finished audiobooks.
*   **Audio player:** tap-to-resume from Continue Listening/History requires audio playback with a saved-position seek — net-new machinery; the prototype has none.
*   **Reminders are server-backed:** account-based reminders imply push (APNs/FCM) or hybrid local+sync. Time-zone correctness (broadcast origin is CT; never show "CT" in copy), remote schedule control for holy days, and a **remote kill switch** so reminders never fire when we aren't streaming.
*   **Permission flow:** prime-then-prompt; the OS dialog is a one-shot resource; denial can only deep-link to Settings. Client must track default/granted/denied — the priming card's variant depends on it.
*   **Skeleton/error implementation:** build the `<Skeleton>` / `<LoadFailed>` / region-wrapper pattern once so any new row opts in trivially; one shared animation clock.
*   **VOD pipeline:** where replays live, who clips/uploads post-broadcast, metadata quality ownership (titles were flagged "CRAP" in PRD 1 — needs a Programming SOP). Artwork: series title-cards exist (Jack Cote, 2026-08-14); per-episode stills do not.
*   **Account deletion:** in-app deletion is an App Store requirement (5.1.1(v)); define erasure scope and grace period.
*   **Feature toggle:** the bundle ships behind toggles (ideally severable: VOD / accounts / reminders) — Brian controls the flip, Peter makes the call.
*   **Analytics:** account_created (by method), login, gate_impression/gate_tap (by surface), reminder_set/fired/tapped/disabled, resume_play, vod_play, watch_tab_opened, deletion. Guardrail measurable: playback_start by auth state.
*   **Platform parity:** iOS and Android for auth SDKs, push, casting, universal links.

# Risks & Mitigation:
| Risk | Mitigation | Owner | Status |
| ---| ---| ---| --- |
| Father Rocky doesn't like the design | Full clickable prototype exists (link above); get sign-off before build | Peter |  |
| **Engineers under-explore the state space and build the happy path only** | §Engineer Walkthroughs is the contract — walk WF-1…WF-14 in the prototype before estimating; review builds against the same list | Peter + Brian |  |
| Older users are scared off by accounts, or gates read as a paywall | Gates never block playback; no padlock iconography; guardrail metric on anonymous playback; copy leads with "free"; test with Trusted Testers | Peter (copy) + Damien (testing) |  |
| Magic-link emails land in spam / never arrive | Reputable transactional provider, monitored deliverability, password fallback always available | Brian |  |
| Magic link doesn't open the app reliably (universal links, cold start) | Validate deep linking on both platforms before committing; fallback web page with instructions | Brian |  |
| Apple Hide My Email breaks the email relationship | Treat relay addresses as first-class; never require the real address; name fallback post-sign-in | Brian |  |
| Reminders fire at wrong times (DST, holy days) or when we aren't streaming | Server-controlled schedule + remote kill switch; never hardcode times on device | Brian |  |
| Users deny the notification permission | Prime-then-prompt; declined prime unsets the reminder (no false promises); Settings variant after OS denial | Brian |  |
| Cross-device sync conflicts lose someone's place | Last-write-wins with tested tolerance; resume rewinds a few seconds | Brian |  |
| Account deletion compliance missed | In-app Delete My Account in scope from day one; legal review of erasure scope | Brian + Rick |  |
| Bundle is too big and slips | Severable feature toggles; staged beta; no public date commitments | Peter + Brian |  |
| VOD replays don't get uploaded promptly or titled well | Programming SOP for post-broadcast ingestion + metadata; monitoring alert | Damien + Programming |  |
| Low account adoption | End-screen prompt, on-air callouts, gate copy A/B if needed | Peter (marketing) + Damien (monitor) |  |

# Open Questions:
| Category | Question | Answer | Owner | Status |
| ---| ---| ---| ---| --- |
| Technical | Auth backend — Firebase Auth vs. alternative? Concrete magic-link + Apple + Google stack? |  | Brian | Unresolved |
| Technical | Push vs. hybrid local notifications for account-based reminders? What fires offline? |  | Brian | Unresolved |
| Technical | Magic-link expiry window and single-use policy? Rate limiting on the email endpoint? |  | Brian | Unresolved |
| Technical | Resume heartbeat interval and cross-device latency target? |  | Brian | Unresolved |
| Technical | VOD hosting: Vimeo library? Who uploads replays and how fast? |  | Brian + Damien | Unresolved |
| Technical | Audio player scope for Continue Listening tap-to-resume — new build or extension of existing playback? |  | Brian | Unresolved |
| Technical | Can Programming remotely adjust the reminder schedule for holy days without an app update? |  | Brian | Unresolved |
| Design | Default reminder timing — 5, 10, 15 min before broadcast? |  | Peter | Unresolved |
| Design | Notification sound — default or custom? |  | Peter | Unresolved |
| Design | Per-episode artwork: interim treatment while only series title-cards exist (repeat, crop, or generic)? |  | Peter | Unresolved |
| Design | Should we ever prompt password creation post-sign-in, or leave it discoverable in Account? (Default: discoverable only) |  | Peter | Unresolved |
| Cross-dept | Magic-link + reset email templates: who writes/designs? Where does Contact Us route internally? |  | Peter + Marketing | Unresolved |
| Testing | When do Trusted Testers / Interview Pool see this? Key checks: do older users accept the gates as "free"? Does the email-first flow complete without help? |  | Damien | Unresolved |
| Technical | What migrates for existing beta users when accounts launch? (No on-device reminders shipped, so presumed nothing) | Presumed nothing — confirm | Brian | Unresolved |
