#!/bin/bash
# session-start-gate.sh — Global SessionStart hook for AI Governance v4.0.0
#
# Fires at the start of every Claude Code session, regardless of working directory.
# Resets tool counter, checks for handoff files, and injects governance + critical rules.
#
# Deployed globally from ai-governance-standards v4.0.0.

# 1. Derive session ID from shared resolver
source "$(dirname "$0")/resolve-session-id.sh"
export SESSION_ID
# W.10 (P1): Shared jq extraction helpers with sentinel + error-log discipline
source "$(dirname "$0")/jq-extract.sh"
# Persist session ID keyed by Claude's PID so child hooks can recover it
# even if $TMUX_PANE is stripped (e.g., iTerm2 -CC mode).
echo "$SESSION_ID" > "/tmp/claude-session-id-ppid-$PPID"

# 1-cleanup-errlog. Cross-session error-log pruning.
# Error logs at /tmp/claude-hook-error-${SESSION_ID} are session-scoped, not
# pane-scoped, so this prune runs UNCONDITIONALLY (NOT TMUX-gated). Predicate:
# a session is "live" iff a /tmp/claude-session-id-ppid-$PID file keyed on a
# still-alive PID maps to that session id. The current session was just mapped
# above, so it is always live and its own error log is never pruned. Error logs
# whose suffix is not in the live-session set are deleted. Chosen over a blunt
# "prune everything except current SESSION_ID" predicate so that concurrent
# real Claude Code sessions running their own hooks do not nuke each other's
# error logs.
LIVE_SESSION_IDS=" ${SESSION_ID} "
for PPID_FILE in /tmp/claude-session-id-ppid-*; do
    [ -f "$PPID_FILE" ] || continue
    PPID_KEY="${PPID_FILE##*-}"
    case "$PPID_KEY" in *[!0-9]*) continue ;; esac
    if kill -0 "$PPID_KEY" 2>/dev/null; then
        PPID_SESSION=$(cat "$PPID_FILE" 2>/dev/null)
        if [ -n "$PPID_SESSION" ]; then
            LIVE_SESSION_IDS="${LIVE_SESSION_IDS}${PPID_SESSION} "
        fi
    fi
done
for STALE_ERRLOG in /tmp/claude-hook-error-*; do
    [ -f "$STALE_ERRLOG" ] || continue
    ERR_SUFFIX="${STALE_ERRLOG##*/claude-hook-error-}"
    case "$LIVE_SESSION_IDS" in
      *" ${ERR_SUFFIX} "*) continue ;;
    esac
    rm -f "$STALE_ERRLOG"
done

# Phase 2 (Commit A): session secret + UUID + session_id_at_creation generation.
# Parent plan §3.1 — creates the 3-line secret file under noclobber, mode 0600,
# used by every blocking hook to sign/verify content-signed gate artifacts.
# UNCONDITIONAL (NOT TMUX-gated): secrets are session-scoped, not pane-scoped.
SECRET_FILE="/tmp/claude-session-secret-${SESSION_ID}"
SECRET_MTIME_FILE="/tmp/claude-session-secret-mtime-${SESSION_ID}"
if [ ! -f "$SECRET_FILE" ]; then
    TMP_SECRET=$(mktemp -t claude-session-secret-XXXXXX 2>/dev/null || mktemp)
    HEX=$(openssl rand -hex 32 2>/dev/null || head -c 64 /dev/urandom | xxd -p -c 64)
    UUID=$(uuidgen 2>/dev/null | tr 'A-Z' 'a-z')
    if [ -n "$HEX" ] && [ -n "$UUID" ]; then
        printf '%s\n%s\n%s\n' "$HEX" "$UUID" "$SESSION_ID" > "$TMP_SECRET"
        chmod 0600 "$TMP_SECRET"
        # Atomic exclusive creation via set -C (noclobber). If a concurrent
        # session-start-gate already created the file, fail loudly by leaving
        # the tmp file in place and skipping the rename.
        if ( set -C; : > "$SECRET_FILE" ) 2>/dev/null; then
            mv -f "$TMP_SECRET" "$SECRET_FILE"
            chmod 0600 "$SECRET_FILE"
            # Record mtime baseline for §3.4 tripwire.
            stat -f %m "$SECRET_FILE" > "$SECRET_MTIME_FILE" 2>/dev/null || \
                stat -c %Y "$SECRET_FILE" > "$SECRET_MTIME_FILE" 2>/dev/null
            # Purge c4_link marker bound to any prior (rotated) secret. The marker
            # MAC is computed against the old secret's UUID; leaving it in place
            # would trip userpromptsubmit-guard's "forged marker" block on the next
            # approval phrase, even though the marker is merely stale.
            rm -f "/tmp/claude-c4-link-${SESSION_ID}.json"
        else
            rm -f "$TMP_SECRET"
            echo "HOOK INTEGRITY: session-start-gate concurrent secret creation detected" \
                >> "/tmp/claude-hook-error-${SESSION_ID}"
        fi
    else
        rm -f "$TMP_SECRET"
        echo "HOOK INTEGRITY: session-start-gate secret generation failed (openssl/uuidgen unavailable)" \
            >> "/tmp/claude-hook-error-${SESSION_ID}"
    fi
