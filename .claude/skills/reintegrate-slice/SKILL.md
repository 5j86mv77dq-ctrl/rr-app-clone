---
name: reintegrate-slice
description: Assess a stale slice and give one verdict — cosmetic, structural, or conceptual — then reintegrate it against its current base and re-pin. Use when Peter says "reintegration", "assess staleness", "is this slice stale?", "X is stale", or pastes Proto's reintegration prompt.
---

# Reintegrate a stale slice

**Stale is detection, not a verdict.** A slice is flagged stale when its base file has commits
after its front-matter pin **that touch content outside the PROTO block** (meta-only
bookkeeping commits — re-pins, field edits — never count), or when the designation moved off
its base. Stale ≠ blocked, and stale ≠ bad: it only means someone has to look.

**Never hand-patch a stale slice.** Assess first, then do one of three things.

## Assess

Diff the base file between the pinned commit and now:

```bash
git diff <baseCommit>..HEAD -- <basePath>
```

Read the slice's own changelog section to know what its feature delta actually is. Then
report **one verdict**:

- **Cosmetic** — the base gained styling or copy the slice should inherit, and it can be
  restyled in a single prompt. Apply it directly.
- **Structural** — the base changed shape (new components, new state, a reworked page).
  **Re-copy the current base to a fresh file, then re-apply this slice's feature delta from
  its changelog.** Do not merge by hand; the point of the copy is that the slice inherits
  everything real.
- **Conceptual** — the app evolved past the slice's premise. Stop and go back to Peter; this
  is a product decision, not a merge.

Say which verdict and why in two or three sentences before doing the work.

## Reintegrate

For cosmetic and structural, once the work is done:

1. re-pin `base` in the slice's PROTO front matter — `<path> @ <new sha> (<date>, re-pinned;
   <cosmetic|structural> — <one-line reason>)`
2. update `baseCommit` in the dashboard `MANIFEST` — same commit
3. log a `meta` row in the slice's `Roadmap/CHANGELOG.md` section
4. verify by rendering, then push

A re-pin commit that touches only the PROTO block is meta-only by design and will not make
dependents stale.
