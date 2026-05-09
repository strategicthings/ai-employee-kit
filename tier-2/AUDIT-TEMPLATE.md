# Audit Report Template

> **Referenced from:** GOVERNANCE.md Section 5 (Review Protocol) and TRACEABILITY.md
> **Required for:** Tier 2+ (when formal audit is conducted)
> **Return to:** GOVERNANCE.md Section 5

Use this template to document formal review findings. An audit is a structured evaluation of whether the project, process, or documentation meets its stated standards. Complete every section. The report should be detailed enough that someone who was not present for the audit can understand what was reviewed, what was found, and what needs to happen next.

---

## Audit Metadata

- **Audit ID:** [A-XXX]
- **Title:** [Brief description of what was audited]
- **Auditor(s):** [Who conducted the audit]
- **Date conducted:** [YYYY-MM-DD HH:MM]
- **Version reviewed:** [Version number of the artifact being audited, if applicable]

### Companion Documents (Self-Regulation Cycle)

This audit is one leg of the Audit-Plan-Post-Mortem triangle. See `tier-2/SELF-REGULATION-PROTOCOL.md`.

- **Implementation Plan:** [P-XXX] [link when created, or "Pending"]
- **Post-Mortem:** [PM-XXX] [link when created, or "Pending"]

### Traceability Gate

This audit is **OPEN** until a Post-Mortem references it and all findings are resolved or justified. Update the Companion Documents section when the plan and post-mortem are produced.

---

## Audit Scope

Define the boundaries of this audit. What was reviewed and what was explicitly excluded.

- **In scope:** [List the specific files, processes, systems, or documentation sections that were reviewed.]
- **Out of scope:** [List anything that was intentionally excluded from this review and why.]
- **Time period covered:** [If the audit reviews activity over a period, specify the start and end dates.]

---

## Audit Type

Select one or more:

- [ ] **Completeness:** Does the documentation cover everything it should?
- [ ] **Depth:** Is the documentation detailed enough to be useful?
- [ ] **Enforcement:** Are the stated rules and patterns actually being followed?
- [ ] **Accessibility:** Can someone new to the project find and understand the documentation?
- [ ] **Other:** [Describe]

---

## Methodology

How the audit was conducted. Include enough detail that the audit could be repeated.

- **Review method:** [Manual review / Automated scan / Interviews / Combination]
- **Sampling approach:** [Was everything reviewed, or was a sample selected? If sampled, describe the criteria.]
- **Tools used:** [Any scripts, linters, or search tools used during the audit]
- **Standards referenced:** [Which governance documents, checklists, or external standards were used as the baseline]

---

## Summary

**Overall assessment:** [ ] PASS / [ ] NEEDS REVISION / [ ] FAIL

**Narrative summary:** [3-5 sentences summarizing the overall state of what was audited. Highlight the most important findings, both positive and negative. This section should give a reader the key takeaways without needing to read the full findings table.]

---

## Findings

| ID | Severity | Description | Recommendation | Status |
|----|----------|-------------|---------------|--------|
| F001 | [P0 / P1 / P2] | [What was found. Be specific: reference file names, line numbers, sections, or examples.] | [What should be done to address this finding.] | [ ] Open / [ ] In Progress / [ ] Resolved / [ ] Won't Fix |
| F002 | | | | |
| F003 | | | | |
| F004 | | | | |

### Severity Definitions

- **P0 (Critical):** The finding represents an active risk, a broken process, or a governance violation that could cause immediate harm. Must be addressed before the next working session.
- **P1 (Important):** The finding represents a gap or inconsistency that will cause problems if left unaddressed. Should be resolved within one review cycle.
- **P2 (Minor):** The finding is a quality improvement, a clarification, or a cleanup item. Address when convenient, no urgency.

---

## Remediation Plan

**For Tier 2+ work:** Create a full Implementation Plan using `tier-2/PLAN-TEMPLATE.md` instead of this abbreviated table. The plan must include a Finding Coverage Table mapping every F-### to a plan step.

**For Tier 1 work or quick remediations:** Use this table.

For each open finding, specify the remediation path.

| Finding ID | Owner | Action Required | Target Date | Dependencies |
|-----------|-------|----------------|------------|-------------|
| F001 | [Who is responsible] | [Specific steps to resolve] | [YYYY-MM-DD HH:MM] | [What must happen first, or "None"] |
| F002 | | | | |
| F003 | | | | |

---

## Positive Observations

Document what is working well. Audits should not only catalog problems.

- [Positive observation 1. What is being done right and should continue.]
- [Positive observation 2.]
- [Or "No specific observations beyond expected compliance."]

---

## Sign-Off

| Role | Name | Date | Notes |
|------|------|------|-------|
| Lead Auditor | [Name] | [YYYY-MM-DD HH:MM] | [Any qualifying remarks] |
| Reviewer | [Name] | [YYYY-MM-DD HH:MM] | [Any qualifying remarks] |
| Stakeholder | [Name] | [YYYY-MM-DD HH:MM] | [Acknowledgment or objections] |

**Next audit scheduled:** [YYYY-MM-DD or "To be determined"]
