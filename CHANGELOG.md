# Changelog

All notable changes to the AI Employee Kit are documented here.

Versioning follows [Semantic Versioning](https://semver.org/). The `0.x` line explicitly allows breaking changes.

## [0.1.0] - 2026-04-17

First versioned release. Tracks `ai-governance-standards` v5.1.1, built on AI Governance Protocol v2.0.

### Added

- `bin/check-contamination.sh` — standalone denylist scanner. Runs against the working tree and is also piped `git log --all -p` input from CI. Exits 0 when no listed patterns match.
- `bin/denylist.txt` — adopter-facing scanner input with three generic placeholder patterns active by default, plus commented examples (AWS access key, base64 secret candidate). See the file itself for the authoritative pattern list. Adopters extend with their own company-specific tokens.
- `bin/verify-project-root.sh` — sourced helper that binds a plan to a `project_root:` stamp and fails closed on mismatch. Byte-equivalent to the upstream version in `ai-governance-standards`.
- `.claude/project-gate.json.example` — project-overlay rules template (`{rules:[]}` schema) with two commented sample rules.
- `.claude/settings.json.example` — minimal Claude Code settings wiring the session-start gate.
- `CONTRIBUTING.md` — contributor guide: scanner-run guidance, counselor-review expectations for any PR touching R1-R7 / I1-I9.
- `SECURITY.md` — one-page policy directing vulnerability reports to GitHub Security Advisories.
- `VERSION` — tracks the kit version (`0.1.0`).
- `CHANGELOG.md` — this file.
- `.github/workflows/denylist.yml` — CI workflow running `check-contamination.sh` plus an inline maintainer-token sweep on every push and pull request to `main`.
- `.github/.denylist-maintainer` — maintainer-only token list, excluded from scanner scan and authoritative in CI only.

### Changed

- `INSTALL-GUIDE.md` — `gp3-retrospective.sh` renamed to `stop-advisories.sh` (Step 1 script list and Step 2 Stop-hook registration). Tracks the upstream rename in `ai-governance-standards` v5.0.x.
- `README.md` — added compatibility line and refreshed the file inventory to include the new safety, config, CI, and docs surfaces shipped in this release.

### Verified

- `bash bin/check-contamination.sh` exits 0 on the working tree.
- `bash bin/check-contamination.sh` exits 0 when piped `git log --all -p` input (full-history scan).
- `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/denylist.yml'))"` parses the CI workflow without error.
- `jq . .claude/project-gate.json.example` validates as JSON.
- `GOVERNANCE-SKILL.md` is byte-equal to the upstream `employee-kit/GOVERNANCE-SKILL.md` in `ai-governance-standards` (verified via `diff -q`).

### Notes

- **Public `bin/denylist.txt` is intentionally not a mirror of the private denylist.** The public version ships generic defaults only; the private upstream carries company-specific tokens that would create false positives or leak content if shipped. Adopters are expected to extend the public denylist for their own organization.
- **`/Users/` was considered as a generic default and omitted.** It would match any macOS absolute path in an adopter's README example and produce false positives on typical repo content. Adopters who never want absolute local paths committed can add `/Users/`, `/home/`, `C:\Users\` patterns themselves.
- **`.github/.denylist-maintainer` ships with placeholder strings only.** Real maintainer-identifying tokens are never committed to public git history. The CI workflow regex matches the placeholders; adopters cloning the kit replace them with their own tokens and keep the file out of their public scanner scope via the same exclusion rule.
