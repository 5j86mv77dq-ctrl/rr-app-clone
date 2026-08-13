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

## Session 14 — 2026-04-10 / 2026-04-11

### Commits on `main`
| Commit | Description |
|--------|-------------|
| `f3a97c3` | Article carousel: dominant color extraction with WCAG contrast (recovered uncommitted work) |
| `5393bd3` | Remove White and Dark Blue hero card variants — keep only Blue |

### Commits on `prd/live-video-in-app-home-screen` (new branch)
| Commit | Description |
|--------|-------------|
| `f604942` | Revert nav to 4-item Home/Explore/Menu/Pray; swap profile icon for gear |
| `13c1d4f` | Disable clicks on nav items and settings cog |
| `c33b445` | Trigger Netlify branch deploy |
| `a8c0d4e` | Video player: share + cast only; post-live end-screen copy update |
| `a6e190e` | Post-live end screen: FRAA-specific copy and drop LIVE badge |
| `29eb276` | Post-live end screen: tighter subtitle + button copy |
| `3cab8e5` | Prefix browser tab title with Netlify branch name |
| `fec344f` | CLAUDE.md: document branch tab title rule and update push workflow |
| `8383b38` | Video player: remove LIVE badge from top-right of video tile |

### Summary
Session split across `main` cleanup and the first PRD-scoped branch. **On `main`**: recovered uncommitted work (dominant-color extraction for the article carousel with WCAG AA contrast enforcement) and simplified the 6:45 PM CT hero card demo down to just the Blue variant on both Home and Watch tabs — removed the White and Dark Blue toggle pills. **Created `prd/live-video-in-app-home-screen`** for the Live Video In-App PRD and scoped the app down to the PRD surface: reverted the bottom nav to the old 4-item Home/Explore/Menu/Pray layout (hiding Listen/LIVE/Watch/Pray active routing), swapped the profile icon back to a settings cog, and disabled clicks on all four nav items and the cog so only the home-screen live card + video player are interactive. **Video player cleanup**: trimmed the icon row across on-demand/landscape/live modes to just Share + Cast (removed prayer, sleep, series, and the standalone Submit Prayer Request button), removed the red LIVE badge from the top-right of the video tile, and rewrote the post-live end screen with FRAA-specific copy — "Know Someone Who Needs Prayer? / Share the rosary with someone you love." with "Share Family Rosary" and "Back to Live Broadcast" buttons, no reminder card. **Deploy infrastructure**: set up Netlify branch previews, added an inline `<head>` script that reads the Netlify hostname and prefixes the browser tab title with a human-readable branch name (`[PRD Live Video In-App (Home Screen)] ...`), and documented a new "Branch Tab Title Rule" in CLAUDE.md so the `branchTitles` mapping stays in sync whenever a new branch is pushed.

### Next Up
- Continue Live Video In-App PRD work on `prd/live-video-in-app-home-screen`
- Father Rocky review of the PRD branch preview URL on Netlify
- Article card variant feedback still outstanding from Session 13

---

## Session 15 — 2026-04-13 → 2026-04-14
**Branches:** `prd/on-device-prayer-reminders-watch-tab` (primary) + `prd/live-video-in-app-home-screen` (secondary)

### Commits (reminders branch — 76 commits)
Too many to list individually. Major milestones:
- Iterated countdown hero card overlay (9am/1pm/4pm toggles): scaled up elements, sized title to fit one line, grouped "UP NEXT" with title/countdown, removed show title entirely, solid white Remind Me button
- Added dark overlay to live mode hero cards (11:45/2:45/6:45) and live video card
- Small prayer cards under "Set Daily Prayer Reminders" went through multiple incarnations: wide icons → looping videos → wide icons
- Prayer reminder section restructured several times: vertical "Live Daily Prayer" 3-up grid → V4 refinements → horizontal rows with identity image + bell pill → "Live Daily Prayer" carousel (scroll) → fixed 3-col flex → reverted to horizontal rows with 60px show thumbnails from `rr_shows/reminder_cards/`
- Renamed heading to "Daily Prayer Reminders", times to 12:00/3:00/7:00 PM (broadcast still starts 15 min before)
- Hero card video overlay reduced 35% → 20%
- Video player cleanup: removed Sleep Timer, Prayer/Personal Cue, Series icon, Submit Prayer Request
- End screens: "Thank you for praying with us!" headline with conditional content — shows "Pray with us again tomorrow" + reminder card (when reminder not yet set) or "Share the [Mass/Chaplet/Rosary] with a friend" + share card (when already set). Snapshot at screen-open so tap doesn't jolt layout.
- Added "Remind me" button on live player below play/pause, wired to current show
- End screen reminder card matches watch tab horizontal row design

