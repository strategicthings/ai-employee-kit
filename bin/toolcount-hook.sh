#!/bin/bash
# toolcount-hook.sh — Global PostToolUse hook for autonomous handoff chain
#
# Increments a per-session tool call counter and injects context warnings
# when the session approaches degradation thresholds.
#
# Part of the AI Employee Kit: https://github.com/strategicthings/ai-employee-kit
#
# Thresholds (fire ONCE at exact count, not every call after):
#   33 — Yellow warning: "begin wrapping up"
#   37 — Red warning: "write handoff NOW"
#   40+ — Every 5 calls: overdue reminder
#
# Design: Previous approach fired on every call >= 30, injecting ~500 chars each
# time. This consumed the context budget needed for handoff writing + chain spawn,
# causing chains to die without spawning successors.

# Derive session ID from shared resolver
source "$(dirname "$0")/resolve-session-id.sh"

COUNTER_FILE="/tmp/claude-session-toolcount-${SESSION_ID}"

# Read current count (default 0 if missing/corrupt)
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")
COUNT=$((COUNT + 1))

# Write updated count
echo "$COUNT" > "$COUNTER_FILE"

# Threshold logic — fire ONLY at exact thresholds to preserve context budget
if [ "$COUNT" -eq 37 ]; then
    echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"HANDOFF NOW (37/38 calls). Stop new work. Finish in-flight ops, then write handoff to docs/governance/handoffs/ (auto-registered). Write metadata: echo 'SKILL=X\\nTIER=N\\nTOOLS=Y' > /tmp/claude-chain-meta-${SESSION_ID}. Subagents: ignore.\"}}"
elif [ "$COUNT" -eq 33 ]; then
    echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"WRAP UP (33/38 calls). Finish current task, prepare for handoff at 37. Subagents: ignore.\"}}"
elif [ "$COUNT" -ge 40 ] && [ $(( (COUNT - 40) % 5 )) -eq 0 ]; then
    echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"OVERDUE (${COUNT} calls). Write handoff NOW to docs/governance/handoffs/.\"}}"
fi
