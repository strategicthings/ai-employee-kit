#!/bin/bash
# session-start-gate.sh — Global SessionStart hook for AI Governance v3.7.0
#
# Fires at the start of every Claude Code session, regardless of working directory.
# Resets tool counter, checks for handoff files, and injects governance + critical rules.
#
# Deployed globally from ai-governance-standards v3.7.0.

# 1. Derive session ID from shared resolver
source "$(dirname "$0")/resolve-session-id.sh"
export SESSION_ID
# Persist session ID keyed by Claude's PID so child hooks can recover it
# even if $TMUX_PANE is stripped (e.g., iTerm2 -CC mode).
echo "$SESSION_ID" > "/tmp/claude-session-id-ppid-$PPID"

# 1-cleanup. Prune stale temp files from dead tmux panes.
# Only runs inside tmux. Lists all live pane IDs, then removes temp files
# whose pane ID suffix doesn't match any live pane.
if [ -n "$TMUX" ]; then
    LIVE_PANES=$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | sed 's/^%//')
    # Clean ALL session-scoped temp files (including handoff, meta, newpane)
    for STALE in /tmp/claude-session-toolcount-* /tmp/claude-chain-dir-* /tmp/claude-chain-group-* /tmp/claude-chain-handoff-* /tmp/claude-chain-meta-* /tmp/claude-chain-newpane-* /tmp/claude-handoff-written-* /tmp/claude-session-mutations-* /tmp/claude-session-tier-* /tmp/claude-session-escalation-fired-*; do
        [ -f "$STALE" ] || continue
        SUFFIX="${STALE##*-}"
        case "$SUFFIX" in *[!0-9]*) continue ;; esac
        if ! echo "$LIVE_PANES" | grep -qx "$SUFFIX"; then
            rm -f "$STALE"
        fi
    done
    # Clean PID-keyed session ID files where the PID is dead
    for STALE in /tmp/claude-session-id-ppid-*; do
        [ -f "$STALE" ] || continue
        SUFFIX="${STALE##*-}"
        case "$SUFFIX" in *[!0-9]*) continue ;; esac
        if ! kill -0 "$SUFFIX" 2>/dev/null; then
            rm -f "$STALE"
        fi
    done
    # Clean per-group chain number files where no pane references the group
    for CHAIN_NUM_FILE in /tmp/claude-chain-number-*; do
        [ -f "$CHAIN_NUM_FILE" ] || continue
        GROUP_SUFFIX="${CHAIN_NUM_FILE#/tmp/claude-chain-number-}"
        # Check if any live group file references this group
        GROUP_ALIVE=false
        for GF in /tmp/claude-chain-group-*; do
            [ -f "$GF" ] || continue
            if [ "$(cat "$GF" 2>/dev/null)" = "$GROUP_SUFFIX" ]; then
                GROUP_ALIVE=true
                break
            fi
        done
        if ! $GROUP_ALIVE; then
            rm -f "$CHAIN_NUM_FILE"
        fi
    done
fi

# 1a. Reset session-scoped tool counter and state
echo '0' > "/tmp/claude-session-toolcount-${SESSION_ID}"
rm -f "/tmp/claude-handoff-written-${SESSION_ID}"
rm -f "/tmp/claude-chain-handoff-${SESSION_ID}"
rm -f "/tmp/claude-chain-meta-${SESSION_ID}"

# 1b. Chain tracking — scoped per chain group (not global)
CHAIN_DIR_FILE="/tmp/claude-chain-dir-${SESSION_ID}"
CHAIN_GROUP_FILE="/tmp/claude-chain-group-${SESSION_ID}"

# Save working directory for chain-spawn.sh
echo "$PWD" > "$CHAIN_DIR_FILE"

# Determine chain group: inherit from parent or create new one.
# chain-spawn.sh writes the group ID for spawned windows.
if [ -f "$CHAIN_GROUP_FILE" ]; then
    CHAIN_GROUP=$(cat "$CHAIN_GROUP_FILE")
else
    # Fresh session (manual start). Generate a unique group ID from pane + timestamp.
    CHAIN_GROUP="${SESSION_ID}-$(date +%s | tail -c 6)"
    echo "$CHAIN_GROUP" > "$CHAIN_GROUP_FILE"
fi

