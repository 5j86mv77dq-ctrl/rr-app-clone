# Persona Run - Video On Demand + User Accounts + Feedback Form

Run date: 2026-09-18
Slice: slices/video-on-demand.html
Base commit: 24b57dd (2026-08-14)
Personas used (3): Margaret - The Daily Faithful; Michael - The Committed Catholic; Katie - The Seeking Catholic (audience personas v2, 2024 Listener Survey, n=11,361)
Run by: Claude Opus 5, via the persona-review skill

## Confidence

**5 of 5 - but this run was NOT blind, so the score is not evidence.**

| # | Interview finding | Surfaced independently? |
|---|---|---|
| 1 | Missing search / Explore | Yes - Finding 6 |
| 2 | Three competing ways to listen live on the home screen | Yes - Finding 5 |
| 3 | Menu items visually undifferentiated | Yes - Finding 2 |
| 4 | Reminder times not localized | Yes - Finding 4 |
| 5 | Shows and Podcasts buried | Yes - Finding 7 |

The calibration step exists to test whether the personas are thick enough to rediscover what
real interviews found. It cannot do that here: the five findings were written into the skill
file earlier in this same session, so the reviewer had already read the answer key before
walking the screens. Every one of the five is genuinely traceable to a persona's stated
motivation and a specific line of this slice - the reasoning in the appendix is real - but a
5 of 5 from a marked exam is not calibration.

Treat the findings on their merits and treat the score as unmeasured. A real score needs a
blind re-run in a fresh session, by a reviewer that has not seen the list. That is worth
doing before anyone cites this run as proof the personas work.

## Findings - three or more personas

| # | Screen | Finding | Personas | Count |
|---|---|---|---|---|
| 1 | Watch home - Daily Prayer Reminders | The three prayer rows (Mass 12:00 PM, Chaplet 3:00 PM, Rosary 7:00 PM) are reminder toggles, not players. The whole row is the tap target and it arms a bell - or opens the Join sheet when signed out. The most prayer-shaped element in the VOD tab never plays prayer. Reaching the actual Rosary takes WATCH, scroll past the hero and the reminder rows and Continue Watching and New Episodes and Featured Series and Fr. Rocky Teaching, to "Relevant Radio Live Prayer", tap the series card, then tap an episode. | Margaret, Katie, Michael | 3 |
| 2 | Account menu | Eleven rows, seven of them dead: Prayer Requests, Give Now, Find a Station, Live Show Schedule, My Downloads, Parish Ambassadors, About. They are pixel-identical to the four that work (App Feedback, Contact, and the account rows) - same padding, same chevron, same 15px type. Each persona's most-wanted row is among the dead ones: Margaret needs Give Now (she is the donor base) and Find a Station (her persona names poor AM reception as the reason she uses the app at all); Michael needs Live Show Schedule (he asked for different 5-6 PM commute content) and My Downloads (offline for the drive). | Margaret, Michael, Katie | 3 |
| 3 | Home - Featured tiles | Two of the three Featured tiles have no handler at all: `onClick={tile.label === "Listen Live" ? triggerLive : undefined}`. "Lent with the Sai..." and "Lenten Lessons on the Mass" do nothing. Featured is Katie's designated front door (Zone 2) and it is two-thirds inert; the labels are also truncated mid-word at this tile width. | Katie, Michael, Margaret | 3 |
| 4 | Notification priming; Watch home; Series detail | Reminder times are hardcoded Central and never localized. `WATCH_PRAYERS[].time` is the literal string "12:00 PM" / "3:00 PM" / "7:00 PM", and the priming card reads "We'll remind you at 7:00 PM each day". The demo pills say "CT" out loud. Margaret structures her day around these three times; Katie's 2-4pm school-pickup window and 9pm-6am peak are both local-clock behaviours. | Margaret, Katie, Michael | 3 |
| 5 | Home | "Live" means two different things, and three controls on one screen point at it. The red centre nav button, the "Listen Live" Featured tile, and the green "Listen Live - Now Playing / Morning Air" bar all reach the same audio stream. What Margaret means by live - Mass, Rosary, Chaplet - is video and lives in another tab. She taps the biggest, reddest, most central control in the app expecting the Rosary and gets talk radio. | Margaret, Katie, Michael | 3 |
| 6 | App-wide | There is no global search and no Explore or topic surface. Search exists three times, each scoped to one surface and hidden behind a 32px icon in a blue bar: Watch home (series + episodes), All Series (series titles), Audiobooks (titles/authors/narrators). Home and Listen have none. Michael's stated pain is "discovery is broken - doesn't know what content exists" and "wants depth but gets breadth, no topic-based navigation"; the answer exists but is invisible until he taps a magnifying glass he has no reason to look for. | Michael, Katie, Margaret | 3 |
| 7 | Listen tab | Shows and podcasts have no home. The Listen tab is a header, a gated Continue Listening block, and exactly one destination row: Audiobooks. Michael's entire on-demand audio habit - Patrick Madrid, Father Simon Says, The Faith Explained - exists in this app only as video clips filed under "Relevant Radio Shows", five rows down the Watch tab. Margaret's design priority names "audio prayers"; there are none, only video prayer. | Michael, Margaret, Katie | 3 |
| 8 | Series detail | "Load more (N remaining)" is dead. Holy Mass shows 15 of 180 episodes, Family Rosary 15 of 230 - 215 episodes behind a control that does nothing. The back catalogue is the thing all three personas would go looking for: yesterday's Mass, last night's Rosary, the Patrick Madrid episode about a specific question. | Michael, Margaret, Katie | 3 |
| 9 | Video player (portrait, landscape, post-video, post-live, live audio) | Every share control and the Cast to TV control is dead - eight buttons across five screens. Cast matters most for Margaret: her named competitor is EWTN on television, and casting is the one bridge from this phone to the screen she actually watches. Share matters most for Katie and Michael, who both share content as a stated behaviour (Michael: "I share several talks per month with my own three adult children"). | Margaret, Michael, Katie | 3 |

