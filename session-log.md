# RR App Clone — Session Log

---

## Session 1 — 2026-02-21

### Commits
| Commit | Description |
|--------|-------------|
| `ea06c13` | Added Charity Mobile sponsor banner (Task 3) — home screen only, fixed position between Now Playing bar and bottom nav |
| `658a3a9` | Fixed sponsor banner clipping — increased Now Playing bar offset from 116 to 128 |
| `ddb002f` | Added rotating promotional banner carousel (Task 4) — 5 images, swipe, dots, rainbow bar, auto-rotate |
| `4a24e25` | Simplified carousel — removed rainbow strip, pagination dots, and deleted mismatched banner_2.png |

### Summary
Built two home screen components from the todo tracker. **Task 3** replaced the wireframe ad placeholder with the actual Charity Mobile sponsor banner image, positioned as a fixed element above the bottom nav and only visible on the Home tab. **Task 4** added a rotating promotional banner carousel at the top of the home screen with 4 banner images (Lent 40, Eucharistic Encounters, Holy Land Pilgrimage, Lenten Lessons), swipeable left/right with auto-rotation every 5 seconds. Iterated on both — fixed banner clipping on Task 3, then stripped the rainbow bar and dots from the carousel per Peter's feedback to keep it clean and swipe-only.

---

## Session 2 — 2026-02-21

### Commits
| Commit | Description |
|--------|-------------|
| `be346a2` | Added Featured Tiles row (Task 5) with real show artwork — Morning Air, Lent with the Saints, Lenten Lessons |
| `0f9deea` | Added missing show artwork images to git (lent_with_the_saints, lenten_lessons_on_the_mass) |
| `1f16403` | Fixed Featured Tiles text truncation with ellipsis |
| `0d1cc42` | Committed all reference screenshots and show artwork assets |
| `0f5f9c1` | Changed Featured Tiles from horizontal scroll to full-width 3-up grid |
| `40ff07b` | Tightened Featured Tiles spacing, dark blue header, thinner labels |
| `9ea1662` | Increased tile label size to 12px medium weight |
| `101803f` | Hard-truncated "Lent with the Saints" to "Lent with the Sai..." |
| `2f5b903` | Added Hero Article Card carousel (Task 6) with 3 article images, dots, VIEW ALL |
| `5d68bff` | Hero Article: full-width edge-to-edge, dots + VIEW ALL moved below image, red active dot, clickable dots |
| `a50c53d` | Renamed Settings header to "More" |
| `900dc8a` | Moved More screen into content area — header and nav stay visible |
| `eb2c084` | Reordered More menu: My Downloads moved above Parish Ambassadors |
| `3750fa6` | Replaced RR logo PNG button with profile/person SVG icon |
| `d0d6081` | Moved back arrow into main RR header for More screen, removed blue sub-header |

### Summary
Built **Task 5 (Featured Tiles)** and **Task 6 (Hero Article Card)**. Featured Tiles went through several iterations: started as horizontal scroll, changed to full-width 3-up grid with real show artwork (Morning Air, Lent with the Saints, Lenten Lessons on the Mass). Tightened spacing, switched header to dark blue, adjusted label styling. Hero Article Card built as a swipeable full-width carousel with 3 pre-rendered article images, pagination dots (red active state, clickable), and VIEW ALL link below the image. Also refactored the More/Settings screen: renamed to "More", moved it into the content area so header and bottom nav stay visible, added back arrow to main RR header, replaced RR logo button with profile icon, and reordered menu items.

---

## Session 3 — 2026-02-21

