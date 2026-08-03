#!/usr/bin/env bash
set -euo pipefail

METHODOLOGY_URL="https://github.com/chrislee-cmd/pxd-playground.git"
METHODOLOGY_DIR="${HOME}/pxd-playground"

RESPONSES_REPO="chrislee-cmd/pxd-responses"
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

# 2) Responses (private) — clone with gh CLI (requires auth) or fall back to git https
if [ -d "$RESPONSES_DIR/.git" ]; then
  echo "  Updating responses at $RESPONSES_DIR"
  git -C "$RESPONSES_DIR" pull --ff-only
else
  echo "  Cloning private responses repo to $RESPONSES_DIR"
  if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
    gh repo clone "$RESPONSES_REPO" "$RESPONSES_DIR"
  else
    echo "  ⚠ gh CLI 로그인이 없어 git https 로 시도합니다 (자격증명 프롬프트가 뜰 수 있음)."
    git clone "https://github.com/${RESPONSES_REPO}.git" "$RESPONSES_DIR"
  fi
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
echo "  - 방법론(공유): $METHODOLOGY_DIR"
echo "  - 응답저장(개인정보): $RESPONSES_DIR  ← 절대 public 으로 바꾸지 마세요"
echo ""
echo "새 'claude' 세션을 열면 /pxd 커맨드가 뜹니다."
