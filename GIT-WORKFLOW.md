# Git Workflow: Vibe Coding + Demo Snapshots

## The Setup
- **`main` branch** = your live working copy. This is what GitHub Pages shows at your URL.
- **Demo branches** (e.g. `Audiobooks-Demo`) = frozen snapshots you can share with Fr. Rocky.

---

## Day-to-Day: Just Build

Ask Claude to make changes and push. That's it. Everything goes to `main` automatically.
Your GitHub Pages URL always shows the latest version.

---

## Creating a Demo Snapshot

When you hit a state worth sharing, tell Claude:

> "Save this as a demo snapshot called `Demo-V2`" (or whatever name you want)

Claude will run:
```
git checkout -b Demo-V2
git push origin Demo-V2
git checkout main
```

That creates a frozen branch on GitHub and immediately puts you back on `main` to keep building.

---

## Switching GitHub Pages to a Snapshot

When you want Fr. Rocky to see a specific demo version:

1. Go to your repo on GitHub
2. **Settings → Pages → Branch** → change from `main` to your demo branch (e.g. `Demo-V2`)
3. Hit **Save** — the site updates in ~1–2 minutes

To go back to showing your latest work, just switch it back to `main`.

---

## What the Terminal Commands Mean

| Command | Plain English |
|---|---|
| `git checkout main` | Switch to the main working branch |
| `git checkout -b Demo-V2` | Create a new snapshot branch called Demo-V2 |
| `git push origin Demo-V2` | Upload that snapshot to GitHub |
| `git checkout main` | Switch back to main to keep building |

---

## TL;DR

- **Building?** Just tell Claude what you want. It handles everything.
- **Need a snapshot?** Say "save this as a demo snapshot called X."
- **Sharing with Fr. Rocky?** Change GitHub Pages to point at that snapshot branch.
- **Done with the review?** Change GitHub Pages back to `main`.
