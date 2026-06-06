# Roadmap — How This Project Is Organized

This folder is the source of truth for **how the branches relate to `main`**, **what
features belong where**, and **the workflow for developing and promoting features**.
Read this first every session. (Last fully updated: 2026-06-04.)

- **[CHANGELOG.md](CHANGELOG.md)** — running per-branch log of every change + its port status.
- **[main-production-vision.md](main-production-vision.md)** — the complete feature inventory of `main` (the vision).
- **[slice-prayer-reminders.md](slice-prayer-reminders.md)** — the active slice (live prayer experience).
- **[slice-live-video.md](slice-live-video.md)** — earlier slice, superseded.

---

## 1. The mental model

```
   slice branches (where iteration happens)
        │   only the "vision" pieces funnel up
        ▼
   main  =  the long-term VISION / production line
            the most-complete end-state the dev team builds backward from
```

- **`main` is the destination, not a scratch branch.** It is the canonical, most-complete
  prototype — the "end state" Peter works *backward* from into shippable slices. It is a
  **visual prototype**, not a deployed app, but it is treated as the production line.
- **Slices funnel their vision pieces *into* `main`.** `main` is **NEVER** overwritten or
  fast-forwarded *to* a slice. Work flows **up** (slice → main), never down.
- **Not everything funnels up.** Each change is either:
  - 🌐 **Vision** — part of the long-term app → funnel into `main`.
  - 🔀 **Transitional / slice-only** — only makes sense at an interim stage → stays on its slice.
- **Peter (+ Father Rocky) make the product calls. Claude owns all git** — every merge,
  conflict, splice, promotion. **Peter never resolves a merge conflict.**

## 2. How the branches relate to `main`

| Branch | Role |
|---|---|
| `main` | Production / long-term vision. The destination. Built *toward*. |
| `prd/live-video-in-app-home-screen` | **Active slice** — Live Video on Home Screen, the **foundational** PRD. Its vision pieces funnel up into **both** the prayer-reminders slice and `main`. |
| `prd/on-device-prayer-reminders-watch-tab` | **The next slice** — live-prayer experience; builds on top of live video. |
| `prd/beta-feedback` | **Active slice** — in-app Beta Feedback (More-menu card → form → confirmation). Discrete app-wide chrome off `main`; its work funnels straight back to `main`. |

> **No standing integration branch.** This is a prototype with cheap rollback (git revert +
> Netlify auto-redeploys in ~30s), so `main` is protected by **verifying the render locally
> before each push**, not by a buffer branch. (The old `prd/watch-tab-synthesis` was retired
> 2026-06-06.) If a particular hand-port is gnarly enough to want a *deployed* staging preview,
> spin up a throwaway branch ad hoc and delete it after.

**Important history:** the two `prd/...` slices grew up **in parallel** (not stacked), so they
diverged — the prayer slice re-implemented the live-video slice's work, and the live-video
branch is ~7 weeks behind `main` on *feature* code (it lacks `main`'s video library). That's
why syncing *between any of these* is a hand-port, not a clean merge. **Live video is the
foundational PRD**: changes made on it funnel up into the prayer-reminders slice **and** `main`.
(Note: meta/infrastructure files — `CLAUDE.md`, `Roadmap/`, `session-log.md` — are kept in sync
across branches from the canonical copy; only `index.html` feature code diverges per slice.)

**Branch a new slice from the CLOSEST base — and confirm the base before creating it.**
- **Default = `main`.** It's the most complete line (full vision: video library + live-prayer
  experience), so branching from it gives the cleanest funnel back. The older slices are now
  *behind* `main` (they lack its video library), so don't reach for them by reflex.
- **But you may branch from a slice** when that slice is structurally/visually closer to what
  you're building — e.g. "the next stage past the prayer slice." It's faster to vibe-code from
  a close base. Tradeoff: funneling back to `main` is then a hand-port (Claude owns it), and
  that slice's good work should also funnel to `main` eventually.
