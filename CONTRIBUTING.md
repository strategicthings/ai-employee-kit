# Contributing to ai-employee-kit

Thanks for your interest. This kit packages a minimal, auditable starting surface for adopting the AI Governance Protocol v2.0. Contributions must preserve that minimalism — the kit is intentionally smaller than the private reference implementation.

## Before you open a PR

1. **Run the contamination scanner** against your working tree:
   ```
   bash bin/check-contamination.sh
   ```
   Exit 0 means clean. Exit 1 means fix the match before pushing. Exit 2 means the denylist file is missing — restore it and re-run.

2. **Scan the full history** when adding significant new content or rewrites:
   ```
   git log --all -p | bash bin/check-contamination.sh --stdin
   ```

3. **Validate any YAML or JSON you changed.** The CI workflow parses them; local pre-flight:
   ```
   python3 -c "import yaml; yaml.safe_load(open('.github/workflows/denylist.yml'))"
   jq . .claude/project-gate.json.example
   ```

## Changes to R1–R7 or I1–I9

Any change to the seven safety rules or nine invariants defined in `GOVERNANCE-SKILL.md` requires counselor review (5 independent reviewers, plus human override) per the upstream governance protocol. Open an issue **before** writing the PR so reviewers can be scheduled.

Documentation-only PRs (typos, clarifications that do not alter semantics) follow the normal review path.

## Filing issues

Use GitHub Issues. Include:
- What you observed
- What you expected
- Exact commands or steps to reproduce
- `VERSION` contents and your platform (macOS / Linux / shell)

Security issues go through GitHub Security Advisories — see `SECURITY.md`. Do not open public issues for vulnerabilities.

## Scope of this repo

- **In scope:** safety scaffolding, adopter-facing templates, install/governance docs, denylist tooling.
- **Out of scope (for now):** advanced runtime hooks, project-specific overlays, tiered tier-2/tier-3 protocol material. These live in the private reference repo and may be ported case-by-case in later versions.
