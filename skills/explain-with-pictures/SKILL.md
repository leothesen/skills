---
name: explain-with-pictures
description: Turn a wall of text into the clearest form to act on — a structured summary, an ASCII diagram, or a published mermaid artifact — by first diagnosing whether the content is actually graph-shaped. Use when the user says "explain with pictures", "diagram this", "visualize this", "I can't parse this", "too much text", "TL;DR", "make this make sense", or points at a long spec, PR description, CI log, review thread, or doc and asks what it means.
---

# Explain with pictures

The goal is **understanding fast enough to act**, not producing a picture. A diagram of
something that wasn't graph-shaped is worse than three bullets, because it looks
authoritative while having invented its own structure.

## Step 1 — Lead with the answer

Before any diagram or summary, one line: **the single thing that matters most.** The
decision to make, the thing that's broken, the reason it works. If the source buries it,
that burial is the actual problem you're solving.

## Step 2 — Triage the shape

Ask what the content *is*. Draw only if it's genuinely one of these:

| Shape | Tell |
|---|---|
| Flow / pipeline | Things move between stages, output of one feeds the next |
| State machine | A thing is in one state at a time and transitions |
| Dependency / tree | A needs B; hierarchy or containment |
| Timeline / sequence | Ordered events, or messages between actors |

**Do not draw** — use prose structure instead — when it's: a list of unrelated items, an
argument or rationale, config values, a comparison across attributes (use a table),
quantitative data (use a chart), or one decision with supporting reasons.

Most walls of text are *not* graph-shaped. Expect to summarise more often than you draw.

## Step 3 — Answer in the terminal first

**Always start in the terminal**, with no round-trip and nothing to click:

- Graph-shaped → **ASCII diagram** (~350 tokens)
- Not graph-shaped → **structured summary** (~150 tokens), shape at the bottom of this file

This is the answer, not a teaser. It has to stand alone — if the user reads only this,
they should be able to act.

## Step 4 — Always offer the deeper dive

After every terminal answer, close with exactly this:

> Would you like me to create a mermaid diagram and add it to an artifact for you to dive
> deeper?

Ask every time. Don't pre-judge whether it's worth it — that's the user's call, and the
cost of asking is one line. If the content wasn't graph-shaped, drop "mermaid diagram" and
offer the deeper-dive artifact on its own.

## Step 5 — If they say yes, go deeper

The artifact is **not a re-render of the ASCII**. It's the level of detail the terminal
answer deliberately compressed out. Publish a **markdown file with a `mermaid` fence**
(~190 tokens for the diagram) and add back:

- The specifics the ASCII dropped — payloads, error codes, config, exact file paths
- Why each step exists, not just that it exists
- Failure modes per stage, and what each one looks like when it happens
- The branches and edge cases the terminal version flattened
- Links/pointers to the source material

Hand-written HTML (~1790 tokens, 5× the ASCII) only when mermaid genuinely can't express
it: spatial layout, annotated UI, dashboards, anything positional. See
[REFERENCE.md](REFERENCE.md) for mermaid recipes and where mermaid falls down.

## Rules

- **Never invent structure.** If the source is vague about whether A causes B, say
  "unclear from the source" — do not draw a confident arrow. Fabricated edges are this
  skill's main failure mode.
- **Keep the specifics.** Names, numbers, error codes, and file paths survive the
  compression. They're usually the actionable part.
- **Flag what you dropped.** If you cut a third of the source, say what tier it was
  (background, caveats, alternatives considered) so the user can ask for it back.
- **One screen.** If the diagram doesn't fit in a terminal screen, it's two diagrams or
  it's the wrong form.

## Structured summary shape

When not drawing, this is the fallback:

```
<the one thing that matters>

- <3-5 bullets, each an action or a fact that changes a decision>

Watch out: <the trap, if there is one>
```