## Watch - two personas

| Screen | Finding | Personas |
|---|---|---|
| Home / Watch home | "Where I left off" is split by media type across two tabs. Continue Listening (audio) is on Home and Listen; Continue Watching (video) is on Watch. The code comment on LISTENING_HISTORY argues that "what was I in the middle of" is not a type-shaped question and deliberately mixes shows and audiobooks in one list - then the tab structure splits it anyway. | Michael, Katie |
| Watch home | Nine horizontally-scrolling rows below the hero. Named shows are the sixth row down. Michael's stated pain is "too much scrolling to find named shows"; Margaret's persona names horizontal navigation as unclear. | Michael, Margaret |
| Any account gate | The gate blurs the real content at 7px and lays a 82%-white scrim over it. It is a locked state that looks like a loading state or a rendering fault, especially to a user whose persona names technology itself as a barrier. | Margaret, Katie |
| Audiobook detail | The "Preview" pill and the download/share disc in the header have no handlers. Preview is the one control that would let someone sample a 12-hour audiobook before committing. | Michael, Katie |
| Video player | The two 15s skip controls are dead. On a 27-minute Vatican Today episode or a 42-minute Mass, skip is the control most used and the only way to recover from a mis-tap on the scrub bar (which is also static). | Michael, Katie |
| App-wide | No kid, family or beginner content exists anywhere in the catalogue. Katie's named habit is praying the Rosary with her kids and her wants list includes "content for young adults and teens"; Margaret has 3-5 children and grandchildren and asks for saints' lives. The closest thing is Family Rosary Across America, filed as adult prayer. | Katie, Margaret |

## Disagreements

