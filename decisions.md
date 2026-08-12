# Decisions Log

Dated entries recording **why the vision or the system moved — or deliberately didn't**.
The changelog records what changed; this records what was decided, including what was
decided *against*. Appended by Claude when a decision lands; never rewritten.

---

- **2026-08-12 — The bundle gets its build PRD; on-device reminders PRD formally nixed.**
  Peter's call: the VOD slice is the final prototype the dev team executes against.
  `Roadmap/prd-vod-user-accounts.md` was rewritten in the house PRD template
  (ClickUp-style: Problem & Strategy / Feature Specs / Design / Risks / Open
  Questions), superseding the product-spec draft (git history preserves it) and
  replacing the "On-Device Prayer Reminders (Watch Tab)" PRD — reminders ship
  account-based, with accounts, eliminating that PRD's preference-migration risk.
  Cut from the bundle's player: sleep timer, queue/series button, prayer-request
  submission (share + cast only). Published to ClickUp under PRDs → Drafts.
- **2026-08-05 — Gated set narrowed to three; Favorites deferred; Downloads stay local.**
  Peter's call: accounts gate only daily prayer reminders, video resume (Continue
  Watching), and audio resume (Continue Listening) in this release. Favorites/My List is
  not being built yet; My Downloads keeps its existing local behavior — untouched and
  ungated. Also decided: the account menu gets a **dedicated Daily Prayer Reminders
  page** — a deliberate visual duplicate of the Watch-tab section (same state, second
  surface), chosen over a pointer row for findability. PRD amended in place.
- **2026-08-04 — VOD + User Accounts merged into one feature, one release.** Peter's
  call: they were planned as two slices (a `user-accounts` slice created off VOD,
  `dependsOn` it) — no longer. They ship together; `slices/video-on-demand.html` is the
  single prototype home for both the VOD experience and the accounts/gating UX. The
  planned separate slice and its dependency lineage are dead. Product spec:
  `Roadmap/prd-vod-user-accounts.md` (free-forever app; accounts gate continuity —
  reminders, resume, favorites, downloads — EWTN-style in-place soft gates). The PRD's
  §8 release scope also settles the VOD scope-trim debt recorded 2026-08-01.
- **2026-08-03 — Workflow statuses removed from the system; ClickUp owns them.** Peter's
  call: no dual maintenance of review/dev/shipped state in ClickUp AND the repo/Proto. The
  `stage` field is gone from front matter + MANIFEST; the dashboard's Status column and
  Proto's Roadmap surface (planned cards) are deleted — planning and status both live in
  ClickUp. The repo keeps only technical truth: production designation, base pins,
  dependsOn, funnel. Freeze/ship/retire remain as announcements with repo side-effects
  (gap note, base refresh offers, archive).
- **2026-08-03 — proto-prd.md is canon.** Supersedes prototype-system-v3.md (and v1/v2
  research docs). One document defines the system and the Proto app; the final mockup
  (`design_process/basis-mockup.html`) is the normative visual spec.
- **2026-08-03 — Slice front matter codified.** Every slice file opens with a
  `<!--PROTO-->` block (name · stage · production · base pin · dependsOn) — the per-file
  record; the dashboard MANIFEST is its index, updated in the same commit.
- **2026-08-02 — Chains removed; two relationships only.** Peter's call: `base` (lineage,
  pinned, drives staleness — says nothing about ship order) and `dependsOn` (ship order)
  are orthogonal and both real; "chains" and feature/step fields added nothing and were
  deleted. A big feature is slices linked by dependencies, MVP first, each later piece
  copying the piece it depends on once it stabilizes (≤3 unshipped deep).
- **2026-08-02 — The Vision stays durable and AI-maintained.** v2's
  "regenerate-the-vision-from-a-doc" model rejected: `index.html` is the accumulated
  result of every funnel decision and the artifact Father Rocky approves. `vision.md` is
  the written record beside it, not the source above it.
- **2026-08-01 — Vision-copy exception used for VOD.** `slices/video-on-demand.html` was
  copied from the Vision (the VOD experience exists nowhere else). Debt recorded: it owes
  a scope-trim before leaving draft. Default basis for slices remains current production.
- **2026-08-01 — Current production = a designation, not a page.** Exactly one slice
  carries `production: true` (today: `slices/live-video.html`, in beta). It moves only
  when Peter announces "X is now production."
- **2026-08-01 — One branch; slices are pages.** Migrated off branch-per-slice: all slices
  became `slices/<name>.html` on `main`, with per-path URLs. Old `prd/` branches frozen;
  delete after ~2026-08-15.
