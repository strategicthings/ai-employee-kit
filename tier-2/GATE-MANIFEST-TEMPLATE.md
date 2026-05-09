# Gate Manifest Template

> **Referenced from:** DEPLOYMENT-CHECKLIST.md, GOVERNANCE-CORE.md
> **Return to:** GOVERNANCE-CORE.md

A **gate manifest** is the project-specific checklist that gates a primary output from reaching its recipient. Use it when your project has a recurring ship action — a deployment, a publication, a release, a customer-facing send — whose quality depends on a fixed set of checks always running first.

This template gives you the shape. Fill in project-specific checks. Keep it in the project (not in the governance kit), typically at `<project>/GATE-MANIFEST.md` or `<project>/.claude/rules/gate-manifest.md`.

---

## How to use this template

1. Copy to your project root (or `.claude/rules/`).
2. Replace every `[PLACEHOLDER]` with project-specific content.
3. Keep the two-tier structure (Pre-Flight + Block-Level). Do not collapse them.
4. Link to the manifest from CLAUDE.md so sessions see it at start.
5. Review the manifest each time the project's ship process changes.

The manifest is a **living contract**. When a check becomes obsolete, remove it. When a new failure mode appears in production, add the check that would have caught it.

---

## Structure

### Pre-Flight Checks

Advisory checks run before ship. If a Pre-Flight check fails, the model must pause and raise the issue with the human, but the human may waive it. These are high-signal quality checks that do not always apply.

- [ ] **PF-1: [PLACEHOLDER: check name].** [PLACEHOLDER: what to verify and how.]
- [ ] **PF-2: [PLACEHOLDER].**
- [ ] **PF-3: [PLACEHOLDER].**

(Add as many as the project needs. Typical count: 3-8.)

### Block-Level Checks

Hard blocks. If a Block-Level check fails, the ship action is refused. These cover: safety violations, legal or compliance constraints, data-integrity risks, outputs that cannot be recalled after the ship action.

- [ ] **BL-1: [PLACEHOLDER: check name].** [PLACEHOLDER: what to verify. Failure mode. Override path, if any.]
- [ ] **BL-2: [PLACEHOLDER].**
- [ ] **BL-3: [PLACEHOLDER].**

(Keep the list tight. Typical count: 2-6. Every Block-Level check must have an explicit override path or be marked "no override — human override required (R7/I7).")

---

## Worked template (replace everything in brackets)

```
## Pre-Flight Checks

- [ ] PF-1: [Output passes format linter].
  - How: run [linter command].
  - On fail: fix, re-run.

- [ ] PF-2: [All referenced assets resolve].
  - How: [check command or manual inspection].
  - On fail: resolve missing references.

## Block-Level Checks

- [ ] BL-1: [No unpublished / embargoed content in output].
  - How: grep output for embargo markers.
  - On fail: remove embargoed sections. No override.

- [ ] BL-2: [No PII in logs or exports].
  - How: [scan tool or checklist].
  - On fail: redact before ship. Human override required.
```

---

## What NOT to put in a gate manifest

- **Generic governance rules** (R1-R7, I1-I9). Those live in CLAUDE.md / GOVERNANCE-CORE.md.
- **Process advice.** The manifest is a checklist, not a workflow description.
- **Style preferences.** Put those in a style guide; the manifest only blocks ship if the style violation is ship-breaking.
- **Things the project does not actually ship.** If you do not have a recurring ship action, you do not need a manifest.

---

## Relationship to the governance protocol

- Manifest checks are **project-specific** overlays on top of governance. They do not replace R1-R7, I1-I9, or GP-1.
- The manifest is consulted **at the ship boundary**. Governance applies to everything upstream: planning, authoring, review.
- If a manifest check duplicates a governance rule, delete it. The governance rule already applies everywhere.

---

## Template Version

Created: 2026-04-15
Governance version: 5.0.0
