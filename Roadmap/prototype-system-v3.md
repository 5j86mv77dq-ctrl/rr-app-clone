# The Prototype System — v3 (Grounded Proposal)

> **SUPERSEDED 2026-08-03.** This document is historical. The canonical definition of the
> system and the Proto app is **[proto-prd.md](proto-prd.md)** — do not follow this file
> as guidance (its body still describes chains, which were removed).

> **Amendment 2026-08-02 — chains removed.** Peter's call, adopted everywhere: there are
> exactly **two relationships** per slice — **`base`** (lineage: the file it was copied
> from, pinned; drives staleness; says nothing about ship order) and **`dependsOn`**
> (ship order: what must ship first). "Chains" and the `feature`/`step` fields are gone;
> a big feature is just slices linked by dependencies, MVP first, each later piece copying
> the piece it depends on once it stabilizes (max 3 unshipped deep). §2.2's "chain" and
> any `feature`/`step` references below should be read accordingly. The app is **Proto**.

**Status:** Proposal. Supersedes the v2 design document.
**Owner:** Peter Atkinson (product lead). **Drafted by:** Claude, against the running repo.
**What's different about v3:** v1 and v2 were written as specs for a system to *build*.
v3 is written against the system that is *already running* in `rr-app-clone` (migrated off
branches 2026-08-01). Every item is tagged:

- ✅ **RUNNING** — live in the repo today
- 🔧 **ADOPT** — this proposal; graftable without restructuring anything
- 🏗 **BUILD** — the Proto Mac app (real software project, scoped in §7)
- ⏸ **DEFERRED** — consciously not now

---

## 1. Foundations (✅ RUNNING — unchanged from v2)

- **Vibe coding is used for exactly one thing: visual prototypes.** No prototype code ever
  ships as production code. The dev team builds every feature natively, from scratch, in
  the real app's stack, using the prototype purely as a visual spec.
- **The prototype is the deliverable.** Stakeholders approve pixels, not markdown. Text
  documents are the durable *record behind* the prototypes, never the deliverable.
- **Disposability is the engine.** Because prototype code never flows anywhere, prototypes
  are cheap to create, modify recklessly, and throw away.

### 1.1 The two-repo boundary (clarifies v2's biggest ambiguity)

Two repositories exist and they never touch:

| Repo | Contents | Owner |
|---|---|---|
| `rr-app-clone` (this one) | Every prototype, the dashboard, all system records | Peter + Claude |
| The real app's repo | Actual production code | Dev team |

**This system reads and writes only the prototype repo.** Staleness detection (§5) is a
question about *our own files* — "has the base page changed since this slice copied it?" —
answered from the prototype repo's git history. The real world enters the system exactly
one way: **Peter announces it** ("X shipped", "X is now production"). Those announcements
move the production designation, which is the system's model of reality. No integration
with the app's repo exists, and none is needed.

---

## 2. The Conceptual Model

Four primitives plus one derived annotation. The first three are the things Peter named as
must-captures: the settable basis, the chain sequence, and the funnel status.

### 2.1 Basis — the one hard arrow (✅ RUNNING as `base`; 🔧 ADOPT the pin)

Every slice records **what it was copied from and envisioned against**. This is settable
at creation (and re-settable on a rebase). Today it's a plain label (`base: "live-video"`);
this proposal upgrades it to a **pin**:

```
base: "live-video", baseCommit: "9430718"   // in the dashboard MANIFEST
```

The pin is what makes staleness *detectable* instead of *remembered* (§5).

