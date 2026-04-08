#!/bin/bash
# handoff-detector.sh — Auto-register handoff files when Claude writes them
#
# PostToolUse hook that watches for Write/Edit calls targeting handoff files.
# When detected, automatically writes the path to /tmp/claude-chain-handoff-${SESSION_ID}
# so chain-spawn.sh picks it up at session end.
#
# This removes Claude from the critical path — it just needs to write the
# handoff file (which it does reliably). The hook handles registration.
#
# Part of the AI Employee Kit: https://github.com/strategicthings/ai-employee-kit

# Read hook input from stdin (JSON with tool_name, tool_input)
INPUT=$(cat)

# Extract tool name — fast-path exit for non-file tools
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4)
case "$TOOL_NAME" in
    Write|Edit) ;;
    *) exit 0 ;;
esac

# Extract file_path from tool_input
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)
[ -z "$FILE_PATH" ] && exit 0

# Check if this is a handoff file
IS_HANDOFF=false
case "$FILE_PATH" in
    */docs/governance/handoffs/*.md)  IS_HANDOFF=true ;;
    */HANDOFF.md)                     IS_HANDOFF=true ;;
    *handoff*.md)                     IS_HANDOFF=true ;;
esac

$IS_HANDOFF || exit 0

# Don't register sidecar/claim files
case "$FILE_PATH" in
    *.claimed-by-chain-*) exit 0 ;;
esac

# Resolve session ID
source "$(dirname "$0")/resolve-session-id.sh"

HANDOFF_FILE="/tmp/claude-chain-handoff-${SESSION_ID}"
MARKER_FILE="/tmp/claude-handoff-written-${SESSION_ID}"

# Register the handoff (only if the file actually exists on disk)
if [ -f "$FILE_PATH" ]; then
    echo "$FILE_PATH" > "$HANDOFF_FILE"
    touch "$MARKER_FILE"
fi
