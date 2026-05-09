# Self-Regulation Protocol

> **Referenced from:** GOVERNANCE-CORE.md (Self-Regulation Cycle), GOVERNANCE.md Section 5
> **Required for:** Tier 2+ (any work that produces audit findings or modifies process/structure)
> **Return to:** GOVERNANCE-CORE.md

## Purpose

This protocol defines the closed-loop cycle that governs how work is audited, planned, implemented, and verified. Every Tier 2+ change that starts from an audit must complete the full cycle. The cycle produces three artifacts that cross-reference each other. Nothing passes until all three match.

---

## The Self-Regulation Cycle

### 6 Phases

```
Phase 1: Audit  ->  Phase 2: Plan  ->  Phase 3: Approval  ->  Phase 4: Implement  ->  Phase 5: Post-Mortem  ->  Phase 6: Pattern Extraction
   |                    |                                                                    |                          |
   | F-001, F-002...    | maps each F-### to a step                                         |                          |
   |                    |                                                                    |                          |
   +-------- post-mortem verifies every F-### resolved, referencing both audit + plan -------+                          |
   |                                                                                                                    |
   +---------- recurring patterns promoted to breadcrumbs or rules, preventing future recurrence -----------------------+
```

### Phase 1: Audit

Produce an **Audit Report** using `tier-2/AUDIT-TEMPLATE.md`.

Requirements:
- Enter plan mode (read-only exploration)
- Read the relevant files and project state
- Each finding receives an F-### ID per `tier-2/TRACEABILITY.md`
- Assign severity (P0/P1/P2) to every finding
- Save the audit as an MD file, not just conversation output
- File naming: `docs/audits/YYYY-MM-DD-[topic]-audit.md`

The audit is a read-only operation. No files are modified during this phase.

### Phase 2: Implementation Plan

Produce an **Implementation Plan** using `tier-2/PLAN-TEMPLATE.md`.

Requirements:
- Stay in plan mode (or re-enter it)
- The plan metadata MUST include an "Audit Reference" field linking to the audit
- The plan MUST include a **Finding Coverage Table** mapping every F-### from the audit to one or more plan steps
- If a finding will NOT be addressed, it MUST appear in the table with status "Deferred" and a justification
- **Gate rule:** If any F-### from the audit has no entry in the Finding Coverage Table, the plan is incomplete. Do not request approval.
- Save the plan as an MD file
- File naming: `docs/audits/YYYY-MM-DD-[topic]-plan.md`
- Update the audit's Companion Documents section to link to this plan

### Phase 3: Approval Gate

Present the plan to the human for review.

The human checks:
1. Does the Finding Coverage Table account for every F-### from the audit?
2. Are the plan steps reasonable and complete?
3. Are deferred findings justified?

The human approves, requests changes, or rejects. Implementation does not begin until approval is given (Invariant I1).

### Phase 4: Implementation

Execute the approved plan.

Requirements:
- Follow the 5-step execution order from `tier-2/CHANGE-CONTROL.md` (canonical source -> tests -> implement -> triangulate -> document)
- Track which findings are being resolved as work proceeds
- If new findings emerge during implementation, log them with new F-### IDs for the next cycle
- Run GP-1 (Governance Pulse) before claiming implementation is complete

### Phase 5: Post-Mortem

Produce a **Post-Mortem Report** using `tier-2/POST-MORTEM-TEMPLATE.md`.

Requirements:
- The post-mortem metadata MUST link to both the audit and the implementation plan
- The **Resolution Matrix** maps every F-### to: the plan step that addressed it, the actual change made, and verification evidence
- Any unresolved findings MUST be listed with justification and a forward reference to the next audit cycle
- A **Regression Check** asks: did the implementation introduce any new findings?
- **Gate rule:** The post-mortem PASSES only if every F-### is either resolved (with evidence) or justified (with rationale). Otherwise it FAILS and the cycle remains open.
- Save the post-mortem as an MD file
- File naming: `docs/audits/YYYY-MM-DD-[topic]-post-mortem.md`
- Update the audit's Companion Documents section to link to this post-mortem

### Phase 6: Pattern Extraction

