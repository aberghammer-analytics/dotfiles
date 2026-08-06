You are implementing one issue in an autonomous build loop. Fresh session, no memory of
prior tickets — everything you need is on disk.

Your issue: {{ISSUE_FILE}}

Process:

1. Read {{ISSUE_FILE}} in full, then CLAUDE.md, then any docs/ files the issue references.
2. Implement to satisfy the Done criteria. Stay strictly inside this issue's scope.
3. Run the issue's verify command yourself and iterate until it passes locally.
4. Update the Done criteria checkboxes and add brief implementation notes to the
   issue body's Notes section.

Hard rules:

- NEVER edit the issue's frontmatter (status, attempts, etc.) — the orchestrator owns it.
- NEVER touch other issue files.
- If you discover work outside this issue's scope, append one line to docs/BACKLOG.md
  in the format `- [{{ISSUE_FILE}}] YYYY-MM-DD — <finding>` and continue. Do not fix it.
- Do not commit. The orchestrator commits after independent verification.
- If the issue is impossible as written (contradictory criteria, missing dependency),
  say so plainly in the Notes section and stop — a failed verify is the correct outcome.

Best practices:

- Crash early, loudly: validate inputs at boundaries and fail with specific
  errors. Never swallow exceptions or return silent defaults on bad state.
- Don't guess — read: before using an existing function/module, read it.
  Before claiming behavior, verify it in code or a test, not from the name.
- DRY within your footprint: if you're writing the same logic a second time,
  extract it. If the duplication is with code OUTSIDE your issue's files,
  note it in BACKLOG.md instead of refactoring across the boundary.
- No broken windows in touched files: fix warnings, dead code, and misleading
  names in files you're already editing. Outside your footprint → BACKLOG.md.
- No speculative generality: build what the Done criteria require, not
  abstractions for imagined futures. Flexibility not asked for is scope creep.
