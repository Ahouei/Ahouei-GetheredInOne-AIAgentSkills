#!/usr/bin/env bash
# Install skills from this repo into a Claude Code skills directory.
#
#   scripts/install.sh                       # everything -> ~/.claude/skills
#   scripts/install.sh --project .           # everything -> ./.claude/skills
#   scripts/install.sh --core                # only the 45 curated (non-Composio) skills
#   scripts/install.sh frontend-design pdf   # only the named skills
#   scripts/install.sh --dry-run             # show what would be copied
#
# Existing skill folders are skipped unless --force is given.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO/skills"
DEST="$HOME/.claude/skills"
CORE=0 FORCE=0 DRY=0
NAMES=()

usage() { sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --global)  DEST="$HOME/.claude/skills" ;;
    --project) [ $# -ge 2 ] || usage 1; DEST="$(cd "$2" && pwd)/.claude/skills"; shift ;;
    --dest)    [ $# -ge 2 ] || usage 1; DEST="$2"; shift ;;
    --core)    CORE=1 ;;
    --force)   FORCE=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) usage 0 ;;
    --)        shift; NAMES+=("$@"); break ;;
    -*)        echo "unknown option: $1" >&2; usage 1 ;;
    *)         NAMES+=("$1") ;;
  esac
  shift
done

if [ ${#NAMES[@]} -eq 0 ]; then
  for d in "$SRC"/*/; do
    n="$(basename "$d")"
    if [ "$CORE" -eq 1 ]; then
      case "$n" in *-automation) continue ;; esac
    fi
    NAMES+=("$n")
  done
fi

# Skills that other skills read from (accesslint's methodology) must come along.
needs_shared=0
for n in "${NAMES[@]}"; do case "$n" in accessibility-*) needs_shared=1 ;; esac; done
if [ "$needs_shared" -eq 1 ]; then
  have=0; for n in "${NAMES[@]}"; do [ "$n" = shared ] && have=1; done
  [ "$have" -eq 1 ] || NAMES+=("shared")
fi

[ "$DRY" -eq 1 ] || mkdir -p "$DEST"
copied=0 skipped=0
for n in "${NAMES[@]}"; do
  if [ ! -d "$SRC/$n" ]; then echo "not found: $n" >&2; exit 1; fi
  if [ -e "$DEST/$n" ] && [ "$FORCE" -eq 0 ]; then skipped=$((skipped + 1)); continue; fi
  if [ "$DRY" -eq 1 ]; then echo "would install $n -> $DEST/"; else
    rm -rf -- "$DEST/$n"; cp -R -- "$SRC/$n" "$DEST/$n"
  fi
  copied=$((copied + 1))
done
echo "$([ "$DRY" -eq 1 ] && echo 'would install' || echo installed): $copied, skipped (already present): $skipped -> $DEST"
