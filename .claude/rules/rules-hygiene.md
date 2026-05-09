# Rules hygiene

Policy: keep `.claude/rules/` small and high-signal. A session reads every
rules file at start; bloat raises token cost and drowns real guardrails.

Budget: 15k characters total across `.claude/rules/`.

Enforcement: `bin/rules-hygiene-check.sh` runs at SessionStart. On overflow
it emits a warning and names the largest files so they can be trimmed.

Pattern:
- Each rules file should answer "what must the model not do in <domain>?"
  in under 100 lines.
- Deep reference content goes to `.claude/docs/<topic>-detail.md`.
- Rules files link out; docs files are pulled in on demand.
- Never duplicate a governance rule (R1-R7, I1-I9, GP-1) here — those live
  in CLAUDE.md / GOVERNANCE-CORE.md.
