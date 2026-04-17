#!/bin/bash
# verify-project-root.sh -- v5.1.0 Deliverable B helper (counselor punch-list 1, 2).
#
# Sources cleanly into pretool-plan-guard.sh and is also runnable as:
#   bash bin/verify-project-root.sh <plan_file>
# When invoked directly, exits 0 on release/grandfather, 2 on fail-closed.
#
# Decision tree:
#   stamp present + match (after realpath)    -> release
#   stamp present + mismatch                  -> fail-closed (block)
#   stamp absent                              -> grandfather-with-warn (release)
#   PROJECT_ROOT unset AND no git_root        -> fail-closed
#
# Honors symlinks via realpath. Macro path may contain spaces.

# When sourced from pretool-plan-guard.sh, the host script provides log() and
# block(). When invoked standalone, fall back to stderr-write + exit 2.
if ! command -v log >/dev/null 2>&1; then
  log() { echo "$(date '+%H:%M:%S') [verify-project-root] $*" >&2; }
fi
if ! command -v block >/dev/null 2>&1; then
  block() { echo "BLOCK: $1" >&2; exit 2; }
fi

verify_project_root_binding() {
  local plan_path="$1"
  [ -n "$plan_path" ] && [ -f "$plan_path" ] || return 0

  local stamped_root
  stamped_root=$(grep -E '^[[:space:]]*project_root:' "$plan_path" 2>/dev/null \
    | head -1 | sed -E 's/^[[:space:]]*project_root:[[:space:]]*//' | tr -d '"' | tr -d "'")

  if [ -z "$stamped_root" ]; then
    log "PROJECT-ROOT GRANDFATHER: plan $plan_path has no project_root stamp -- allowing (legacy plan)"
    return 0
  fi

  local current_root="${PROJECT_ROOT:-}"
  if [ -z "$current_root" ]; then
    current_root=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  fi
  if [ -z "$current_root" ]; then
    log "PROJECT-ROOT BLOCK: PROJECT_ROOT unset and git_root unresolvable; plan stamp=$stamped_root"
    block "PROJECT-ROOT MISMATCH: plan stamped for project_root=$stamped_root but current session has no resolvable project root (set PROJECT_ROOT or run from inside the target git worktree)"
  fi

  local stamped_real current_real
  stamped_real=$(realpath -- "$stamped_root" 2>/dev/null || echo "$stamped_root")
  current_real=$(realpath -- "$current_root" 2>/dev/null || echo "$current_root")

  if [ "$stamped_real" = "$current_real" ]; then
    log "PROJECT-ROOT MATCH: plan stamped=$stamped_real, current=$current_real"
    return 0
  fi

  log "PROJECT-ROOT BLOCK: plan stamped=$stamped_real, current=$current_real (mismatch)"
  block "PROJECT-ROOT MISMATCH: plan $plan_path is stamped for project_root=$stamped_real but this session is operating in $current_real. Cross-project plan reuse is fail-closed. Restart in the correct project or re-stamp the plan."
}

# Standalone-mode entrypoint.
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  verify_project_root_binding "$1"
  exit 0
fi