### Commits
| Commit | Description |
|--------|-------------|
| `dfdcab8` | Add Continue Listening section — 3 placeholder cards with horizontal scroll, progress bars |
| `4444242` | Restyle — smaller 105px cards, dark overlay + centered play button, thicker progress bar, drop narrator |
| `c0894b2` | Major redesign — 2x2 compact grid with progress bars, time remaining, See All → full list view |
| `6c4d778` | White card containers with subtle shadow, truncated author line |
| `c23855e` | Fix cards overflowing viewport — add minWidth/overflow constraints to grid children |
| `ae1928c` | Rework cards — 2-line title clamp, fixed text height, larger cover art |
| `e44e9cd` | Remove author from cards — title gets full 2 lines |
| `edb1890` | Tighten cards — less padding, smaller art, progress bar pinned to bottom |
| `a96cac5` | Add play button to Continue Listening full list view |
| `e41858a` | Enlarge cover art to 52px, thin progress bar to 2px |
| `1f44e3c` | Increase font sizes + progress bar thickness, green chevron on full list |
| `decd5d6` | Fix title-to-progress gap, thicker bar, light blue play button |
| `d47e281` | Redesign full list to match search result cards — consistent UI with chevron, author, progress |
| `fd3ca3f` | Align progress bar to cover art bottom, more right padding, remove duration from full list |
| `8ab815f` | Reduce cover art to 44px to eliminate title-progress whitespace gap |

### Summary
Built the **Continue Listening** section for the Audiobooks screen through extensive iterative design. Started as a horizontal scroll row of square cards, then redesigned into a **2x2 compact grid** with white card containers, small cover art (44px), 2-line title clamp, green progress bar, and time remaining text. Added a **"See All →"** link navigating to a full-page list view matching the existing `SearchResultItem` pattern (cover, title, author, progress bar + time remaining, chevron). Went through ~15 iterations refining card sizing, padding, font sizes, progress bar alignment, and layout consistency — final design has progress bar bottom-aligned with cover art and asymmetric padding for text breathing room.

---

## Session 4 — 2026-02-22

### Commits
| Commit | Description |
|--------|-------------|
| `06488d2` | Replace bottom nav SVG icons with custom PNG icons from visual_elements |
| `2fe4671` | Update bottom nav icon images |
| `8b80386` | Nav tabs close profile menu; Listen Live tile opens big player |
| `3bc057b` | Fix blank screen: pass triggerLive as prop to HomeScreen |
| `09b78af` | Audiobooks back button returns to Listen landing page |
| `b041cc1` | Switch all page headers and subheaders from Crimson Pro to DM Sans |

### Summary
Replaced the four bottom nav icons (Home, Listen, Watch, Pray) with custom PNG icons from `visual_elements/nav_bar_bottom/`, updated the images a second time after Peter revised them. Added two UX behaviors: tapping any bottom nav tab now closes the profile/More menu, and the "Listen Live" featured tile on the Home screen opens the big live player overlay. Fixed the Audiobooks back button to return to the Listen landing page instead of doing nothing. Switched all page headers and section subheaders from Crimson Pro (serif) to DM Sans (sans-serif) for a cleaner look.

---

## Session 5 — 2026-02-22/23