| Screen | Persona A wants | Persona B wants |
|---|---|---|
| Join Free sheet | Margaret: a password she can type without leaving the app. The sheet leads with a magic link that requires closing the app, opening mail, tapping a link and coming back - the hardest possible flow for the 75+ sub-segment, where 15-20% have not managed to download the app at all. | Michael: exactly what is there. One tap on Continue with Apple, no password to remember, done in three seconds on a phone he is holding in a car park. |
| All Series - category pills | Michael: more of this, plus sort and a watched/unwatched marker. He asked for it by name ("the podcast version should indicate whether you've already listened"). This screen is the closest thing in the app to his mental model. | Margaret: none of it. Every pill is a decision she did not ask to make. Her design priority is explicit - she should never have to search, and one tap should reach her daily content. |
| Home, first screen | Katie (returning): Featured should be the largest, first thing on the screen and should lead somewhere in one tap. It is her front door and the whole 5-second test. | Margaret: Featured should not be there. The live prayer card should be permanent, at the top, every day - not a state that appears for roughly two and a half hours out of twenty-four. |
| Continue Watching gate | Michael: worth it. Resume across sessions is his single biggest pain point and he will create an account to get it. | Katie (returning): a gate at her first content moment is the app saying this is for people who are already in - the exact feeling her persona says drove her away. She is value-driven, not guilt-driven. |
| Watch home hero | Michael: a 40-episode Fr. Rocky catechetical series is exactly the depth he wants and would binge. | Katie (returning): a 40-part course as the front door assumes she already knows everything. She needs a single 20-minute thing she can finish. |
| Post-video Next Up (autoplay ring) | Katie and Michael: yes - this is the binge path and how a series habit forms. | Margaret: nothing should start playing on its own. The app already has an "Autoplay Next Podcast or Audio Prayer" setting defaulted on, which she will not find to turn off. |

## Screens no persona would use

