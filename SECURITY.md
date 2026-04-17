# Security Policy

## Reporting a vulnerability

Please report suspected vulnerabilities through **GitHub Security Advisories** on this repository:

https://github.com/strategicthings/ai-employee-kit/security/advisories/new

Do not open public issues for security-sensitive findings.

Include:
- A description of the issue and its potential impact
- Steps to reproduce or a proof of concept
- Affected version (see `VERSION`)
- Any mitigations you have already identified

## What to expect

Advisories are reviewed on a best-effort basis. Valid reports receive an acknowledgment and a remediation plan. Fixes ship in a patch release and are documented in `CHANGELOG.md`.

## Scope

In scope:
- Issues in scripts under `bin/`
- Misconfiguration in example settings under `.claude/`
- CI workflow weaknesses (`.github/workflows/`)
- Documentation that could mislead an adopter into a weaker posture

Out of scope:
- Vulnerabilities in upstream dependencies you add locally
- Vulnerabilities introduced by your own project-gate rules or denylist edits
