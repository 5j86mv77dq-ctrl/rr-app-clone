---
name: new-slice
description: Create a new slice page — confirm the kind of slice and its base with Peter first, then copy the base file and write both records. Use when Peter says "new slice", "New slice: <idea>", "make a slice for X", or describes a new feature and agrees it should be its own slice.
---

# Create a new slice

**NEVER auto-create a slice.** A new idea gets a question, not a file.

## 1. Ask which kind, and confirm the base

> New slice? One-off (copy the current-production slice — default), a piece of a bigger
> feature (copy the piece it depends on), or off the Vision (vision-level design work)?

- **One-off** — a small feature, e.g. a call-in button. Copy the slice carrying the
  designation (`isProduction: true`); it inherits everything real and adds one thing.
  Usually no `dependsOn`.
- **A piece of a bigger feature** — copy the piece it depends on, once that piece has
  stabilized. Set `dependsOn`. Never stack more than 3 unshipped slices deep in a
  dependency line.
- **Off the Vision** — only for vision-level design work, and it's an exception worth
  recording in `decisions.md`: a Vision copy owes a scope-trim before it leaves draft.

If the idea is big, invoke the chop-up-feature skill instead — define the pieces first and
build only the MVP.

Wait for the answer. Do not create anything before it.

## 2. Copy the base file

```
slices/<kebab-name>.html
```

- set `<title>` to `Slice: <Pretty Name> — Relevant Radio`
- **keep the `<base href="/">` tag** — slice pages live in a subfolder and every asset is
  root-relative; without it the page breaks
- write the PROTO front-matter block:

```
<!--PROTO
name: <Pretty Name>
production: false
base: <base path> @ <7-char sha of the base file's current commit> (<YYYY-MM-DD>)
dependsOn: none | <path>[, <path>…]
-->
```

## 3. Write the other records — same commit

- a matching `MANIFEST` entry in `dashboard.html`: `page`, `pretty`, `role` (one sentence),
  `base`, `basePath`, `baseCommit`, and `dependsOn` if it can't ship until another slice does
- a new section in `Roadmap/CHANGELOG.md` with a creation row marked `meta`
- if a PRD covers it, a row in `Roadmap/prds.md` (or tell Peter he can add it in Proto)

## 4. Verify and push

Render the new page locally before pushing — a copy that lost its `<base>` tag looks fine in
the file and blank in the browser.
