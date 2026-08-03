#!/usr/bin/env bash
set -euo pipefail

# --- Config -------------------------------------------------------------

METHODOLOGY_URL="https://github.com/pxd-labs/methodology.git"
METHODOLOGY_DIR="${HOME}/pxd-methodology"

COMMANDS_DIR="${HOME}/.claude/commands"

# --- Preflight ----------------------------------------------------------

echo "▶ pxd-labs installer"

for tool in git curl; do
  if ! command -v $tool >/dev/null; then
    echo ""
    echo "❌ '$tool' 이 필요합니다."
    exit 1
  fi
done

# --- Clone / update methodology -----------------------------------------

if [ -d "$METHODOLOGY_DIR/.git" ]; then
  echo "  Updating methodology at $METHODOLOGY_DIR"
  git -C "$METHODOLOGY_DIR" pull --ff-only
else
  echo "  Cloning methodology to $METHODOLOGY_DIR"
  git clone "$METHODOLOGY_URL" "$METHODOLOGY_DIR"
fi

# --- Symlink commands ---------------------------------------------------

mkdir -p "$COMMANDS_DIR"
for cmd in "$METHODOLOGY_DIR"/commands/*.md; do
  name=$(basename "$cmd")
  ln -sf "$cmd" "$COMMANDS_DIR/$name"
  echo "  ✓ /$(basename "$name" .md) linked"
done

# --- Local backup folder (optional, for /pxd offline fallback) ----------

mkdir -p "${HOME}/pxd-responses"

echo ""
echo "✓ Done. GitHub auth 필요 없음. 응답은 Vercel API 로 즉시 공유됩니다."
echo "  - 방법론: $METHODOLOGY_DIR"
echo "  - 로컬 백업 폴더: ${HOME}/pxd-responses"
echo "  - 실시간 공유 API: https://pxd-api.vercel.app/api/responses"
echo ""
echo "새 'claude' 세션에서 /pxd 또는 /pxd-lunch 실행하세요."
