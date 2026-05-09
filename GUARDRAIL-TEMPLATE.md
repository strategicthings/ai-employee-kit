# Guardrail Template

> **Referenced from:** GOVERNANCE.md Section 1 (Invariants)
> **Required for:** Tier 1+ (fill in per project)
> **Return to:** GOVERNANCE.md Section 1

Fill in this template for each project before starting work with AI. Copy the sections below and replace the bracketed placeholders with your specifics.

---

## 1. Mission

_One sentence describing what this project must accomplish._

**Your mission:**
> [Write one clear sentence here.]

**Example:**
> Migrate the user authentication system from session-based to JWT tokens without any downtime or data loss.

---

## 2. Non-Goals

_What the AI must NOT do, even if it seems helpful. Be specific._

**Your non-goals:**
- [ ] [Thing the AI must not do]
- [ ] [Thing the AI must not do]
- [ ] [Thing the AI must not do]

**Example:**
- Do not refactor unrelated code, even if you notice improvements.
- Do not change the database schema.
- Do not modify the user-facing login UI.
- Do not update dependencies beyond what is strictly required for the migration.

---

## 3. Invariants

_Rules that can never be broken under any circumstances. If completing the task would require violating an invariant, the AI must stop and ask._

**Your invariants:**
- [ ] [Rule that must never be broken]
- [ ] [Rule that must never be broken]
- [ ] [Rule that must never be broken]

**Example:**
- All existing user sessions must remain valid during the transition period.
- No user data may be deleted or modified.
- The API response format must not change for any existing endpoint.
- All changes must pass the existing test suite before being considered complete.

---

## 4. Recovery Plan

_How to get back to the starting point if something goes wrong._

**Your recovery plan:**
> [Describe how to undo or roll back if the work fails.]

**Example:**
> Git branch "auth-migration" contains all changes. If anything fails, revert to the main branch. Database backup taken at 2026-03-23T10:00:00Z and stored in /backups/pre-migration/. Feature flag "jwt-auth" can be toggled off to revert to session-based auth without redeployment.

---

## 5. Verification Checks

_How you will know the work is correct. Be specific about what to test and what "done" looks like._

**Your verification checks:**
- [ ] [How to verify correctness]
- [ ] [How to verify correctness]
- [ ] [How to verify correctness]

**Example:**
- All existing unit and integration tests pass.
- Manual login flow works in staging with both new JWT tokens and legacy sessions.
- Load test shows no performance regression beyond 5%.
- Security scan shows no new vulnerabilities introduced.
- Token refresh flow works correctly after expiration.

---

## 6. Review Level

_Which intensity level applies to this project. Choose one._

- [ ] **Level 1. Quick Check.** Low-risk, easily reversible. A fast scan for obvious errors.
- [ ] **Level 2. Standard Review.** Typical work. Structured walkthrough of each change.
- [ ] **Level 3. Deep Audit.** High-stakes. Independent verification from multiple angles.
- [ ] **Level 4. Adversarial Review.** Critical or irreversible. Hostile review with counselor protocol.

**Example:**
> Level 3. Deep Audit. Authentication changes affect all users and involve security-sensitive code. Triangulation required.

---

## 7. Archetype

_What type of project is this? Choose one._

- [ ] **App.** Building or modifying application code (features, APIs, UI).
- [ ] **Data.** Working with databases, migrations, ETL pipelines, or analytics.
- [ ] **Content.** Writing, editing, or generating text, documentation, or media.
- [ ] **Operations.** Infrastructure, deployments, CI/CD, monitoring, or configuration.
- [ ] **Hybrid.** Combines two or more of the above. Specify which.

**Example:**
> App, with some Operations (feature flag configuration and deployment changes).

---

## 8. Environment

_Where will the AI be doing this work?_

- [ ] **CLI.** Claude Code or similar command-line interface with direct file system access.
- [ ] **Claude.ai.** Browser-based conversation. Output is text that you will apply manually.
- [ ] **Other.** Specify: [API, custom integration, etc.]

**Example:**
> CLI. Claude Code with access to the project repository at /Users/dev/projects/auth-service.

---

## Usage

Once completed, share this template with Claude at the start of your session using this phrase:

> "Here are the guardrails for this project. Read them and confirm you understand every section before we begin."

Keep this template updated as the project evolves. If the mission, non-goals, or invariants change, update this document and re-share it with Claude.
