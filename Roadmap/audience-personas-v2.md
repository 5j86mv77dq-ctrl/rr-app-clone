# Relevant Radio App — Audience Personas v2
**Built from 2024 Listener Survey | n=11,361 respondents | ~9,924 app users**
*Owner: Peter Rowntree | Created: February 22, 2026*

---

## Data Snapshot

| Metric | Finding |
|--------|---------|
| Respondents | 11,361 total · ~87% have downloaded the app |
| Age distribution | 80.8% are 55+ · Median: 65–74 · Under 35 is 2.7% |
| Marital status | 59.5% married · 12% widowed · 10.8% single (never married) |
| Religion | 97.2% Catholic |
| Engagement | 42.6% most days or multiple times/day · 22.2% weekly |
| Top shows (#1 ranked) | Patrick Madrid (35.2%) · Drew Mariani (12.3%) · Family Rosary (12.2%) |
| Top spiritual impact | Pray more (74.6%) · Learn faith (73.5%) · Share faith (61.9%) |
| Video viewers | 44.5% watch video content (sessions up to 45 min+) |
| App pray-ers | 66.4% use the app to pray (5+ min sessions) |
| #1 discovery channel | Bumper stickers (21–43% across all segments) | 
| Pledge drive sentiment | 65.2% say "just right" · 10.1% say "too frequently" |

---

---

## The 3 Personas

The three personas live one-per-file in `personas/` so Proto and the persona-review
skill can read them individually:

- `personas/margaret-daily-faithful.md` — Margaret, The Daily Faithful (~50% of app users)
- `personas/michael-committed-catholic.md` — Michael, The Committed Catholic (~35%)
- `personas/katie-seeking-catholic.md` — Katie, The Seeking Catholic (~15%)

---

## Persona Summary Matrix

| | Margaret | Michael | Katie |
|--|---------|---------|-------|
| **Name** | The Daily Faithful | The Committed Catholic | The Seeking Catholic |
| **Age** | 65–74+ | 45–64 | 25–44 |
| **% of base** | ~50% | ~35% | ~15% |
| **Frequency** | Daily / multiple times per day | Few times per week | Weekly to few times per week |
| **Primary channel** | AM/FM radio + app live stream | App on-demand + podcasts | App on-demand + video |
| **Entry point** | Live stream / audio prayers | Named series (Patrick Madrid, etc.) | Featured content / Family Rosary |
| **Job-to-be-done** | Stay connected to the Church daily | Learn on my commute · Keep my place | Raise faithful kids · Find my way back |
| **App zone** | Zone 1 (Daily Prayer) | Zone 3 (Continue Watching) | Zone 2 (Featured) + Zone 1 |
| **Key feature need** | One-tap access · Simplicity | Resume playback · Discovery | On-ramp · Kid content · Video |
| **Revenue now** | ★★★★★ | ★★★☆☆ | ★☆☆☆☆ |
| **Revenue potential** | Planned giving | Growing monthly donor | Long-term (10–15 year) |
| **Competitive threat** | EWTN (TV) | Hallow, Ascension Press | Hallow, Ascension, Formed |
| **Strategic priority** | RETAIN | DEEPEN | ACQUIRE |

---

## Revenue & Lifecycle View

```
Katie (25-44)          Michael (45-64)          Margaret (65-75+)
  Seeking →              Committed →              Daily Faithful
  [$10/yr]               [$300/yr]                [$600/yr + estate]
                                                    
  ACQUIRE                DEEPEN                   RETAIN + PLANNED GIVING
  Long-term ROI          Growth engine             Current revenue base
  
  ──────────────────── LIFECYCLE JOURNEY ────────────────────►
  
  Family Rosary          Patrick Madrid            Live stream
  Featured content       On-demand series          Audio prayers  
  Video                  Audiobooks                Daily Mass
  Social media           Apologetics               Rosary
```

**The business model depends on moving people LEFT → RIGHT through this lifecycle.**
Katie becomes Michael. Michael becomes Margaret. Each stage increases engagement, giving, and loyalty.

---

## What the Data Confirmed

| Assumption | Verdict | Data Point |
|-----------|---------|------------|
| Audience skews old | ✅ Confirmed | 80.8% are 55+ |
| App users are highly engaged | ✅ Confirmed | 42.6% use most days or multi/day |
| Video is a growth area | ✅ Confirmed | 44.5% already watching · 62% of young families watch video outside RR |
| Prayer is core to app experience | ✅ Confirmed | 66.4% pray on the app 5+ min |
| Patrick Madrid is #1 show | ✅ Confirmed | 35.2% rank him #1 |
| Family Rosary is a gateway | ✅ Confirmed | 12.2% rank it #1 · multiple qualitative mentions as entry point |
| RR reduces loneliness | ✅ Confirmed | 28% overall · 40% of young families · devastating in senior qualitative |
| Returning Catholics are real | ✅ Confirmed | 8.9% say RR helped them come back to Church |
| Younger audience is small | ✅ Confirmed | Under 35 is 2.7% · but 91% app adoption (highest) |
| Bumper stickers actually work | ✅ Confirmed | #1 discovery channel across all segments (21–43%) |
| Planned giving is a massive gap | ✅ Confirmed | 60% have wills · only 3% include RR |
| Spousal impact is highest among young families | ✅ Confirmed | 78% say RR inspired them to be a better spouse |

---

## Design Principles (Derived from Personas)

1. **Margaret funds the mission. Michael is the growth engine. Katie is the future.** Design for Margaret first — she is your core, your donor, your daily active user. Don't sacrifice her zero-friction experience for Katie's discovery needs.

2. **The four-zone architecture serves all three simultaneously:**
   - Zone 1 (Daily Prayer) = Margaret's front door + committed Katie's nighttime habit
   - Zone 2 (Featured) = Returning Katie's front door + Michael's discovery
   - Zone 3 (Continue Watching) = Michael's front door
   - Zone 4 (Series rows) = Michael and Katie's depth

3. **Every screen should pass the "Margaret test":** Can a 75-year-old widow get to her daily Rosary in one tap? If no, redesign.

4. **Every feature should pass the "Michael test":** Can a busy 50-year-old dad resume his Patrick Madrid episode instantly from where he left off? If no, prioritize.

5. **Every launch should pass the "Katie test":** Can a 35-year-old returning Catholic find something she wants to watch within 5 seconds of opening the app? If no, fix Featured.

---

## Strategic Imperatives

| Priority | Action | Persona Served | Timeline |
|----------|--------|---------------|----------|
| **1. Maximize planned giving** | Launch estate/legacy giving initiative | Margaret | NOW — this is time-sensitive |
| **2. Build Continue Watching** | Resume playback, episode tracking, progress | Michael | Next sprint |
| **3. Nail the Featured row** | Curated, timely, high-quality entry points | Katie (returning) | Ongoing |
| **4. Launch audiobooks** | Merry Beggars content in-app | Michael + Margaret | Per roadmap |
| **5. Optimize nighttime prayer** | Sleep timer, one-tap Rosary, bedtime flow | Katie (committed) + Margaret | Near-term |
| **6. Video content pipeline** | Systematic video expansion | All — but Katie is the growth driver | Per Video PRD |
| **7. Accessibility pass** | Large text, fewer taps, hearing aid compat | Margaret (75+) | Near-term |
| **8. Shareable clips** | One-tap sharing of show segments | Michael → Katie acquisition | Medium-term |

---

*Source: Relevant Radio 2024 Listener Survey · n=11,361 · ~9,924 app users*
*Apply these personas to every screen design, feature decision, and content investment.*
*Reference the design process doc and Watch Screen PRD for implementation.*
