# Implementation Plan Template

> **Referenced from:** GOVERNANCE.md Section 2 (Plan Before Execute)
> **Required for:** Tier 2+
> **Return to:** GOVERNANCE.md Section 2

Complete this template before starting any non-trivial change. The purpose is to think through the work before executing it. A plan that takes 10 minutes to write can prevent hours of rework. The plan does not need to be perfect. It needs to be specific enough that someone else could execute it and that you can identify when you are going off-track.

---

## Plan Metadata

- **Plan ID:** [P-XXX]
- **Title:** [Brief description of what this plan accomplishes]
- **Author:** [Who wrote this plan]
- **Date:** [YYYY-MM-DD HH:MM]
- **Status:** [ ] Draft / [ ] Approved / [ ] In Progress / [ ] Completed / [ ] Abandoned
- **Audit Reference:** [A-XXX or "N/A" if this plan does not originate from an audit]

---

## Context

Why this change is being made. What problem exists today and why it needs to be solved now.

[Write 2-5 sentences. Include links to issues, requests, or prior discussions if they exist. The reader should understand the motivation without needing to ask follow-up questions.]

---

## Requirements

What must be true when this work is complete. These are the acceptance criteria.

- [ ] [Requirement 1. Stated as a verifiable condition, not a task.]
- [ ] [Requirement 2.]
- [ ] [Requirement 3.]
- [ ] [Additional requirements as needed.]

---

## Non-Goals

What this plan explicitly does NOT include. This prevents scope creep and sets clear boundaries.

- [Non-goal 1. State what is out of scope and, if helpful, why.]
- [Non-goal 2.]
- [Or "No explicit non-goals."]

---

## Finding Coverage (if audit-driven)

**Required when Audit Reference is not "N/A".** Map every F-### from the source audit to the plan step that addresses it. If any finding from the source audit has no entry in this table, this plan is incomplete.

| Audit Finding | Severity | Plan Step | Status |
|---------------|----------|-----------|--------|
| [F-###] | [P0/P1/P2] | [Step # below] | Planned / Deferred |
| [F-###] | | | |

**Deferred findings** must include justification: [Why this finding is not addressed in this plan and when it will be addressed.]

If this plan does not originate from an audit, write: "N/A. This plan is not audit-driven."

---

## Approach

Step-by-step plan with estimated effort for each step. Steps should be small enough that progress is measurable.

| Step | Description | Estimated Effort | Dependencies |
|------|------------|-----------------|-------------|
| 1 | [What to do first] | [Time estimate] | [None or "Step X"] |
| 2 | [What to do second] | [Time estimate] | [Step 1] |
| 3 | [What to do third] | [Time estimate] | [Step 2] |
| 4 | [Additional steps as needed] | | |

**Total estimated effort:** [Sum of individual estimates]

---

## Risks and Rollback

What could go wrong and how to recover.

| Risk | Likelihood | Impact | Mitigation | Rollback Steps |
|------|-----------|--------|-----------|---------------|
| [What could go wrong] | [Low / Medium / High] | [Low / Medium / High] | [How to prevent or reduce this risk] | [How to undo the change if this risk materializes] |
| [What could go wrong] | | | | |

---

## Dependencies

What must be completed, available, or true before this work can begin.

- [ ] [Dependency 1. Include who owns it and current status.]
- [ ] [Dependency 2.]
- [Or "No external dependencies."]

---

## Verification

How to test that the plan succeeded. Each requirement from the Requirements section should have a corresponding verification step.

| Requirement | Verification Method | Expected Result |
|------------|-------------------|----------------|
| [Requirement 1] | [How to test it] | [What success looks like] |
| [Requirement 2] | [How to test it] | [What success looks like] |

---

## Files Affected

List of files that will be created, modified, or deleted.

| File Path | Action | Description |
|-----------|--------|------------|
| [/path/to/file] | [ ] Create / [ ] Modify / [ ] Delete | [What will change] |
| [/path/to/file] | | [What will change] |

---

## Review Level

Which review intensity applies to this plan, based on the governance framework.

- **Review level:** [ ] Level 1 (Quick Check) / [ ] Level 2 (Standard Review) / [ ] Level 3 (Deep Audit) / [ ] Level 4 (Adversarial Review)
- **Justification:** [Why this level is appropriate. Reference the governance criteria if applicable.]
- **Reviewer(s):** [Who needs to approve before execution begins, or "Self-review" for standard changes.]
