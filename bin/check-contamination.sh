#!/bin/bash
# check-contamination.sh -- scan for denylist matches in working tree or piped input.
#
# Usage:
#   bash bin/check-contamination.sh                 # scans working tree
#   git log --all -p | bash bin/check-contamination.sh --stdin
#
# Exits:
#   0 = clean, no denylist match
#   1 = one or more matches (contamination)
#   2 = denylist file missing or unreadable
#
# Reads patterns from bin/denylist.txt (one pattern per line, blank and # lines skipped).
# Patterns are passed to grep -E (extended regex).
# Working-tree scan excludes: .git/, bin/denylist.txt, .github/.denylist-maintainer, node_modules/.

set -u

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
DENYLIST="${REPO_ROOT}/bin/denylist.txt"

if [ ! -r "$DENYLIST" ]; then
  echo "ERROR: denylist file missing or unreadable: $DENYLIST" >&2
  exit 2
fi

# Load active patterns (strip blanks + comments).
PATTERNS=$(grep -vE '^[[:space:]]*(#|$)' "$DENYLIST" || true)
if [ -z "$PATTERNS" ]; then
  echo "WARN: denylist has no active patterns; nothing to scan against" >&2
  exit 0
fi

# Join patterns with | for single-pass grep -E.
PATTERN_UNION=$(printf '%s\n' "$PATTERNS" | paste -sd '|' -)

HIT=0

if [ "${1:-}" = "--stdin" ]; then
  # Pipe mode: read stdin, match against PATTERN_UNION.
  if grep -nE "$PATTERN_UNION" -; then
    HIT=1
  fi
else
  # Working-tree mode: recursive grep with exclusions.
  cd "$REPO_ROOT" || exit 2
  if grep -rnE "$PATTERN_UNION" . \
      --exclude-dir=.git \
      --exclude-dir=node_modules \
      --exclude=denylist.txt \
      --exclude=.denylist-maintainer; then
    HIT=1
  fi
fi

if [ "$HIT" -eq 1 ]; then
  echo "" >&2
  echo "CONTAMINATION: one or more denylist patterns matched. Fix before commit." >&2
  exit 1
fi

exit 0
