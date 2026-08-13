# Prompt — Loading & Error States

**Command:** `add loading + error states`
**Use it when:** a prototype page needs the skeleton (loading) and failed-to-load (error)
treatments wired behind demo pills, so stakeholders can see what the screen does before the
data arrives and when it never does.

**Reference screenshots:** the real app's Articles carousel in all three states — loaded,
skeleton, error. Peter has these; attach them to the session when running this prompt.
The skeleton **pulsates** while it waits — that's the detail screenshots don't show.

Paste everything below the line into Claude Code.

---

GOAL: Add a demo-state toggle to the prototype so we can show stakeholders what a screen
looks like while data is LOADING and when it FAILS to load. This is a reusable pattern —
once it's in, every new content row we build should support it.

=== STOP. ASK ME THE SCOPE FIRST. EVERY TIME. ===

Do not read ahead and start building. Do not infer the scope from what's on the page, from
what seems obvious, or from how we scoped it last time. Even if this prompt looks familiar
because we've run it before — the scope is different every time, and a wrong guess means
skeletoning half a screen I didn't want touched.

Ask me these four questions, in one message, and WAIT for my answers before editing any file:

  1. WHICH FILE? The Vision (index.html) or which slice?

  2. WHICH REGIONS? List every data-backed region on that page — each row, carousel, card,
     list, and player surface that would be fed by a network request — as a numbered list,
     so I can just reply with numbers. Name them the way they read on screen ("Articles
     carousel", "Continue Listening row"), not by variable name. Include anything I might
     not be picturing, and flag any you think are borderline. Then ask which ones get
     loading and error states in this pass.

  3. BOTH STATES, OR ONE? Am I building loading + error for those regions, or only one of
     the two right now?

  4. WHAT DOES "TRY AGAIN" DO? Either (a) clears the demo state and reveals the loaded
     content — simplest, recovers instantly, or (b) goes error → loading skeleton → loaded,
     so the full recovery arc is visible in a demo. Recommend (b) if I'm about to show this
     to someone; ask which I want.

If the control pills already exist in the target file from an earlier pass, say so, and ask
questions 2–4 only — then just wire the newly-named regions into the existing state.

Nothing below this line gets built until I've answered.

=== THE CONTROL ===

Add a pill group in the right-hand gutter outside the phone (same gutter as the existing
demo pills at left: 393). Do NOT append to the existing stack under BETA — anchor this
group to the BOTTOM of the 375x812 phone frame, so its last pill sits flush with the
phone's bottom edge. Same visual language as the existing pills: 6px 14px padding,
borderRadius 20, DM Sans 9px/700, letterSpacing 0.5, white with 1px solid rgba(0,0,0,0.15)
when off.

Two pills, stacked:
  LOADING — active color #7a7a7a (muted gray), white text
  ERROR   — active color #d32f2f (live red), white text

Behavior:
  - They drive one shared state, e.g. demoState: null | "loading" | "error".
  - Mutually exclusive. Clicking the active one turns it off and returns the app to its
    normal loaded state.
  - The state persists across tab/page navigation so we can walk Home → Watch → Listen and
    see each screen's treatment without re-clicking.
  - Like the other demo pills, this is a presentation control, not app UI.

=== WHAT THE STATES DO ===

Only the regions I named in question 2 change. Everything else on the page renders normally.
App chrome always stays fully real and interactive: the blue header, the bottom nav, the
Now Playing bar, and section headings (e.g. "Articles") never skeleton out — they're local,
not fetched.

One detail from the real app worth copying: when data hasn't resolved, artwork and titles
fall back to generic Relevant Radio branding (RR logo cover art, "Relevant Radio" as the
Now Playing title) rather than going blank or gray. Do that in both states.

LOADING — skeleton, pulsating
  - Each unresolved element becomes a flat light-gray block with the SAME footprint and
    border radius as the real element. No text, no icons, no spinner.
  - The skeleton pulses continuously: a slow opacity/tone breath, roughly 1.5s ease-in-out,
    infinite alternate, subtle — around #ececec at rest easing to #f5f5f5 and back. All
    skeletons on screen share one animation so the page breathes together.
  - Secondary affordances below a block (pagination dots, "VIEW ALL") also skeleton into
    small gray bars rather than disappearing — see the attached loading screenshot of the
    Articles carousel for the exact treatment.

ERROR — inline, recoverable, scoped to the failed region
  - The failed region keeps its exact footprint and becomes a flat light-gray rounded
    container (#ececec, same radius as the real card).
  - Centered vertically inside it, in this order:
      1. A slashed-wifi glyph, gray, ~40px
      2. "Couldn't load <thing>" — DM Sans ~15px, muted gray (#7a7a7a). The <thing> is
         specific to the region: articles, shows, episodes, prayers.
      3. "Try again" — DM Sans ~15px bold, accent blue (#3b6fa0), tappable. Behavior is
         whatever I answered in question 4.
  - Affordances that don't depend on the failed data stay visible and real — in the Articles
    example, "VIEW ALL" remains while the pagination dots are gone, because there's nothing
    to page through.
  - Errors are per-region. If two named rows both fail, both show their own error container.
    Never a full-screen error page.

Reference screenshots are attached: the Articles carousel loaded, in its skeleton state, and
in its error state. Match those three exactly — they're the treatment we've already
validated, and everything else should be built off them.

=== BUILD IT AS A PATTERN, NOT A ONE-OFF ===

Factor the two treatments into small reusable helpers in the same file — something like
<Skeleton w h r /> and <LoadFailed label="articles" onRetry />. Then wire them into only the
regions I named. Future rows should be able to opt in with one line.

When you're done, confirm which regions you wired up, and re-list the data-backed regions on
that page you left alone, so I can decide whether they're next.