### Commits (home branch — 6 commits)
- Updated end screen headline to "Thank you for praying with us!" + "Share the Rosary with a Friend!"
- Added three toggles (11:45 AM / 2:45 PM / 6:45 PM CT) on home tab, each showing the right show (Mass/Chaplet/Rosary) with its own looping clip in Now Praying card
- Wired live video player to play show-specific clip via `getLiveClip` helper
- Removed settings cog from top-right header
- Made end screen share button/subtitle dynamic (Share Mass / Share Chaplet / Share Rosary)
- Home live card: 16:9 aspect ratio + 20% dark overlay to match watch tab
- End screen share card uses `rr_shows/16_9_show_images/` thumbnails

### Summary
Very long iterative session across two branches, primarily on the reminders PRD. Built three distinct design explorations for the daily prayer reminder section (vertical grid, V4 colored-hero cards, and horizontal rows) and ultimately landed on horizontal rows with actual show thumbnails from `rr_shows/reminder_cards/` (Mass.png, divine_mercy.jpg, Rosary.png). The hero card countdown overlay got a full cleanup: show title removed, "UP NEXT" + countdown grouped as one element, Remind Me pill with solid white background. Video player was stripped of non-essential icons (sleep, prayer, series, submit-prayer-request) and got a "Remind me" pill button under play/pause. End screens became smart — headline is always "Thank you for praying with us!" but the screen snapshots whether the reminder was set when opened: unset → shows reminder card with "Pray with us again tomorrow"; set → shows share card with "Share the [Show] with a friend!" Parallel work on the home branch added the three-show demo toggle system and dynamic show names on the end screen. Key pattern that emerged: using `useEffect` keyed to playerMode to snapshot state at screen-open prevents layout jolt when user interacts.

### Next Up
- Stakeholder review of the horizontal prayer rows vs. other explorations
- Consider merging home branch changes (settings cog removal, 3-toggle system) into reminders branch for unified demo
- Refine copy on end screens if needed

---

## Session 16 — 2026-06-04 → 2026-06-05

### Context
Returned after ~7 weeks. Established the branch model end-to-end and **synthesized the Watch/live-prayer experience into `main`** (production). Worked on an integration branch (`prd/watch-tab-synthesis`) off `main`, verifying every change by **headless render + screenshot** (not git archaeology — that caused early errors), then fast-forwarding `main`.

### Commits (main — synthesis, all verified + shipped to production)
- Watch tab synthesis: kept main's full video library; funneled in 16:9 live-video hero, horizontal Daily Prayer Reminders, adaptive end screen
- Watch + Home: **6 / 3 time toggles** (9:00–6:45) + **11:45/2:45/6:45 broadcast start times** so "live" triggers; Home live card made time-aware (Mass/Chaplet/Rosary)
- Per-show hero colors (Mass gold/Chaplet red/Rosary blue); home card → 16:9 + overlay; fixed square→rounded toggle animation (scoped transition to box-shadow)
- Hero is **always a carousel**: live/countdown becomes the **first of 4 swipeable slides** (not a full replacement); removed the Continue Watching countdown card
- Hero countdown card: **ticking HH:MM:SS** + **Remind Me** pill, show-thumbnail images, subtitle = `detail · time`; Chaplet → "Divine Mercy Chaplet"/"Drew Mariani"; Rosary detail → "Fr. Rocky"
- Brought `Roadmap/` docs + branch-workflow CLAUDE.md onto `main`

