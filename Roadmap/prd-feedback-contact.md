# PRD: Feedback & Contact (One Portal) — App Feedback, Beta Feedback, Contact

> **This is the build PRD for the in-app feedback system**: the App Feedback form
> (production), its Beta App Feedback dressing (beta builds), and the Contact page —
> plus the routing model that connects them to **Donor Engagement / Donor Relations**,
> the teams that *are* Relevant Radio's customer service.
> It ships in the **same release** as Video On Demand + User Accounts (one slice, one
> release) but is specced separately (split 2026-08-14, Peter): different owners,
> different downstream teams, different open questions. Companion PRD:
> `Roadmap/prd-vod-user-accounts.md`.
> Supersedes the standalone "Beta Testers Feedback Form" flow (orange card + form,
> June 2026) — that UI is replaced by this portal.
>
> **Normative visual spec:** https://relevantradio.netlify.app/slices/video-on-demand.html
> (account menu → App Feedback / Contact; toggle the **BETA** pill in the right gutter to
> see both dressings). Where this document and the prototype disagree, the prototype wins.

# Problem & Strategy:
## One-Liner:
One in-app feedback door with one required question ("What kind of feedback?"), routed so that broken-app reports reach the team that owes a reply — and so that product signal reaches Peter instead of dying in a support inbox.
## The support model (context everything else depends on):
*   Relevant Radio has no dedicated app-support organization. **Donor Engagement and Donor Relations are the customer service teams** — they already work the website Contact form queue and reply to listeners daily.
*   Therefore, in the **production** app, "Something's broken" is a *support ticket* and routes to Donor Relations — in the same shape their existing Contact-form submissions arrive, so **their process does not change by one step**. A form routing to a team that never agreed to receive it is worse than no form.
*   "I love it" and "I have an idea" are *listening*, not support. They land in the product list, are read by a real person, and deliberately promise nothing — an unkept reply-promise is worse than none.
*   **Beta builds are different (decided 2026-08-14):** beta breakage is not a customer-service matter — Donor Relations isn't in the beta and can't reproduce, triage, or answer beta-build reports. In beta builds, **all submissions — including "Something's broken" — route to the app team**, never to Donor Relations. The *form UI does not fork* (one form, two dressings); only the metadata and the destination do. _Confirm at the Donor Relations sync (see Open Questions) so it's their agreement, not our assumption._
*   The reverse pipe matters just as much: app feedback **already arrives today** through the website Contact form's `Mobile App Support` dropdown and gets resolved as one-off support tickets — so it never becomes product signal. Peter is syncing with Donor Engagement/Relations to get that audience feedback funneled to the app team **as close to real-time as possible** (see Open Questions — this is the highest-value non-build in the feature).
## User Problem:
*   **The frustrated listener (production):** something in the app is broken and I need a human to fix it or tell me what to do — I don't want a black hole, I want the same kind of answer I'd get calling the station.
*   **The devoted fan:** I love this app and want to tell someone, or I have an idea — but I'm not writing an email to a generic address that feels like it goes nowhere.
*   **The beta tester:** I signed up to help; telling you what's broken should take seconds and go straight to the people building it.
*   **The team (internal):** Donor Relations must never get beta noise or un-agreed obligations; Peter must actually see app feedback instead of losing it inside support resolutions.
## Hypothesis:
If feedback is one door with one required routing question, then broken-app reports get answered by the right team within their existing SLA, and product feedback becomes a readable, exportable signal — without adding tooling or headcount.
## Success Metrics:
| Metric | Target | How We Measure |
| ---| ---| --- |
| **Broken-report response rate (PRIMARY)** | 100% of "Something's broken" submissions get a human reply within the promised window | ClickUp response-owed view: due-date compliance |
| Feedback volume & mix | Baseline established in first 90 days; toggle mix readable | ClickUp list, by toggle value + build |
| Routing purity | 0 beta submissions in the Donor Relations queue | Queue audit |
| Signal capture | `Mobile App Support` website submissions visible to the app team near-real-time | Copy-feed in place (see Open Questions) |

