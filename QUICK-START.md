# Quick-Start Reference Card

> **Referenced from:** GOVERNANCE.md Section 0 (quick reference)
> **Required for:** All tiers
> **Return to:** GOVERNANCE.md Section 0

One-page reminder for users who have read GOVERNANCE.md. For the full protocol, refer to GOVERNANCE.md by section number.

---

## Prerequisites

Before using this guide, your project must have the governance files installed. Two paths:

**Automated (recommended):** Clone the governance repo, then run setup from your project directory:
```bash
bash /path/to/ai-governance-standards/tier-3/automation/setup-enforcement.sh
```
This copies CLAUDE.md (with full governance gate), GOVERNANCE-CORE.md, Claude Code hooks, bin/ scripts, reference files, and essential tier-2 templates into your project.

For the full harness (global `~/.claude/bin/` scripts, chain system, stop-advisories Stop hook, debugging): see [`docs/HARNESS-GUIDE.md`](docs/HARNESS-GUIDE.md).

**Manual:** Copy these files from the governance repo into your project root:
1. `GOVERNANCE-CORE.md` (operating handbook, read every session)
2. `tier-3/CLAUDE-MD-TEMPLATE.md` -> `CLAUDE.md` (fill in placeholders)
3. `QUICK-START.md`, `GLOSSARY.md`, `EXACT-PHRASES.md` (reference files)
4. `COMPLIANCE-SCORECARD.md` (session scoring)
5. Create `.claude/settings.json` with SessionStart hook pointing to `bin/session-start-gate.sh`
6. (Recommended) Copy `bin/rules-hygiene-check.sh` to `.claude/bin/` and add to SessionStart hooks to auto-detect oversized rules files

**Archetype skills (optional):** Copy the archetype skill matching your project type from the governance repo's `skills/` directory (app, data, marketing, or ops) into your project's `skills/` directory. These are prompt keywords activated by including `skill.md` in context, not Claude Code slash commands.

**Skill adoption bootstrap:** To use `gov-skills` CLI, first manually copy `skills/adopt-skill/` from the governance repo into your project's `skills/adopt-skill/` directory, then set `GOV_STANDARDS_PATH` to the governance repo path. After that, use `gov-skills install <name>` for all other skills.

---

## Decision Flowchart

```
    Task Arrives
         |
         v
  +------+------+
  | Classify:    |
  | Tier 0/1/2/3 |
  +------+------+
         |
    +----+----+--------+--------+
    |         |        |        |
    v         v        v        v
 Tier 0    Tier 1   Tier 2   Tier 3
 Just do   Plan +   Full     Full +
  it       Verify   Protocol Adversarial
    |         |        |        |
    v         v        v        v
 Done     Steps     Steps    Steps
          1-4,8-9   1-9      1-9 +
                             3 review
                             passes
```

---

## The 9 Steps

### 1. Classify Your Task (Tier 0-3) [Section 0]

Determine the risk level before you start. Tier 0 is casual exploration. Tier 1 is standard work. Tier 2 is complex or multi-system changes. Tier 3 is critical, irreversible, or production-affecting work.

> "This is a Tier [0/1/2/3] task. Here is why: [one sentence justification]."

---

### 2. Answer the 5 Pre-Flight Questions [Section 1]

What am I trying to accomplish? What could go wrong? What must not change? How will I verify correctness? Can I undo this?

> "Before we start, let me answer the five pre-flight questions."

---

### 3. State Your Mission, Non-Goals, and Invariants [Section 1]

One sentence for the mission. Explicit list of what the AI must not do. Hard rules that cannot be broken under any circumstances.

> "Mission: [one sentence]. Non-goals: [list]. Invariants: [list]. Do not violate these under any circumstances."

---

### 4. Enter Plan Mode: AI Explores, Proposes, Waits for Approval [Section 2]

The AI should investigate, outline its approach, and wait for your go-ahead before making any changes.

> "Enter plan mode. Explore the problem, propose your approach, and wait for my approval before executing anything."

---

### 5. Capture the Before Snapshot [Section 3, R1]

Document the current state so you have a known-good baseline to compare against or roll back to.

> "Before making any changes, capture a snapshot of the current state and show it to me."

---

### 6. Execute in Chunks, Verify Each One [Section 3, R3-R4]

Work in small, reviewable increments. After each chunk, verify it independently before moving to the next.

> "Execute this in small chunks. After each chunk, pause and verify the result before continuing."

---

### 7. Enforce Sync Across Related Items [Section 3, R5]

When you change one thing, check everything that depends on it. Code, docs, configs, tests, and downstream references must all stay consistent.

> "Check all related items for sync. If this change affects anything else, update those too and show me the full list."

---

### 8. Review at the Appropriate Intensity Level [Section 5]

Match review depth to risk. Level 1 is a quick scan. Level 2 is a standard walkthrough. Level 3 is a deep audit with triangulation. Level 4 is adversarial review with counselors.

> "Review this output at Level [1/2/3/4] intensity. Show me your findings before we finalize."

---

### 9. Create Audit Trail and Session Handoff [Sections 7-8]

Log what was done, what changed, what was decided, and what remains. If the session will continue later or transfer to another person, write a handoff note.

> "Create an audit trail for this session and write a handoff note covering decisions, changes, and open items."

---

## Prerequisites

Before using this reference card, ensure governance is installed in your project:

1. **Run setup:** `bash /path/to/ai-governance-standards/tier-3/automation/setup-enforcement.sh` from your project root
2. **Archetype skills (optional):** Copy the relevant archetype skill to your project:
   - `cp -r /path/to/ai-governance-standards/skills/app/ your-project/skills/app/` (for code projects)
   - `cp -r /path/to/ai-governance-standards/skills/marketing/ your-project/skills/marketing/` (for content projects)
   - `cp -r /path/to/ai-governance-standards/skills/data/ your-project/skills/data/` (for data projects)
   - `cp -r /path/to/ai-governance-standards/skills/ops/ your-project/skills/ops/` (for ops projects)
3. **Skill library (optional):** Set `GOV_STANDARDS_PATH` to the governance repo and use `gov-skills install <name>` to add workflow skills

Note: The Skill Routing Table in GOVERNANCE-CORE.md references `/ai-gov-app`, `/ai-gov-marketing`, `/ai-gov-data`, `/ai-gov-ops`. These are prompt keywords that work when the matching archetype skill file is in Claude's context. They are not registered Claude Code slash commands.

---

When in doubt, use the Full Protocol. The extra 5 minutes up front saves hours of cleanup later.
