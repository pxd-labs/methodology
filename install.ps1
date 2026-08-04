# pxd-labs installer for Windows (PowerShell)
# Usage:  irm https://raw.githubusercontent.com/pxd-labs/methodology/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$METHODOLOGY_URL = "https://github.com/pxd-labs/methodology.git"
$METHODOLOGY_DIR = Join-Path $HOME "pxd-methodology"

$CLAUDE_DIR   = Join-Path $HOME ".claude"
$COMMANDS_DIR = Join-Path $CLAUDE_DIR "commands"
$AGENTS_DIR   = Join-Path $CLAUDE_DIR "agents"
$SKILLS_DIR   = Join-Path $CLAUDE_DIR "skills"

Write-Host "▶ pxd-labs installer (Windows)"

# --- Preflight ----------------------------------------------------------

foreach ($tool in @("git","curl")) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Host ""
        Write-Host "❌ '$tool' 이 필요합니다."
        Write-Host "   git 설치: https://git-scm.com/download/win"
        exit 1
    }
}

# --- Clone / update methodology -----------------------------------------

if (Test-Path (Join-Path $METHODOLOGY_DIR ".git")) {
    Write-Host "  Updating methodology at $METHODOLOGY_DIR"
    git -C $METHODOLOGY_DIR pull --ff-only | Out-Null
} else {
    Write-Host "  Cloning methodology to $METHODOLOGY_DIR"
    git clone $METHODOLOGY_URL $METHODOLOGY_DIR | Out-Null
}

# --- Helper: symlink (fallback to junction / copy) ----------------------

function New-Link {
    param(
        [string]$Source,   # existing file or directory
        [string]$Target,   # destination path
        [switch]$Directory
    )
    if (Test-Path $Target) { Remove-Item $Target -Force -Recurse -ErrorAction SilentlyContinue }
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force -ErrorAction Stop | Out-Null
        return "symlink"
    } catch {
        if ($Directory) {
            try {
                New-Item -ItemType Junction -Path $Target -Value $Source -Force -ErrorAction Stop | Out-Null
                return "junction"
            } catch {}
        }
        Copy-Item -Path $Source -Destination $Target -Force -Recurse
        return "copy"
    }
}

function Link-All {
    param([string]$Src, [string]$Dst, [switch]$Directory)
    if (-not (Test-Path $Src)) { return }
    if (-not (Test-Path $Dst)) { New-Item -ItemType Directory -Path $Dst -Force | Out-Null }

    if ($Directory) {
        $items = Get-ChildItem -Path $Src -Directory
    } else {
        $items = Get-ChildItem -Path $Src -Filter "*.md" -File
    }

    foreach ($item in $items) {
        if ($item.Name -eq "README.md") { continue }
        $target = Join-Path $Dst $item.Name
        $kind = New-Link -Source $item.FullName -Target $target -Directory:$Directory
        $prefix = Split-Path $Dst -Leaf
        Write-Host "  ✓ $prefix\$($item.Name) ($kind)"
    }
}

# --- Symlink harness elements -------------------------------------------

Link-All -Src (Join-Path $METHODOLOGY_DIR "commands") -Dst $COMMANDS_DIR
Link-All -Src (Join-Path $METHODOLOGY_DIR "agents")   -Dst $AGENTS_DIR
Link-All -Src (Join-Path $METHODOLOGY_DIR "skills")   -Dst $SKILLS_DIR -Directory

# --- Local backup folder ------------------------------------------------

$RESP_DIR = Join-Path $HOME "pxd-responses"
if (-not (Test-Path $RESP_DIR)) { New-Item -ItemType Directory -Path $RESP_DIR -Force | Out-Null }

# --- Done ---------------------------------------------------------------

Write-Host ""
Write-Host "✓ Done."
Write-Host "  - 방법론: $METHODOLOGY_DIR"
Write-Host "  - 로컬 백업: $RESP_DIR"
Write-Host ""
Write-Host "새 'claude' 세션에서 /pxd 또는 /pxd-lunch 실행하세요."
Write-Host ""
Write-Host "※ symlink 가 'copy' 로 대체됐다면 Developer Mode 활성화 권장:"
Write-Host "   Settings → Privacy & Security → For developers → Developer Mode 켜기"
Write-Host "   (활성화 후 install.ps1 재실행 → symlink 로 자동 갱신됨)"