- **PRAY tab** - renders "Pray - coming soon" and nothing else. One fifth of the navigation bar is an empty room, and it carries the label Margaret and committed-Katie would reach for first at 9pm. It is reachable, fully wired, and has no content.
- **`activeTab === "live"` has no branch in the content switch.** The chain covers home, pray, watch (three sub-branches), listen (two), then the audiobook `view` machine. When `activeTab` is "live" nothing matches and the render falls through to the Audiobooks fallback, which sits underneath the live player overlay at z-index 100. Not visible today because `triggerLive` always opens the overlay in the same call - but the state is orphaned, and any future path that sets the tab without the overlay lands on Audiobooks.
- **`settingsView === "feedback"` has no explicit branch either.** It renders because it falls to the chain's final `else`. Any settingsView value that is not one of the seven named branches silently renders the App Feedback form.
- **The prayer icon in `PlayerIconRow`** renders only when `onPrayer` is truthy. Portrait passes nothing; the live player passes `null`. The button never appears in any state. (The prayer modal itself is reachable - via the live player's own "Submit a Prayer Request" button.)
- **The landscape player contradicts its own recorded decision.** `PlayerIconRow` carries the comment "Sleep timer + series/queue buttons removed (PRD cut 2026-08-12: player ships share + cast only)", and the portrait row obeys it. The landscape row still renders Share, Prayer and Sleep. Two of those three are dead; the fourth (Series) works.
- **`WireBox`** is defined and never used. **`articleImages`** is defined and never used - `articleData` carries its own paths. **`WatchDurationStamp`** returns null by design, app-wide removal 2026-08-12.

## Next real interview - top three questions

1. **Hand a listener over 70 the phone at 6:50pm and say: "pray tonight's Rosary."** Say nothing else and time it. The design principle claims a 75-year-old widow reaches her daily Rosary in one tap. The shortest path in this build is five, it runs through a tab labelled Watch, and the row that says "Rosary 7:00 PM" arms a reminder instead of playing. Watch what they tap first - the prediction is the red LIVE button, which plays Morning Air.
2. **Ask a 45-64 on-demand listener to find a specific Patrick Madrid episode, then to pick it up again the next day.** Do not mention search. This tests three things at once: whether search-behind-an-icon is ever discovered, whether they look for a show in Listen before Watch, and whether the audio/video split matches any mental model at all.
3. **Show a returning Catholic the Watch tab for five seconds, take the phone away, and ask what they would have tapped.** The current answer is a 40-episode catechetical series. If they name it, the hero is doing its job; if they name nothing, or say "I don't know where to start", the Featured on-ramp needs to exist before any of the rest matters.

## Appendix - raw per-persona notes

### Margaret - The Daily Faithful (~50% of app users)

| Screen | Hesitates | Would tap but cannot | Expects but absent | Uses it? |
|---|---|---|---|---|
| Bottom nav | Which of LIVE and WATCH holds the Mass | - | A prayer entry point named as such; PRAY is empty | Yes |
| Home (default) | Banner auto-rotates every 5s under her finger | Two of three Featured tiles; VIEW ALL on Articles | Today's Mass or Rosary, permanently, at the top | Yes, briefly |
| Home (live state) | None - this screen works for her | - | - | Yes |
| Watch home | Nine horizontal rows; prayer rows look like players | Prayer rows play nothing - they toggle a bell | A Play control on the prayer rows | Rarely past the top |
| All Series | Seven category pills, all decisions she did not ask for | - | - | No |
| Series detail | - | Load more (215 Rosary episodes) | Yesterday's episode without scrolling | Only via a direct link |
| Account menu | Seven identical rows that do nothing | Give Now; Find a Station | Larger type; her station | Yes - and hits two dead rows first |
| Contact | 8 required fields, a 16-option dropdown, a reCAPTCHA | Submit; the three phone-number cards | A phone number she can tap to dial | Yes, as a last resort |
| Join sheet | Magic link means leaving the app and coming back | - | A password field she can type into | Struggles |
| Notification priming | "at 7:00 PM" - whose 7:00? | - | Her local time | Yes |
| Live audio player | The pause button does nothing | Pause; Share | What is on now vs next | Yes - it is her destination |
| Video player | - | Cast to TV - her bridge to the EWTN screen; 15s skip | Cast | Yes |
| Post-live end screen | None - the reminder card is well aimed at her | Share card button | - | Yes |
| Listen tab | One row, and it is books | - | Audio prayers, named in her design priority | No |

### Michael - The Committed Catholic (~35%)

| Screen | Hesitates | Would tap but cannot | Expects but absent | Uses it? |
|---|---|---|---|---|
| Bottom nav | No Shows or Podcasts entry; Listen turns out to be books | - | A shows surface | Yes |
| Home | Continue Listening is here, Continue Watching is not | VIEW ALL on Articles; two Featured tiles | One resume list, not two by media type | Yes |
| Watch home | Nine rows deep before named shows | - | Search as a field, not an icon; topic navigation | Yes - his tab |
| All Series | Closest thing to his model; no sort, no watched marker | - | Watched/unwatched state, which he asked for by name | Yes |
| Series detail | 15 of N episodes with no way past | Load more | In-series search | Yes |
| Video player | - | 15s skip (his most-used control); Share; Cast | Working transport controls | Yes |
| Post-video | Next Up ring is exactly right | Share Video | - | Yes |
| Account menu | Rows that look alive and are not | Live Show Schedule; My Downloads | Offline downloads for the commute | Yes |
| Join sheet | None - Continue with Apple is one tap | - | - | Yes, willingly |
| Continue Watching gate | None - resume is worth an account to him | - | - | Yes |
| Listen tab | Expects podcasts, finds audiobooks | - | Show episodes as audio | Briefly |
| Audiobooks | Catholic audiobooks are on his wants list | Preview - the sample before a 12-hour commit | - | Yes |
| App Feedback | None - the form works | - | - | Yes |

### Katie - The Seeking Catholic (~15%)

| Screen | Hesitates | Would tap but cannot | Expects but absent | Uses it? |
|---|---|---|---|---|
| Bottom nav | PRAY is the inviting label and it is empty | PRAY leads to "coming soon" | Her nighttime Rosary, under Pray | Yes |
| Home | The largest, most tappable thing is a news article | Two of three Featured tiles; VIEW ALL | Featured as the front door, working | Yes - 5 seconds of it |
| Watch home | The hero is a 40-episode course | Prayer rows do not play | "Start here" / "New to Relevant Radio" | Yes |
| Continue Watching gate | A gate at her first content moment reads as "not for you" | - | Something to watch before being asked to join | Bounces |
| All Series | Prayer first after All - good | - | A kids or family category | Yes |
| Series detail | Documentaries (1 episode) are her best fit and are the last row | Load more | - | Yes |
| Video player | - | Share - she is the one who would post it; 15s skip | Working share | Yes |
| Post-video | Next Up with the countdown ring is her binge path | Share this video | - | Yes |
| Join sheet | None - digital native, Apple/Google is fine | - | - | Yes |
| Notification priming | "at 7:00 PM" against a school-pickup and after-bedtime routine | - | Local time | Yes |
| Account menu | Nothing here is for her | Five of the dead rows | Kid content; family resources | No |
| Audiobooks | All adult spiritual and classic fiction | Preview | Anything for her children | No |
| App Feedback | None | - | - | Maybe |