- **Claude must NOT assume the base or auto-create a branch.** Before creating one, ask Peter:
  *"New slice? What's it building toward? Branch from `main` or from `<closest slice>`?"* and
  confirm. (This is the trunk model with a pragmatic escape hatch: `main` is the usual base
  *and* the destination, but proximity can win for fast iteration.)

## 3. The feature-development workflow (the important part)

When we build or change a feature, this is the loop:

0. **Confirm the branch first.** Before any editing, check the current branch and confirm it's
   the intended one. If Peter is on `main`, or on a slice that doesn't fit the work, **stop and
   ask** (e.g. *"You're on `main` — spin up a new slice first? From which base?"* / *"New
   feature — new branch, or keep editing `<branch>`? Are you sure?"*). Don't edit until confirmed.
1. **Build on a slice off `main`** for slice work. Direct fixes to `main` are fine too — there's
   no buffer branch; what protects `main` is verifying the render locally before pushing (step 2).
2. **Verify it actually renders.** Headless-render the file and check it (screenshot + 0
   compile errors). **Do NOT judge a change from commit messages or grep counts** — that
   caused real errors earlier in this project. The truth is in the pixels.
3. **Log it.** Append the change to **`Roadmap/CHANGELOG.md`** under the current branch
   (date · description · status ⬜ pending).
4. **Show Peter** — a screenshot and/or the branch preview URL.
5. **Triage / ask the routing question** (on demand, or at close session — list the ⬜ items):
   > *"Which of these are part of the long-term vision (→ funnel to `main`) vs. transitional/slice-only (→ stay on the slice)?"*
6. **For each 🌐 Vision item Peter picks → funnel into `main`:** apply it to `main` (a clean ff
   when the slice hasn't diverged, otherwise a hand-port Claude owns), **verify it renders
   locally**, then push (Netlify auto-deploys production). Bring needed assets along. Mark the
   changelog entry 🌐 (or 🔀 if it stays).
7. **Father Rocky gates production.** He reviews via the **live Netlify URLs** — the branch
   preview for a slice, the production URL for `main`. He approves each **stage** of production,
   not just the final state. (Peter uses the live branch / production links; **don't offer
   frozen permalinks**.)

**Cadence of asking:** Don't ask on every push — slice pushes land on **slice previews**, never
on production. Every change is *logged* to the changelog as it happens; the
*decision* ("does this go to `main`?") is batched — at close session or when Peter asks "what
should we port?" Promoting to `main` is the deliberate, gated step.

## 4. How Claude should work (lessons learned)

- **Verify against the running app, not git archaeology.** Render with headless Chrome
  (`--screenshot` / `--dump-dom`) and check for `SyntaxError`/`Unexpected token`. Earlier,
  reading commit messages / grep counts led to calling `main` "empty" when it had a whole
  older watch tab. Always ground claims in the actual rendered screen.
- **Protect `main`.** Verify the render locally (headless Chrome) before every push to `main`.
  There's no buffer branch — the local render is the safety net. Never push an unverified large
  change straight to production. (For a gnarly hand-port, a throwaway deployed-preview branch is
  fine ad hoc; delete it after.)
- **Claude owns all git mechanics.** Branch creation, splices, merges, conflict resolution,
  asset pulls (`git checkout <slice> -- <path>`), fast-forwards, pushes.
- **One self-contained file.** Everything is in `index.html` (single-file React + inline
  styles). For big restructures, write the new component to a temp file and splice with
  `head`/`tail` rather than hand-retyping; for small changes use exact-match edits.
- **At close session:** run the funnel ritual (which changes are vision → `main`) and update
  these Roadmap docs to match reality.

## 5. Branch / Netlify quick reference

- Production (`main`): https://relevantradio.netlify.app/
- Slice preview: `https://<branch-slug>--relevantradio.netlify.app/` (slug = branch name, `/`→`-`)
- Review happens on these **live URLs** (branch preview for slices, production for `main`).
  Permalinks exist but Peter doesn't use them — don't offer to freeze one.
