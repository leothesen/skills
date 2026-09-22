#!/bin/bash
# Moves a skill from ~/.claude/skills into this repo and links it back, so the
# next sync publishes it and every later edit follows automatically.
#
# The repo is PUBLIC: read the skill for anything private before running this.
#
# Usage: scripts/publish.sh <skill-name>

set -euo pipefail

name="${1:?usage: scripts/publish.sh <skill-name>}"
repo="$(cd "$(dirname "$0")/.." && pwd)"
src="$HOME/.claude/skills/$name"
dest="$repo/skills/$name"

if [ -L "$src" ]; then
  echo "$src is already a link to $(readlink "$src"), not moving it." >&2
  exit 1
fi
if [ ! -f "$src/SKILL.md" ]; then
  echo "No skill at $src (expected $src/SKILL.md)." >&2
  exit 1
fi
if [ -e "$dest" ]; then
  echo "$dest already exists." >&2
  exit 1
fi

mv "$src" "$dest"
ln -s "$dest" "$src"
echo "Moved $name into the repo; it goes public on the next sync (within 10 minutes)."
