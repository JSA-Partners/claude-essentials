#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DIRS=(agents commands skills)

for dir in "${DIRS[@]}"; do
  mkdir -p "$CLAUDE_DIR/$dir"

  # Remove broken symlinks (from deleted/renamed files)
  find "$CLAUDE_DIR/$dir" -maxdepth 1 -type l ! -exec test -e {} \; -delete

  # Link each item individually so user can add their own alongside
  for item in "$REPO_DIR/$dir"/*; do
    ln -sfn "$item" "$CLAUDE_DIR/$dir/$(basename "$item")"
  done
done

ln -sf "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json"

echo "Linked to $CLAUDE_DIR"
