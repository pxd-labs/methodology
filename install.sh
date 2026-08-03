#!/usr/bin/env bash
set -euo pipefail

# --- Config -------------------------------------------------------------

METHODOLOGY_URL="https://github.com/pxd-labs/methodology.git"
METHODOLOGY_DIR="${HOME}/pxd-methodology"

RESPONSES_URL="https://github.com/pxd-labs/responses.git"
RESPONSES_DIR="${HOME}/pxd-responses"

COMMANDS_DIR="${HOME}/.claude/commands"

# --- Preflight ----------------------------------------------------------

echo "▶ pxd-labs installer"

# gh CLI presence
if ! command -v gh >/dev/null; then
  echo ""
  echo "❌ 'gh' CLI 가 필요합니다."
  echo "   설치: brew install gh   (또는 https://cli.github.com)"
  exit 1
fi

# gh auth
if ! gh auth status >/dev/null 2>&1; then
  echo ""
  echo "⚠ GitHub 로그인이 필요합니다."
  echo "   아래 명령을 실행하고, 브라우저 인증을 완료한 후 install.sh 를 다시 실행하세요:"
  echo ""
  echo "     gh auth login"
  echo ""
  echo "   ※ /pxd 로 응답을 push 하려면 pxd-labs 조직에 write 권한이 있어야 합니다."
  echo "   (초대장을 받았다면 https://github.com/orgs/pxd-labs/invitation 에서 수락하세요)"
  exit 1
fi

GH_USER=$(gh api /user -q .login)
echo "  ✓ GitHub 로그인: $GH_USER"

# --- Clone / update -----------------------------------------------------

# 1) Methodology
if [ -d "$METHODOLOGY_DIR/.git" ]; then
  echo "  Updating methodology at $METHODOLOGY_DIR"
  git -C "$METHODOLOGY_DIR" pull --ff-only
else
  echo "  Cloning methodology to $METHODOLOGY_DIR"
  git clone "$METHODOLOGY_URL" "$METHODOLOGY_DIR"
fi

# 2) Responses — clone via gh so gh's credential helper handles auth
if [ -d "$RESPONSES_DIR/.git" ]; then
  echo "  Updating responses at $RESPONSES_DIR"
  git -C "$RESPONSES_DIR" pull --ff-only 2>/dev/null || true
else
  echo "  Cloning responses to $RESPONSES_DIR"
  gh repo clone pxd-labs/responses "$RESPONSES_DIR"
fi

# gh already sets up credential helper globally, so plain git push works
# for anyone with write access to pxd-labs/responses.

# --- Symlink commands ---------------------------------------------------

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
