# Compliance Scorecard

> **Referenced from:** GOVERNANCE-CORE.md, tier-3/COMPLETION-RUBRIC.md
> **Return to:** GOVERNANCE-CORE.md

Measures governance process adherence per session. 13 checks. Each scores 0 or 1.

The Completion Rubric (tier-3/COMPLETION-RUBRIC.md) measures output quality. This scorecard measures whether the process was followed. Together they answer: "Did we follow the rules?" and "Is the result good?"

---

## The 13 Checks

| ID | Check | Pass Condition | How to Verify |
|----|-------|----------------|---------------|
| C1 | Task classified | First substantive response contains "Tier [0-3]" | Search session output for tier classification |
| C2 | Archetype identified | First substantive response identifies the project archetype (App/Data/Marketing/Ops/Hybrid) | Search session output for archetype statement |
| C3 | Plan stated before execution | A plan exists before the first file edit or deliverable | Confirm no edits occurred before a plan was presented |
| C4 | User approved plan | "Approved," "Go ahead," "Proceed," or equivalent appears before first edit. Plan-continuation chains inherit the original approval; C4 passes if the referenced plan file exists. | Search for approval signal or verify plan-continuation marker + plan file |
| C5 | No unauthorized changes | All file changes match the approved plan scope | Compare git diff (or output) against approved plan items |
| C6 | Sync dependencies maintained | When a file was changed, its known dependents were also checked/updated | Review changed files against sync matrix or manual check |
| C7 | Verification performed | Verification statement appears before output is marked complete | Search for verification evidence in session output |
| C8 | Session handoff produced | A handoff note exists at session end (for Tier 1+ multi-session work) | Check for handoff note with: done, remaining, decisions, next step |
| C9 | Change log updated with timestamp | Change log has an entry with format YYYY-MM-DD HH:MM | Check change log for timestamped entry matching session date |
| C10 | Governance pulse completed | GP-1 (3 pulse questions) was run before claiming completion | Search for pulse check answers in session output. GP-1 also serves as post-compaction governance verification per I8. |
| C11 | Post-mortem produced (if audit-driven) | If work originated from an audit, a post-mortem was produced referencing both audit and plan | Check for post-mortem MD file with Resolution Matrix |
| C12 | Agent output redirected (P38) | Every dispatched agent expected to produce >50 lines wrote results to a file and returned a summary only | Review agent dispatch prompts for file path instructions; check that no large inline results were returned |
| C13 | Handoff format compliant | Session handoff uses canonical template (tier-2/SESSION-HANDOFF-TEMPLATE.md) with Tools Required column, Modified Artifacts section, and system state snapshot | Compare handoff against template; verify Tools Required column is populated for each priority |

---

## Scoring

**Score: X/13** (C11 only applies to audit-driven work; C12 only applies to sessions with agent dispatch; C13 only applies to sessions that produce a handoff. Score out of applicable checks.)

| Tier | Target Score | Interpretation |
|------|-------------|----------------|
| Tier 0 | N/A | Scorecard not required for casual tasks |
| Tier 1 | 7+ | C1, C3, C4, C5, C7 are the most critical |
| Tier 2 | 9+ | All checks expected. C8 required for multi-session work. |
| Tier 3 | 10/10 | Full compliance required. Any miss requires a written explanation. |

---

## Scoring Guide

**Automatic pass (no action needed):**
- C1 passes if CLAUDE.md has the Governance Gate and Claude's first response includes the acknowledgment.
- C2 passes if CLAUDE.md has an Archetype field filled in.

**Requires session discipline:**
- C3, C4: Plan-before-execute. Structural enforcement via Acknowledgment Gate helps but does not guarantee.
- C5, C6: Sync compliance. Partially automatable via sync matrix scripts (tier-3/automation/check-sync.js).
- C7, C10: Verification and pulse. Embedded in CLAUDE.md and skill.md as prompts.
- C8, C9: Session artifacts. Partially automatable via governance-health-check.sh.
- C11: Post-mortem for audit-driven work. Only applies when work originates from an audit. Verified by checking for a post-mortem MD file that references both the audit and implementation plan.
- C12: Agent output redirection. Only applies when agents are dispatched. Verify each agent prompt included a file path and the agent wrote there instead of returning large inline output.
- C13: Handoff format compliance. Only applies when a session handoff is produced. Verify against canonical template.

---

## Automation Path

Several checks can be partially automated:

| Check | Automation Method | Tool |
|-------|-------------------|------|
| C5 | Git diff analysis against plan file | Custom script or manual review |
| C6 | Sync matrix enforcement | tier-3/automation/check-sync.js |
| C9 | Timestamp format check in changelog | tier-3/automation/governance-health-check.sh |
| C1, C2 | Acknowledgment gate in CLAUDE.md | Structural (auto-loaded at session start) |
| C11 | Post-mortem file exists with audit + plan cross-references | File existence check in docs/audits/ |
| C12 | Agent prompts include file output paths | Grep agent dispatch prompts for file path instructions |
| C13 | Handoff matches canonical template | Diff against tier-2/SESSION-HANDOFF-TEMPLATE.md sections |
| Tier 2+ counselor review | Mechanically enforced at session exit | stop-handoff-guard.sh blocks if 3+ mutations or TIER >= 2 and no counselor signal |
| Tier 3 adversarial review | Mechanically enforced at session exit | stop-handoff-guard.sh blocks if TIER >= 3 and no adversarial signal |

Checks C3, C4, C7, C8, C10 require session-level analysis and are best evaluated by the user or a post-session review. C11 only applies to audit-driven work. C12 only applies to sessions with agent dispatch. C13 only applies to sessions that produce a handoff.

---

## Using the Scorecard

**During a session:** The user or AI can run a quick scorecard at any time:

> "Run a compliance scorecard check. For each of C1 through C13, state pass or fail with a one-line justification."

**After a session:** Review the session against all 13 checks. Record the score in the session handoff or change log.

**Over time:** Track scores across sessions to identify patterns. Consistently failing the same check indicates a structural gap that needs a process or tooling fix.
