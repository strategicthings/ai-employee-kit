#!/bin/bash
# resolve-session-id.sh — Single source of truth for SESSION_ID derivation
#
# Source this file from any hook script:
#   source "$(dirname "$0")/resolve-session-id.sh"
#
# After sourcing, $SESSION_ID is set.
#
# Priority:
#   1. $TMUX_PANE (authoritative, stripped of %)
#   2. PID-keyed file from session start (covers iTerm2 -CC mode)
#   3. "unknown-$$" (unique per process, never collides with pane IDs)
#
# NEVER use `tmux display-message` — it returns the focused pane, not the caller.
# NEVER use a global /tmp/claude-session-id — last-writer-wins causes cross-contamination.

# shellcheck disable=SC2034
if [ -n "$TMUX_PANE" ]; then
    SESSION_ID="${TMUX_PANE#%}"
elif [ -f "/tmp/claude-session-id-ppid-$PPID" ]; then
    SESSION_ID=$(cat "/tmp/claude-session-id-ppid-$PPID")
else
    SESSION_ID="unknown-$$"
fi
