# Session Handoff Template

> **Referenced from:** GOVERNANCE.md Section 7 (Session Handoff)
> **Required for:** Tier 1+ (recommended), Tier 2+ (required)
> **Return to:** GOVERNANCE.md Section 7

Complete this template at the end of every working session. The goal is to give the next session (whether that is you tomorrow or a different contributor) everything needed to resume work without re-investigation. Be specific. Vague handoffs waste the next session's time re-discovering context.

> **MUST (section ordering):** `## Chain Handshake` MUST be the first content section of the handoff, immediately after the frontmatter/title. Do not reorder. Do not push it to the bottom of the file. Do not omit it. The receiving chain scans from the top and the auto-spawn detector at `bin/chain-spawn.sh` expects the handshake fields to be accessible in the first ~120 lines. Placing Chain Handshake at EOF (observed 2026-04-17 in a C1-authored handoff) causes the receiving chain to scan, fail to find it, and either skip the handshake or stop with a format ambiguity. All sections below MUST appear in the order shown; additive sections (e.g. project-specific addenda) go at the end, never interleaved between the required 14.

---

## Chain Handshake

- **Sent by:** [Chain fingerprint, e.g. G20260408-143052-786-C3] at [YYYY-MM-DD HH:MM]
- **Received by:** [To be filled by receiving chain -- write your chain fingerprint and timestamp (date + time) here before starting work. Format: G{YYYYMMDD-HHMMSS-paneID}-C{N} at YYYY-MM-DD HH:MM. Example: G20260420-143022-453-C15 at 2026-04-20 14:31]
- **Closed by:** [Leave blank. Only the human operator can authorize closure. See "MUST (operator-only closure)" rule below.]

> Chain fingerprints use P51 format: `G{YYYYMMDD-HHMMSS-paneID}-C{N}`. If you are a receiving chain and "Received by" is already filled, STOP. This handoff has been claimed by another chain. Do not proceed. Alert the user.

> **MUST (sender, all handoffs including terminal close-outs):** The `Received by:` field MUST be left exactly as the bracketed `[To be filled by receiving chain -- ...]` placeholder above. Do NOT replace it with a declarative phrase, explanatory note, status comment, `N/A`, `terminal`, em-dash, or any other text. This is a required rule, not a convention. The receiving-chain handshake check pattern-matches on "looks filled" -- any value other than the unclaimed placeholder triggers the STOP block, even when no continuation was intended. Declarative values like `[terminal -- no chain continuation expected]` will cause the next auto-spawned chain to halt with a false claim-conflict.

> **MUST (terminal / close-out handoffs):** If this handoff records completed work with no next chain expected, still leave `Received by:` as the placeholder. Encode terminality elsewhere:
>
> - `## Standing Authorization` section: write `No standing authorization. Close-out record.`
> - `## Active Task` section: write `No active task. Await user direction.`
> - `## Resume Prompt` block: write `After reading, await user direction. There is no inherited task from the prior chain.`
> - `Closed by:` field in Chain Handshake (this section, above): stays blank at handoff-write time. It is written ONLY when the operator later says the chain is closed, per the operator-only MUST rule below. A handoff authored as a close-out still ships with `Closed by:` blank -- the close is an operator action, not an author action.
>
> Never encode terminality in `Received by:`. The handshake gate has no concept of "terminal"; it only checks whether the field looks claimed.

> **MUST (operator-only closure):** The `Closed by:` field is the single machine-checkable signal that a handoff is final. Once written, future chains MUST treat the handoff as closed and MUST NOT reinterpret it as an unclaimed inbound, even if `Received by:` is still the placeholder. Writing `Closed by:` is restricted to the human operator -- Claude MUST NOT self-stamp this field.
>
> **Accepted operator trigger phrases** (case-insensitive substring match against the most recent user message; any one of these authorizes writing the field):
>
> - `this chain is closed`
> - `the chain is closed`
> - `close the chain`
> - `workstream closed`
> - `close this workstream`
> - `chain closed`
>
> If the operator uses any of the above, Claude writes the line in this exact format:
>
> ```
> - **Closed by:** <Operator name>, <YYYY-MM-DD> -- "<verbatim operator phrase>"
> ```
>
> **Reversibility:** if the operator says `reopen the chain`, `reopen this chain`, or `undo the close`, Claude removes the `Closed by:` line (restoring the original blank placeholder line). No other edits to the handoff are made as part of a reopen.
>
> **Who is authoritative:** Claude never infers closure from context, memory, resume prompt wording, terminology inside the handoff body, or its own judgment that the DoD is satisfied. The operator types the trigger phrase, or the field stays blank.

---

## Blocked Priorities (optional frontmatter field)

If the receiving chain should mechanically skip one or more priorities (e.g. Priority 1 is harness-blocked / operator-only / awaiting external dependency), declare them in YAML frontmatter using the array form:

```yaml
---
chain-id: ...
priority-1: ...
priority-2: ...
priority-3: ...
blocked_priorities: [1, 3]
---
```

