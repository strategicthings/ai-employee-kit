# Post-Mortem Report Template

> **Referenced from:** tier-2/SELF-REGULATION-PROTOCOL.md (Phase 5)
> **Required for:** Tier 2+ (when work originates from an audit)
> **Return to:** GOVERNANCE-CORE.md (Self-Regulation Cycle)

Use this template after completing an implementation that was driven by an audit. The post-mortem verifies that every audit finding was resolved. It is the third leg of the Audit-Plan-Post-Mortem triangle. The cycle is only closed when this document PASSES.

---

## Post-Mortem Metadata

- **Post-Mortem ID:** [PM-XXX]
- **Title:** [Brief description of what was implemented and verified]
- **Author:** [Who produced this post-mortem]
- **Date:** [YYYY-MM-DD HH:MM]

### Companion Documents

These three documents form a closed triangle. All must reference each other.

- **Audit Report:** [A-XXX] [link to docs/audits/YYYY-MM-DD-[topic]-audit.md]
- **Implementation Plan:** [P-XXX] [link to docs/audits/YYYY-MM-DD-[topic]-plan.md]

---

## Resolution Matrix

Map every finding from the source audit to its resolution. Every F-### from the audit MUST appear in this table.

| Audit Finding | Severity | Plan Step | Change Made | Verification Evidence | Status |
|---------------|----------|-----------|-------------|----------------------|--------|
| F-001 | [P0/P1/P2] | [Step # from plan] | [Specific change: file, line, what changed] | [How resolution was verified] | Resolved / Deferred / Won't Fix |
| F-002 | | | | | |
| F-003 | | | | | |

### Resolution Status Definitions

- **Resolved:** The finding was addressed. The Change Made column describes what was done. The Verification Evidence column proves it worked.
- **Deferred:** The finding was not addressed in this cycle. The Justification section below explains why and provides a forward reference to the next cycle.
- **Won't Fix:** The finding was reviewed and a deliberate decision was made not to address it. The Justification section below explains the rationale. Requires a D-### decision ID per tier-2/TRACEABILITY.md.

---

## Unresolved Findings

List any findings that were NOT resolved, with justification for each.

| Finding | Status | Justification | Forward Reference |
|---------|--------|---------------|-------------------|
| [F-###] | Deferred / Won't Fix | [Why this was not resolved] | [Next audit ID or "None"] |

If all findings are resolved, write: "All findings resolved. No unresolved items."

---

## Regression Check

Did the implementation introduce any NEW findings that did not exist in the original audit?

- [ ] **No regressions found.** The implementation did not introduce new issues.
- [ ] **Regressions found.** New findings are listed below with F-### IDs for the next cycle.

| New Finding | Severity | Description | Assigned to Cycle |
|-------------|----------|-------------|-------------------|
| [F-NEW-###] | [P0/P1/P2] | [What was introduced] | [Next audit ID or "Immediate"] |

---

## Coverage Verification

Cross-reference check between the three triangle documents.

| Check | Result |
|-------|--------|
| Every F-### from the audit appears in this Resolution Matrix | [ ] PASS / [ ] FAIL |
| Every plan step maps to at least one F-### | [ ] PASS / [ ] FAIL |
| This post-mortem references the audit by ID | [ ] PASS / [ ] FAIL |
| This post-mortem references the plan by ID | [ ] PASS / [ ] FAIL |
| The audit's Companion Documents section links to this post-mortem | [ ] PASS / [ ] FAIL |

---

## Lessons Learned / Pattern Promotion

This section supports Phase 6 (Pattern Extraction) of the self-regulation cycle. Complete it after the Regression Check passes.

### Recurring Pattern Check

Did any finding in this audit appear in a previous audit cycle?

| Finding | Previous Occurrence | Pattern Description | Action Taken |
|---------|--------------------|--------------------|--------------|
| [F-###] | [A-XXX, F-###] | [What keeps recurring and why] | [ ] Breadcrumb created / [ ] Rule promoted / [ ] No action (justify) |

If no recurring patterns: "No findings from this audit appeared in previous cycles."

### Breadcrumb Review

Should any existing breadcrumb be promoted to a governance rule?

| Breadcrumb | Appearances | Promotion Recommendation |
|------------|-------------|--------------------------|
| [Breadcrumb title] | [Count of retrospectives/audits] | [ ] Promote to rule / [ ] Keep as breadcrumb / [ ] Retire |

If no breadcrumbs are candidates: "No breadcrumbs meet the 3-retrospective threshold for rule promotion."

---

## Gate Result

- [ ] **PASS:** All findings resolved or justified. No unverified resolutions. Triangle complete.
- [ ] **FAIL:** Unresolved findings without justification, or missing cross-references.

If FAIL: The cycle remains OPEN. Address the gaps and re-run this post-mortem, or escalate to the next audit cycle.

---

## Sign-Off

| Role | Name | Date | Notes |
|------|------|------|-------|
| Implementer | [Name] | [YYYY-MM-DD HH:MM] | [Any qualifying remarks] |
| Reviewer | [Name] | [YYYY-MM-DD HH:MM] | [Any qualifying remarks] |
| Stakeholder | [Name] | [YYYY-MM-DD HH:MM] | [Acknowledgment] |