# Chain counter is now per-group, not global
CHAIN_FILE="/tmp/claude-chain-number-${CHAIN_GROUP}"

if [ ! -f "$CHAIN_FILE" ]; then
    echo "1" > "$CHAIN_FILE"
fi

CHAIN_NUM=$(cat "$CHAIN_FILE" 2>/dev/null || echo "1")

# Rename current tmux window with group prefix so pruning is group-scoped
if [ -n "$TMUX" ]; then
    tmux rename-window "G${CHAIN_GROUP}-C${CHAIN_NUM}"
fi

# 2. Check for handoff files from previous sessions
HANDOFF_HINT=""
CWD=$(pwd)

# Check common handoff locations.
# Strategy: find the latest unclaimed handoff. If all are claimed, mechanically
# follow the chain forward (claimer -> claimer's handoff -> next claimer) until
# an unclaimed successor is found or the chain is broken. Stale handoff paths
# are NEVER injected into context — model compliance alone fails ~10%.
if [ -d "$CWD/docs/governance/handoffs" ]; then
    LATEST_UNCLAIMED=""
    LATEST_ANY=""
    LATEST_ANY_CLAIMED_BY=""
    for CANDIDATE in $(ls -t "$CWD/docs/governance/handoffs/"*.md 2>/dev/null); do
        # Skip files that are themselves sidecar markers
        case "$CANDIDATE" in *.claimed-by-chain-*) continue ;; esac
        # Track the most recent handoff regardless of claim status
        if [ -z "$LATEST_ANY" ]; then
            LATEST_ANY="$CANDIDATE"
            CLAIM_SIDECAR=$(ls "${CANDIDATE}.claimed-by-chain-"* 2>/dev/null | head -1)
            if [ -n "$CLAIM_SIDECAR" ]; then
                LATEST_ANY_CLAIMED_BY=$(echo "$CLAIM_SIDECAR" | sed 's/.*claimed-by-chain-//')
            fi
        fi
        # Check if unclaimed
        if ! ls "${CANDIDATE}.claimed-by-chain-"* 1>/dev/null 2>&1; then
            LATEST_UNCLAIMED="$CANDIDATE"
            break
        fi
    done

    if [ -n "$LATEST_UNCLAIMED" ]; then
        # Unclaimed handoff found -- claim it
        touch "${LATEST_UNCLAIMED}.claimed-by-chain-${CHAIN_NUM}"
        HANDOFF_HINT="I5 HANDOFF FOUND: Previous session handoff exists at $LATEST_UNCLAIMED (claimed by Chain $CHAIN_NUM). Read it before starting new work. "
        echo "inherited" > "/tmp/claude-session-tier-${SESSION_ID}"
    elif [ -n "$LATEST_ANY" ]; then
        # All handoffs claimed. Mechanically follow the chain forward.
        # NEVER inject the stale handoff path — model compliance fails ~10% of the time.
        CURRENT_CLAIMER="$LATEST_ANY_CLAIMED_BY"
        FOLLOW_HOPS=0
        MAX_FOLLOW_HOPS=20
        while [ "$FOLLOW_HOPS" -lt "$MAX_FOLLOW_HOPS" ]; do
            FOLLOW_HOPS=$((FOLLOW_HOPS + 1))
            # Scan for a handoff written by the claiming chain
            # Regex: "chain${N}" followed by non-digit prevents chain4 matching chain40
            SUCCESSOR=""
            for SUCC_CAND in $(ls -t "$CWD/docs/governance/handoffs/"*.md 2>/dev/null); do
                case "$SUCC_CAND" in *.claimed-by-chain-*) continue ;; esac
                SUCC_BASE=$(basename "$SUCC_CAND")
                if echo "$SUCC_BASE" | grep -qE "chain${CURRENT_CLAIMER}([^0-9]|\.md$)"; then
                    SUCCESSOR="$SUCC_CAND"
                    break
                fi
            done

            if [ -z "$SUCCESSOR" ]; then
                # Broken chain — claimer wrote no successor. No path exposed.
                HANDOFF_HINT="I5 HANDOFF CHAIN BROKEN: Chain $CURRENT_CLAIMER claimed the previous handoff but wrote no successor. Do NOT search for or read old handoff files. Ask the user for direction before starting any work. "
                break
            fi

            # Check if the successor is also claimed
            SUCC_CLAIM=$(ls "${SUCCESSOR}.claimed-by-chain-"* 2>/dev/null | head -1)
            if [ -z "$SUCC_CLAIM" ]; then
                # Unclaimed successor found — claim it and inject
                touch "${SUCCESSOR}.claimed-by-chain-${CHAIN_NUM}"
                HANDOFF_HINT="I5 HANDOFF FOUND: Previous session handoff exists at $SUCCESSOR (claimed by Chain $CHAIN_NUM). Read it before starting new work. "
                echo "inherited" > "/tmp/claude-session-tier-${SESSION_ID}"
                break
            else
                # Successor also claimed, follow the chain forward
                CURRENT_CLAIMER=$(echo "$SUCC_CLAIM" | sed 's/.*claimed-by-chain-//')
            fi
        done

        if [ "$FOLLOW_HOPS" -ge "$MAX_FOLLOW_HOPS" ]; then
            HANDOFF_HINT="I5 HANDOFF ERROR: Chain-following exceeded $MAX_FOLLOW_HOPS hops. Possible circular claims. Ask the user for direction. "
        fi
    fi