The bootstrap parses `blocked_priorities` BEFORE applying the Priority 1 default. Listed priorities are skipped; the bootstrap advances to the lowest unblocked priority. If all listed priorities are blocked, the bootstrap writes a no-op closure handoff and exits without re-attempting.

This field has mechanical force. Prose recommendations like "skip this priority on next chain" do not — use the structured field whenever a priority is genuinely blocked, not just deferred.

---

## Standing Authorization

**Fill this if the next chain should execute without re-approval.** Leave as-is or delete the section if no standing auth applies.

Write the declaration as a line that STARTS with one of these canonical prefixes -- left-anchored (no indent, no quote, no bullet), case-insensitive. The `chain-spawn.sh:123` detector is `^`-anchored and will not fire if the phrase is buried mid-paragraph:

- `Standing authorization: <scope>`
- `Pre-authorized: <scope>`
- `Carryover authorized: <scope>`

Example (copy and edit):

> Standing authorization: next chain executes Priority 1 (migrate CMS collection X) and Priority 2 (publish the draft). No synthesis-back. Stop and ask only on scope drift, ambiguity, or 2+ blocking errors.

If omitted, the receiving chain will hit the default synthesis-back gate and wait for user confirmation -- that is the correct behavior when standing auth was NOT granted.

---

## Business Goal

State the business objective this work serves. Not the tasks -- the outcome. Why does this work matter? What does success look like? This section must be filled at every handoff so the receiving chain understands the purpose, not just the to-do list.

- **Objective:** [What business outcome are we driving toward?]
- **Success criteria:** [How do we know we achieved it?]
- **Constraints:** [Budget, timeline, dependencies, or scope limits]

---

## Active Task

**This is the ONE thing the next chain should work on.** Everything else belongs in the Backlog section below.

- **Task:** [One sentence: what to do next]
- **Resumption point:** [Exact state -- what is done, what remains on THIS task]
- **Tools required:** [Specific MCP, API, CLI needed]
- **Acceptance criteria:** [How to know this task is done]

> If this chain was interrupted mid-task, describe where it stopped so the next chain can resume without re-investigation. If the active task is complete and no new task has been assigned, state "No active task. Await user direction."

---

## Session Info

- **Timestamp:** [YYYY-MM-DD HH:MM] to [YYYY-MM-DD HH:MM]
- **Session owner:** [Name or identifier]
- **Work stream:** [workstream-slug, e.g. `workstream-fingerprint-binding`]

> **MUST (lowercase):** Workstream slugs MUST be lowercase ASCII matching `^[a-z0-9][a-z0-9._-]{0,63}$` (canonical grammar at `bin/_ws_normalize.sh:73`). Mixed-case tags (`Z2H-A`, `featureName`) are silently rejected by the c4_link self-issue normalizer with `NORMALIZATION_REJECT reason=slug_grammar`. Use hyphen-separated lowercase: `z2h-a`, `feature-name`.
- **Project/scope:** [What area of the project this session focused on]
- **Tool count (this chain):** [~N — best-effort estimate at handoff close, for waste-pattern monitoring per `feedback_tool_call_discipline.md`]

---

## Resume Prompt

Copy the block below and paste it as the **first message** in a fresh Claude terminal session. The new session reads the referenced files to rebuild full context.

````
I'm resuming work on [PROJECT NAME] at [PROJECT PATH].

Read these files in order to get context:
1. CLAUDE.md (governance rules, project state, session checklist)
2. [HANDOFF FILE PATH] (what was done, what remains, decisions made)
3. [ADDITIONAL FILE 1 - e.g., an implementation plan, design spec, or CHANGELOG.md]
4. [ADDITIONAL FILE 2 - add as many as needed, remove if not needed]

After reading, resume from: [EXACT NEXT STEP - be specific enough that the new session can start immediately]
````

### First command field (Grammar A — optional; recommended on standing-auth)

Standing-auth chains MAY embed a literal first-command anchor on its own line within the §Resume Prompt section, using markdown bold field grammar:

```markdown
**First command (optional; recommended on standing-auth):** `bd show ai-governance-standards-<bead-id>`
```

`bin/chain-spawn.sh` (INHERITED_PLAN PROMPT-builder elif branch) extracts the backtick-wrapped bash invocation and interpolates it verbatim into the spawned-child PROMPT prose: "YOUR FIRST ACTION MUST BE: `<command>`. Execute this Bash before any synthesis, Read, or other tool call." Absent field is silent no-op (best-effort default; falls back to existing prose-only standing-auth instructions).

Threat closure: T2 (model synthesizes-back instead of executing) — mechanical first-action target reduces synthesis-window. Pairs with `bin/standing-auth-stall-detector.sh` (firing-time T1 closure). See `docs/HARNESS-GUIDE.md` `## uzt` for full mechanism, marker lifecycle, and 3-part predicate semantics.

---

## What Was Accomplished

**IMPORTANT: This section must be the LAST section written before saving the handoff.** Do not write the handoff mid-task and plan to "finish up after." Complete all work first, then document what was accomplished. If you wrote the handoff early, re-verify this section matches actual state before the session ends.

