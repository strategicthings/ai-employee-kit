# AI Governance Glossary

> **Referenced from:** GOVERNANCE.md (reference as needed)
> **Required for:** All tiers
> **Return to:** GOVERNANCE.md

This glossary defines every term used in the AI Governance Protocol. If you encounter a word you do not understand in any governance document, check here first.

---

**Adversarial Review**
A review where one or more **Counselors** deliberately try to break, exploit, or find flaws in a deliverable. The goal is to surface problems before they reach production, not to be hostile. Think of it as a stress test performed by someone whose job is to poke holes.

**Alias Resolution**
The process of figuring out that two different names refer to the same thing. For example, if one file calls something "client" and another calls it "customer," alias resolution confirms they mean the same entity and maps them together.

**All-or-Nothing (Atomic Operations)**
A rule that says a set of changes must either all succeed together or all fail together. No partial updates. If step three of five fails, steps one and two get rolled back as if they never happened.

**Archetype (Project Archetype)**
A reusable project template that defines the standard structure, gates, and expectations for a specific type of work. Instead of starting from scratch every time, you pick the archetype that matches your project and it gives you the skeleton.

**Audit Trail**
A chronological record of every significant action taken during a project, including who did it, when, and why. It exists so that anyone can reconstruct what happened after the fact.

**Blocking Gate**
A checkpoint that must be passed before work can continue. If the gate's criteria are not met, progress stops. No exceptions, no workarounds. Compare with non-blocking checks that only produce warnings.

**BLOCK / WARN / LOG (Consequence Levels)**
The three severity levels the system can apply when a rule is triggered. BLOCK stops the action entirely. WARN lets the action proceed but flags it for attention. LOG silently records the event for future review without interrupting anything.

**Bootstrap (Self-Governance Bootstrap)**
The initial setup process that gets the governance system running on a new project. It creates the foundational files, configurations, and rules that everything else depends on. Like installing an operating system before you can run any programs.

**Breadcrumbs**
Small, structured references left in files that point to related information elsewhere. They help anyone navigating the system follow a trail from one document to the decisions, context, or files that inform it.

**Canonical**
The one official, authoritative version of something. If multiple copies or descriptions of the same thing exist, the canonical version is the one that wins when there is a conflict. Everything else must match it or be considered wrong.

**Cascade (SSOT Cascade)**
The process by which a change to a **Canonical** source automatically propagates to every file or system that depends on it. When the single source of truth changes, everything downstream must update to stay in sync.

**Change Control**
The formal process for proposing, reviewing, and approving modifications to governed files. You cannot just edit things directly. Changes go through a defined workflow so nothing gets altered without visibility and sign-off.

**CLI (Command Line Interface)**
A text-based way of interacting with a computer by typing commands instead of clicking buttons. In this system, it refers to the tool (such as Claude Code) that the AI agent operates through.

**Compaction**
Server-side summarization of conversation history when the context window approaches capacity. The API replaces earlier conversation turns with a condensed summary. Governance state must survive compaction (see CL-9 and I8). Compaction extends a single context window; it does not create a new one.

**Completion Rubric**
A checklist of specific, measurable criteria that define when a task or project phase is truly done. It removes ambiguity about what "finished" means by spelling out exactly what must be true before something can be marked complete.

**Consequence Level**
The severity of the system's response when a rule is triggered. See **BLOCK / WARN / LOG** for the three levels.

**Context Awareness**
A capability in newer Claude models (Sonnet 4.6, Sonnet 4.5, Haiku 4.5+) where the model receives its total token budget at session start and remaining token counts after each tool call. This allows the model to manage its own context consumption and trigger handoffs proactively rather than running out of context unexpectedly.

**Context Budget**
The total token capacity available in a context window (e.g., 1,000,000 tokens for Claude Opus 4.6). Used as input tokens accumulate through conversation turns, tool calls, and file reads. Non-renewable within a single context window.

**Context Window**
The total text a language model can reference when generating a response, including the response itself. This is the model's "working memory" for the current session. Different from the model's training data. Larger context windows allow more complex work but accuracy degrades as token count grows (context rot).

**Counselor (AI Counselor)**
An AI agent assigned to review, challenge, or validate work produced by another AI agent. Counselors serve as a quality control layer, providing independent judgment before deliverables are finalized.

**Data Contract**
A formal agreement about the exact shape, format, and rules for a piece of data. It specifies what fields exist, what types they are, which are required, and what valid values look like. If data does not match its contract, something is wrong.

**Definition of Done (DoD)**
The terminal condition stated in a plan that defines when work is complete. When the DoD statement is satisfied and GP-1 passes, the chain states the stop phrase and halts; it does not do additional discretionary work.