# Feature Specs:
## Primary User Action:
*   Send feedback about the app from the account menu — one form, under a minute, no account required.
## The surfaces (three, one system):
*   **App Feedback (production build):** account-menu row directly under Give Now, styled like every other row — muted icon, label **"App Feedback."** House-blue banner header on the form.
*   **Beta App Feedback (beta builds):** the *same row and same form*, re-dressed by the build flag: label **"Beta App Feedback,"** orange icon, orange grain banner, orange buttons, "Help shape the app" intro (see The Form, item 0) and message placeholder ("What's working? What's not?"). **The flag changes label, color, copy, silent metadata, and — for "Something's broken" — the routing destination. It never changes what the form asks.**
*   **Contact (both builds):** sits **directly beneath App Feedback** — two adjacent doors do the routing with no explanatory copy. Contact is the **website's form embedded in a webview** — reproduced in the prototype deliberately (six required fields, PLEASE SELECT dropdowns and all) so App Feedback can be judged against what actually exists. **Owned by Donor Relations; do not restyle, do not rebuild** (see Cuts).
## The form (one form, two dressings):
0.  **Intro headline + copy, by build:** beta — **"Help shape the app"** / "As you test new features, tell us what's working and what's not. Your feedback is reviewed daily by our team and directly shapes the app's development." Production — **"Tell us what you think"** / existing copy. The asymmetry is deliberate: beta may promise influence (testers really do steer the build); **production must not promise anything** (Peter, 2026-08-14).
1.  **"What kind of feedback?" — required, nothing pre-selected:** *I love it · I have an idea · Something's broken* — each chip carries a **stroke icon above a centered label** (heart / lightbulb / wrench; icons, never emoji), the whole chip column-centered so the two-line "Something's broken" doesn't leave its one-line neighbors floating at the top of their boxes. This is the one tap that routes the submission so nobody downstream has to read-to-sort. A default would look like an answer, and defaults win — most submissions would arrive mis-tagged, flooding Donor Relations and corrupting the only field that measures friction.
2.  **Message box** — placeholder varies by build.
3.  **Identity:** signed in → a **"Sending as"** block (name + email, nothing to type). Signed out → a **required email field** plus the offer "**Create a free account** and we'll fill this in for you next time." **No account is required to submit** — today's Contact form requires none, and gating feedback would ship a regression to an older-skewing audience. Email is required on both paths: de-duplication, follow-up, and a reply path.
4.  **Send** stays disabled until a toggle + some text + an email (or a signed-in session) all exist. The old beta form accepted empty submissions; this one can't.
5.  **Silent metadata:** app version (production) / device + OS + build + app version (beta). Metadata is attached, never asked.
6.  **Confirmation forks on the promise, not the words — and the promise exists only where Donor Relations actually receives:** **production** "Something's broken" → "Someone from our team will get back to you, usually within one business day" + "We'll reply to {email}." Everything else — the other two toggles, **and all three toggles in beta** — gets the thank-you ("A real person on our team reads every one of these!") which deliberately promises nothing. Never promise a reply nobody is queued to send (Peter, 2026-08-14).
7.  **Footer card** — "**Need us for something else?**" (shortened 2026-08-14 to hold one line) → points at Contact for donations, prayer requests, shows, station questions.
## Routing (the heart of the feature):
| Build | Toggle | Lands in | Also | Promise shown |
| ---| ---| ---| ---| --- |
| Production | Something's broken | ClickUp feedback list (auto-assignee + auto due date) | **Emails Donor Relations in their existing Contact-form shape** | Reply, usually within one business day |
| Production | I love it / I have an idea | ClickUp feedback list | — | None (thank-you) |
| Beta | **Anything, including Something's broken** | ClickUp feedback list, beta view → **app team** | **Never Donor Relations** | Thank-you (beta breakage gets fixed, not ticketed) |

*   All submissions land in **one ClickUp list** (native CSV export, permanent record, where daily triage already happens; no new tooling). Auto-captured: `source`, toggle value, build, app version, identity.
*   Two saved views: **response-owed** (Donor Relations) and **everything** (Peter, exportable). A beta view filters by build.
*   **The obligation must be structural, not cultural** — auto-assignee + auto due date at submission; if it lives in someone's memory it holds ~3 weeks and then silently stops. **Replies go out from the ticket, not a personal inbox**, or the record keeps the question and loses the answer.

## What We're Not Building & Why:
| Cut | Reason | Future Phase? |
| ---| ---| --- |
| **Native Help form / rebuilding Contact** | Contact is the website's form in a webview. Rebuilding it in-app forks one general contact form into two to keep in sync — the exact duplication this feature removes. It already works and Donor Relations owns it. Rebuild when the *website* form is rebuilt, so it's designed once for both surfaces (Peter, 2026-08-14) | Yes — when the .org form is rebuilt, or if the webview breaks |
| **Account required to submit** | Today's Contact form requires no account; gating feedback would ship a regression, and the audience skews older. Email instead — one field, ~4 seconds (Peter, 2026-08-14) | Revisit only if spam/volume forces it |
| **A default on the toggle** | Required with nothing pre-selected — a default reads as an answer and defaults win. Precedent: the live Contact form's own required dropdowns ship as "PLEASE SELECT" | No — by design |
| **Canny (or any feedback tool)** | Small team, no appetite for new stack. Canny's value is *public* feedback (votes, roadmap) — a community-management commitment we aren't staffed for. **Tripwire:** manual de-duplication becomes noticeable, or we want a public roadmap | Unsure — tripwire |
| **A second beta-only form** | One form, two dressings. What differs between builds is metadata and routing, not questions | No — by design |
| **Anonymous feedback** | Email required on both paths. Accepted cost: we lose the rare thing people won't sign. An annual survey is the better home for that | Unsure |
| **CAPTCHA** | Native apps have app-level attestation, App Store distribution, and rate limiting; the reCAPTCHA on the embedded Contact form is a web artifact and genuinely hostile to older users | No |