### Commits (prayer slice)
- Give Now → prominent red button (match vision)
- Rosary detail → "Fr. Rocky"; committed design-process docs/personas/mockups; added `.gitignore`
- Created then **renamed `stages/` → `Roadmap/`**, documenting the full branch model, feature ownership, and dev workflow

### Summary
Defined how the branches relate: **`main` is the production/long-term-vision line; slices funnel their "vision" pieces *up* into `main` (never the reverse); transitional/slice-only bits stay put.** The video player is the clearest split — `main` keeps the FULL player; the prayer slice keeps a limited one. Built the entire Watch-tab synthesis (library + live prayer experience) and shipped it to production incrementally, each piece verified by rendering. Key correction this session: stop judging code from commit messages/greps — render it and look. Recorded everything in `Roadmap/` (README = model + workflow, main-production-vision = full feature inventory, plus a doc per slice) and on `main` itself. Father Rocky gates production via frozen Netlify permalinks; Claude owns all git; Peter never resolves conflicts.

### Addendum (06-05) — workflow system built into the project
- **Branching rule refined:** branch a new slice from the **closest base** (default `main`, the
  most complete line; but a slice is fine when it's closer to what you're vibe-coding — funnel
  back is then a hand-port Claude owns). Claude **confirms the base before creating any branch**.
- **`Roadmap/CHANGELOG.md`** added — a running per-branch log of every change with port status
  (⬜ pending / 🌐 ported / 🔀 slice-only).
- **Port ritual + branch-confirmation** wired into CLAUDE.md: log each change → batch the "which
  go to `main`?" decision (on demand / at close session); confirm the active branch before any
  editing and on open/start session (catch "wrong branch" / offer a new branch). All on `main` too.

### Next Up
- **Live Video on Home Screen PRD** — active work on `prd/live-video-in-app-home-screen`; its vision pieces funnel up into the prayer-reminders slice **and** `main`
- Optionally bring `.gitignore` onto `main`

---

## Session 17 — 2026-06-05

### Branch
`prd/live-video-in-app-home-screen` (reactivated as the **foundational** slice)

### Commits
| Commit | Description |
|--------|-------------|
| `132af5d` | Sync workflow infrastructure onto live-video slice; reactivate as foundational PRD |
| `a5f0813` | Workflow rule: meta/infrastructure files are shared — propagate to every active branch (standard behavior) |
| `f0667e4` | Home live card: add generic 'Event' demo toggle (Relevant Radio Live) |
| `df320eb` | Event live card: use special-event-livestream.mp4 as the video |
| `d221e32` | End screen: center RR logo with L/R padding so it isn't clipped (event) |
| _(+ meta-sync commits on `main`, prayer slice, integration branch)_ | Propagated shared meta to all active branches |

