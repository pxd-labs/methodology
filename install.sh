#!/usr/bin/env bash
set -euo pipefail

# --- Config -------------------------------------------------------------

METHODOLOGY_URL="https://github.com/pxd-labs/methodology.git"
METHODOLOGY_DIR="${HOME}/pxd-methodology"

RESPONSES_URL="https://github.com/pxd-labs/responses.git"
RESPONSES_DIR="${HOME}/pxd-responses"

# Public repo, public token (by design for demo). Fine-grained PAT scoped
# to pxd-labs org / All repositories / Contents: Read and Write only.
# If abused → rotate at github.com/settings/tokens and re-push install.sh.
RESPONSES_PUSH_TOKEN="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"

COMMANDS_DIR="${HOME}/.claude/commands"

# --- Install ------------------------------------------------------------

echo "▶ pxd-labs installer"

# 1) Methodology — clone or update
if [ -d "$METHODOLOGY_DIR/.git" ]; then
  echo "  Updating methodology at $METHODOLOGY_DIR"
  git -C "$METHODOLOGY_DIR" pull --ff-only
else
  echo "  Cloning methodology to $METHODOLOGY_DIR"
  git clone "$METHODOLOGY_URL" "$METHODOLOGY_DIR"
fi

# 2) Responses — clone or update
if [ -d "$RESPONSES_DIR/.git" ]; then
  echo "  Updating responses at $RESPONSES_DIR"
  git -C "$RESPONSES_DIR" pull --ff-only 2>/dev/null || true
else
  echo "  Cloning responses to $RESPONSES_DIR"
  git clone "$RESPONSES_URL" "$RESPONSES_DIR"
fi

# 2b) Always (re-)embed token in origin URL — this is what enables push
git -C "$RESPONSES_DIR" remote set-url origin \
  "https://x-access-token:${RESPONSES_PUSH_TOKEN}@github.com/pxd-labs/responses.git"

# 3) Symlink every command into ~/.claude/commands/
mkdir -p "$COMMANDS_DIR"
for cmd in "$METHODOLOGY_DIR"/commands/*.md; do
  name=$(basename "$cmd")
  ln -sf "$cmd" "$COMMANDS_DIR/$name"
  echo "  ✓ /$(basename "$name" .md) linked"
done

echo ""
echo "✓ Done."
echo "  - 방법론: $METHODOLOGY_DIR"
echo "  - 응답저장: $RESPONSES_DIR"
echo ""
echo "새 'claude' 세션에서 /pxd 또는 /pxd-lunch 실행하세요."
