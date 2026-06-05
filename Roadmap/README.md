# Roadmap — How This Project Is Organized

This folder is the source of truth for **how the branches relate to `main`**, **what
features belong where**, and **the workflow for developing and promoting features**.
Read this first every session. (Last fully updated: 2026-06-04.)

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
| `prd/on-device-prayer-reminders-watch-tab` | **Active slice** — the up-to-date live-prayer experience. |
| `prd/live-video-in-app-home-screen` | Earlier slice; its features were re-implemented in the prayer slice. Superseded. |
| `prd/watch-tab-synthesis` | **Integration branch off `main`** — where Claude builds/verifies a change before fast-forwarding `main`. Safety buffer so production never breaks. |

**Important history:** the two `prd/...` slices grew up **in parallel** (not stacked), so they
diverged — the prayer slice re-implemented the live-video slice's work. That's why syncing
*between those two* is a hand-port, not a clean merge.

**Branch NEW slices from `main`.** After this session's synthesis, **`main` is the most
complete line** — it holds the full vision (video library + live-prayer experience), and the
older slices are now *behind* it. So a new feature slice should **branch from `main`**, do its
work, and funnel its 🌐 Vision pieces back into `main`. (This is the trunk model: `main` is
both the base new work starts from and the destination work funnels back to.) Do **not** branch
new work from the older slices — they lack `main`'s video library.

## 3. The feature-development workflow (the important part)

When we build or change a feature, this is the loop:

1. **Build on a slice or an integration branch off `main`** — never experiment directly on `main`.
2. **Verify it actually renders.** Headless-render the file and check it (screenshot + 0
   compile errors). **Do NOT judge a change from commit messages or grep counts** — that
   caused real errors earlier in this project. The truth is in the pixels.
3. **Show Peter** — a screenshot and/or the branch preview URL.
4. **Ask the routing question** (unless Peter already directed it):
   > *"Is this part of the long-term vision (→ funnel to `main`) or transitional/slice-only (→ stays on the slice)?"*
5. **If it's 🌐 Vision and Peter approves → funnel into `main`:** build it on the integration
   branch off `main`, verify it renders, `git merge --ff-only` into `main`, push (Netlify
   auto-deploys production). Bring any needed image/video assets along.
6. **Father Rocky gates production.** Before/as a stage hits the public production URL, freeze
   a **Netlify permalink** (`https://<deploy-hash>--relevantradio.netlify.app/`) of that deploy
   so he can review a frozen version. He approves each **stage** of production, not just the
   final state.

**Cadence of asking:** Don't ask on every push — pushes land on **slice / integration
previews**, never on production. The decision point is only **"does this go to `main`?"**
Frequent auto-pushing to a slice is fine and expected; promoting to `main` is the deliberate,
gated step.

## 4. How Claude should work (lessons learned)

- **Verify against the running app, not git archaeology.** Render with headless Chrome
  (`--screenshot` / `--dump-dom`) and check for `SyntaxError`/`Unexpected token`. Earlier,
  reading commit messages / grep counts led to calling `main` "empty" when it had a whole
  older watch tab. Always ground claims in the actual rendered screen.
- **Protect `main`.** Build + verify on the integration branch, then fast-forward `main`.
  Never push an unverified large change straight to production.
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
- Every deploy also gets a permanent permalink — use it to freeze a version for Father Rocky.
