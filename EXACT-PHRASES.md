# Exact Phrases

> **Referenced from:** GOVERNANCE.md Appendix A
> **Required for:** All tiers
> **Return to:** GOVERNANCE.md Appendix A

Copy-paste prompts organized by situation. Use these exact sentences when working with Claude.

---

## Starting a Task

**Starting any task.** Use this as a universal opener to establish governance context.

> "We are working under the AI Governance Protocol. I will classify the task, state the mission, non-goals, and invariants, and then we will enter plan mode before executing."

**Starting a Tier 0 (casual) task.** Use this for low-risk exploration, brainstorming, or information gathering where nothing permanent changes.

> "This is a Tier 0 task. Casual exploration only. No files will be created or modified. No governance overhead needed beyond this classification."

**Starting a Tier 1 (standard) task.** Use this for routine work with limited blast radius and easy reversibility.

> "This is a Tier 1 task. Standard governance applies. Mission: [one sentence]. Non-goals: [list]. Invariants: [list]. Enter plan mode and propose your approach."

**Starting a Tier 2 (complex) task.** Use this for multi-step work, cross-system changes, or anything that touches multiple files or services.

> "This is a Tier 2 task. Full governance applies. Mission: [one sentence]. Non-goals: [list]. Invariants: [list]. Before doing anything, capture a snapshot of the current state, then enter plan mode with a detailed breakdown of each step."

**Starting a Tier 3 (critical) task.** Use this for irreversible operations, production changes, data migrations, or anything where failure is expensive.

> "This is a Tier 3 task. Maximum governance applies. Mission: [one sentence]. Non-goals: [list]. Invariants: [list]. Capture a full snapshot first. Enter plan mode with detailed steps. I will approve each step individually before you execute it. Do not proceed without explicit approval at every stage."

---

## Setting Boundaries

**Defining non-goals.** Use this when you need to explicitly fence off what the AI should not touch.

> "Non-goals for this task: [list]. If you find yourself drifting toward any of these, stop immediately and flag it. Do not attempt these even if they seem helpful."

**Defining invariants.** Use this to set hard rules that override everything else.

> "Invariants for this task: [list]. These rules cannot be broken under any circumstances. If completing the task would require violating an invariant, stop and tell me instead of proceeding."

**Providing company context.** Use this when the AI needs background about your organization, tools, or conventions.

> "Here is the company context for this project. Read it and confirm you understand before we proceed. [Paste or reference ABOUT.md content]."

---

## Governance Enforcement (v2.0)

**If Claude's first response is missing the governance acknowledgment.** Use this to force governance re-activation.

> "You skipped the governance acknowledgment. Start over. Your first response must state: Governance active, your tier classification, your archetype, and confirm R1-R7 and I1-I9 are loaded."

**Running a governance pulse check mid-session.** Use this when you suspect drift or before accepting any deliverable as complete.

> "Run a governance pulse check. Answer: (1) Are you within the approved plan scope? (2) Are all sync dependencies current? (3) Have you made any changes I did not request?"

**Governance refresh for long sessions.** Use this when a conversation is getting long and you want to reinforce governance.

> "Governance refresh. Restate the active safety rules (R1-R7), active invariants (I1-I9), current tier, current archetype, and current plan scope. Confirm you are still following them."

**Context budget check.** Use this when you want the AI to report its context consumption.

> "How much context budget do you have remaining? What zone are you in (Green/Yellow/Orange/Red)? If you are in Orange or Red, start preparing a handoff."

**Force a handoff.** Use this when you want to end the current context window and prepare for a fresh session.

> "Prepare a handoff now. Write the full governance state snapshot, fill out the session handoff template, and give me a resume prompt I can paste into a fresh session to continue this work."

**Resume from handoff.** Use this at the start of a new session to restore governance context from a previous session.

> "[Paste the resume prompt from the previous session here.] Verify the governance state above. Restate the tier, archetype, plan scope, and where we left off. Confirm this matches your understanding before continuing."

**Post-compaction verification.** Use this after /compact to verify governance survived.

> "Governance state verification. After that compaction, restate: (1) current tier and archetype, (2) the approved plan scope and where we are in it, (3) active rules (R1-R7, I1-I9, GP-1, GP-2), (4) any decisions made so far, (5) any active warnings. Does this match what we were doing?"

**Running a compliance scorecard.** Use this to score governance adherence at any point.

> "Run a compliance scorecard check. For each of C1 through C10, state pass or fail with a one-line justification."

---

## During Work

