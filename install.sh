#!/usr/bin/env bash
set -euo pipefail

# --- Config -------------------------------------------------------------

METHODOLOGY_URL="https://github.com/pxd-labs/methodology.git"
METHODOLOGY_DIR="${HOME}/pxd-methodology"

CLAUDE_DIR="${HOME}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"
AGENTS_DIR="${CLAUDE_DIR}/agents"
SKILLS_DIR="${CLAUDE_DIR}/skills"

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

# --- Helper: symlink files or dirs into a target ------------------------

link_all() {
  # $1 = source dir (may be missing)
  # $2 = target dir
  # $3 = glob (e.g. '*.md' or '*/' )
  local src="$1"; local dst="$2"; local pattern="$3"
  [ -d "$src" ] || return 0
  mkdir -p "$dst"
  # shellcheck disable=SC2086
  for item in "$src"/$pattern; do
    [ -e "$item" ] || continue   # nothing matched
    name=$(basename "$item")
    # README 는 문서용이므로 심링크 대상에서 제외
    [ "$name" = "README.md" ] && continue
    ln -sfn "$item" "$dst/$name"
    echo "  ✓ $(basename "$dst")/$name linked"
  done
}

# --- Symlink harness elements -------------------------------------------

link_all "$METHODOLOGY_DIR/commands" "$COMMANDS_DIR" "*.md"
link_all "$METHODOLOGY_DIR/agents"   "$AGENTS_DIR"   "*.md"
link_all "$METHODOLOGY_DIR/skills"   "$SKILLS_DIR"   "*/"

# --- Local backup folder (for /pxd offline fallback) --------------------

mkdir -p "${HOME}/pxd-responses"

echo ""
echo "✓ Done."
echo "  - 방법론: $METHODOLOGY_DIR"
echo "  - 슬래시 커맨드: $COMMANDS_DIR/"
echo "  - 서브에이전트: $AGENTS_DIR/"
echo "  - 스킬: $SKILLS_DIR/"
echo "  - 로컬 백업: ${HOME}/pxd-responses/"
echo ""
echo "새 'claude' 세션에서 /pxd · /pxd-lunch · Agent 툴에서 pxd-* 에이전트 사용 가능."