Rules (✅ running): default basis for a one-off = the current-production slice; for a chain
step = the previous step. Copying the Vision is allowed **only** when the feature exists
nowhere else (v2's absolute ban is rejected) — and a Vision-based slice owes a **scope-trim
pass** before leaving draft: strip anything that is neither in production nor in this
slice's scope. (This debt is currently open on `slices/video-on-demand.html`.)

### 2.2 Chain — the sequence (✅ RUNNING)

A large feature is chopped into ordered slices sharing a `feature` name with `step`
numbers. Step 1 = the MVP that ships fastest; step N is copied from step N−1. The dashboard
groups chain steps under the feature name. **Cap: never more than three unshipped steps**
(🔧 make explicit in CLAUDE.md) — deeper than that is speculation on an unshipped
foundation. Plan deeper chains in the roadmap; don't prototype step 4 until step 1 ships.

### 2.3 Funnel status — the third must-capture (✅ RUNNING; 🔧 surface it)

"Has this slice's work been funneled to the Vision?" is already recorded — every change in
`Roadmap/CHANGELOG.md` carries ⬜ pending / 🌐 ported / 🔀 slice-only — but it's only
visible by opening the changelog. **Adopt:** each slice's MANIFEST entry gets a `funnel`
summary (e.g. `"3🌐 1🔀 2⬜"`) maintained at session close, shown on the dashboard row. A
slice with ⬜ items outstanding is a slice with undecided ideas — visible at a glance.

### 2.4 Dependency — the optional forward arrow (🔧 ADOPT lazily)

Distinct from basis: *based on* X but *can't ship until* Y. Supported as an optional
MANIFEST field (`dependsOn: ["slices/other.html"]`) **the first time the divergent case
actually occurs**. No ceremony until then. Within a chain, ship order is already implied
by step numbers; `dependsOn` is only for cross-feature blocking.

### 2.5 Production designation — the moving flag (✅ RUNNING)

Exactly one slice carries `isProduction: true` (green tag, pinned under the Vision):
the closest mirror of the real app today (currently `slices/live-video.html`, in beta).
It is the default basis for one-offs and the reference every staleness check is measured
against. It moves only when Peter says *"X is now production."*

### 2.6 The Vision — durable, not regenerable (✅ RUNNING; v2 inverted, v3 restores)

v2 called the vision prototype a disposable illustration of `vision.md`. **Rejected.**
`index.html` is the *accumulated result of every funnel decision ever made* — the artifact
Father Rocky actually approves. It is durable and hand-maintained — by the AI, verified by
render before every push, so the maintenance-cost argument against durable prototypes
doesn't apply. `vision.md` (🔧 adopt, §4.1) is the cheap written record *beside* it — the
tie-breaker in direction arguments — not the source above it.

---

## 3. Physical Layout (✅ RUNNING; 🔧 four additions)

One repo, one branch (`main`), one Netlify deploy. No feature branches, ever (throwaway
preview branches allowed for risky Vision edits; deleted after). Slices are **single-file,
whole-app clones** — v2's screens-per-folder layout is rejected: Father Rocky clicks
through the *entire app*, and consistency comes free because a copy of the app can't be
off-brand. The cost — staleness detection is per-slice, not per-screen — is acceptable at
this scale. (Same reasoning defers the design-token Kit: copy-inheritance already does its
job. Build the Kit only if the dev team formalizes a native design system to extract from.)

```
rr-app-clone/
├── index.html            ✅ The Vision (durable; AI-maintained)
├── dashboard.html        ✅ Mission Control: rows, statuses, manual, MANIFEST (source of truth)
├── CLAUDE.md             ✅ The encoded rulebook (rituals live here, not in memory)
├── vision.md             🔧 One-page north star; the tie-breaker record
├── decisions.md          🔧 Dated log: why the vision moved (or deliberately didn't)
├── personas/             🔧 One page per audience persona (from Peter's existing docs)
├── slices/
│   ├── live-video.html   ✅ current production (green flag)
│   ├── video-on-demand.html  ✅ chain "VOD + User Accounts", step 1 (owes scope-trim)
│   └── archive/          ✅ retired slices (or deleted; git preserves)
├── Roadmap/
│   ├── README.md         ✅ The model, in full
│   └── CHANGELOG.md      ✅ Per-slice change log with funnel statuses
└── session-log.md        ✅ Session record (AI-maintained)
```

URLs are derived from paths (`…/slices/<name>.html`) — links cannot go stale. The
dashboard adds a **local** link per row (instant preview at `localhost:8000`) and a
**share** link (Netlify).

---

## 4. Lifecycle and Rituals

Stages (✅ running): **draft → in-review → in-dev (frozen spec) → shipped → archived**,
plus the production designation as an orthogonal flag. Status changes happen only when
Peter announces reality; a status is a label, it notifies no one.

### 4.1 The durable text layer (🔧 ADOPT — one afternoon)
- **`vision.md`** — one page: what the app is for, who it serves, the 3–5 pillars of the
  end-state, what the app deliberately will *not* be. Function: tie-breaker. Updated
  deliberately and rarely, each change logged in `decisions.md`.
- **`decisions.md`** — dated entries recording *why* the vision moved or deliberately held.
  The changelog records what changed; this records what was decided **not** to happen and
  why — the knowledge that currently evaporates.

### 4.2 Session close (✅ changelog/session-log; 🔧 add two checks)
1. **Vision Funnel** (✅ running as "funnel to main" / close-session triage): list ⬜
   items, Peter picks, Claude ports element-by-element into `index.html`. Never bulk-merge
   a slice — the Vision is a destination, not a changelog.
2. **Persona Pass** (🔧 adopt — Peter has persona documents; import to `/personas/`):
   the AI walks the modified flows as each persona and reports friction against their
   red-flag lists. A *lint check, not user research* — output is a flag list Peter accepts
   or dismisses; dismissals logged. **Beta-group data always outranks the simulation**;
   when they disagree, the persona page gets updated.
3. **Integrity check** (🔧 adopt): any slice file with git changes this session but no
   matching changelog entry → "unrecorded session" warning before push. The system
   polices its own record-keeping.

### 4.3 Freeze — the gap note (🔧 ADOPT)
When a slice moves to in-dev, the AI drafts a one-page **gap note** from the changelog:
what the **Vision shows** for this area · what **production has** today · what **this
slice ships** · what is **deliberately deferred, and why**. Deferred scope is what gets
re-litigated in meetings; writing it once, at freeze, ends that. Filed alongside the slice,
linked from ClickUp.

### 4.4 Handoff — as a question (🔧 ADOPT as ritual language)
The slice URL + gap note go to the dev team framed as a question: *"Here's the intent —
what's wrong with it? What's expensive? What does the foundation make hard?"* Their
pushback lands before any native code is written; the slice adjusts, or the constraint
enters the funnel. This is the mitigation for the real organizational risk of a product
lead arriving with finished-looking prototypes.

### 4.5 Ship — the flag question (✅ RUNNING)
"X shipped" → stage flips; Claude asks whether the production designation moves and offers
to rebase the next chain step (§5.3). Ships-with-deviations → the deviation enters the
funnel (absorb into the Vision or hold the line; either way a `decisions.md` entry).

---

## 5. Staleness and Reintegration (🔧 ADOPT — the core v2 keeper, corrected)

A slice is envisioned against a moment in time, and the world moves. Two distinct triggers,
**both inside the prototype repo** (§1.1):

1. **The base page changed.** Mechanical: has the basis file been committed to since
   `baseCommit`? The dashboard computes this live from the prototype repo's GitHub API and
   shows a **stale badge** on the row. Zero AI, zero maintenance.
2. **The designation moved.** Human-triggered: Peter announced a new production slice, so
   every draft one-off based on the *old* production is now building on yesterday. Same
   badge, different reason.

### 5.1 Assessment — three verdicts, on demand
A stale flag says *that*, not *how bad*. An on-demand AI assessment diffs old-base vs
new-base and returns:
- **Cosmetic** — restyle in one prompt.
- **Structural** — the base changed shape: re-copy the current base, re-apply this slice's
  feature delta from its changelog.
- **Conceptual** — the app evolved past the premise: back to Peter for a re-envision call.

### 5.2 Reintegration — regenerate, never hand-patch
The rebase is one agentic prompt: *"Slice X is pinned to base @ commit N; base is now M.
Re-copy the base, re-apply the feature delta from X's changelog, flag anything that no
longer fits."* The mechanically-maintained changelog is load-bearing: it records **intent**,
which is what survives; the old prototype file is discarded. Machine detects; agent
assesses; Peter decides.

---

## 6. CLAUDE.md — the encoded rulebook (✅ RUNNING; 🔧 additions)

Already encodes: the model, slice-creation ritual (never auto-create; confirm basis),
target-page confirmation, render-verification before every push, changelog discipline,
session open/close, the dashboard MANIFEST as source of truth. **Adds under this
proposal:** the basis pin format, the chain cap, the Persona Pass, the integrity check,
the gap-note-at-freeze ritual, the handoff-as-question framing, and the three-verdict
reintegration menu. Rituals live in the rulebook so they run when humans are tired,
rushed, or inspired.

---

## 7. Proto — the native macOS control room (🏗 BUILD)

*(Named **Proto** — distinct from the "basis" arrow of §2.1, which keeps its name.)*

A personal SwiftUI Mac app on top of the running system. Design constraints, in order:

1. **The repo is the database. Proto stores nothing.** All state — slices, stages, basis
   arrows, chains, staleness, funnel summaries, URLs — is derived by reading the local
   repo: the `MANIFEST`, the changelog, and `git log`. A week of Claude Code sessions can
   never desync it, because there is nothing to sync. (Corollary: the MANIFEST + changelog
   formats become a **stable read contract** — any format change must keep Proto parsing.)
2. **Proto is the control room; Claude Code is the workbench.** Proto never generates
   prototypes. "Start session" opens Claude Code in the repo with a pre-filled prompt;
   "Assess" / "Reintegrate" launch the §5 agentic sessions. (Embedding the agent via the
   Claude Agent SDK is explicitly out of scope for v1.)
3. **Rigidity is a feature.** Proto hardcodes the workflow as a commitment device against
   redesigning-instead-of-running. Reopening the frozen workflow requires a written case
   in `decisions.md`, at quarterly planning only.
4. **Links are derived** from folder paths. Proto is Peter's private cockpit; the deployed
   dashboard remains the team's front door — the dev team never needs Proto.

**v1 surfaces:** a **Board** (slices by stage, green flag, stale badges, funnel summaries);
**Slice detail** (basis rail drawn as a track — chain steps, designation lit, staleness
per node — plus gap note, persona flags, changelog); **Vision** (vision.md, funnel queue,
decisions log); **Personas**. v1 reads the repo and launches sessions; it does not write
files itself.

**Build order note:** Proto *renders* the system; it doesn't create it. The 🔧 adoptions —
especially basis pins and funnel summaries in the MANIFEST — are its data model, so they
land first, get exercised by one real chain, and only then get glass poured over them.

---

## 8. Ownership (reality-based)

| Responsibility | Peter | Claude (AI) | Product ops | Dev team |
|---|---|---|---|---|
| Vision (`index.html`), `vision.md`, `decisions.md` | **Decides** | Maintains + verifies | Log hygiene | Informed |
| Slices: create, iterate, funnel decisions | **Decides** | Executes + records | Converts to specs/tasks | Builds natively from them |
| All git, all record-keeping, all rituals | — | **Owns, every session** | — | — |
| Stage changes + production designation | **Announces** | Applies | Tracks in ClickUp | Reports ships/deviations |
| Gap notes | Approves | Drafts | Files in ClickUp | Receives with slice URL |
| Personas | Approves | Runs the pass | Syncs with survey waves | Informed |
| Production code | Informed | — | — | **Owns** |

The record-keeper is not a human who might get busy. (✅ already true; v3 just writes it down.)

---

## 9. Adoption Plan

**Step 1 — the graft (~one session):** `vision.md` + `decisions.md` seeded · personas
imported to `/personas/` · MANIFEST gains `baseCommit` pins + `funnel` summaries
(+ `dependsOn` support) · dashboard gains stale badges + funnel column · CLAUDE.md gains
the new rituals (§4, §5, chain cap) · scope-trim pass scheduled for the VOD slice.

**Step 2 — freeze and run.** No further process redesign. Push the VOD chain end-to-end
through the system: prototype → trim → Persona Pass → freeze with gap note → handoff as a
question → ship → flag moves → step 2 created off step 1. The remaining unknowns get
answered by the run, not by a v4 document. *(v2's own best line: the top risk is a
workflow endlessly redesigned instead of run.)*

**Step 3 — build Proto** against the data model the run just validated (§7 build-order note).

**Definition of success (30 days):** VOD step 1 goes prototype → spec → shipped with a
gap note that prevented at least one re-litigation; zero long-lived branches; every
staleness badge on the dashboard is either green or explained; at least one element ported
upstream through the funnel; Proto v1 renders the Board from the repo with no stored state.

---

## 10. Deferred, with reasons (⏸)

| Item | Why deferred |
|---|---|
| Design-token Kit | Copy-inheritance already guarantees coherence; extract from the dev team's native design system if/when one exists |
| Screens-per-folder prototypes | Whole-app clones are the point: stakeholders tour the app, not screens; restructuring re-shares every URL for a precision gain that doesn't matter at this scale |
| Regenerable Vision prototype | The Vision is the accumulated approval artifact; regenerating from a one-pager destroys ported detail. AI maintenance removes the cost that motivated v2's rule |
| Agent embedded in Proto (Agent SDK) | v1 launches Claude Code; embedding is a v2 decision after the control room proves itself |
| Cross-feature `dependsOn` ceremony | Field is supported; UI/rituals wait for the first real divergent case |