fi

# 1-cleanup. Prune stale temp files from dead tmux panes.
# Only runs inside tmux. Lists all live pane IDs, then removes temp files
# whose pane ID suffix doesn't match any live pane.
if [ -n "$TMUX" ]; then
    LIVE_PANES=$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | sed 's/^%//')
    # Clean ALL session-scoped temp files (including handoff, meta, newpane, fingerprint)
    for STALE in /tmp/claude-session-toolcount-* /tmp/claude-chain-dir-* /tmp/claude-chain-group-* /tmp/claude-chain-handoff-* /tmp/claude-chain-meta-* /tmp/claude-chain-newpane-* /tmp/claude-chain-skill-* /tmp/claude-handoff-written-* /tmp/claude-session-mutations-* /tmp/claude-session-tier-* /tmp/claude-session-escalation-fired-* /tmp/claude-chain-fingerprint-* /tmp/claude-session-plan-* /tmp/claude-session-planmode-* /tmp/claude-session-approved-* /tmp/claude-session-scope-* /tmp/claude-session-synth-* /tmp/claude-session-reads-* /tmp/claude-phase-* /tmp/claude-concurrency-class-* /tmp/claude-entitlement-checked-* /tmp/claude-keyword-filter-* /tmp/claude-concurrent-writes-* /tmp/claude-replay-guard-* /tmp/claude-auth-token-log-*; do
        [ -f "$STALE" ] || continue
        SUFFIX="${STALE##*-}"
        case "$SUFFIX" in *[!0-9]*) continue ;; esac
        if ! echo "$LIVE_PANES" | grep -qx "$SUFFIX"; then
            rm -f "$STALE"
        fi
    done
    # Clean c4_link markers from dead panes (uses .json suffix, so handled separately
    # from the digit-suffix sweep above). Marker lifecycle is bound to the session
    # secret; a dead pane's marker is definitively stale and its MAC is no longer
    # verifiable by any live session.
    for STALE in /tmp/claude-c4-link-*.json; do
        [ -f "$STALE" ] || continue
        BASENAME="${STALE##*/}"
        SUFFIX="${BASENAME#claude-c4-link-}"
        SUFFIX="${SUFFIX%.json}"
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
INHERITED_GROUP=false
if [ -f "$CHAIN_GROUP_FILE" ]; then
    CHAIN_GROUP=$(cat "$CHAIN_GROUP_FILE")
    INHERITED_GROUP=true
else
    # Fresh session (manual start). Generate a globally unique group ID.
    # Format: YYYYMMDD-HHMMSS-{paneID} — human-readable date + machine-unique pane.
    CHAIN_GROUP="$(date +%Y%m%d-%H%M%S)-${SESSION_ID}"
    echo "$CHAIN_GROUP" > "$CHAIN_GROUP_FILE"
fi

# Chain counter is now per-group, not global
CHAIN_FILE="/tmp/claude-chain-number-${CHAIN_GROUP}"

if [ ! -f "$CHAIN_FILE" ]; then
    echo "1" > "$CHAIN_FILE"
fi

CHAIN_NUM=$(cat "$CHAIN_FILE" 2>/dev/null || echo "1")

