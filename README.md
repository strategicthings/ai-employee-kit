# AI Employee Kit

Kit v0.1.0 · Built on AI Governance Protocol v2.0 · Tracks ai-governance-standards v5.1.1

A governance protocol that makes AI assistants (Claude) more careful, reliable, and predictable.

## What This Does

When installed, Claude will:

- **Plan before acting.** Claude states what it will do and waits for your approval before making changes.
- **Verify before delivering.** Claude checks its own work, confirms counts match, and flags anything uncertain.
- **Follow safety rules.** Seven non-negotiable rules prevent Claude from deleting data, skipping steps, or making unauthorized changes.
- **Produce session summaries.** At the end of every working session, Claude writes up what was done, what is left, and what the next person needs to know.

## Quick Start

1. Go to [claude.ai](https://claude.ai) and open or create a Project.
2. Open **Project Settings** and find the **Project Instructions** field.
3. Copy the entire contents of `GOVERNANCE-SKILL.md` and paste it into the Project Instructions field.

That is it. Claude will now follow the governance protocol in every conversation within that project.

For detailed setup options (including Claude Code CLI setup), see [INSTALL-GUIDE.md](INSTALL-GUIDE.md).

## What's In the Kit

| File | Description |
|------|-------------|
| `GOVERNANCE-SKILL.md` | The governance protocol itself. Paste this into Claude's project instructions. |
| `INSTALL-GUIDE.md` | Step-by-step installation guide with three setup options. |
| `QUICK-REFERENCE.md` | One-page cheat sheet of the 9 governance steps and 7 safety rules. |
| `ABOUT-TEMPLATE.md` | Template for adding your company context so Claude understands your business. |
| `CONTRIBUTING.md` | Guide for contributors: scanner usage, counselor-review expectations for rule changes. |
| `SECURITY.md` | Security policy. Directs vulnerability reports to GitHub Security Advisories. |
| `CHANGELOG.md` | Release notes, starting with v0.1.0. |
| `VERSION` | Tracks the kit version. |
| `bin/` | Hook scripts for Claude Code CLI: session-start gate, session ID resolver, contamination scanner (`check-contamination.sh`), denylist template, and project-root verifier. See INSTALL-GUIDE.md Option C. |
| `.claude/` | Example Claude Code settings: `project-gate.json.example` (project-overlay rules template) and `settings.json.example` (minimal hook wiring). |
| `.github/` | CI workflow (`workflows/denylist.yml`) plus the maintainer-only token list. Runs the contamination scanner on every push/PR. |

## How It Works

### Tier Classification

Every task gets classified before Claude starts working:

- **Tier 0 (Casual):** Quick questions and brainstorming. No overhead.
- **Tier 1 (Standard):** Single deliverable with clear scope. Claude plans, you approve, Claude executes.
- **Tier 2 (Complex):** Multi-step or multi-file work. Full planning, chunk-by-chunk execution, and review.
- **Tier 3 (Critical):** Financial, legal, or public-facing work. Maximum verification with three independent review passes.

### The 7 Safety Rules

These are always active and non-negotiable:

- **R1:** Never touch the original. Work on copies.
- **R2:** All or nothing. Multi-step work either all succeeds or all gets flagged.
- **R3:** Validate inputs before processing.
- **R4:** Guard every assumption. Verify before acting.
- **R5:** Keep related things in sync. Both happen now, never "later."
- **R6:** Know the undo. If irreversible, get explicit approval first.
- **R7:** Human always has final say. Claude recommends, you decide.

### Plan-Before-Execute Flow

For any task above Tier 0, Claude will:

1. Tell you what it found and what it understands about the current state.
2. Present a step-by-step plan, including what it will NOT touch.
3. Wait for your explicit approval before doing any work.
4. Verify its output before delivering.

## Customization

Use `ABOUT-TEMPLATE.md` to give Claude your company context. Fill in your company name, industry terms, business rules, and preferences. Paste the completed template into your project or conversation so Claude can tailor its work to your organization.

## Advanced Setup

Claude Code users can add the included `bin/` hook scripts for automated session management. The starter kit provides:

- **Governance gate** that fires on every session start, injecting safety rules and checking for handoffs
- **Session awareness** with unique session IDs derived from tmux pane or PID

These hooks ensure the governance protocol loads automatically every session. When a session ends, you start a new one and point it at a handoff file to continue where the last session left off.

For teams that need advanced capabilities (tool call counting, automatic multi-session chaining, secret scrubbing, security guards, retrospective gates), see the full [ai-governance-standards](https://github.com/strategicthings/ai-governance-standards) repository.

See [INSTALL-GUIDE.md](INSTALL-GUIDE.md) Option C for setup.

## License

MIT. See [LICENSE](LICENSE).
