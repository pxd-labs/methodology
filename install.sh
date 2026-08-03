#!/usr/bin/env bash
set -euo pipefail

METHODOLOGY_URL="https://github.com/chrislee-cmd/pxd-playground.git"
METHODOLOGY_DIR="${HOME}/pxd-playground"

RESPONSES_URL="https://github.com/chrislee-cmd/pxd-responses.git"
RESPONSES_DIR="${HOME}/pxd-onboarding-responses"

COMMANDS_DIR="${HOME}/.claude/commands"

echo "▶ pxd-playground installer"

# 1) Methodology (public) — clone or update
if [ -d "$METHODOLOGY_DIR/.git" ]; then
  echo "  Updating methodology at $METHODOLOGY_DIR"
  git -C "$METHODOLOGY_DIR" pull --ff-only
else
  echo "  Cloning methodology to $METHODOLOGY_DIR"
  git clone "$METHODOLOGY_URL" "$METHODOLOGY_DIR"
fi

# 2) Responses (public, demo) — clone or update
if [ -d "$RESPONSES_DIR/.git" ]; then
  echo "  Updating responses at $RESPONSES_DIR"
  git -C "$RESPONSES_DIR" pull --ff-only
else
  echo "  Cloning responses to $RESPONSES_DIR"
  git clone "$RESPONSES_URL" "$RESPONSES_DIR"
fi

# 3) Symlink all commands into ~/.claude/commands/
mkdir -p "$COMMANDS_DIR"
for cmd in "$METHODOLOGY_DIR"/commands/*.md; do
  name=$(basename "$cmd")
  ln -sf "$cmd" "$COMMANDS_DIR/$name"
  echo "  ✓ /$(basename "$name" .md) linked"
done

echo ""
echo "✓ Done."
echo "  - 방법론: $METHODOLOGY_DIR"
echo "  - 응답저장: $RESPONSES_DIR (public, 시연용)"
echo ""
echo "새 'claude' 세션에서 /pxd 또는 /pxd-lunch 를 실행하세요."