# Build the full chain fingerprint: globally unique, never collides across tabs.
# Format: G{YYYYMMDD-HHMMSS-paneID}-C{N} e.g. G20260408-143052-786-C1
CHAIN_FINGERPRINT="G${CHAIN_GROUP}-C${CHAIN_NUM}"
echo "$CHAIN_FINGERPRINT" > "/tmp/claude-chain-fingerprint-${SESSION_ID}"

# P36: Write initial phase marker (planning until explicit approval transition)
echo "planning" > "/tmp/claude-phase-${SESSION_ID}"

# Read inherited skill metadata from parent chain (written by chain-spawn.sh)
CHAIN_SKILL_FILE="/tmp/claude-chain-skill-${SESSION_ID}"
INHERITED_SKILLS=""
if [ -f "$CHAIN_SKILL_FILE" ]; then
    INHERITED_SKILLS=$(cat "$CHAIN_SKILL_FILE" 2>/dev/null)
fi

# Rename current tmux window with fingerprint so pruning is group-scoped
if [ -n "$TMUX" ]; then
    tmux rename-window "$CHAIN_FINGERPRINT"
fi

# P10: Deny-before-allow rule ordering check
# W.10 refactor + Batch 4 (D.1 + D.2): on malformed settings JSON, emit P10
# CHECK SKIPPED to stdout (via SETTINGS_WARN, which is interpolated into the
# HEREDOC at the bottom) AND stage a single consolidated HOOK INTEGRITY line
# via ERR_LOG_ACCUM (written once after both HOME and PROJECT blocks so the
# error log gets delta=1 even when both files are malformed). Never fail the
# hook. SETTINGS_WARN drives stdout; ERR_LOG_ACCUM drives the error log.
SETTINGS_WARN=""
ERR_LOG_ACCUM=""
if command -v jq >/dev/null 2>&1 && [ -f "$HOME/.claude/settings.json" ]; then
  # Validate JSON first; skip gracefully on malformed settings so fixtures
  # and real sessions both see a clean `exit 0` path.
  if ! jq empty "$HOME/.claude/settings.json" 2>/dev/null; then
    SETTINGS_WARN="P10 CHECK SKIPPED: ~/.claude/settings.json is not valid JSON. "
    ERR_LOG_ACCUM="P10 CHECK SKIPPED: ~/.claude/settings.json is not valid JSON"
  else
    ALLOW_COUNT=$(jq_extract_file "$HOME/.claude/settings.json" '.permissions.allow // [] | length' '0')
    DENY_COUNT=$(jq_extract_file "$HOME/.claude/settings.json" '.permissions.deny // [] | length' '0')
    if [ "$ALLOW_COUNT" -gt 0 ] 2>/dev/null && [ "$DENY_COUNT" -eq 0 ] 2>/dev/null; then
      SETTINGS_WARN="P10: Allow rules present (${ALLOW_COUNT}) without deny counterparts. "
    fi
  fi
fi

# P34: Project vs user settings.json override check
# W.10 refactor + Batch 4 (D.1 + D.2): same malformed-JSON handling, with
# PROJECT P10 CHECK SKIPPED stanza appended to ERR_LOG_ACCUM (pipe-separated
# if HOME already contributed) for the single consolidated write below.
if [ -f ".claude/settings.json" ] && [ -f "$HOME/.claude/settings.json" ]; then
  if ! jq empty ".claude/settings.json" 2>/dev/null; then
    SETTINGS_WARN="${SETTINGS_WARN}PROJECT P10 CHECK SKIPPED: .claude/settings.json is not valid JSON. "
    if [ -n "$ERR_LOG_ACCUM" ]; then
      ERR_LOG_ACCUM="${ERR_LOG_ACCUM} | PROJECT P10 CHECK SKIPPED: .claude/settings.json is not valid JSON"
    else
      ERR_LOG_ACCUM="PROJECT P10 CHECK SKIPPED: .claude/settings.json is not valid JSON"
    fi
  else
    PROJECT_ALLOWS=$(jq_extract_file ".claude/settings.json" '.permissions.allow // [] | .[]' '')
    if [ -n "$PROJECT_ALLOWS" ]; then
      SETTINGS_WARN="${SETTINGS_WARN}P34: Project-level settings.json has allow rules. Verify no global deny override conflict. "
    fi
  fi
fi

