# Governance Protocol v2.0: Quick Reference

Print this or keep it open while working with Claude.

## The 9 Steps

1. **Classify your task.** Is it casual (Tier 0), standard (Tier 1), complex (Tier 2), or critical (Tier 3)?
2. **Identify project type.** App, Content, Data, Operations, or Hybrid? Each has specific defaults.
3. **Answer 5 questions.** What could go wrong? Do I have a backup? Can I undo this? How will I verify? What's NOT part of this?
4. **State your mission and boundaries.** Tell Claude what to do AND what NOT to do.
5. **Make Claude plan first.** "Show me your plan and wait for my approval."
6. **Capture the before state.** Save copies of originals before any changes.
7. **Execute in chunks.** Don't let Claude do everything at once. Verify each piece.
8. **Keep things in sync.** If one thing changed, update everything related. Now, not later.
9. **Review and save.** Quick check for small tasks, deep review for important ones. Save a session summary.

## The 7 Safety Rules (Always Active)

| Rule | What It Means |
|------|--------------|
| R1 | Never modify, delete, or overwrite originals. Work on copies. |
| R2 | Multi-step: all succeed or all get flagged. No partial. |
| R3 | Check inputs before processing (missing values, wrong formats). |
| R4 | Don't assume. Verify files exist, lists have items. |
| R5 | Keep related things in sync. Change together, never "later." |
| R6 | Know the undo. If irreversible, get explicit approval first. |
| R7 | You decide. Claude recommends. You have final say. Always. |

## Definition of Done (DoD)

Work is done when: every plan task is complete AND the DoD statement is satisfied AND GP-1 passes. No drift into adjacent work.

- **Plan header (Tier 1+):** "DoD = [terminal condition]"
- **Non-goals (Tier 2+):** list what you will NOT do
- **Stop phrase:** "Plan scope complete. [N/N] tasks done. DoD satisfied. Stopping. Handoff follows."
- **Out-of-scope during execution:** "NOTICED: [description]. Not in scope. Logged for next session."

## Project Type Defaults

| Type | Key Defaults |
|------|-------------|
| App | TypeScript, write tests first, pass all CI gates before delivering |
| Content | Read style guide first, calendar before writing, each piece in its own file |
| Data | Snapshot source before transforming, verify row counts, never touch originals |
| Operations | Write runbook first, document rollback, assess blast radius |
| Hybrid | Apply the stricter rule at every decision point |

## When Something Goes Wrong

**Minor (looks off):** Stop. Compare to your backup. Ask Claude what it changed.
**Major (definitely wrong):** Stop. Do NOT let Claude try to fix it. Restore from backup. Start a new conversation.
**Data lost:** Stop everything. Check cloud backups, trash, version history. Do not run any more commands.

## Key Phrases to Copy-Paste

**Starting:**
> Before you do anything, tell me your plan and wait for my approval.

**Setting boundaries:**
> Do NOT change anything I didn't specifically ask you to change.

**Checking work:**
> Show me what changed. Compare it to the original. Did anything change that wasn't in the plan?

**When Claude goes off track:**
> Stop. I didn't ask for that. Revert it and explain why you made that change.

**Ending a session:**
> Create a session summary: what we did, what's left, decisions made, and warnings for next time.

## Platform Limits (Don't Exceed These)

| What | Limit | Why |
|------|-------|-----|
| CLAUDE.md | 200 lines max | Longer files cause Claude to forget rules |
| Skill files | 500 lines max | Eats context budget needed for actual work |
| MEMORY.md | 200 lines loaded | Anything past line 200 is invisible |
