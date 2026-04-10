#!/usr/bin/env bash
set -e

UPSTREAM_URL="https://github.com/NormalNvim/NormalNvim.git"
REPO_DIR="$(git rev-parse --show-toplevel)"
cd "$REPO_DIR"

# 1. Add upstream if not present
if ! git remote get-url upstream &>/dev/null; then
  echo "Adding upstream: $UPSTREAM_URL"
  git remote add upstream "$UPSTREAM_URL"
else
  echo "Upstream already set: $(git remote get-url upstream)"
fi

# 2. Fetch
echo ""
echo "Fetching upstream..."
git fetch upstream

# 3. Show incoming changes
INCOMING=$(git log --oneline HEAD..upstream/main)
if [ -z "$INCOMING" ]; then
  echo ""
  echo "Already up to date with upstream/main."
  exit 0
fi

echo ""
echo "Incoming commits from upstream/main:"
echo "$INCOMING"
echo ""

# 4. Prompt rebase
read -rp "Rebase onto upstream/main now? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  git rebase upstream/main
  echo ""
  echo "Rebase done. Test your config, then run scripts/update-push.sh."
else
  echo ""
  echo "Skipped rebase. Run this script again or manually: git rebase upstream/main"
fi
