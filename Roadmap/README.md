# Roadmap — How This Project Is Organized

This folder is the source of truth for **how the slices relate to the Vision**, **what
features belong where**, and **the workflow for developing and promoting features**.
Read this first every session. (Last fully updated: 2026-08-01 — the Vision + Slices
migration; one branch, slices as pages.)

- **[CHANGELOG.md](CHANGELOG.md)** — running per-slice log of every change + its port status.
- **[main-production-vision.md](main-production-vision.md)** — the complete feature inventory of the Vision (`index.html`).
- **[slice-live-video.md](slice-live-video.md)** — the **foundational** slice (Live Video on Home Screen); fed both the prayer slice and the Vision.
- **[slice-prayer-reminders.md](slice-prayer-reminders.md)** — the live-prayer slice, built on live video.

> **Mission Control:** a hosted dashboard of the Vision + every slice and how they funnel,
> at **https://relevantradio.netlify.app/dashboard.html** (the file is `dashboard.html` at
> the repo root). Its embedded `MANIFEST` is the source of truth for slice roles/stages.

---

## 1. The mental model

```
   slices/<name>.html   (where iteration happens — one page per slice)
        │   only the "vision" pieces funnel up
        ▼
   index.html  =  the VISION / production line
                  the most-complete end-state the dev team builds backward from
```

- **One git branch: `main`.** Everything — the Vision, every slice, the dashboard, these
  docs — lives on it. Slices are **pages, not branches** (migrated 2026-08-01).
- **The Vision (`index.html`) is the destination, not a scratch page.** It is the canonical,
  most-complete prototype — the "end state" Peter works *backward* from into shippable slices.
- **Slices funnel their vision pieces *into* the Vision.** The Vision is **NEVER** replaced
  wholesale by a slice. Work flows **up** (slice → Vision), never down.
- **Not everything funnels up.** Each change is either:
  - 🌐 **Vision** — part of the long-term app → port into `index.html`.
  - 🔀 **Transitional / slice-only** — only makes sense at an interim stage → stays on its slice.
- **Peter (+ Father Rocky) make the product calls. Claude owns all git and all porting.**

## 2. The pages and their roles

| Page | Role | Stage |
|---|---|---|
| `index.html` | **The Vision** — long-term end-state. The destination. | vision |
| `slices/live-video.html` | Live Video on Home Screen. **CURRENT PRODUCTION** — in beta, closest mirror of the real app; default base for one-offs. | in-review |
| `slices/prayer-reminders.html` | Live-prayer experience built on the live-video foundation. Vision pieces ported. | in-review |
| `slices/beta-feedback.html` | In-app Beta Feedback (More-menu card → form → confirmation). Ported to the Vision. | in-review |

**Three layers:** the **Vision** (where we're going) · the **current-production slice** (where
we are — exactly one slice carries `isProduction: true` in the dashboard `MANIFEST`; moves only
when Peter says *"X is now production"*) · **slices** (the steps in between). Two kinds of slice
work: **one-offs** (copy current production, add one feature) and **feature chains** (a large
feature chopped into ordered, independently-shippable steps — `feature` + `step` in the
`MANIFEST`; step 1 = MVP off current production, step N off step N-1; when a step ships,
refresh the next step's base and ask whether the production designation moves).

**Slice lifecycle:** `draft` (iterating) → `in-review` (Father Rocky has the URL) →
`in-dev` (handed to Brian's team — the page is a **frozen spec**) → `shipped` (live in the
real app) → `archived` (page deleted / moved to `slices/archive/`; git history preserves it).
The current stage of every slice lives in the dashboard `MANIFEST`.

**History note:** these slices grew up as parallel git branches (pre-2026-08) and diverged —
that's why their code differs structurally from the Vision (the prayer slice re-implemented
live-video's work; both lack the Vision's video library). Porting between any of them is a
hand-port, not a copy-paste. The old branches (`prd/...`) are frozen and slated for deletion
(~2026-08-15); their content lives on in `slices/`.

**New slice = new page, copied from the closest base — and confirm before creating.**
- **Default base = the current-production slice** (one-offs inherit everything real). Chain
  steps copy the previous step. Copy `index.html` only for vision-level design work.