### Commits
| Commit | Description |
|--------|-------------|
| `9dda688` | Watch Tab foundation + Task 2: header, data, routing, tokens |
| `4c7ef82` | Task 3: Hero Billboard with live mode + 4-slide carousel |
| `a7ee091` | Add LIVE demo toggle pill next to Watch header |
| `a659ba5` | Rename Rosary live title to Family Rosary Across America |
| `dc7ab4b` | Task 4: Live Daily Prayer Cards with 3-state strip |
| `9bd7cba` | Enlarge prayer strip: stacked 2-line layout, bigger icons + text |
| `c5d0e0d` | Prayer strip: large bell left-aligned, 2-line text to the right |
| `24f09c9` | Prayer strips: icon-only bells, remove all text labels |
| `b58eef2` | Add small 'Remind me' / 'Reminder set' text beneath bell icons |
| `726acf6` | Prayer strips: full-width text, more spacing, live strip shows LIVE label |
| `6e67a7f` | Much larger bells (20px), larger text (10-12px), matching heights |
| `fcf86e2` | Live strip: match height of reminder strips with minHeight |
| `2acf481` | Task 5: Continue Watching row with primitives |
| `7b94b22` | Task 6: New This Week row — 4 episode cards with NEW badges |
| `106ad77` | Task 7: Featured Series row — 5 series cards with All Series link |
| `1d2305e` | Task 8: Four episode rows — Fulton Sheen, Vatican Today, 5-Min Homilies, Patrick Madrid |
| `dc57e29` | Task 9: Fr. Rocky Teaching row — 3 series cards |
| `4e6e0d1` | Task 10: Documentaries row — 4 episode cards with film runtimes |
| `5acd95c` | Wire real thumbnail images into Watch Tab |
| `8795d04` | Family_Rosary.jpeg for hero live state and Rosary prayer card |
| `f627a42` | pope_leo.png for Vatican Today in New This Week |
| `7c5ce3c` | fulton_sheen.png and vatican_today.png into all matching cards |
| `0d1aeda` | Rosary prayer strip uses prayer_strip_family_rosary.jpeg |
| `cb26ae0` | NEC.png for Eucharistic Encounters series card |
| `ad6c16e` | into_the_breach.png for hero carousel + Continue Watching |
| `7b76cf7` | Update prayer strip images — new rosary and divine mercy thumbnails |
| `650c3a4` | Wire EE.png, LLOTS.png; add NEC content + SEEK assets |
| `14f30e2` | Update NEC.png with new version |
| `bb37f07` | Watch tab only shows live state when LIVE toggle is tapped |
| `b7ef3d2` | Task 12-14: All Series page — search, category filters, 2-column grid |
| `e88cca9` | Mark Task 15 complete — already assembled in Task 12 |
| `568cd1e` | Task 16-20: Series Detail page — hero, subscribe, episodes |
| `b62d796` | Mark Task 22 (Time Simulator) as skipped |
| `08739b1` | Mark Task 21 complete — already built |
| `9f2a719` | Mark Task 23 (Annotation Notes) as skipped |

