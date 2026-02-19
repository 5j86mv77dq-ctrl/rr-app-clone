# Relevant Radio App — Audiobooks Visual Prototype

## What This Is
This is a **visual prototype** for the audiobooks section of the Relevant Radio mobile app. It is NOT production code. It exists to iterate on UX/UI designs quickly, get stakeholder approval, and generate a visual spec for the development team.

## Tech Stack
- Single-file React (JSX) with inline styles
- Fonts: Crimson Pro (serif headings) + DM Sans (UI text) via Google Fonts CDN
- No external dependencies beyond React hooks (useState, useMemo)
- All data is hardcoded dummy content
- Mobile viewport: 375 x 812px (iPhone frame with rounded corners)

## How to Work With This
- **All changes should stay in a single JSX file** — do not split into multiple components/files
- **Inline styles only** — no CSS files, no Tailwind, no styled-components
- **Keep it self-contained** — anyone should be able to drop this file into a React sandbox and see it immediately
- **Prioritize visual fidelity over code quality** — this is a prototype, not production
- When adding new pages/views, add them as new states in the existing `view` state machine

---

## Design System

### Colors (from Relevant Radio's existing app)
```
Header/Nav blue:    #3b6fa0
Card blue:          #4a7fb3
Page background:    #f5f5f5
Content cards:      #ffffff
Dark nav bar:       #0a1929
Accent blue:        #3b6fa0
Light accent:       #5b9bd5
Body text:          #2a2a2a
Muted text:         #7a7a7a
Live button red:    #d32f2f
Now Playing green:  #2e7d32
```

### Typography
- **Page titles:** Crimson Pro, 24-26px, bold, white (on blue headers)
- **Section headings:** Crimson Pro, 19px, bold, dark
- **Body/UI text:** DM Sans, 12-13px
- **Small labels:** DM Sans, 9-11px, muted gray
- **Cover art titles:** Crimson Pro, 13-14px, bold, white with text shadow

### Components Already Built
- `SearchBar` — dark variant (on blue headers) and light variant (on white)
- `SquareCover` — 140x140 horizontal scroll cover
- `GridCover` — responsive 2-up grid cover
- `SearchResultItem` — compact list item for search results
- `HorizontalRow` — category row with title, optional subtitle, See All link, horizontal scroll
- `PageHeader` — blue header with back arrow, title, optional right element
- `TitleDetailPage` — full detail view with hero, summary, credits, suggestions
- `StaticWaveform` — 5-bar static waveform for LIVE button

---

## App Architecture (Views)

The app uses a `view` state variable to control what's shown:

```
"main"          → Browse page: search bar + horizontal rows (Spiritual Reading, Fiction)
"allTitles"     → All Titles: 2x2 grid of everything + search bar
"allSpiritual"  → Spiritual Reading grid + search bar  
"allFiction"    → Fiction grid + search bar
"detail"        → Individual title detail page
```

Navigation flow:
```
Main Page
├── Search bar → filters all titles into list view (inline, no page change)
├── "All Titles →" (header) → allTitles page
├── Spiritual Reading "See All →" → allSpiritual page
├── Fiction "See All →" → allFiction page
└── Tap any cover → detail page
    └── "You Might Also Enjoy" → tap to navigate to another detail page

Every sub-page has a back arrow returning to the previous view.
```

---

## Bottom Navigation (persistent across all views)
1. **Home** — house icon
2. **Listen** — headphones icon  
3. **LIVE** — red circle (#d32f2f) with static 5-bar white waveform, centered, same height as other items, NOT animated, NOT elevated above the bar
4. **Watch** — play triangle icon
5. **Pray** — icon

Plus a green "Now Playing" mini-bar floating above the nav showing current live stream.

---

## Content Rules

### Categorization
- **Spiritual Reading** = nonfiction, devotional (e.g., Confessions, Interior Castle, Story of a Soul)
- **Fiction** = literary fiction with Catholic themes (e.g., Brideshead Revisited, Power and the Glory)
- These are the ONLY two categories in audiobooks
- Audio dramas are a completely separate section of the app (not in this prototype)

### The Merry Beggars Branding
The Merry Beggars is the production company that makes all this content. Branding rules:
- **NO badge or logo on any audiobook cover**
- **NO "from The Merry Beggars" on Spiritual Reading** titles
- **YES: "from The Merry Beggars"** as italic gray subtitle under the **Fiction category heading only** — explains why a Catholic radio app has literary fiction
- **YES: Full credits on every title's detail page** under "Details & Credits" (Producer, Director, Audio Editor, Sound Design, Music, Production)
- The Merry Beggars gets full branding only in the audio dramas section (not this prototype)

### Title Detail Page Structure
1. Blue hero section: cover art, preview button, title, duration, author + narrator
2. White content area with rounded top corners overlapping hero
3. "Download to Play" button (blue, full width, rounded)
4. Summary (paragraph text)
5. Divider
6. Details & Credits (label/value pairs: Producer, Director, Audio Editor, Sound Design, Music, Production)
7. Divider
8. "You Might Also Enjoy" — 2 randomly selected titles from the library as square covers

### Dummy Data
- 5 Spiritual Reading titles, 4 Fiction titles
- All have full summaries and credits
- Credits use placeholder names (Michael Torres, Sarah Chen, etc.)

---

## What Needs to Be Built Next (Future Iterations)
- [ ] Listen page (what you see when you tap "Listen" in nav — audiobooks would be a sub-section here)
- [ ] Home page
- [ ] Watch page
- [ ] Pray page
- [ ] Audio dramas section (separate from audiobooks, full Merry Beggars branding)
- [ ] Playback/player UI
- [ ] "Continue Listening" row on main audiobooks page
- [ ] Download progress states
- [ ] Empty states (no search results already handled)
- [ ] Onboarding or first-time experience

---

## Stakeholder Context
- **Father Rocky** (senior leader) needs to approve visuals — keep designs simple, polished, and demo-ready
- **Peter** (VP Marketing) is iterating on UX decisions — expect frequent changes to layout, copy, and information architecture
- **Dev team** (Brian + contractors) will eventually implement from this prototype — keep the visual spec clear and consistent
