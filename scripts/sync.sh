#!/bin/bash
# Keeps this repo and GitHub in step. Run every 10 minutes by a launchd agent
# (~/Library/LaunchAgents/com.leothesen.skills-sync.plist); safe to run by hand.
#
# Each skill in ~/.claude/skills is a symlink into skills/ here, so editing a
# skill edits this working tree. This commits any such edit, pulls anything
# changed on GitHub, and pushes.
#
# A failure raises a macOS notification rather than only logging, because a
# sync that has quietly stopped looks exactly like one with nothing to do.
# Log: ~/Library/Logs/skills-sync.log

set -uo pipefail
export PATH="/usr/bin:/bin:/opt/homebrew/bin:/usr/local/bin"

repo="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo" || exit 1

fail() {
  echo "$(date '+%F %T') sync failed: $1" >&2
  osascript -e "display notification \"$1\" with title \"Skills sync failed\"" >/dev/null 2>&1
  exit 1
}

if [ -n "$(git status --porcelain)" ]; then
  git add -A || fail "could not stage changes"
  # Name the commit after the skills that changed, e.g. "Update dumb, README.md".
  changed="$(git diff --cached --name-only | awk -F/ '{print ($1 == "skills" ? $2 : $0)}' | sort -u | paste -sd, - | sed 's/,/, /g')"
  git commit -q -m "Update ${changed}" || fail "could not commit changes"
fi

if ! git pull -q --rebase; then
  git rebase --abort 2>/dev/null
  fail "could not pull from GitHub (conflict?) - run scripts/sync.sh by hand"
fi

if [ -n "$(git log '@{u}..' 2>/dev/null)" ]; then
  git push -q || fail "could not push to GitHub"
  echo "$(date '+%F %T') pushed: $(git log -1 --format=%s)"
fi
