#!/usr/bin/env bash
#
# sync-skills.sh — Sync skills from claude-skills repo into life-os plugin
#
# Usage: ./scripts/sync-skills.sh [path-to-claude-skills]
#
# Default source: ../claude-skills (sibling directory)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE="${1:-$PLUGIN_DIR/../claude-skills}"

# Resolve to absolute path
SOURCE="$(cd "$SOURCE" 2>/dev/null && pwd)" || {
  echo "Error: claude-skills directory not found at: ${1:-$PLUGIN_DIR/../claude-skills}"
  echo "Usage: $0 [path-to-claude-skills]"
  exit 1
}

SKILLS=(
  "planning-review-system"
  "time-energy-manager"
)

echo "Source: $SOURCE"
echo "Target: $PLUGIN_DIR/skills/"
echo ""

for skill in "${SKILLS[@]}"; do
  src="$SOURCE/$skill"
  dst="$PLUGIN_DIR/skills/$skill"

  if [ ! -d "$src" ]; then
    echo "Warning: $src not found, skipping"
    continue
  fi

  # Sync SKILL.md
  if [ -f "$src/SKILL.md" ]; then
    cp "$src/SKILL.md" "$dst/SKILL.md"
    echo "  $skill/SKILL.md"
  fi

  # Sync references/
  if [ -d "$src/references" ]; then
    mkdir -p "$dst/references"
    cp "$src/references/"* "$dst/references/" 2>/dev/null || true
    echo "  $skill/references/*"
  fi
done

echo ""
echo "Sync complete. Changes:"
cd "$PLUGIN_DIR" && git diff --stat skills/ 2>/dev/null || echo "(not a git repo or no changes)"
