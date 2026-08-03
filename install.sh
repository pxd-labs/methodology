#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/chrislee-cmd/pxd-playground.git"
INSTALL_DIR="${HOME}/pxd-playground"
COMMANDS_DIR="${HOME}/.claude/commands"

echo "▶ pxd-playground installer"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "  Updating existing clone at $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo "  Cloning to $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

mkdir -p "$COMMANDS_DIR"

for cmd in "$INSTALL_DIR"/commands/*.md; do
  name=$(basename "$cmd")
  ln -sf "$cmd" "$COMMANDS_DIR/$name"
  echo "  ✓ /$(basename "$name" .md) linked"
done

echo ""
echo "✓ Done. Open a new 'claude' session to use the commands."
