#!/usr/bin/env bash
set -e

REPO_DIR="$(git rev-parse --show-toplevel)"
cd "$REPO_DIR"

# 1. Show status
STATUS=$(git status --short)
if [ -n "$STATUS" ]; then
  echo "Uncommitted changes:"
  echo "$STATUS"
  echo ""
  read -rp "Commit these changes before pushing? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    read -rp "Commit message: " msg
    git add -A
    git commit -m "$msg"
  else
    echo "Aborting. Commit or stash your changes first."
    exit 1
  fi
fi

# 2. Show what will be pushed
OUTGOING=$(git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline HEAD)
if [ -z "$OUTGOING" ]; then
  echo "Nothing to push — origin is already up to date."
  exit 0
fi

echo ""
echo "Commits to push to origin/main:"
echo "$OUTGOING"
echo ""

read -rp "Push to origin/main? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  git push origin main
  echo ""
  echo "Pushed."
else
  echo "Skipped push."
fi
