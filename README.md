# skills

Non-invasive skills for [Claude Code](https://claude.com/claude-code), and any other agent that reads
`SKILL.md`, that I use mostly when I'm too tired to read a response properly.

## Why these exist

Harnesses and models are changing too quickly for low-level skills to age well. So none of these try to
change the primitives that Claude Code, or any other harness, already gives you. They sit on top of it.

The problem they solve is the cognitive overload and fatigue that build up when you're running several
sessions for hours on end. The model's full response still matters, because it's the context a skill
needs to work from. So each skill is a translation layer: it takes a niche, technical response and turns
it into something a tired brain can take in.

## The skills

| Skill                                                             | What it does                                                                                                                                                                                                          |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`/dumb`](skills/dumb/SKILL.md)                                   | Catches you up on a session you've lost track of (where you are, what's being done, why, what's finished) in a few plain lines, then asks what it needs from you as a one-click choice.                                 |
| [`/explain-with-pictures`](skills/explain-with-pictures/SKILL.md) | Turns a wall of text into the clearest form to act on: a short summary, or an ASCII diagram if the content really is diagram-shaped. It can then build a fuller diagram for a deeper dive. |

## Install

```
npx skills add leothesen/skills
```

Or copy a skill's folder into `~/.claude/skills/` to use it in every project, or into `.claude/skills/`
inside a repo to use it there only.
