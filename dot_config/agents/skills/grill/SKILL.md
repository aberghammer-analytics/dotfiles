---
name: grill
description: >
  Adversarial convergence phase that pressure-tests riff's draft plans, closes every
  open decision, scaffolds the repo, and finalizes the project-level docs. Use when
  a repo has draft PRD.md/ARCHITECTURE.md/PLAN.md and the user is ready to commit
  to the design — trigger phrases include "grill", "/grill", "grill me".
  Also use to RE-grill an existing project when a new slice
  requires architecture or scope decisions ("we need to rethink X before the next
  feature"). Interviews hard, forces every OPEN item closed, records default
  autonomy intent per phase, runs the language scaffold to a green verify baseline,
  and finalizes CLAUDE.md. Does NOT decompose phases into steps or tickets — phases
  stay high-level here. Do NOT use before riff has produced drafts.
---

# Grill

Adversarial convergence. You close decisions; you produce ZERO steps, tickets, or
task lists. If you're writing implementation steps, stop.

## Preflight

Read PRD.md, ARCHITECTURE.md, PLAN.md, CLAUDE.md stub, and RESEARCH.md if present.
Docs must exist, if not prompt the user to generate them first. If the docs are
set to `status: draft` then this is a greenfield project.

## Interrogate

One question at a time. Attack specifics, not vibes. Always offer 2-3
options + your recommendation, force a pick. Nothing stays OPEN.
Probe hardest on:

- anything that could have downstream simplicity, scaling, or other ramifications
- anything an downstream agent would have to guess.
- any decisions that are expensive to undo
- decisions where crash-early boundaries live

Use RESEARCH.md against weak differentiation.

## Then

1. Harden PLAN.md phases: 3-6 bullets each, one-line "done when" per phase, no
   steps. Phase 1 = smallest slice exercising the riskiest assumption end to end.
2. Record default autonomy per phase in PLAN.md frontmatter (binding choice
   happens at spec's gate). Default driver.
3. Scaffold: language init per ARCHITECTURE.md; `just verify` entrypoint
   (format + lint + test); one trivial passing test. Exit bar: `just verify`
   exits 0 before you finish.
4. Finalize: PRD/ARCHITECTURE/PLAN → status: final, banners removed. Rewrite
   CLAUDE.md: stack, commands, conventions, loop standing rules (findings →
   one line in docs/BACKLOG.md, never fix; never edit issue frontmatter; never
   commit — orchestrator commits). Commit all. Offer wf-render.

## Done when

No OPEN items · phases hardened with autonomy defaults · verify green · CLAUDE.md
real · committed. Point at /spec.
