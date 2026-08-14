---
name: chop-up-feature
description: Break a big feature into shippable slices with Peter — define the pieces, MVP first, then build only the MVP. Use when Peter says "chop up <feature>", "break this down", "this is too big", or asks how to stage a large feature across slices.
---

# Chop up a big feature

A big feature is just slices linked by `dependsOn`, MVP first. The point of chopping is that
something ships early — not that the whole thing is designed up front.

## 1. Define the pieces with Peter — before creating anything

Propose a split and argue for an order. The first piece is **the MVP that can ship fastest**,
not the one that's most interesting to design. For each piece, say in one line:

- what it delivers on its own
- what it needs that doesn't exist yet
- why it can't ship before the piece in front of it

Peter adjusts the split. Agree on it explicitly before any file is created.

## 2. Build only the MVP now

Create just the first piece, via the new-slice skill. Later pieces are **not** created yet —
each one gets created by copying the piece it depends on, once that piece has stabilized.
Creating them early guarantees they're stale before anyone opens them.

Record the agreed sequence somewhere durable: the MANIFEST `role` of the MVP, the changelog
section, or `decisions.md` if the split itself was a judgment call.

## 3. Constraints on the chain

- Never stack more than **3 unshipped slices** deep in a dependency line.
- `dependsOn` is ship order. `base` is lineage. They are different things and a slice can be
  stale without being blocked.
- When a piece ships, invoke the slice-announcements skill: offer to refresh dependents'
  bases and ask whether the designation moves.