# Batch 4 D.2: consolidated single-line error-log write. At most one line
# is appended (delta=1) no matter how many of HOME/PROJECT were malformed.
# Content always begins with the base substring "P10 CHECK SKIPPED" so
# fixture-09/10 substring checks pass, and always contains "PROJECT P10
# CHECK SKIPPED" when the PROJECT block fired (fixture-11 substring check).
if [ -n "$ERR_LOG_ACCUM" ]; then
  printf 'HOOK INTEGRITY: %s %s\n' \
    "$(basename "$0")" \
    "$ERR_LOG_ACCUM" \
    >> "/tmp/claude-hook-error-${SESSION_ID}" 2>/dev/null || true
fi

# 2. Check for handoff files from previous sessions
HANDOFF_HINT=""
CWD=$(pwd)

# Check common handoff locations.
# Strategy: find the latest unclaimed handoff. If all are claimed, mechanically
# follow the chain forward (claimer -> claimer's handoff -> next claimer) until
# an unclaimed successor is found or the chain is broken. Stale handoff paths
# are NEVER injected into context — model compliance alone fails ~10%.
#
# Chain group scoping: inherited sessions only detect handoffs from their own
# chain group (via .written-by-G{group}-* sidecars). Fresh sessions do NOT
# auto-claim — they inform the user that unclaimed handoffs exist.
if [ -d "$CWD/docs/governance/handoffs" ]; then

    # Helper: check if a handoff belongs to our chain group via .written-by-* sidecar
    handoff_matches_group() {
        local candidate="$1"
        for wb in "${candidate}.written-by-"*; do
            [ -f "$wb" ] || continue
            # Extract group from sidecar name: .written-by-G{group}-C{N} -> {group}
            local writer
            writer=$(echo "$wb" | sed 's/.*written-by-//')
            local writer_group
            writer_group=$(echo "$writer" | sed 's/^G//' | sed 's/-C[0-9]*$//')
            if [ "$writer_group" = "$CHAIN_GROUP" ]; then
                return 0
            fi
        done
        return 1
    }

    if [ "$INHERITED_GROUP" = true ]; then
        # INHERITED SESSION: only detect handoffs from our chain group
        LATEST_UNCLAIMED=""
        LATEST_ANY=""
        LATEST_ANY_CLAIMED_BY=""
        # shellcheck disable=SC2045  # ls -t needed for time-sorted order
        for CANDIDATE in $(ls -t "$CWD/docs/governance/handoffs/"*.md 2>/dev/null); do
            case "$CANDIDATE" in *.claimed-by-*|*.written-by-*) continue ;; esac
            # Skip handoffs not from our chain group
            handoff_matches_group "$CANDIDATE" || continue
            if [ -z "$LATEST_ANY" ]; then
                LATEST_ANY="$CANDIDATE"
                CLAIM_SIDECAR=$(ls "${CANDIDATE}.claimed-by-"* 2>/dev/null | head -1)
                if [ -n "$CLAIM_SIDECAR" ]; then
                    LATEST_ANY_CLAIMED_BY=$(echo "$CLAIM_SIDECAR" | sed 's/.*claimed-by-//')
                fi
            fi
            if ! ls "${CANDIDATE}.claimed-by-"* 1>/dev/null 2>&1; then
                LATEST_UNCLAIMED="$CANDIDATE"
                break
            fi
        done

        if [ -n "$LATEST_UNCLAIMED" ]; then
            touch "${LATEST_UNCLAIMED}.claimed-by-${CHAIN_FINGERPRINT}"
            HANDOFF_HINT="I5 HANDOFF FOUND: Previous session handoff exists at $LATEST_UNCLAIMED (claimed by $CHAIN_FINGERPRINT). Read it before starting new work. "
            echo "inherited" > "/tmp/claude-session-tier-${SESSION_ID}"
        elif [ -n "$LATEST_ANY" ]; then
            # All same-group handoffs claimed. Follow the chain forward.
            CURRENT_CLAIMER="$LATEST_ANY_CLAIMED_BY"
            FOLLOW_HOPS=0
            MAX_FOLLOW_HOPS=20
            while [ "$FOLLOW_HOPS" -lt "$MAX_FOLLOW_HOPS" ]; do
                FOLLOW_HOPS=$((FOLLOW_HOPS + 1))
                SUCCESSOR=""
                # shellcheck disable=SC2045  # ls -t needed for time-sorted order
        for SUCC_CAND in $(ls -t "$CWD/docs/governance/handoffs/"*.md 2>/dev/null); do
                    case "$SUCC_CAND" in *.claimed-by-*|*.written-by-*) continue ;; esac
                    if [ -f "${SUCC_CAND}.written-by-${CURRENT_CLAIMER}" ]; then
                        SUCCESSOR="$SUCC_CAND"
                        break
                    fi
                done

                if [ -n "$SUCCESSOR" ] && [ "$SUCCESSOR" = "$LATEST_ANY" ]; then
                    HANDOFF_HINT="I5 HANDOFF CHAIN ENDED: $CURRENT_CLAIMER claimed and updated the latest handoff but wrote no new successor. Check MEMORY.md for context or ask the user for direction. "
                    break
                fi

                if [ -z "$SUCCESSOR" ]; then
                    HANDOFF_HINT="I5 HANDOFF CHAIN BROKEN: $CURRENT_CLAIMER claimed the previous handoff but wrote no successor. Do NOT search for or read old handoff files. Ask the user for direction before starting any work. "
                    break
                fi

                SUCC_CLAIM=$(ls "${SUCCESSOR}.claimed-by-"* 2>/dev/null | head -1)
                if [ -z "$SUCC_CLAIM" ]; then
                    touch "${SUCCESSOR}.claimed-by-${CHAIN_FINGERPRINT}"
                    HANDOFF_HINT="I5 HANDOFF FOUND: Previous session handoff exists at $SUCCESSOR (claimed by $CHAIN_FINGERPRINT). Read it before starting new work. "
                    echo "inherited" > "/tmp/claude-session-tier-${SESSION_ID}"
                    break
                else
                    CURRENT_CLAIMER=$(echo "$SUCC_CLAIM" | sed 's/.*claimed-by-//')
                fi
            done

            if [ "$FOLLOW_HOPS" -ge "$MAX_FOLLOW_HOPS" ]; then
                HANDOFF_HINT="I5 HANDOFF ERROR: Chain-following exceeded $MAX_FOLLOW_HOPS hops. Possible circular claims. Ask the user for direction. "
            fi
        fi
    else
        # FRESH SESSION: do NOT auto-claim. Inform if unclaimed handoffs exist.
        UNCLAIMED_COUNT=0
        # shellcheck disable=SC2045
        for CANDIDATE in $(ls -t "$CWD/docs/governance/handoffs/"*.md 2>/dev/null); do
            case "$CANDIDATE" in *.claimed-by-*|*.written-by-*) continue ;; esac
            if ! ls "${CANDIDATE}.claimed-by-"* 1>/dev/null 2>&1; then
                UNCLAIMED_COUNT=$((UNCLAIMED_COUNT + 1))
            fi
        done
        if [ "$UNCLAIMED_COUNT" -gt 0 ]; then
            HANDOFF_HINT="I5 INFO: ${UNCLAIMED_COUNT} unclaimed handoff(s) exist in docs/governance/handoffs/ from previous sessions. This is a fresh session — no auto-claim. Check MEMORY.md for context or ask the user which work stream to resume. "
        fi
    fi
