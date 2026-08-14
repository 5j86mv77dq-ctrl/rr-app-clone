---
name: serve-local
description: Start the local preview server at localhost:8000 so the dashboard's local links and every slice page resolve. Use when Peter says "serve local", "start the server", "the local links are broken", or when a local preview is needed and nothing is listening on 8000.
---

# Serve local

```bash
python3 -m http.server 8000
```

Run it **at the repo root**, from a normal Bash shell, and leave it running in the background.

## Non-negotiables

- **Always port 8000.** The dashboard's `local` links and Proto's embedded previews are
  hardcoded to it. Serving on any other port silently breaks them — the links still look
  fine and just don't load.
- **Serve the repo root**, not `slices/`. Slice pages carry `<base href="/">` and their
  assets are root-relative; served from a subfolder they render blank.
- **Start it from a normal Bash shell.** The Claude Code preview-server launcher
  (`.claude/launch.json`) runs its subprocess in a sandbox that cannot read `~/Documents`
  and fails with `Operation not permitted`. Don't reach for `launch.json` here.
- **No Node/npm on this machine**, and none needed — React and Babel come from unpkg CDNs,
  so there is no build step. Verify with Python and the browser, never `npx`/`npm`.

Proto also spawns this server automatically when it launches and finds port 8000 closed, so
it is often already running. Check before starting a second one.

Once it's up, pages are at `http://localhost:8000/<path>` — e.g.
`http://localhost:8000/slices/video-on-demand.html`, `http://localhost:8000/dashboard.html`.
