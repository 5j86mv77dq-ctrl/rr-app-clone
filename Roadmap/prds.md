# PRDs

The register of product requirement docs and which slices they spec. **Proto reads and
writes this file** — it is the one file in the repo Proto edits, deliberately kept separate
from the slice HTML and the changelog so a Claude Code session and a Proto edit can never
collide.

A PRD can cover several slices, and a slice can be covered by several PRDs — the `Slices`
column is the join. The PRD *content* lives in the markdown file named in `Doc`
(repo-relative); the `ClickUp` link is an optional pointer for the team. Markdown in the repo
is the source of truth; ClickUp is where the team comments.

**Parse contract (Proto reads this):** rows are the pipe-table below, in this column order.
`Slices` is comma-separated page paths. Empty cells are `—`. Don't rename the columns or add
new ones without updating `proto-app/Sources/Proto/Repo.swift`.

| PRD | Slices | Doc | ClickUp | Notes |
|---|---|---|---|---|
| Video On Demand + User Accounts + Feedback Form | slices/video-on-demand.html | Roadmap/prd-vod-user-accounts.md | — | Current for accounts + the feedback form. VOD polish from ~2026-08-12 on is unsynced — the slice URL is normative where they disagree. |
| Live Video In-App (Home Screen) | slices/live-video.html | — | — | PRD 1 — shipped to beta. No doc in the repo; the slice is the spec. |
