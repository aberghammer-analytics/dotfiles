<!-- STUB: written by riff from this template. Workflow conventions, commands,
     and standing rules are added by grill after scaffold — do not invent them
     before the repo has code. Grill removes this banner. -->

# {{PROJECT_NAME}}

{{ONE_LINE_DESCRIPTION}}

## Stack (draft — finalized at grill)

{{STACK_SUMMARY}} <!-- language/runtime, storage, interface shape; mark
                         anything still OPEN exactly as ARCHITECTURE.md does -->

## Architecture summary

{{THREE_TO_FIVE_SENTENCES}} <!-- the shape of the system, mirroring
                                   ARCHITECTURE.md's overview; pointers, not detail -->

## Documents

- Formats and machine contracts: SCHEMA.md (repo root)
- Product: docs/PRD.md · Architecture: docs/ARCHITECTURE.md · Phases: docs/PLAN.md
- Research context (if present): docs/RESEARCH.md

<!-- ============================================================
     Added by grill (delete this comment block when finalizing):
     ## Commands        — verify / run / test entrypoints (just verify, etc.)
     ## Conventions     — repo-specific style and structure rules
     ## Standing rules for autonomous workers:
       - Out-of-scope findings: append ONE line to docs/BACKLOG.md
         (`- [<issue-id>] YYYY-MM-DD — <finding>`). Never fix them.
       - Never edit issue frontmatter — the toolbelt owns it.
       - Never commit — wf-collect commits after independent verification.
       - Issue and artifact formats are defined in SCHEMA.md.
     ============================================================ -->