### Summary
Switched to the **Live Video on Home Screen PRD** and reframed it as the **foundational slice** (the prayer-reminders slice is the stage *after* it; live-video's vision funnels up into **both** prayer-reminders and `main`) — previously mislabeled "superseded." Found the live-video branch was ~7 weeks behind on *infrastructure* (no `Roadmap/`, stale CLAUDE.md, session-log stopped at Session 14), so **synced all meta/infrastructure from `main`** and **rebuilt the complete 1–16 session-log** (the full history was scattered: `main` had 1–13, this branch had 14, the prayer slice had 15–16 — no single branch had it all). Updated the **"start session" skill** so it now presents a **table of active branches** for Peter to select, and made **meta-file propagation standard behavior** — a documented rule that any change to `CLAUDE.md` / `Roadmap/` / `session-log.md` / `.gitignore` is pushed to every active branch (verified identical by hash across `main`, both `prd/` slices, and the integration branch). Removed the frozen-permalink watch-tab item from Next Up. Then built the feature itself: a **generic "Event" home live toggle** — a 4th option beside the three time-based prayer toggles that shows a branded *Relevant Radio Live* event card ("Live Now" heading, RR/Guadalupe slate, RR-blue hero bar, brands the video player + end screen on tap-through). Follow-on commits swapped the static slate for a real `special-event-livestream.mp4` clip and fixed the end-screen logo clipping.

### Next Up
- **Triage pending:** funnel the "Event" toggle up to `main` + the prayer-reminders slice (hand-port — branches diverged)
- Continue Live Video on Home Screen PRD work

---

## Session 18 — 2026-06-05

### Branch
`prd/live-video-in-app-home-screen` (foundational live-video slice)

### Commits
| Commit | Description |
|--------|-------------|
| `46ae79c` | End screen: replace 'Done' text button with an X close icon (superseded same session) |
| `cad36bd` | End screen: use centered down-arrow (collapse to mini) instead of X/Done — unified player behavior |
| `686d300` | Mini player: play live video clip instead of static thumbnail |

### Summary
Polished the live-video player flow. First swapped the end-screen "Done" text pill for an X close icon on both video end screens — then, on Peter's correction, replaced **both** with the same centered top **down-arrow** (`PlayerDownArrow` → `collapseToMini`) the active player already uses, so the close/minimize gesture is identical everywhere in the player (unified behavior, not a separate Done/X control). Then fixed a real gap Peter spotted: the **mini player showed a frozen thumbnail** even for live video — it now renders the live clip playing (autoPlay/loop/muted) when the series has one, falling back to the static series image for on-demand content. Also (non-code) created `.claude/settings.local.json` with an allowlist of safe repetitive bash commands (git status/diff/log/add, ls/cat/cd/mkdir, rm scoped to `/tmp` render artifacts) — kept out of version control. Noted but **left untouched** a long-standing (Feb-24) stray `)}` at index.html:1853 that blame confirms predates this work and the app renders fine against, so it's balanced higher up — not an anomaly. Known prototype limitation flagged to Peter: the mini player's play/pause button is visual-only (doesn't actually pause the autoplay video), consistent with the full player.

### Triage / Funnel (done this session)
Peter chose to **funnel all three pending items now** (`main` + prayer slice). Since the
branches diverged, these were **hand-ports adapted to each branch's architecture** — `main`'s
player is image-based for fullscreen/mini (only home card + Watch hero play clips), and the
prayer slice's home card is countdown-driven (`homeLiveNow`/`homeNextPrayer`). Ported to both:
the **Event home toggle** (new toggle + a separate `homeDemoLive === "event"` card; on the
prayer slice the event is guarded so it yields no `homeLiveNow`/`homeNextPrayer`), the
**down-arrow end-screen unification**, the **mini-player live clip** (added a `getLiveClip`
helper on each, plus `getSeriesImage` → RR logo for the event), and the **end-screen
logo-centered fix**. Also brought the `special-event-livestream.mp4` asset onto both branches.
Every port was **Babel-parse verified** (`/tmp/jsxcheck.js` runs the `text/babel` block through
`@babel/standalone`, since no headless renderer is installed) — **visual review still pending on
the Netlify deploys.** Commits: `main` `415cb2c`, prayer slice (Event funnel). Changelog
entries marked 🌐.

### Next Up
- **Visual-verify the funneled Event feature** on the `main` and prayer-slice Netlify deploys
  (parse-verified only; confirm the Event card, player, mini clip, and end-screen logo render).
- Optional: wire real play/pause control across all player surfaces (video ref + effect).

---

## Session 19 — 2026-06-06

### Branch
`prd/beta-feedback` (**new slice off `main`**) → funneled to `main` at close.

### Commits (slice)
| Commit | Description |
|--------|-------------|
| `a28fa90` | Beta Feedback: add in-app feedback door to the More menu (row + form + confirmation) |
| `278cae8` | Form: drop pill toggle, labeled field groups |
| `336f7a0` | Move entry to its own top section + orange Submit Feedback button |
| `1465e32` | **Mood-board orange gradient card** (grain + bloom, kicker, headline, white pill) |
| `49e946d` | Orange-brand the whole flow (banner, buttons, checkmark) |
| `3a85f80` | Banner title, bigger field titles, balanced confirmation spacing, bold mission |
| `0161dd0` | In-field placeholders; banner title matches card headline |
| `5dc0706` | **Funnel → `main`** (ff via integration branch): full flow + softened Give Now red |

