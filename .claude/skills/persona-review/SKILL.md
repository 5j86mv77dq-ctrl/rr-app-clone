---
name: persona-review
description: Run every audience persona over one slice in a single pass — where each one hesitates, what they tap that isn't tappable, what they expect that isn't there — then score the run against five findings from real interviews and report. Read-and-report only; never edits the slice. Use when Peter says "persona check", "persona review", "run personas", "run a persona check", "run personas against <slice>", or "run a persona review on <slice>".
---

# Persona review

**Takes one argument: the slice path.** If Peter names a feature instead of a file, resolve
it yourself from the `MANIFEST` in `dashboard.html` — match on `page` or `pretty`. Only if it
is genuinely ambiguous, ask which slice. That is the one question this skill may ask;
everything else takes the conservative option, proceeds, and gets noted at the end.

Do not invoke open-session, close-session, or any other ritual skill from inside this one.

## The five constraints — these are the skill

A persona run without them produces plausible filler: fluent, confident, and true of any
app. That reads as insight and is worse than no run at all, because someone acts on it.
**If you are editing this skill, do not soften or drop any of the five.** They are the
reason it works.

1. **Read the slice in full.** Not a skim, not a sample.
2. **Build the screen inventory from the state machine**, including unreachable states.
3. **One pass over all personas.** Never separate runs.
4. **If you could say it about any mobile app, delete it.**
5. **Every persona must disagree with another at least once.**

Plus the calibration score, which is what stops the run marking its own homework: five
findings, honestly counted, and a LOW CONFIDENCE stamp below 2 of 5.

## 1. Inputs

1. **Read the slice file in full.** Do not skim and do not sample it.
2. **Read every persona file in `personas/*.md`, in full.** Currently the audience personas
   v2, built from the 2024 Listener Survey (n=11,361):

   - `personas/margaret-daily-faithful.md` — Margaret, The Daily Faithful (~50% of app users)
   - `personas/michael-committed-catholic.md` — Michael, The Committed Catholic (~35%)
   - `personas/katie-seeking-catholic.md` — Katie, The Seeking Catholic (~15%)

   Read whatever is in the directory, not this list — it is a pointer, not the roster, and
   personas get added. **If you cannot find any persona files, stop and say so. Do not
   invent personas.**
3. **Read `Roadmap/audience-personas-v2.md`** for the shared context these three sit in: the
   data snapshot, the summary matrix, the revenue lifecycle, and the design principles. The
   Margaret / Michael / Katie tests at the end of that doc are the sharpest version of what
   each persona wants, and a finding that contradicts one of them needs a reason.
4. Get the slice's base commit:

```bash
git log -1 --format="%h %cs" -- <slice path>
```

## 2. Screen inventory

From the slice's `view` state machine, list every reachable view plus every meaningful state
of each one: empty, loading, error, signed-out, signed-in, first-run. Include states a user
could only reach by an unlikely path, and states only reachable by toggling a demo control.
**Reading the code is the point** — do not limit yourself to what a click-through would find.

Write the inventory down before you start reviewing. If a view exists in the state machine
but nothing routes to it, that is a finding: log it under "Screens no persona would use."

## 3. The review — one pass, all personas

Walk the screen inventory in natural navigation order. At each screen, answer for **every**
persona, three fields only:

- a) Where does this persona hesitate, and why?
- b) What would they tap that is not tappable?
- c) What do they expect to be there that is not?

Plus one binary per screen per persona: would they use this screen at all, yes or no.

Two hard constraints:

- **If you could say a finding about any mobile app, delete it.** Every finding must be
  specific to this design and to that persona's stated motivations. Generic usability advice
  is worse than nothing because it reads as insight.
- **Every persona must disagree with at least one other persona somewhere.** You are running
  them in one pass, which tempts you to average them into a single generic user. Do not. If
  two personas never conflict, you have not run them as distinct people — go back.

## 4. Converge

Group findings by screen. Count **distinct personas** per finding.

| Personas | Becomes |
|---|---|
| 3 or more | a Finding |
| exactly 2 | a Watch item |
| 1 | appendix only |

Rank Findings by persona count, then by how early in the flow the screen sits.

## 5. Calibrate

Score yourself against these five findings from real user interviews with Brett and Katie:

1. Missing search / Explore
2. Three competing ways to listen live on the home screen
3. Menu items visually undifferentiated
4. Reminder times not localized
5. Shows and Podcasts buried

Count how many you independently surfaced in steps 3–4 **before** reading this list — do not
retrofit. If fewer than 2, stamp the report **LOW CONFIDENCE** and state plainly that the
personas are too thin to trust and should be fixed before anyone acts on the findings.

Be honest here. A run that admits it found nothing is useful. A run that pads its score is
worse than no run.

## 6. Output

Produce the report in exactly this structure. No extra sections, no emojis.

```
# Persona Run - <Slice Name>
Run date / Slice / Base commit / Personas used (n) / Run by
## Recommendations     (1-10, ranked; table: #, Change, Why and who for, From)
## Confidence          (X of 5, with the five as a checklist)
## Findings - three or more personas    (table: #, Screen, Finding, Personas, Count)
## Watch - two personas                 (table: Screen, Finding, Personas)
## Disagreements                        (table: Screen, Persona A wants, Persona B wants)
## Screens no persona would use
## Next real interview - top three questions
## Appendix - raw per-persona notes
```

**Recommendations leads the report** because it is what Peter acts on; everything under it is
the evidence. Between one and ten of them, ranked by how much of the persona base each
unblocks and then by how early in the flow it sits. Each one names the finding it comes
from — a recommendation that cannot cite a finding is the generic filler constraint 4 exists
to delete, so cut it rather than pad the list to ten.

## 7. Save, then push

Write the report to `Roadmap/persona-runs/<slice-name>-<YYYY-MM-DD>.md`. Create the folder if
it does not exist.

Then, if a ClickUp MCP is connected, create a page in document `12f0m3-62731` with
`parent_page_id` `12f0m3-79651`, named `Persona Run - <Slice Name> - <YYYY-MM-DD>`,
containing the report. If ClickUp is not connected, say so and print the report so Peter can
paste it.

Commit and push: `git commit -m "Persona run: <slice name> <date>"`, then
`git push origin main`. Stage the report deliberately rather than `git add -A` — see the
integrity step in the close-session skill for why.

## Do not

**Do not modify the slice or any other repo file.** This is a read-and-report job. The only
files it creates are the report and, if needed, its folder.