After the post-mortem PASSES, review all findings for recurring patterns before closing the cycle.

Requirements:
- Review the current audit's findings against all previous audit findings
- Any pattern appearing in **2+ audit cycles** MUST be promoted to a breadcrumb in `BREADCRUMBS.md` using `tier-2/BREADCRUMBS-TEMPLATE.md`
- Any breadcrumb appearing in **3+ retrospectives** MUST be evaluated for rule promotion (amendment to GOVERNANCE-CORE.md or a new Red Flag)
- Document pattern promotions in the post-mortem's "Lessons Learned / Pattern Promotion" section
- If no recurring patterns are found, note "No recurring patterns identified" in the post-mortem

This phase is what prevents the governance system from repeatedly detecting the same problem without ever fixing the root cause. Detection without prevention is incomplete.

---

## The Triangle

Three artifacts form a closed triangle. Each references the other two.

```
            Audit Report (A-XXX)
            /                   \
           / F-001, F-002...     \
          /                       \
Implementation Plan (P-XXX) --- Post-Mortem (PM-XXX)
   references A-XXX                references A-XXX + P-XXX
   maps F-### to steps              maps F-### to resolutions
```

The cycle is **OPEN** until the post-mortem PASSES.
The cycle is **CLOSED** when the post-mortem verifies every finding.

---

## Cross-Reference Gate Rules

| Gate | Rule | Failure Condition |
|------|------|-------------------|
| Plan Gate | Every F-### from the audit appears in the plan's Finding Coverage Table | Any F-### missing from the table (without "Deferred" status) |
| Post-Mortem Gate | Every F-### appears in the Resolution Matrix with evidence or justification | Any F-### with no resolution AND no justification |
| Regression Gate | Implementation did not introduce new untracked findings | New issues found but not logged as F-### for next cycle |
| Triangle Gate | All three documents reference each other by ID | Any document missing a link to the other two |

---

## When to Trigger the Cycle

The self-regulation cycle is REQUIRED for:
- Any governance change (modifying governance files, rules, or protocols)
- Any Tier 2+ work where an audit was conducted (formally or informally)
- Any work that modifies project structure, process, or documentation standards

The cycle is OPTIONAL but RECOMMENDED for:
- Tier 1 work where findings were identified during review
- Retrospectives that produce actionable findings

The cycle is NOT REQUIRED for:
- Tier 0 casual work
- Tier 1 work with no findings

---

## File Storage

All cycle artifacts are stored in the project's `docs/audits/` directory.

Naming convention:
```
docs/audits/YYYY-MM-DD-[topic]-audit.md
docs/audits/YYYY-MM-DD-[topic]-plan.md
docs/audits/YYYY-MM-DD-[topic]-post-mortem.md
```

The date and topic string tie the three documents together. They also cross-reference each other by formal ID (A-XXX, P-XXX, PM-XXX) in their metadata sections.

---

## Integration with Existing Protocols

| Protocol | Integration |
|----------|-------------|
| Traceability (F/T/V/D IDs) | Findings use F-### IDs. Post-mortem resolutions create V-### verifications. |
| Change Control (5-step execution) | Phase 4 follows the 5-step execution order. |
| Governance Pulse (GP-1) | GP-1 runs before claiming Phase 4 is complete. |
| Compliance Scorecard | C11: audit-originated work requires a post-mortem. C12: agent-dispatched work requires output redirection (P38). C13: handoff format compliance. |
| Session Management | The audit and post-mortem serve as session handoff artifacts. |
| Counselor Protocol | For Tier 3 work, counselor review applies to the plan (Phase 2) and/or the post-mortem (Phase 5). |
| Breadcrumbs (`BREADCRUMBS.md`) | Phase 6 promotes recurring patterns to breadcrumbs using `tier-2/BREADCRUMBS-TEMPLATE.md`. Breadcrumbs are reviewed during retrospectives for rule promotion. |
| Retrospective (`tier-2/RETROSPECTIVE-TEMPLATE.md`) | Retrospectives review breadcrumbs and evaluate whether any should be promoted to governance rules. See "Breadcrumb Review" section in the retrospective. |