### Summary
Built the entire **Watch Tab** from scratch across 35 commits following the V9 wireframe. Created the Watch foundation with `watchColors` tokens, 18-series data model, and internal navigation (`watchView` state: home → allSeries → seriesDetail). Built all Watch Home components: **Hero Billboard** (live mode + 4-slide carousel), **Live Daily Prayer Cards** (3-state strips with bell icons — iterated heavily on sizing after Peter's "make this work for an old person" feedback), **Continue Watching**, **New This Week**, **Featured Series**, **4 episode rows**, **Fr. Rocky Teaching**, and **Documentaries**. Wired real thumbnail images from `visual_elements/watch_tab/` into all components across 10+ image-wiring commits. Made the Watch tab demo-safe by removing real-time clock dependency — live state only triggers when the LIVE toggle button is tapped. Built the **All Series page** (search bar, 7 category filter pills, 2-column grid) and **Series Detail page** (hero banner, subscribe toggle, continue watching within series, full episode list with progress/checkmarks/load more). Skipped Tasks 22 (Time Simulator) and 23 (Annotation Notes) per Peter's explicit instructions.

---

## Session 6 — 2026-02-23

### Commits
| Commit | Description |
|--------|-------------|
| `d7cf3b6` | Series Detail: full-page scroll, sticky title, images on all thumbnails |

### Summary
Continuation of Session 5 (which ran out of context). Completed Peter's final request from that session: restructured the **Series Detail page** from split-scroll (fixed hero + separately scrollable episode list) to a **single full-page scroll** where hero, info, subscribe, continue watching, and episodes all flow as one scrollable unit. Added a **sticky title bar** with back button that pins to the top as you scroll past the hero. Created a **SERIES_IMAGES mapping** for 14 series covering all available assets, and wired images into every episode thumbnail (cycling through available images so no empty gradients remain) — both in the episode list and continue watching sections. Hero banner now shows the series' primary image with a gradient overlay.

---

## Session 7 — 2026-02-24

### Commits
| Commit | Description |
|--------|-------------|
| `1a371cd` | Video player: status bar, back button, overlay wiring (Tasks 1-2) |
| `77cebdc` | Task 3: Video Tile with fullscreen button + LIVE badge |
| `7ef3d68` | Task 4: Play/Pause button — 60px white circle, toggles play/pause |
| `65b96ed` | Task 5: Skip 15s buttons flanking play/pause |
| `40720cc` | Task 6: Scrub bar with handle + timestamps (7:42 / -14:26) |
| `8f0cc1f` | Task 7: Bottom icon row — share, prayer, sleep, series |
| `07b4945` | Task 8: Prayer request modal — white bottom sheet |
| `f8d4e0e` | Task 10: Landscape fullscreen player — tap fullscreen to toggle |
| `c06fddc` | Task 11: Live player — LIVE badge, no scrub/skip, prayer CTA |
| `25d00cf` | Task 12: Mini player bar — collapse/expand, sits above tab bar |
| `1190176` | Task 13: Post-video screen — share card, next up with countdown timer |
| `8660ba6` | Task 14: State Switcher — dev/demo toggle for all 5 player states |
| `d6da640` | Revision 1: Mini Player replaces Now Playing bar |
| `ab6951c` | Revision 2: Down arrow replaces Back button on video player |
| `1c2cd27` | Revision 3: Tab bar stays visible but dark grayscale in video player |
| `9582463` | Revision 4: Listen Live cancels video player, tabs close video |
| `b34d8dd` | Revert Revision 3: remove dark grayscale tab bar during video player |

### Summary
Built the complete **Video Player** prototype from scratch across 17 commits, following the `rr-video-player-wireframe.jsx` reference and `rr-video-player-todo.md` build tracker. Created 8 reusable primitives (status bar, down arrow, video tile, play/pause, skip 15s, scrub bar, icon row, prayer modal) plus `vP` design tokens, then assembled them into **5 distinct player states**: **Portrait** (full transport controls), **Landscape** (fullscreen with overlaid controls), **Live** (LIVE badge, no scrub/skip, prayer CTA button), **Mini Player** (collapsed bar above tab bar), and **Post-Video** (share card + next up with countdown timer ring). Added a **dev/demo state switcher** (gear icon → 5 toggle pills) for stakeholder demos. Then made 4 UX revisions: mini player **replaces** the Now Playing bar (only one bar at a time), **down arrow** replaces "Back" pill (matching the green audio player pattern), attempted dark grayscale tab bar (reverted per Peter's feedback), and **Listen Live cancels video** (audio always wins — `triggerLive` closes any active video player).

---

## Session 8 — 2026-02-24

### Commits
| Commit | Description |
|--------|-------------|
| `8f54fa3` | Video player shows series thumbnails; remove state switcher cog |
| `9a908d7` | Keep sponsor banner visible under mini player on home screen |

### Summary
Two polish changes to the video player. **Series thumbnails now appear in the video player** — tapping any show (Into the Breach, Fulton Sheen, Family Rosary, 5-Minute Homilies, etc.) displays that series' actual thumbnail image across all player states: portrait, landscape, live, mini player bar, post-video share card, and next-up card. Added a `seriesNameToId` mapping to resolve display names back to `SERIES_IMAGES`. **Removed the dev/demo state switcher** (cog icon + toggle pills) from both mini player bar and full-screen modes — all states are now reachable through natural interaction only. **Sponsor banner fix**: the Charity Mobile banner now stays visible on the home screen even when the video mini player is active, with the mini player shifted up above the banner.

---

## Session 9 — 2026-02-24

### Commits
| Commit | Description |
|--------|-------------|
| `a7c16a6` | Episode duration stamp on thumbnail (YouTube-style) + series card host/episodes layout |
| `edc4a40` | Reorganize Watch Home sections: add Our Hosts, Conferences & Events, Documentaries & Films |
| `3c54aad` | 16:9 thumbnails, single-line titles, reorder sections, real production companies |
| `1b6805c` | Series detail hero banner uses 16:9 aspect ratio |

### Summary
Redesigned Watch Tab card presentation and reorganized all content sections. **Episode cards** now show duration as a YouTube-style stamp (semi-transparent black pill, bottom-right of thumbnail) instead of text below the title. **Series cards** got a new info layout: host/creator name above the title, title (single-line with truncation), and episode count below. **All thumbnails** — episode cards, series cards, All Series grid, and series detail hero banner — switched from fixed pixel heights to `aspectRatio: "16/9"` for proper YouTube-style landscape dimensions. **Reorganized Watch Home** into 9 sections: Hero, Prayer, Continue Watching, New This Week, Featured Series, Fr. Rocky Teaching, Our Hosts (new), Conferences & Events (new), Documentaries & Films (new). Removed 5 standalone episode rows (Fulton Sheen, Vatican Today, 5-Min Homilies, Patrick Madrid, old Documentaries) and regrouped content into series-card-based category sections with real production companies (Knights of Columbus, Holy Cross Ministries, University of Dallas).

---

## Session 11 — 2026-02-27

### Commits
| Commit | Description |
|--------|-------------|
| `eda469f` | Live stream end screen: postLive mode with reminder toggle, share card, back-to-stream |
| `153ad50` | Back to Live Stream button opens big green broadcast player, not video live mode |
| `e4def35` | Live hero card: use full series image (Family_Rosary.jpeg) instead of prayer strip crop |
| `5e981a3` | Move LIVE demo toggle outside iPhone frame — floats to the right on Watch tab |
| `434c68c` | Fix black screen: lift demoLive state to AudiobooksApp, pass as prop to WatchHome |
| `8dc77ee` | LIVE toggle: white background in inactive state for better readability |
| `32bf6d7` | Home screen: external LIVE toggle + Family Rosary live hero card between banner and tiles |
| `c286461` | Home live card: tap opens video player in live mode for Family Rosary, not audio stream |
| `8983d36` | Home live card: add 'Pray With Us' section header above live hero card |
| `ec08e33` | Live card header: red pulsing LIVE badge + 'Pray With Us' for urgency |
| `093aa5e` | Home live state: hide banner carousel when live, header reads 'Pray Live with Relevant Radio' |
| `2932439` | Home live section: full-bleed image with gradient overlay, text and controls on top |
| `2183b3a` | Home live section: white header strip, clean image, white title strip with drop shadow |
| `d17037a` | Home live section: full-bleed image to top, ghost play button, single bottom strip with microcopy |
| `b823f01` | Home live section: autoplay looping video clip (FRAA-clip.mp4) replaces static image |
| `77cba16` | Add FRAA-clip.mp4 video asset |
| `54a7cf6` | Home live strip: remove microcopy, capitalize text, red play button right-aligned |
| `1c86742` | Home live section: all content on video with gradient scrim, Watch Live pill CTA, no white strip |
| `b3d93bb` | Live section: deeper scrim, larger title, solid red Watch Live button, no subtitle |
| `23575da` | Video player: add Cast to TV icon (Android style) to icon row on both live and on-demand screens |
| `f3067e1` | On-demand player: remove prayer icon, leaving 4 icons (share, sleep, cast, series) |

### Summary
Two main areas of work this session. **Live state demo infrastructure**: moved both the Watch and Home LIVE demo toggles outside the iPhone frame (floating to the right, clearly dev controls), fixed a black-screen regression caused by `demoLive` state being out of scope, and made toggles white when inactive for readability. The Watch tab's Family Rosary hero card now uses the full `Family_Rosary.jpeg` instead of the cropped prayer strip image. **Home screen live section**: built a full demo live state for the Home tab featuring a `homeDemoLive` toggle that hides the rotating banner and replaces it with a Family Rosary Across America live section. Went through many design iterations — card → full-bleed image → gradient overlay → white strips → back to gradient scrim — landing on: autoplay looping video (`FRAA-clip.mp4`), dark gradient scrim covering the bottom half, LIVE badge top-right, bold white title at 24px, and a solid red "Watch Live" pill CTA. Tapping opens the video player in live mode (not the audio stream). **Video player polish**: added a Cast to TV icon (Android Chromecast style) to the icon row on both live and on-demand screens; removed the prayer icon from on-demand leaving 4 icons (share, sleep, cast, series).

### Next Up
- Redo the Hero Article Card section on the Home screen — replace current swipeable carousel with text-overlay-on-image style (similar to the live section treatment)

---

## Session 10 — 2026-02-25

### Commits
| Commit | Description |
|--------|-------------|
| `f6543c8` | Fix: collapsing live player returns to previous tab instead of Audiobooks |
| `1ce5efb` | Watch tab background color changed to #F5F5F7 |
| `7f53e20` | Split documentaries into individual series, add Formation category, clean up Watch tab |
| `34364a8` | Enlarge series cards to 280px wide for full YouTube thumbnail size |
| `80a3d27` | Restructure Watch tab: rename series, add Live Prayer + Shows lanes, conditional subscribe |
| `7b19a33` | Wire all episode tiles to video player — New This Week, series detail episodes, continue watching |
| `fec94f0` | Mini player: landscape thumbnail, more subtitle spacing, circular play/pause button |
| `b9434a5` | Remove border-top artifact from mini player |
| `a2afef8` | Mini player background: dark navy (#0d2240) to match app palette |
| `924b382` | Mini player: rounded top corners, eliminate white strip gap artifact |
| `37afb82` | LIVE button toggles: second tap collapses live player and returns to previous tab |
| `20765cb` | Uniform 16px spacing above all Watch section headers; reorder RR Shows |
| `ce9bdb8` | Larger section headers (18px), better contrast on prayer subtitle |
| `af32c3e` | Prayer cards: larger labels (14px), time below left-aligned, bigger reminder text (11px) |
| `330c377` | Scale series cards from 280px to 220px |
| `68aee75` | Standardize all video labels to 'episode/episodes' — remove film/films terminology |
| `331fc1a` | Fix duration stamp: consistent padding for even margins |
| `d9f6681` | Profile icon toggles settings menu open/closed |
| `9998c9d` | Series icon in video player navigates to series page; rename Fulton Sheen to Life Is Worth Living |
| `de7b14d` | Fix series icon: stopPropagation, always close player and navigate to series page |

### Summary
Major Watch Tab restructuring and UX polish session. **Fixed live player navigation** — collapsing the live player now returns to the previous tab (was defaulting to Audiobooks), and the LIVE button toggles open/closed. **Restructured Watch content**: split the single "Documentaries" collection into 4 individual series pages (Pray, Mother Teresa, Face of Mercy, Apparition Hill) each with 1 episode; moved Into the Breach + The Quest into a new **Formation** category; removed fake series (Lenten Series 2026, Virtuous Leadership). Created two new swim lanes: **Relevant Radio Live Prayer** (Family Rosary Across America, Divine Mercy Chaplet, Holy Mass) and **Relevant Radio Shows** (Vatican Today, Patrick Madrid, Trending with Timmerie). **Subscribe button** now only appears on 10 series with ongoing content. **Renamed series**: Daily Mass → Holy Mass, Family Rosary → Family Rosary Across America, Timmerie → Trending with Timmerie, Fulton Sheen → Life Is Worth Living. **Wired all episode tiles to the video player** (New This Week, series detail episodes, continue watching within series). **Mini player polish**: landscape thumbnail, circular play/pause, dark navy background (#0d2240), rounded top corners, eliminated white strip artifact. **UI refinements**: section headers bumped to 18px, uniform 16px spacing between sections, prayer card labels larger with time underneath, duration stamps with consistent padding, profile icon toggles, "episode" standardized everywhere. **Known issue**: video player series icon (bottom-right) to navigate to series page is not working — needs debugging next session.

---

## Session 12 — 2026-02-27

### Commits
| Commit | Description |
|--------|-------------|
| `c0aea52` | Hero card style toggle: two demo buttons for blue vs white bottom section |
| `0c261db` | Add third hero card style toggle: 6:45 PM CT Dark Blue |
| `41cbc72` | Dark blue hero card variant: change color to #105187 |
| `22f0676` | Remove pulse dot from demo toggle buttons, keep simple red highlight on select |
| `5b64138` | Add fourth hero card style toggle: 6:45 PM CT Slate (#576CA8) |
| `e2e7118` | Remove slate hero card style option |
| `907787b` | Rename page title to App Prototype - Relevant Radio |

### Summary
Built a **multi-variant demo toggle system** for stakeholder review of the Family Rosary live hero card's bottom section color on both the Home and Watch tabs. Three color options controlled by toggle buttons outside the phone frame: **Blue** (#009fe0, white text), **White** (white bg, dark title, red subtitle), and **Dark Blue** (#105187, white text). Tried a fourth Slate option (#576CA8) but removed it. Simplified the toggle buttons by removing the pulsing LIVE dot indicators — they now just turn red when selected. Renamed the page title from "RR Audiobooks Prototype — v9" to "App Prototype - Relevant Radio".

---

## Session 13 — 2026-02-27

### Commits
| Commit | Description |
|--------|-------------|
| `1819a85` | Home live section: replace full-bleed hero with Watch-tab-style card, Now Praying heading |
| `61e8f4b` | Rename LIVE demo toggles to '6:45 PM CT', add spacing from phone frame |
| `482ef8f` | Home live card: subtitle reads 'Fr. Rocky · Streaming now' |
| `1943980` | Article card A/B/C design toggle: current, title-on-top card, live-card style |
| `2daa628` | Article toggles: vertical stack, labeled Article A/B/C, positioned lower |
| `2b09dee` | Left-align all toggles using left:393 instead of right:-148 |
| `3a1ac5e` | Prevent toggle label text wrapping with whiteSpace nowrap |
| `116ca15` | Add 'Articles' header above article section for designs B and C |
| `85818cb` | Fix article card height: fixed title height for consistent card size |
| `6d3c190` | Article D: stacked horizontal cards with landscape image left, text right |
| `874d91a` | Article D: increase title size to 19px |
| `e214733` | Article D: VIEW ALL button top-right opposite Articles header |
| `10d4af5` | Article D: landscape image dimensions (130x90) |
| `c39915f` | Article B: match image height to Article C (170px, objectFit cover) |
| `bae595a` | Article D: image fills full card height, no white space |
| `9a41b11` | Articles B/C/D: VIEW ALL in header row opposite Articles title |
| `5567d55` | B/C: remove VIEW ALL from header; D: VIEW ALL bottom-right below cards |
| `06058e8` | Article D: fixed card height (110px), source line pinned to bottom |
| `1ca0761` | Article E: same as C with shorter 120px image for above-fold visibility |
| `53c7cb8` | Article toggles: C.1 (shorter image) and C.2 (no header) as circle sub-options of C |

### Summary
Two main areas of work. **Home live section redesign**: replaced the full-bleed video hero with a card matching the Watch tab's live hero style — rounded card with looping video thumbnail, red play button, LIVE badge, "Now Praying" section heading (26px, matching Watch header), and "Fr. Rocky · Streaming now" subtitle. Renamed the LIVE demo toggles to "6:45 PM CT" for stakeholder clarity. Iterated on gradient scrim and spacing to eliminate the hard video edge and align padding with the Watch tab. **Article card design toggle system**: built 6 article design variants toggled via pills outside the iPhone frame for Father Rocky review. **Article A** = current full-width image carousel. **Article B** = white card with title on top, image below. **Article C** = card modeled after the live Now Praying card (image top, text below). **Article C.1** = same as C but shorter 120px image for better above-fold title visibility. **Article C.2** = same as C but without the "Articles" header. **Article D** = three stacked horizontal cards with landscape image left and title/source right, VIEW ALL bottom-right. C.1 and C.2 appear as small circle sub-option buttons next to the Article C pill. All toggles left-aligned, vertically stacked, with `whiteSpace: nowrap` to prevent label wrapping.

### Next Up
- Get Father Rocky's feedback on article card variants (leaning toward C or C.1)
- Continue iterating on home screen layout and content density

---
