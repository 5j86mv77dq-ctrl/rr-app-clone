---
name: funnel-to-main
description: Port a slice's keeper changes into the Vision (index.html) — list the pending changelog items, let Peter pick, hand-port the winners, verify and push. Use when Peter says "funnel to main", "what should we port?", "port this to the Vision", or "funnel it".
---

# Funnel to main

Slices funnel their vision pieces INTO `index.html`. The Vision is never overwritten by a
slice wholesale — porting is a deliberate, per-feature hand-edit, and Claude owns it.

## 1. List what's pending

From `Roadmap/CHANGELOG.md`, list every ⬜ item, grouped by slice, with its date and
description. Keep it scannable — Peter is picking from this list.

If something is genuinely ambiguous, mark it ❓ TBD and say what the call depends on.

## 2. Peter picks

He answers with the ones that belong in the end-state. Anything he doesn't pick is 🔀
slice-only — a prototype-chrome or slice-specific choice that shouldn't reach the Vision.

## 3. Port each winner by hand

For each 🌐 item:

- find the corresponding code in the slice and apply the *feature*, not the diff — the Vision
  has diverged and the surrounding code will differ
- keep the Vision's own structure, naming and state machine
- if a port depends on something the Vision doesn't have yet (accounts, a gate, a component),
  say so and either port the dependency first or hold the item

## 4. Verify, mark, push

Render the Vision before claiming anything works (see CLAUDE.md's verification constraint).
Then mark each ported row 🌐, the rest 🔀, update the slice's `funnel` tally in the
dashboard `MANIFEST`, and push.

Report back: what went in, what stayed slice-only, and anything held with the reason.
