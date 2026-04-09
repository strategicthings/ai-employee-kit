# AI Governance Protocol: Installation Guide

## What This Is

This is a set of rules that makes Claude work more carefully and reliably. It prevents Claude from making changes you didn't ask for, deleting things, skipping verification, or delivering work without checking it first.

Once installed, Claude will:
- Ask what you're trying to do before jumping in
- Plan its approach and wait for your approval
- Check its own work before delivering
- Flag its own mistakes if it catches them
- Produce a summary at the end of every session

## How to Install (Choose One)

### Option A: Claude.ai Projects (Recommended)

This is the best option. You set it up once and it works for every conversation in that project.

1. Go to claude.ai
2. Click **Projects** in the left sidebar
3. Click **Create Project** (or open an existing one)
4. Click the **gear icon** or **Project Settings**
5. Find **Project Instructions** (sometimes called "Custom Instructions")
6. Open the file called **GOVERNANCE-SKILL.md** (included in this kit)
7. Copy EVERYTHING in that file
8. Paste it into the Project Instructions field
9. Click Save

Now open the file called **ABOUT-TEMPLATE.md**. Fill it in with your company and project details. When you start a conversation in the project, paste your filled-in ABOUT as your first message. This gives Claude the context it needs to do good work.

**How to verify it worked:** Start a new conversation in the project. Claude's first response should say: "Governance Protocol v2.0 active. Safety rules R1-R7 loaded. Invariants I1-I9 loaded. Awaiting task classification."

If you don't see that message, the instructions didn't load. Go back to step 5 and make sure you pasted the full content.

### Option B: Claude.ai Chat (No Project)

Use this if you don't want to create a project. You'll need to paste the instructions at the start of each conversation.

1. Open claude.ai
2. Start a new conversation
3. Open **GOVERNANCE-SKILL.md**
4. Copy EVERYTHING
5. Paste it as your first message
6. Claude will respond: "Governance Protocol v2.0 active. Safety rules R1-R7 loaded. Invariants I1-I9 loaded. Awaiting task classification."
7. Now give Claude your task

You need to do this every time you start a new conversation. That's why Option A (Projects) is better for ongoing work.

### Option C: Claude Code (CLI)

For technical team members using the terminal. Requires tmux, Claude Code CLI, and bash.

**Step 1: Install the hook scripts.**

All scripts are in the `bin/` directory of this repo. Copy them to `~/.claude/bin/` and make them executable:

```bash
mkdir -p ~/.claude/bin
cp bin/*.sh ~/.claude/bin/
chmod +x ~/.claude/bin/*.sh
```

Scripts included:

| Script | Purpose |
|--------|---------|
| `resolve-session-id.sh` | Derives a unique session ID from tmux pane or PID |
| `session-start-gate.sh` | Fires the governance gate, resets counters, checks for handoffs |

These two scripts give you the governance gate (safety rules injected every session) and session awareness (unique session IDs, handoff detection). For advanced capabilities (tool call counting, automatic session chaining, secret scrubbing), see the full [ai-governance-standards](https://github.com/strategicthings/ai-governance-standards) repo.

**Step 2: Edit project-specific block rules.**

Open `~/.claude/bin/session-start-gate.sh` and find the "PROJECT-SPECIFIC BLOCK RULES" section near the bottom. Replace the example rules with rules specific to your project (deployment restrictions, content style rules, etc.). Or remove them if not needed.

**Step 3: Register the hooks in `~/.claude/settings.json`.**

Add this to your settings file (create it if it does not exist):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/bin/session-start-gate.sh",
            "statusMessage": "Loading governance gate..."
          }
        ]
      }
    ]
  }
}
```

**Step 4 (optional): Install the governance skill.**
1. Run: `mkdir -p ~/.claude/skills/ai-governance`
2. Copy **GOVERNANCE-SKILL.md** to `~/.claude/skills/ai-governance/SKILL.md`
3. In any Claude Code session, type `/ai-governance` to activate

The hooks in Steps 1-3 give you session awareness: governance gate on every session and handoff detection at session start. The skill in Step 4 is a convenience that loads the full protocol text into a session on demand.

## What Happens After You Install It

When you give Claude a task, it will:

1. **Classify your task** as Tier 0, 1, 2, or 3 based on complexity
   - Tier 0 (casual): quick questions, brainstorming. No extra process.
   - Tier 1 (standard): single deliverables. Claude plans, you approve, Claude executes.
   - Tier 2 (complex): multi-step work. Full planning, verification, and review.
   - Tier 3 (critical): financial, legal, or public-facing. Maximum scrutiny.

2. **Plan before doing anything.** Claude tells you what it found, what it plans to do, and what it will NOT touch. Then it waits for your "go ahead."

3. **Verify before delivering.** Claude checks its own work (counts match, facts verified, no unexpected changes).

4. **Summarize at the end.** Claude produces a session summary so you (or the next person) can pick up where you left off.

## The 7 Safety Rules (Always Active)

These are non-negotiable. Claude follows them every time.

1. **Never touch the original.** Claude works on copies. Your originals stay safe.
2. **All or nothing.** Multi-step work either all succeeds or all gets flagged.
3. **Check inputs first.** Claude verifies data before processing it.
4. **Don't assume.** Claude checks that files exist, lists have items, etc.
5. **Keep things in sync.** If changing one thing requires changing another, both happen now.
6. **Know the undo.** Before any action, Claude knows how to reverse it.
7. **You decide.** Claude recommends. You have final say. Always.

## Tips

- **For simple questions:** Just ask. The protocol classifies it as Tier 0 and adds no overhead.
- **For important work:** Fill in the ABOUT template so Claude has your company context.
- **If Claude skips the governance acknowledgment:** Say "You skipped the governance acknowledgment. Start over."
- **If Claude drifts mid-session:** Say "Run a governance pulse check." Claude will answer 3 self-check questions.
- **For long sessions:** If a conversation exceeds ~40 tool uses, context may degrade. Write a session summary and start fresh. The full [ai-governance-standards](https://github.com/strategicthings/ai-governance-standards) repo includes automatic tool counting and handoff hooks.
- **If Claude stops following the rules:** Start a new conversation and re-paste the instructions.
- **To turn it off for one task:** Say "Disable governance for this task."

## Files in This Kit

| File | What It Is |
|------|-----------|
| INSTALL-GUIDE.md | This document. How to set everything up. |
| GOVERNANCE-SKILL.md | The governance protocol. Paste this into Claude. |
| ABOUT-TEMPLATE.md | Fill this in with your company/project details. |
| QUICK-REFERENCE.md | One-page cheat sheet of the 9 steps. |
| bin/ | Hook scripts for Claude Code CLI (Option C). Session gate and session ID resolver. |