Complete list of work finished during this session. Use [x] for verified-complete items only. Each item should be specific enough to verify.

- [x] [Completed item 1 -- verified done. Include file names, feature names, or other identifiers.]
- [x] [Completed item 2 -- verified done.]
- [x] [Additional items as needed.]

---

## Backlog / Carryover

Items NOT part of the active task. The next chain should only move to these after the Active Task is complete or blocked. Apply the 3-session stale rule (HHP-2) to every carryover item. Ordered by priority. **The Tools column is mandatory.**

| # | Priority | Task | Tools Required | Blockers |
|---|----------|------|---------------|----------|
| 1 | HIGH | [Task description] | [Specific MCP, API, CLI, or "Manual: person in system"] | [None / blocker] |
| 2 | HIGH | [Task description] | [Tool details] | [None / blocker] |
| 3 | MEDIUM | [Task description] | [Tool details] | [None / blocker] |

**Tools Required examples:**
- Good: "HubSpot Automation v4 API (REST, PAT auth). See memory: reference_hubspot_automation_api.md"
- Good: "Notion MCP (fetch page 31f5235f, then update-page with content_updates)"
- Good: "Webflow MCP (CMS item update, collection 65b9f7bb9e2e5cc8a6a871b3)"
- Good: "Manual: Josh in HubSpot Settings > Connected Emails"
- Bad: "HubSpot" (too vague, which API? which tool? auth method?)

---

## Decisions Made

Decisions that affect future work. Document the decision and the reasoning so it is not revisited unnecessarily.

| Decision | Reasoning | Alternatives Considered |
|----------|-----------|------------------------|
| [What was decided] | [Why this option was chosen] | [What other options were evaluated and why they were rejected] |
| [What was decided] | [Why this option was chosen] | [Alternatives or "None"] |

---

## Rules and Patterns Established

Any new breadcrumbs, conventions, or rules that emerged during this session. These should also be added to the breadcrumbs file if they are persistent patterns.

- [Pattern or rule 1. Describe what it is and why it was established.]
- [Pattern or rule 2.]
- [Or "None this session."]

---

## Warnings for Next Session

Things that could go wrong, require caution, or need special attention. Write these as direct instructions.

- **[Warning 1]:** [What to watch out for. Be specific about the risk and what to do about it.]
- **[Warning 2]:** [What to watch out for.]
- [Or "No active warnings."]

---

## Modified Artifacts

Every file, page, DB entry, workflow, or system object touched this session. Group by system. The next session uses this to verify state and avoid conflicts.

**Notion pages:**
| Page | ID |
|------|----|
| [Page name] | [UUID] |

**Local files:**
| File Path | Change Description |
|-----------|-------------------|
| [/path/to/file] | [What was changed and why] |

**HubSpot objects (if applicable):**
| Object | ID | Change |
|--------|----|--------|
| [Workflow/List/Email/etc.] | [ID] | [What changed] |

**Memory files (if applicable):**
| File | What It Stores |
|------|---------------|
| [filename.md] | [Brief description] |

---

## Resource Links

**This section is mandatory at every handoff. Do not skip.**

Check each external system below. If it was used this session, provide the entry-point URL, portal link, or resource ID so the next session knows WHERE to go, not just which tool to use. If a system was not used, mark N/A. If you used a system not listed here, add it in the same format.

| System | Used? | Entry Point URL / ID |
|--------|-------|---------------------|
| Notion | [ ] Yes / [ ] N/A | [Workspace URL, page URLs, database UUIDs] |
| HubSpot | [ ] Yes / [ ] N/A | [Portal URL (app.hubspot.com/...), settings/workflow/list URLs] |
| Figma | [ ] Yes / [ ] N/A | [File URLs, specific frame/component links] |
| Webflow | [ ] Yes / [ ] N/A | [Site dashboard URL, CMS collection URLs, page URLs] |
| GitHub | [ ] Yes / [ ] N/A | [Repo URL, open PR/issue URLs] |
| Slack | [ ] Yes / [ ] N/A | [Channel links, canvas links] |
| PostHog | [ ] Yes / [ ] N/A | [Dashboard URLs, insight URLs] |
| Google Calendar | [ ] Yes / [ ] N/A | [Calendar or event links] |
| Fireflies | [ ] Yes / [ ] N/A | [Meeting/transcript links] |
| [Other] | [ ] Yes / [ ] N/A | [URL or ID] |

---

## Current State

Answer each question so the next session knows what they are walking into.

- **Is the project in a clean state?** [ ] Yes / [ ] No. [If no, explain what is unfinished or broken.]
- **Are there uncommitted changes?** [ ] Yes / [ ] No. [If yes, list the files and explain why they were not committed.]
- **Is anything currently broken?** [ ] Yes / [ ] No. [If yes, describe what is broken and any known workarounds.]
- **Are any processes running?** [ ] Yes / [ ] No. [If yes, describe what is running and whether it needs to be stopped or monitored.]
- **Are there pending dependencies?** [ ] Yes / [ ] No. [If yes, what is being waited on and from whom.]