fi

# Also check for handoff files in project root (with claim logic)
if [ -f "$CWD/HANDOFF.md" ] && ! ls "$CWD/HANDOFF.md.claimed-by-"* 1>/dev/null 2>&1; then
    touch "$CWD/HANDOFF.md.claimed-by-${CHAIN_FINGERPRINT}"
    HANDOFF_HINT="I5 HANDOFF FOUND: HANDOFF.md exists in project root (claimed by $CHAIN_FINGERPRINT). Read it before starting new work. "
fi

# P9: Concurrency classification reminder for inherited-tier sessions
CONCURRENCY_NOTE=""
if [ -f "/tmp/claude-session-tier-${SESSION_ID}" ]; then
  CONCURRENCY_NOTE=" For agent dispatch, classify each operation as safe (concurrent-ok) or exclusive (serial-only) before dispatching. Write classification to /tmp/claude-concurrency-class-${SESSION_ID}."
fi

# P40 plan-continuation: check if this chain inherits an approved plan
PLAN_CONT_FILE="/tmp/claude-plan-continuation-${SESSION_ID}"
STEP5_TEXT="STEP 5 - CLASSIFY BEFORE EXECUTING: Before taking any action, state the tier level. For Tier 1+ work, complete the synthesis-back gate (P40): restate the task in your own words and wait for confirmation before proceeding. Production system changes (HubSpot, Slack, Notion, Webflow, CRM) are ALWAYS Tier 3. Write plan, get approval, then execute. No shortcuts.${CONCURRENCY_NOTE}"
if [ -f "$PLAN_CONT_FILE" ]; then
  PLAN_PATH=$(cat "$PLAN_CONT_FILE" 2>/dev/null)
  if [ -n "$PLAN_PATH" ] && [ -f "$PLAN_PATH" ]; then
    STEP5_TEXT="STEP 5 - PLAN-CONTINUATION MODE (P40): This chain inherits an approved plan at ${PLAN_PATH}. Read the plan. Synthesize your understanding of the plan, current progress, and next steps for your own comprehension. Then proceed with execution without waiting for user confirmation. Stop and ask the user only if: the plan file is missing, you detect drift from the approved plan (GP-1 Q1), or you encounter 2+ blocking errors.${CONCURRENCY_NOTE}"
  fi
