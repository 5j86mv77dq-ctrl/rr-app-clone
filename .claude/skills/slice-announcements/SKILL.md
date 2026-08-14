---
name: slice-announcements
description: Handle the four announcements that change repo truth — "X is now production", "X shipped", "X is frozen for dev" (draft the gap note), and "retire X" / "archive X". Use when Peter announces any change in a slice's real-world status.
---

# Slice announcements

Workflow status (in review, in dev, shipped) lives in **ClickUp**, not the repo — Peter
refuses dual maintenance. But four announcements change technical truth here, and each has a
procedure. In all four, front matter and the dashboard `MANIFEST` update **in the same
commit**.

---

## "X is now production"

The designation moves. Exactly one slice carries `isProduction: true` — the closest mirror of
the real app today, and the default base for one-off slices.

1. Remove `isProduction` (and `productionLabel`) from the slice that has it.
2. Set `isProduction: true` on X, with `productionLabel: "beta"` or `"prod"` — ask which if
   it isn't obvious. `beta` = in the real app but not shipped to everyone (amber tag);
   `prod` = shipped (green). Absent means `prod`.
3. Set `production: true` in X's PROTO front matter; clear it on the old one.
4. Any slice based on the *old* designated slice is now stale by rule — flag them and offer
   the reintegrate-slice skill.

## "X shipped"

1. If X carries the designation, flip `productionLabel` to `"prod"`.
2. Offer to refresh dependents' bases: every slice with `dependsOn: X` should usually be
   re-copied from the shipped X rather than hand-patched — that's the reintegrate-slice skill.
3. Ask whether the designation should move to X if it isn't already there.
4. Ask whether X should now be archived (shipped and done is one of the archive reasons).

## "X is frozen for dev"

X is a **frozen spec** — the dev team is building from it. Do not edit the file afterwards
without Peter's explicit OK, and say so plainly if a later request would touch it.

**Draft the gap note** from X's changelog. Four parts, in this order:

1. **What the Vision shows** — the end-state this slice is a step toward
2. **What production has** — what's live in the real app today
3. **What this slice ships** — the actual scope of this build
4. **What is deliberately deferred, and why** — the part that prevents the dev team
   rebuilding something that was cut on purpose

The gap note travels with the slice URL to the dev team.

**Hand off as a question, never an order:** "here's the intent — what's wrong with it? what's
expensive? what does the foundation make hard?" Pushback lands before native code gets
written; the slice adjusts, or the constraint enters the funnel.

## "retire X" / "archive X"

Archive is one state, no sub-types: **the slice is no longer a live workspace** — shipped and
done, merged into another slice, or abandoned. A free-text note with the date says which.

1. `git mv slices/X.html slices/archive/X.html`
2. add `archived: <YYYY-MM-DD> — <why>` to its PROTO front matter
3. in the `MANIFEST`: update `page` to the new path, add `archived: true` and
   `archivedNote` — **keep the entry**. Deleting it hides the slice from Proto entirely and
   breaks lineage.
4. update the slice's `Roadmap/CHANGELOG.md` section heading to the new path and add an
   archive row marked `meta`
5. refuse (and say why) if X carries the designation, or if a live slice still `dependsOn` it

Peter can also archive from Proto's board, which does steps 1–3 but deliberately not step 4 —
so check for a missing changelog row at close session.