### Summary
New discrete slice for the **Beta Testers Feedback Form** PRD (live video ships to ~200 Android
testers ~6/8; no structured in-app feedback channel today). Built as a **visual prototype** —
the UI/UX of a one-tap in-app feedback door — leaving the PRD's ClickUp/Lambda/Firebase
plumbing to the dev team. Branched from `main` (discrete app-wide menu chrome, no overlap with
the live-video/prayer slices). The **menu entry** went through a long design exploration
(in-line gray row → solid orange button → white-with-orange-outline → its own titled top
section → **final: a saturated orange gradient "mood-board" card** with grain/noise overlay +
light bloom, ALL-CAPS kicker, "Help shape the app" headline, white "Submit Feedback" pill),
guided by Peter's quarterly-app-email reference docs (Lovable "electric skin" / grain). Tapping
opens a **form** (orange `PageHeader`-style banner + grain, titled fields with in-field
placeholders, open text + optional email as real controlled inputs, orange Send Feedback) →
**confirmation** (orange checkmark + kicker, "Thank you" + body with the bolded mission line,
orange Done). The whole flow is `BETA_BUILD`-gated and consistently orange-branded so card →
form → confirmation feel like one environment. **Funneled to `main`** at close (reset the stale
integration buffer to `main`, applied the verified `index.html`, ff'd `main` → `5dc0706`);
also brought the **softened Give Now red** (`#cc4b4b`). Verified throughout by headless render
(0 syntax errors) + per-state screenshots.

### Next Up
- **Father Rocky review** — via the live production URL (https://relevantradio.netlify.app/).
- Optional further card polish (3D screenshot inset that "breaks the frame"; brand-adapted
  palette once Dave & Beth set it).
- Optional: wire real play/pause control across all player surfaces (carried from S18).

---

## Session 20 — 2026-06-06

### Branch
`main` (production / vision). Workflow + dashboard housekeeping, then three live-video bug fixes
committed directly to `main` (verified locally before push, per the retired-integration-branch
workflow).

### Commits (main)
| Commit | Description |
|--------|-------------|
| `f542208` | Sync shared meta: drop frozen-permalink guidance (review via live URLs) |
| `18cfeb5` | Workflow: retire the integration branch — verify locally before pushing `main` |
| `5b20278` | Add Branch Mission Control `dashboard.html` (live branch menu + funnel diagram) |
| `b10ae36` | **Fix full-screen video playback + special-event end screen + Watch EVENT toggle** |

### Summary
Opened with workflow/meta cleanup carried over from S19: **retired the standing integration
branch** (cheap rollback + local headless render now protects `main`; spin up a throwaway
preview branch only ad hoc) and **dropped frozen-permalink guidance** (Father Rocky/Peter review
via the live branch + production URLs). Added a new **Branch Mission Control `dashboard.html`** —
a standalone live menu of branch deploys + a funnel diagram (separate from the app prototype).
Then fixed three bugs Peter found in the live-video flow on `main`: **(1) full-screen video
wasn't playing** — `PlayerVideoTile` (and the landscape player) only rendered a static `<img>`,
never the `<video>` clip, so the mini player played but the full-screen/Event player didn't; both
now render the live clip via `getLiveClip(...)`, matching the `prd/live-video-in-app-home-screen`
slice where it already worked. **(2) The special-event post-live end screen was missing its share
card** — the share card only showed when a prayer reminder existed, and the event has none; it now
always shows for the event with the slice's "Broadcast" wording ("Share the Broadcast with a
friend" / "Special Broadcast" / "Share Broadcast"). **(3) Added an EVENT toggle** to the Watch
tab demo selector (below 6:45 PM CT), wired to a synthetic special-event live state (mirrors the
home Event card → same player/end-screen flow); the **EVENT** label is now all-caps on home + Watch.
Verified by headless render (0 syntax errors) and by driving the actual Watch→EVENT→end-screen and
home→EVENT→end-screen flows in Puppeteer (all wording strings present, no page errors) + screenshots.

### Addendum — concurrent workflow/dashboard session (same day, separate context)
A parallel session ran the workflow + dashboard half of the commits above; this records what it
covered beyond the one-line mentions:
- **Retired the integration branch** as a deliberate decision (Peter): a standing buffer branch
  is redundant for a prototype with cheap rollback — local headless render protects `main`,
  throwaway preview branches only ad hoc for gnarly hand-ports. Deleted `prd/watch-tab-synthesis`
  (local + remote; confirmed content-identical to `main` first). Rewrote the buffer-branch
  language across `CLAUDE.md` + `Roadmap/` and propagated to all active branches.
- **Branch Mission Control (`dashboard.html`)** — built, headless-render-verified (desktop +
  mobile, zero horizontal overflow), shipped to `main`, and **propagated to all 3 slices** (meta
  file, identical by hash). Live branch menu (GitHub API, public repo, no backend) + branded SVG
  funnel diagram + an embedded `MANIFEST` for roles/topology. Added `dashboard.html` to the
  meta-files list and folded **manifest-sync** into the branch-creation + close-session rituals.
- **Found + preserved uncommitted `index.html`** in the working tree (the Watch-EVENT work from
  the concurrent session) — stashed/popped it intact so meta could propagate without disturbing
  it; per Peter, left it uncommitted (he later committed it himself as `b10ae36`).
- **Diagnosed the production-deploy blocker** (see Next Up): production is frozen at the
  pre-session commit (`5dc0706`) — it has Beta Feedback but NOT `dashboard.html` (404) or
  Watch-EVENT, while **branch deploys are current** (live-video branch serves `/dashboard.html`
  with 200). Code/git side is fully correct (file on `origin/main`, GitHub raw 200, no build
  config to fail). The block is **Netlify production auto-publishing being stopped/locked** — a
  dashboard setting Claude can't reach.

### Next Up
- **⚠️ Resume Netlify production auto-publishing.** `relevantradio` site → **Deploys** → look for
  "Auto publishing is off" / a 🔒 locked deploy → **Resume auto publishing** (or Publish/Trigger
  the latest `main` deploy). Until then production (`https://relevantradio.netlify.app/`) and
  `…/dashboard.html` stay frozen at `5dc0706`; branch previews are unaffected. Dashboard works now
  at `https://prd-live-video-in-app-home-screen--relevantradio.netlify.app/dashboard.html`.
- **Father Rocky review** — via the live production URL (once auto-publishing resumes).
- Optional: wire real play/pause control across all player surfaces (carried from S18/S19).
- Optional: confirm the special-event clip paints in a real device/browser (headless Chromium
  doesn't decode video frames; element + autoplay confirmed present).

---

## Session 21 — 2026-08-01

**THE VISION + SLICES MIGRATION.** Retired the branch-per-slice model: everything now lives
on `main` — the only branch. Slices became standalone pages: `slices/live-video.html`,
`slices/prayer-reminders.html`, `slices/beta-feedback.html` (each copied from its old
`prd/...` branch tip, given its own `<title>` + `<base href="/">`, with 6 missing image
assets brought along). `dashboard.html` rewritten around a page-based `MANIFEST` (slice
lifecycle stages: draft → in-review → in-dev → shipped → archived; per-page last-updated
dates + a stray-branch strip from the GitHub API). CLAUDE.md + Roadmap/README.md +
CHANGELOG.md rewritten for the one-branch model (meta-file propagation ritual deleted —
no longer needed). Stale `GIT-WORKFLOW.md` (GitHub Pages era) removed. All four pages
verified by headless render before push.

**Why:** Peter asked for the best PM workflow going forward. Analysis showed all three
slices' vision work was already ported to `main` and the branches were 25–27 commits behind
it — the branch machinery (propagation, branchTitles, branch-confirm ritual) was pure
overhead. One branch + slices-as-pages keeps every slice URL and every funnel relationship
with none of that.

### Next Up
- **Delete the frozen `prd/...` branches (local + remote) after ~2026-08-15** — grace period
  so old shared branch URLs don't die overnight. Content lives in `slices/`.
- **Re-share the new slice URLs** with Brian's team (`…/slices/<name>.html`).
- Confirm with Peter the true lifecycle stage of each slice (all provisionally `in-review`)
  and retag in the dashboard `MANIFEST`.

---

## Session 22 — 2026-08-02

**ENVIRONMENT SHAKEDOWN AFTER OS REINSTALL — no product changes.** Peter reinstalled macOS,
did not reinstall VS Code, and asked whether Claude Code alone can run this project. Verified
end-to-end that it can: `gh` is still authenticated (account `5j86mv77dq-ctrl`, scopes
`repo`/`workflow`/`gist`/`read:org`, token in the macOS keychain), the `origin` remote is
reachable, and `git` 2.50.1 + Python 3.9.6 are present. **Node/npm are NOT installed and are
not needed** — the prototype loads React, ReactDOM and Babel from unpkg CDNs and compiles JSX
in the browser, so there is no build step and never was a Node dependency. Rendered
`index.html` and `dashboard.html` locally and confirmed both draw correctly with **zero
console errors**. Confirmed the documented **"serve local"** ritual (`python3 -m http.server
8000` at the repo root) still works post-reinstall, which is what keeps the dashboard's
`localhost:8000` links valid.

**One environment gotcha worth remembering:** the Claude Code *preview-server* launcher runs
its subprocess in a sandbox that cannot read `~/Documents`, so `.claude/launch.json` fails
with `Operation not permitted`. Serving from a normal Bash shell has full access and works
fine. **Use the documented `python3 -m http.server 8000` from Bash for local verification —
do not bother with `launch.json` on this machine.** A `.claude/serve.py` helper was written
and then deleted during this session: it was redundant and bound port 8765, which would have
silently broken the dashboard's `localhost:8000` local links.

**Also corrected a stale-state misread.** Early in the session the working tree was still at
`95616e9` (pre-migration), so an initial branch analysis reported the old `prd/...` branches
as carrying 19–117 "unfunneled" commits and recommended a triage. That was wrong — Session
21's migration had already settled it. Those commits were slice-internal iteration whose
vision pieces were already ported; the branches are frozen and their content lives in
`slices/`. No triage is needed.

**Changelog triage:** nothing to do — `Roadmap/CHANGELOG.md` has **no ⬜ pending entries**
(the only ⬜ marks are legend/template lines). No slices were created, renamed, or restaged,
so the dashboard `MANIFEST` needed no sync.

### Next Up
- **Delete the frozen `prd/...` branches (local + remote) after ~2026-08-15** — still pending
  from Session 21; all six branches (incl. the Feb-2026 `Audiobooks-Demo` /
  `Video-In-App-Demo` archives) are still present.
- **Re-share the new slice URLs** with Brian's team (`…/slices/<name>.html`).
- Confirm the true lifecycle stage of each slice (all provisionally `in-review`) and retag in
  the dashboard `MANIFEST`.
- Optional: remove the legacy `branchTitles` script from `index.html` (fires only on
  branch-deploy hostnames — harmless, but dead once the `prd/...` branches are deleted).

---

## Session 23 — 2026-08-02 → 2026-08-03

**THE PROTO DESIGN MARATHON.** Designed and shipped the complete prototyping-system
design: the **Proto** macOS control room, mocked up as a fully clickable page
(`design_process/basis-mockup.html`, 8 iterations: cards → ClickUp-style rows → sidebar
nav → graph view → right sidebar with history scrubber). Major model decisions along the
way, all logged in `decisions.md`: **chains removed** in favor of two orthogonal
relationships (`base` = pinned lineage, `dependsOn` = ship order); **PROTO front matter**
installed in every slice file; app named **Proto**. Wrote `Roadmap/proto-prd.md` as the
canonical system definition (supersedes v3 + the three branch-era Roadmap docs, now
bannered). Then executed the readiness roadmap: M1 (canon), M2 (records: vision.md,
decisions.md, slices/archive/, Vision front matter + legacy branchTitles script removed,
MANIFEST pinned with basePath/baseCommit/funnel), M3 (dashboard = interim Proto: computed
stale badges, funnel chips, ⧉ session-prompt copy).

Commits: f0ce4cb · 94b5984 · 0e2b99b · 26d03e8 · 3d9dee5 · e0bb2cd · cd98aef · 315b9d0 ·
fa68be6 · 33c3cfb · e1dc175 · df9b5d7 + the M2/M3 commits following.

### Next Up
- **M4 Personas** — gated on Peter providing his persona documents → import to
  `personas/`, activate the Persona Pass.
- **M5 Validation** — scope-trim VOD (Vision-copy debt), run the full ritual loop to
  in-dev with a gap note; **delete the 3 frozen `prd/` branches after ~2026-08-15**.
- VOD is expected to show STALE after this session (its base `index.html` was edited in
  M2 — front matter + title). Verdict: cosmetic; re-pin during M5's first VOD session.

---

## Session 24 — 2026-08-04 → 2026-08-13

**THE VOD + USER ACCOUNTS BUILD.** The slice's entire reason for existing got built,
iterated, and specced in one long arc — 29 commits (`b0b5a61` → `51106c4`). Product
decisions first: VOD and User Accounts **merged into one feature/release** (the planned
separate `user-accounts` slice is dead), the gated set narrowed to reminders + video
resume + audio resume, and the on-device reminders PRD formally nixed in favor of
account-based reminders. Then the prototype: the full account system (in-place blurred
gates with benefit-first copy, Hallow-pattern email-first sheet with a neutral
magic-link flow — name captured post-auth, enumeration-safe — passwords as fallback,
forgot-password, Help→Contact Us), the account area (Edit Profile with avatar presets,
Update Email, Create/Change Password, Sign Out, Delete), account-based prayer
reminders with prime-then-prompt, the signed-out video end screen, Home Continue
Listening, series-page redesign (tap-to-play hero, Remind-me pill on prayer series,
no Subscribe anywhere), and a unified card system: two-slot metadata lines
(identity flexes, time pinned), **green = status / white = control**, no badges or
timestamps over artwork, `ordering: "sequential"` in the data model (Into the Breach,
The Quest sort ascending "IN ORDER"). The build PRD was rewritten in the house
template and published to ClickUp (PRDs → Drafts → `12f0m3-76051`); **PRD updates are
frozen at Peter's request** until he calls for a sync — drift since ~2026-08-12 is
tracked in the changelog. Close-session triage: **all ~30 ⬜ entries stay pending** —
one deliberate port into the Vision after Father Rocky reviews the slice. VOD base
re-pinned @ `7decf1f` (cosmetic staleness; the base's commits were chrome applied to
both files). Also this session: BETA demo pill (all screens, both files), iPad-over-LAN
demo workflow (`http://<mac-ip>:8000/…`), and two out-of-band Proto/dashboard commits
(`b8911d5`, `e831a31`) that landed mid-window from separate work.

### Next Up
- **Father Rocky reviews the slice** (live URL) → then funnel-triage the ~30 ⬜
  changelog entries into the Vision in one pass.
- **PRD sync when Peter says go** — repo + ClickUp are behind the prototype from
  ~2026-08-12 onward (end-screen v3–v5, benefit-first gate copy, two-slot metadata +
  series ordering, green/white rule, badges/timestamps removal, Continue Watching
  purity, no-Subscribe).
- **Dev handoff with Brian** off the ClickUp PRD (Drafts → Approved); handoff as a
  question — what's expensive, what does the foundation make hard?
- **Delete the frozen `prd/...` branches — due now (~2026-08-15).**
- Re-share slice URLs with Brian's team; put real targets in the PRD metrics table.