# Feature Design:
*   One door, one required question, under a minute. The toggle does the routing; the user never chooses a department.
*   Build-flag dressing is a *costume change*, not a fork: same row position, same form skeleton, same validation. Orange = tester context; blue = production. The confirmation forks on what we can *promise*, not on flattery.
*   The "Create a free account" line under the signed-out email field is the gentlest possible account ask — an offer of convenience, never a wall (consistent with the accounts philosophy in the companion PRD).
*   Contact stays visually untouched — its dated web form sitting one row below the new native form *is the argument* for the eventual website rebuild; don't soften it.
## Engineer Walkthroughs (prototype, account menu):
**WF-F1 · Production form, signed out.** BETA pill **off** → menu → App Feedback: blue banner. Verify Send is disabled until toggle + text + email all exist. Pick "I have an idea" → submit → thank-you (no reply promise).
**WF-F2 · The fork (production only).** Same form, pick "Something's broken" → submit → confirmation promises a reply "usually within one business day" and names the reply-to email. This promise appears **only** in the production build.
**WF-F3 · Signed in.** Sign in first → form shows the three-line "Sending as" block (nothing to type); email requirement is satisfied by the session.
**WF-F4 · Beta dressing.** BETA pill **on** → row becomes "Beta App Feedback" (orange icon) → orange banner/buttons, "Help shape the app" intro, tester copy — same fields, same validation. Submit "Something's broken": the confirmation is the **plain thank-you, no reply promise** — in beta, every toggle value routes to the app team and no reply is owed.
**WF-F5 · Contact.** Menu → Contact (directly under App Feedback): the embedded website form clone — six required fields, "Sending as" prefill block. This page is reference, not a redesign target.

# Technical Considerations:
*   **Dual write (production "broken" only):** ClickUp task creation + an email to Donor Relations formatted to match their existing Contact-form submissions field-for-field, so it enters the queue they already work.
*   **Build detection** drives label/color/copy/metadata *and* the routing destination — one flag, checked server-side too (never trust the client alone for routing).
*   Auto-assignee + auto due date on response-owed submissions at creation time, not by convention.
*   Rate limiting on the submission endpoint; no CAPTCHA, no account requirement (see Cuts).
*   Contact webview: loads the .org form; monitor for breakage (it is the fallback support channel).
*   **Analytics:** feedback_opened, feedback_submitted (by toggle, build, auth state), contact_opened. Volume by toggle is the friction metric — protect its integrity (no defaults).

# Risks & Mitigation:
| Risk | Mitigation | Owner | Status |
| ---| ---| ---| --- |
| Donor Relations receives a queue they never agreed to | **Settle at the sync before build** — their agreement on format, volume expectations, and SLA is a launch gate | Peter |  |
| Beta noise leaks into the Donor Relations queue | Routing forks on the build flag server-side; queue audit after beta pushes | Brian |  |
| The reply obligation silently decays | Structural: auto-assignee + due date; response-owed saved view; replies from the ticket | Peter + Donor Relations |  |
| Website Contact form changes/breaks under the webview | Monitoring; the form is owned by Donor Relations/Web — coordinate changes | Brian + Web |  |
| Feedback volume swamps a small team | Toggle keeps triage one-glance; thank-you path promises nothing; revisit tooling only at the Canny tripwire | Peter |  |

# Open Questions:
| Category | Question | Answer | Owner | Status |
| ---| ---| ---| ---| --- |
| Cross-dept | **THE SYNC (Peter + Donor Engagement/Donor Relations) — a launch gate, covering:** (a) will they receive production "Something's broken" submissions in their existing queue shape, and in what email format? (b) can they copy-feed `Mobile App Support` + `General Listener Comments` Contact-form submissions to the app team **as close to real-time as possible**? (c) confirm beta submissions bypass them entirely; (d) what is current `Mobile App Support` volume (pre-launch baseline)? |  | Peter | **Unresolved — schedule** |
| Cross-dept | Can the website team make `My Station` optional on the .org Contact form (or add "I listen on the app")? Required broadcast-era field with no true answer for app-only listeners; fixing it there fixes the embedded page too. Second ask: drop `Subject`. |  | Peter + Web | Unresolved |
| Product | Auto-acknowledgment on submission ("we got it; a real person reads these")? Sets expectations for $0 | | Peter | Unresolved |
| Product | Close the loop publicly — "you asked, we fixed it" in release notes? Buys most of Canny's engagement benefit for free | | Peter | Unresolved |
| Product | Exact reply-window wording ("one business day"?) — must match what Donor Relations actually commits to at the sync | | Peter + Donor Relations | Unresolved |
| Design | Should the Contact page clone stay in the Vision? It reproduces the six-required-field status quo deliberately — but the Vision is meant to be the end state | | Peter | Unresolved |
| Testing | Does requiring an email (no account) suppress volume? If so, first loosening to test is optional email on App Feedback only — never on anything response-owed | | Damien | Unresolved |