fi

# Build STEP 3 text: override for inherited skills, default otherwise
if [ -n "$INHERITED_SKILLS" ]; then
    STEP3_TEXT="STEP 3 - INHERITED SKILLS (BLOCKING): This chain inherits skills: ${INHERITED_SKILLS}. You MUST call the Skill tool for EACH of these skills before ANY other action. Do not read GOVERNANCE-CORE.md for routing — your skills are pre-assigned. This is not optional."
else
    STEP3_TEXT="STEP 3 - READ GOVERNANCE-CORE.md (if present): If present, read it. Classify your task using the Task Router (Tier 0-3) and Skill Routing Table (Marketing/App/Data/Ops). Activate the matching archetype skill for Tier 1+ work."
fi

# 3. Build the governance gate message
cat <<HOOKEOF
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"GOVERNANCE GATE ACTIVE. Follow this sequence exactly:

STEP 1 - ACKNOWLEDGE GOVERNANCE: Your FIRST visible response to the user MUST begin with: 'Governance active. Safety rules R1-R7 loaded. Invariants I1-I9 loaded. Awaiting task.' This is mandatory in every session, every project. Do not skip it.

STEP 2 - READ CLAUDE.md (if present): If a CLAUDE.md exists in the working directory, read it for project-specific context, tier level, and archetype. If it contains a governance gate, include the tier and archetype in your acknowledgment. If no CLAUDE.md exists, the governance rules from this hook still apply.

${STEP3_TEXT}

STEP 4 - CHECK FOR HANDOFFS (I5): ${HANDOFF_HINT}If no handoff file is found, check MEMORY.md for project context from prior sessions. Never start Tier 1+ work without context from the last session.

${STEP5_TEXT}

CRITICAL BLOCK RULES (apply to ALL sessions, ALL projects):
- NEVER delete any database file (.db, .sqlite, data directories). Zero exceptions. Use additive migrations only.
- ALL generated files go to [specified output directory]. No Desktop, no other locations.
- No execution without approved plan. Agent dispatch IS execution (I1). Plan -> present -> approve -> execute.
- Agents producing 50+ lines must write to file, return short summary only. No massive inline output.
- Anti-AI writing patterns are BLOCK-level (M11). Scan all content for: false reframes, performative reveals, anaphora, filler, hedging, symmetrical lists, adjective stacking, scaffolding transitions, thesis-summary, meta-narrating.
- Report outcomes faithfully (I9). No manufactured green results. No hedging confirmed results.
${SETTINGS_WARN}
PROJECT-SPECIFIC BLOCK RULES (edit these for your project, or remove if not applicable):
- Example: NEVER use em dashes in any content. Use periods, commas, or restructure.
- Example: NEVER deploy generated code to production without manual review.
- Replace these examples with rules specific to your organization."}}
HOOKEOF

# W.10 defensive exit: the HEREDOC above is the last functional output. Make
# the script's exit code deterministic (0) regardless of cat's propagation.
exit 0
