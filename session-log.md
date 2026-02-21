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