**Dependency Map**
A document or diagram that shows which files, systems, or components rely on which others. It answers the question: "If I change this thing, what else will be affected?"

**Divergence (SSOT Divergence)**
A state where a downstream file or system has fallen out of sync with its **Canonical** source. Divergence is a problem because it means two places disagree about what is true, and someone will eventually act on the wrong information.

**Enforcement Tag**
A label embedded in a governance rule that tells the system how strictly to enforce it. The tag maps to a **Consequence Level** (BLOCK, WARN, or LOG) so the system knows what to do when the rule is triggered.

**Environment Adaptation**
The ability of governance rules to adjust their behavior based on the context they are running in. A rule might enforce strictly in production but only warn during local development. The rule itself does not change, but how it responds does.

**Fresh Eyes (Fresh Eyes Principle)**
The practice of having someone (or some agent) who was not involved in creating a deliverable review it from scratch. The idea is that a new perspective catches problems that the original creator is too close to see.

**Function Registry**
A centralized list of every function or tool available to AI agents in the system, including what each one does, what inputs it expects, and what outputs it produces. It prevents agents from calling things that do not exist or using them incorrectly.

**Golden File / Golden Test**
A known-good reference output that is stored and used to verify future outputs. When you run a test, you compare the result against the golden file. If they match, the test passes. If they differ, something changed and needs investigation.

**Governance Bridge**
A connector that links two governance systems or two parts of the same system that were designed separately. It translates rules, formats, or conventions from one side to the other so they can work together without conflict.

**Guardrail**
A rule or constraint that prevents AI agents from doing something harmful, unauthorized, or out of scope. Guardrails define the boundaries of acceptable behavior. They say "you must not" or "you must always" regardless of what the task instructions say.

**Handoff (Session Handoff)**
The structured transfer of context, progress, and next steps from one AI **Session** to the next. Because sessions do not share memory automatically, a handoff document captures everything the next session needs to continue without losing ground.

**Invariant**
A condition that must always be true, no matter what. If an invariant is ever violated, something has gone fundamentally wrong. For example, "every file must have exactly one owner" could be an invariant. There are no circumstances where breaking it is acceptable.

**Multi-Reviewer Protocol**
A review process that requires more than one independent **Counselor** to evaluate a deliverable. It reduces the risk of a single reviewer missing something and adds confidence through independent agreement.

**Non-Goal**
Something the project explicitly will not try to achieve. Listing non-goals is just as important as listing goals because it prevents scope creep and sets clear expectations about what is out of bounds.

**Operator Track / Builder Track**
Two distinct paths through the governance system based on role. The Operator Track is for people who use and configure the system. The Builder Track is for people who extend or modify the system itself. Each track has different permissions, rules, and expectations.

**Plan Mode**
A phase where the AI agent outlines what it intends to do before doing it. In plan mode, no changes are made to any files. The agent produces a proposal for human review and only proceeds to execution after approval.

**Precedence (Rule Precedence)**
The order in which rules are applied when two or more rules conflict. Higher-precedence rules override lower-precedence ones. **Safety Rules** always have the highest precedence.

**Pre-Flight Questions**
A set of clarifying questions the AI agent asks before starting work on a task. They ensure the agent has enough context and that assumptions are validated before effort is spent. Think of it as a pilot's checklist before takeoff.

**Recovery Playbook**
A step-by-step guide for getting back to a working state after something goes wrong. Each playbook covers a specific failure scenario and provides concrete actions, not general advice. The goal is to make recovery fast and repeatable.

**Retrospective**
A structured review conducted after a project or phase is complete. It examines what went well, what went poorly, and what should change for next time. Findings are recorded and fed back into the governance system to improve future work.

**Resume Prompt**
A standardized block of text generated at the end of a context window that contains all governance state needed to continue work in a fresh session. The resume prompt is self-contained: a new session with only the resume prompt can continue correctly without access to the prior conversation.

**Review Intensity Level**
A setting that controls how thorough a review should be, based on the risk and complexity of the work. Low-intensity reviews might be a quick scan. High-intensity reviews involve multiple **Counselors**, **Adversarial Review**, and detailed checklists.

**Safety Rule**
A governance rule that exists to prevent data loss, security breaches, or other serious harm. Safety rules have the highest **Precedence** and are always enforced at the BLOCK level. They cannot be overridden by task instructions or agent judgment.

**Semver (Semantic Versioning)**
A versioning system that uses three numbers separated by dots (e.g., 2.1.0). The first number means a breaking change. The second means a new feature that does not break existing behavior. The third means a bug fix. It tells you at a glance how significant a change is.