**Requesting plan mode.** Use this to force the AI into an explore-and-propose cycle before execution.

> "Enter plan mode. Analyze the problem, outline your proposed approach step by step, and wait for my explicit approval before making any changes."

**Approving a plan.** Use this to give the green light after reviewing a proposed approach.

> "Plan approved. Execute step [number/name] and pause for verification before moving to the next step."

**Requesting a snapshot.** Use this to capture current state before changes begin.

> "Before making any changes, capture a snapshot of the current state. Include file contents, database state, configuration values, or whatever is relevant. Show it to me."

**Enforcing sync.** Use this when a change might have downstream effects that need updating.

> "This change may affect related items. Check all dependencies, references, documentation, tests, and configurations. List everything that needs to be updated for consistency and update them all."

**Checking for red flags.** Use this mid-task when something feels off or the AI seems to be drifting.

> "Pause. Before continuing, answer these questions: Are we still aligned with the original mission? Have any invariants been violated? Are there any changes you made that I did not explicitly request? Is anything out of sync?"

---

## Reviewing Output

**Quick check (Level 1).** Use this for Tier 0 and low-risk Tier 1 work where a fast scan is sufficient.

> "Do a Level 1 review. Quick scan for obvious errors, confirm the output matches the mission, and flag anything that looks off."

**Standard review (Level 2).** Use this for typical Tier 1 and Tier 2 work requiring a structured walkthrough.

> "Do a Level 2 review. Walk through each change, verify it matches the mission, check for sync issues across related items, and confirm no invariants were violated. Show me your findings."

**Deep audit with triangulation (Level 3).** Use this for high-stakes Tier 2 and Tier 3 work where independent verification is needed.

> "Do a Level 3 review. Audit every change in detail. Triangulate correctness by checking from at least two independent angles. Verify all invariants. Document any concerns, no matter how minor."

**Adversarial review with counselors (Level 4).** Use this for critical Tier 3 work where you want the AI to argue against its own output.

> "Do a Level 4 adversarial review. Assume the role of a hostile reviewer trying to find flaws. Challenge every assumption. Try to break the output. Then switch back and address every issue you found. Show me both the attack and the defense."

**Fresh eyes review (new session).** Use this when you want to eliminate confirmation bias by starting a clean session.

> "This is a fresh-eyes review session. I am going to share the output from a previous session. Your job is to review it critically without any context about the decisions that led to it. Judge only the final result against these criteria: [list criteria]."

---

## Definition of Done

**Stop phrase (when DoD is satisfied and GP-1 passes).** Use this exact structure to mark plan scope complete. Do not paraphrase. The DoD line MUST be quoted verbatim from the plan open — same words, not a summary.

> "Plan scope complete. [N/N] tasks done.
> DoD = [terminal condition quoted verbatim from plan open].
> Verification: ✅ satisfied." (or "⚠️ satisfied with deviations:" followed by bullets)
> "Stopping. Handoff follows."

**Why bracket the DoD.** Declaring DoD at plan open and quoting it verbatim at plan close lets the user compare the two statements side-by-side and confirm they match. Without the quote, "DoD satisfied" is an unverifiable assertion. Bracketing makes it a verifiable contract.

**NOTICED format (for out-of-scope observations during execution).** Use this when you notice something worth doing that is not in the current plan. Log it; do not act on it.

> "NOTICED: [description]. Not in scope. Logged for next session."

**DoD statement prompt (user to AI when starting a plan).** Use this to force an explicit terminal condition before any work begins.

> "Before proposing your plan, state the DoD = [terminal condition]. This is the contract. You stop when this condition is satisfied, not before, not after."

---

## Ending a Session

**Creating an audit trail.** Use this to document what happened during the session for future reference.

> "Create an audit trail for this session. Include: what was requested, what was done, what changed, what decisions were made and why, and any open items or known issues."

**Creating a session handoff.** Use this when work will continue in a future session or be picked up by someone else.

> "Create a session handoff note. Include: current state of the work, what is complete, what remains, any blockers or open questions, key decisions made, and the exact next step to resume."

**When the AI did something you did not ask for.** Use this to flag and roll back unauthorized changes.

> "You made a change I did not request. Specifically: [describe]. Revert that change immediately. Explain why you made it. In this session, do not make any changes beyond what I explicitly ask for."

**When something went wrong.** Use this to stop, assess, and recover from an error or unexpected outcome.

> "Stop all work. Something went wrong: [describe]. Do not make any more changes. Show me the current state compared to the last known-good snapshot. Propose a recovery plan but do not execute it until I approve."