- **Claude must NOT assume the base or auto-create a slice.** Ask Peter first:
  *"New slice? One-off (off current production), chain step (off the previous step), or off
  the Vision?"*
- Mechanics: copy base → `slices/<kebab-name>.html`, set `<title>` (`Slice: <Pretty Name> —
  Relevant Radio`), keep `<base href="/">`, add the `MANIFEST` card/node/edges, log in the
  changelog, push.

## 3. The feature-development workflow (the important part)

When we build or change a feature, this is the loop:

0. **Confirm the target page first.** Before any editing, confirm which file the work
   belongs to — the Vision or which slice. New-feature work → stop and ask (*"new slice,
   or straight into the Vision?"*). A slice in `in-dev` or later is a frozen spec — don't
   touch it without Peter's explicit OK.
1. **Build on the slice page** for slice work; direct changes to the Vision are fine for
   vision-level work. What protects production is step 2 — not a buffer branch.
2. **Verify it actually renders.** Serve the repo root locally (`python3 -m http.server`),
   headless-render the touched page, check for `SyntaxError`/`Unexpected token`, and look
   at the screenshot. **Do NOT judge a change from commit messages or grep counts** — that
   caused real errors earlier in this project. The truth is in the pixels.
3. **Log it.** Append the change to **`CHANGELOG.md`** under the slice (date · description ·
   status ⬜ pending).
4. **Show Peter** — a screenshot and/or the live URL (`…/slices/<name>.html` — updates ~30s
   after push).
5. **Triage / ask the routing question** (on demand, or at close session — list the ⬜ items):
   > *"Which of these are part of the long-term vision (→ port to the Vision) vs. transitional/slice-only (→ stay on the slice)?"*
6. **For each 🌐 Vision item Peter picks → port into `index.html`** (a hand-port Claude
   owns; bring needed assets along), **verify the render locally**, then push. Mark the
   changelog entry 🌐 (or 🔀 if it stays).
7. **Father Rocky gates production.** He reviews via the **live URLs** — the slice page URL
   for a slice, the production URL for the Vision. He approves each **stage** of production,
   not just the final state. (**Don't offer frozen permalinks.**)

**Cadence of asking:** Don't ask on every push — slice pushes land on **slice pages**, never
on the Vision. Every change is *logged* as it happens; the *decision* ("does this go into
the Vision?") is batched — at close session or when Peter asks "what should we port?"
Porting into the Vision is the deliberate, gated step.

## 4. How Claude should work (lessons learned)

- **Verify against the running page, not git archaeology.** Render with headless Chrome
  (`--screenshot` / `--dump-dom`) and check for `SyntaxError`/`Unexpected token`. Always
  ground claims in the actual rendered screen.
- **Protect the Vision.** Verify the render locally before every push that touches
  `index.html`. For a genuinely risky Vision change that wants a *deployed* preview first,
  spin up a throwaway git branch ad hoc (branch deploys are still enabled) and delete it after.
- **Claude owns all git mechanics and all porting.** Peter never runs git and never
  resolves conflicts.
- **One self-contained file per page.** Everything is single-file React + inline styles.
  For big restructures, write the new component to a temp file and splice with `head`/`tail`
  rather than hand-retyping; for small changes use exact-match edits.
- **Slice pages need `<base href="/">`** — they live in a subfolder but reference
  root-relative assets. Never remove it; add it when creating a slice.
- **At close session:** run the funnel ritual, update these Roadmap docs, and sync the
  dashboard `MANIFEST` if any slice was created / staged / retired.

## 5. URL quick reference

- The Vision (production): https://relevantradio.netlify.app/
- A slice: `https://relevantradio.netlify.app/slices/<name>.html`
- Mission Control: https://relevantradio.netlify.app/dashboard.html
- Review happens on these **live URLs**. Permalinks exist but Peter doesn't use them.
- **Deploys come from Netlify auto-publishing `main`** (~20–30s after push). If production
  looks frozen while pushes succeed, check the Netlify Deploys tab for "auto publishing
  off" / a locked deploy (Claude can't reach Netlify settings).