**Session (AI Session)**
A single, continuous interaction between a human and an AI agent. Sessions have a defined start and end. Because AI agents lose memory between sessions, governance rules require explicit **Handoff** documents to maintain continuity.

**Snapshot**
A complete, frozen copy of the system's state at a specific point in time. Snapshots are used for backups, comparisons, and recovery. They let you answer the question: "What did everything look like at 3:00 PM last Tuesday?"

**SSOT (Single Source of Truth)**
The one authoritative location where a piece of information lives. All other references to that information must point back to the SSOT or be derived from it. If the SSOT and a copy disagree, the SSOT wins. Always.

**Sync Enforcement / Sync Matrix**
The mechanism that checks whether downstream files and systems are still aligned with their **SSOT**. The sync matrix is a table that maps each source to its dependents and tracks whether they are in sync or have **Diverged**.

**Task Classification Tier**
A category assigned to a task based on its complexity, risk, and required oversight. Higher tiers require more review, more gates, and stricter enforcement. The tier determines which governance rules apply and how intensely.

**Three-Way Triangulation**
A verification method that cross-references three independent sources to confirm a piece of information. If all three agree, confidence is high. If they disagree, the discrepancy must be investigated before proceeding.

**Traceability (Traceability ID)**
The ability to follow any deliverable, decision, or change back to the requirement, conversation, or approval that caused it. A Traceability ID is a unique identifier assigned to items so they can be tracked across documents and systems without ambiguity.

**Track (Operator / Builder)**
See **Operator Track / Builder Track**.

**Window Transition**
The event where one context window ends and a new one begins. The handoff artifact (including the resume prompt) is the only bridge between windows. Each window is treated as an independent governed session with perfect context about prior work.

**CI-Enforced**
An **Enforcement Tag** indicating the rule is automatically checked by a continuous integration pipeline (a system that runs tests and checks every time code is submitted). If the check fails, the submission is blocked. 100% reliable when configured.

**Escalation Chain**
The sequence of people or actions to try when a problem cannot be resolved at the current level. Typically: self-resolve first, then ask for a fresh AI review, then escalate to the project owner, then stop AI-assisted work and proceed manually.

**Feedback Loop**
The process by which real-world experience (what went wrong, what worked, what was unnecessary) gets fed back into governance rules to improve them over time. The quarterly **Retrospective** is the formal mechanism for this.

**Hook-Enforced**
An **Enforcement Tag** indicating the rule is automatically checked by a git hook (a script that runs before you can save your work). 98% reliable. Can be bypassed if someone runs commands directly instead of through the normal workflow.

**Migration Checklist**
A step-by-step list of tasks to complete when upgrading from one **Task Classification Tier** to the next. For example, upgrading from Tier 1 to Tier 2 requires creating session protocols, setting up handoff processes, and scheduling counselor reviews.

**Pattern Capture**
The practice of documenting a critical rule, constraint, or lesson learned as a **Breadcrumb** so that future sessions do not repeat past mistakes. Happens during work (immediately when discovered) and during **Retrospectives** (periodic review).

**Red Flag**
A warning sign during AI-assisted work that indicates something may be going wrong. Examples: the AI says "I will update that later," the AI wants to delete something to "start fresh," or numbers do not match between two views. When you see a red flag, pause and investigate.

**Severity (Recovery)**
The three levels of incident severity in the **Recovery Playbook**. Severity 1: something looks off but nothing is broken. Severity 2: something is definitely wrong. Severity 3: data has been lost or corrupted. Higher severity means more cautious response (stop earlier, do less, restore from backup).

**Smart Defaults**
Pre-configured settings and assumptions for each **Project Archetype**. For example, App projects default to TypeScript and test-driven development. Data projects default to snapshot-first and immutable sources. These are starting points that can be overridden.

**Task Router**
The decision tree at the beginning of GOVERNANCE.md (Section 0) that classifies your task into a **Task Classification Tier** (0-3) and selects your **Track** (Operator or Builder). This determines how much governance process applies to your work.

**Environment Detection**
The process of identifying whether you are working in a CLI environment (like Claude Code) or a web UI environment (like Claude.ai). This matters because some governance rules are automated in CLI but require manual discipline in web UI. See **Environment Adaptation**.

**Zone (Context Zone)**
A classification of context budget consumption: Green (>40% remaining, normal operation), Yellow (25-40%, tighten responses), Orange (15-25%, warn user and prepare handoff), Red (<15%, stop new work and write handoff), Critical (<5%, emergency stop).