fi

# Also check for handoff files in project root (with claim logic)
if [ -f "$CWD/HANDOFF.md" ] && ! ls "$CWD/HANDOFF.md.claimed-by-chain-"* 1>/dev/null 2>&1; then
    touch "$CWD/HANDOFF.md.claimed-by-chain-${CHAIN_NUM}"
    HANDOFF_HINT="I5 HANDOFF FOUND: HANDOFF.md exists in project root (claimed by Chain $CHAIN_NUM). Read it before starting new work. "
fi

# 3. Build the governance gate message
cat <<HOOKEOF
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"GOVERNANCE GATE ACTIVE. Follow this sequence exactly:

STEP 1 - READ CLAUDE.md: If a CLAUDE.md exists in the working directory, read it NOW. If it contains a governance gate, produce the acknowledgment (Governance active. Tier [X]. Archetype [Y]. Safety rules R1-R7 loaded. Invariants I1-I9 loaded.).

STEP 2 - READ GOVERNANCE-CORE.md: If present, read it. Classify your task using the Task Router (Tier 0-3) and Skill Routing Table (Marketing/App/Data/Ops). Activate the matching archetype skill for Tier 1+ work.

STEP 3 - CHECK FOR HANDOFFS (I5): ${HANDOFF_HINT}If no handoff file is found, check MEMORY.md for project context from prior sessions. Never start Tier 1+ work without context from the last session.

STEP 4 - CLASSIFY BEFORE EXECUTING: Before taking any action, state the tier level. For Tier 1+ work, complete the synthesis-back gate (P40): restate the task in your own words and wait for confirmation before proceeding. Production system changes (HubSpot, Slack, Notion, Webflow, CRM) are ALWAYS Tier 3. Write plan, get approval, then execute. No shortcuts.

CRITICAL BLOCK RULES (apply to ALL sessions, ALL projects):
- NEVER delete any database file (.db, .sqlite, data directories). Zero exceptions. Use additive migrations only.
- ALL generated files go to [specified output directory]. No Desktop, no other locations.
- No execution without approved plan. Agent dispatch IS execution (I1). Plan -> present -> approve -> execute.
- Agents producing 50+ lines must write to file, return short summary only. No massive inline output.
- Anti-AI writing patterns are BLOCK-level (M11). Scan all content for: false reframes, performative reveals, anaphora, filler, hedging, symmetrical lists, adjective stacking, scaffolding transitions, thesis-summary, meta-narrating.
- Report outcomes faithfully (I9). No manufactured green results. No hedging confirmed results.

PROJECT-SPECIFIC BLOCK RULES (edit these for your project, or remove if not applicable):
- NEVER use em dashes in any content. Use periods, commas, or restructure.
- Demo CTA URL is landing.tratta.io/book-a-demo-tratta-2025 (with UTMs). NOT tratta.io/request-demo or /demo.
- Contact page is tratta.io/contact-us, NOT tratta.io/contact.
- NEVER deploy JSON-LD schema via Webflow Scripts API. Generate locally, Josh deploys manually.
- NEVER DNC any HubSpot company with Tratta-specific properties populated (tratta_created_at, revenue, portal, products, etc.)."}}
HOOKEOF
