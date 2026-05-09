# Rules cache

Short, always-loaded project guardrails. Keep this directory under 15k total
characters. Put long-form references, deep examples, and overflow content
in `.claude/docs/` and link from the rules files that need them.

- `.claude/rules/<topic>.md` — a quick-reference guardrail per domain.
- `.claude/docs/<topic>-detail.md` — anything that would bloat the rules file.

The SessionStart hook `bin/rules-hygiene-check.sh` warns when the rules
directory exceeds the budget. Move overflow rather than silencing the warning.

See `rules-hygiene.md` for the enforcement policy.
