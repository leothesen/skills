---
name: dumb
description: Re-orients the user in a session they have lost track of — where we are, what we're doing, why, what's done — in as few plain words as possible, then asks what's needed from them as a selectable question. Use when the user invokes /dumb, or says "where are we", "catch me up", "what are we doing", "I'm lost", "remind me", or comes back to a session after switching away.
---

# Dumb

The user runs many projects and sessions at once. They just switched into this one and
lost the thread. Give them the whole picture in the time it takes to glance at it, then
let them answer with one click.

**Source:** this conversation. Don't read files or run commands to build it. Exception:
if the context was compacted and no longer says where things stand, run one
`git status -sb` and nothing else.

**No preamble, no sign-off, and no other work until they answer.**

## The summary

A markdown bullet list, one bullet per line. Drop any line that would be empty.

```
- Where: <project> · <branch or PR, if any>
- Doing: <the task as an outcome, not a mechanism>
- Why: <the reason it matters to the user>
- Done: <finished and verified>
- Left: <what remains>
```

**Bold for skimming.** In each line, bold the 1–4 words that carry its meaning, so that
reading only the bold gives the gist: the project, the outcome, the status, the next
step. Never bold a whole line, the labels, or filler words. If everything is bold,
nothing stands out.

**Sketch.** Right below the bullets, an ASCII picture that explains the problem and the
options visually, so the user understands them without reading the long text they skipped.
In a code block so it keeps its spacing.

1. **The problem:** draw the real thing — the tables and their links, the services and
   the calls between them, the steps of a flow, the screen layout — and mark where it
   breaks or what is missing (`✗`, `?`, `← here`).
2. **The options:** one small picture per option, showing how that option changes the
   drawing, labelled with the same names as the picker.

Draw the system, not the decision: a fork of option names that only repeats the picker
adds nothing. Up to 12 lines, 70 characters or fewer per line. For a trivial or purely
procedural choice (commit or not, which to do first), leave it out.

```
Problem: deleting a user breaks their orders

  users ──< orders        delete user 42  →  3 orders point at nothing ✗

Soft delete   users(+deleted_at) ──< orders    orders keep their owner
Cascade       users ──< orders   both deleted  order history lost
Null owner    users     orders(user = null)    orders kept, anonymous
```

## Asking

Print the summary as text, then call `AskUserQuestion` in the same turn with nothing in
between. Keep the summary short so it stays on screen above the picker.

The summary must be printed text, not part of the picker: the picker shows its whole
question in bold and prints `**` as literal asterisks, so the key words can't stand out.
Write the summary as a markdown bullet list (`- Where: …`), one bullet per line, so each
line stays on its own. Not a code block, because bold doesn't render inside one.

- `question`: only the decision, as a plain question. No summary, no `**`.
- `header`: 12 characters or fewer, e.g. `Rounding`.
- `options`: 2–4. `label` is the choice in 5 words or fewer; `description` is what
  happens if they pick it. Recommended first, with ` (Recommended)` ending its label.
  Don't add an "Other" option — the picker adds one.
- `preview`: on every option, the detail behind that choice. It shows in a side panel
  when the option is highlighted. Different for each option, 3 lines, labels padded:

  ```
  Next:    <what happens first if they pick this>
  Result:  <what they end up with>
  Cost:    <time, risk, or what they give up>
  ```

- `multiSelect`: false.

When they pick, carry on with that choice as if they had typed it.

**Nothing needed from the user:** no picker. Print the summary as text and end it with
`Next:   <what happens next, and when they'll hear back>`.

**Picker unavailable or refused:** print the summary as text, then
`**Needs from you:** <question>`, the options as a numbered list with the recommended one
first, and `Reply with a number.`

## Rules

- Plain words, written for someone tired who hasn't seen the code today. No file paths,
  function names, flags or error codes unless the decision hinges on one.
- Each line 15 words or fewer. Summary plus question 90 words or fewer.
- One task, one question. If the session moved through several tasks, describe the
  current one. Add a `Parked:` line only for unfinished work the user may have forgotten.
- `Done` means verified. Built but untested is "built, not tested". Never round up, and
  say "not sure" rather than guess.
- Options are real choices, each with its consequence — not "yes / no / maybe".
- Nothing started yet: one line — `Nothing started yet. What do you want to work on?`

## Example

Printed text:

~~~~
- Where: **recipe-app** · PR #12
- Doing: Letting people **scale a recipe** to any number of servings
- Why: People cook for 2 or 6, but **every recipe is written for 4**
- Done: Scaling **works and is tested**; open for review
- Left: **Rounding awkward amounts** like "1.33 eggs"

```
Problem: 4 servings → 3 servings, everything × 0.75

  1¾ cups flour  →  1.3125 cups ✗      2 eggs  →  1.5 eggs ✗

Kitchen fractions   1⅓ cups flour     2 eggs        like a cookbook
Exact decimals      1.31 cups flour   1.5 eggs      precise, awkward
Ship as-is          1.3125 cups       1.5 eggs      fix later
```
~~~~

Then the picker:

```
question: How should awkward amounts be rounded?
header:   Rounding
options:
  Kitchen fractions (Recommended) — "1⅓ cups", eggs rounded to whole
    preview: |
      Next:    Round amounts to ¼, ⅓, ½; count items like eggs whole
      Result:  Recipes read like a cookbook at any serving size
      Cost:    About an hour; amounts are slightly off exact
  Exact decimals                  — accurate, harder to read
    preview: |
      Next:    Show two decimal places everywhere
      Result:  Precise, but "1.33 eggs" stays on screen
      Cost:    Ten minutes; people have to do the rounding themselves
  Ship as-is                      — fix rounding in a follow-up
    preview: |
      Next:    Merge the PR today; open a ticket for rounding
      Result:  Scaling is live now, with odd numbers for a while
      Cost:    Nothing now; rounding still needs doing later
```
