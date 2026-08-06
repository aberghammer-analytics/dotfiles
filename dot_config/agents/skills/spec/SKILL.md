---
name: spec
description: >
  Slice-level execution planning: takes one slice of a grilled project (the MVP,
  the next phase, a named feature), details it into sized steps, gates the plan
  through an HTML review via wf-render, and on confirmation generates the issue
  DAG for wf-loop. Use when project docs are final and the user wants to plan and
  launch a slice — trigger phrases include "spec", "/spec", "spec it out", "spec
  the MVP", "spec phase 2", "spec out <feature>", "plan the next slice", "break
  this into issues", "generate the tickets". Permanent re-entry point for ongoing
  projects — every new phase or feature comes through spec. Drafts autonomously;
  human judgment enters at the review gate, not an interview. Do NOT use if
  PRD/ARCHITECTURE/PLAN are still draft (run grill first). Makes no design
  decisions — structural problems go back to grill.
---

# Spec

You sequence; grill decided. Draft autonomously, decide nothing. Any ambiguity
requiring a design choice = stop, name it precisely, send the user to grill.
Do not interview — the user's first input moment is the rendered review.

## Preflight

- PRD, ARCHITECTURE, PLAN all `status: final` — else stop, point at grill.
- Run the verify command from CLAUDE.md once. Red tree = stop.
- Read `.claude/issues/` if present (prior slices are context; ids continue
  globally, never reuse) and `.claude/ledger.jsonl` (powers the gate's cost
  estimate). Read the project's SCHEMA.md.

## 1. Pick the slice

Default: first incomplete phase in PLAN.md; or the user names one. An unplanned
feature is acceptable if it fits the decided architecture and scope — otherwise
grill escape. If the invocation is ambiguous about WHAT the slice covers, ask 1-3 scope
questions before drafting — clarifying intent, never eliciting design (design
gaps are grill escapes, not questions). If the docs + invocation already pin
the scope, ask nothing and draft.

## 2. Draft the slice plan

Decompose into ordered steps. Per step: name, one-paragraph description, done
criteria checklist, verify command (default `just verify`; add step-specific
checks only if the target exists or the step creates it), expected file
footprint, dependencies.

- Sizing: ~20% of a fresh context window — diff reviewable
  in one sitting, describable in one paragraph. Bigger → split; trivial → merge.
- Checkpoints: end of slice always; mid-slice at natural review seams if large.
  Proposed auto_close from the phase's default autonomy in PLAN.md.
- Order tracer-first: the earliest steps produce a thin end-to-end path through
  the slice — one input flowing to one output, ugly is fine. Breadth, edge
  cases, and polish come after the tracer works.
- Prefer orthogonal steps: minimize shared file footprints between steps so
  each diff is independently reviewable (and parallelizable later).

## 3. Gate

Write the review artifact to `.claude/review/<slice>-plan.html` (gitignored).
Before writing: run `lavish-axi playbook plan` and `playbook diagram` (plus
`comparison` if applicable) and follow them. The page must show: step graph
with dependencies (Mermaid), per-step done criteria + verify commands,
checkpoint positions with driver/cruise settings, file footprints, cost
estimate from ledger actuals if history exists.
Open with `npx -y lavish-axi .claude/review/<slice>-plan.html`, then run
`lavish-axi poll` and leave it running.

## 4. Revise (bounded)

Feedback arrives via poll. Sequencing feedback (split/merge/reorder, tighten
criteria, move checkpoints, flip autonomy) → update the plan AND the artifact,
reply with `--agent-reply`, keep polling. Structural feedback (wrong approach,
wrong scope) → grill escape: say so via --agent-reply, end the session, stop.
Confirmation = the user says ship it (or Send & End with approval). Autonomy
settings on the confirmed artifact are binding.

## 5. On confirm

- Write `docs/plans/<slice>.md` (frontmatter: stage: spec, status: final, slice,
  date) — the durable record of what was approved.
- Generate `.claude/issues/{id}-{slug}.md` per SCHEMA.md: one per step plus
  checkpoints. `blocked_by` = step dependencies + implicit edge to the previous
  step unless genuinely independent (over-block freely; v1 is sequential).
  `status: ready` if no blockers, else `backlog`. Body: `## Context` (2-4
  sentences + pointers into docs/ — the ticket agent has no other memory),
  `## Done criteria`, `## Notes` (empty).
- Validate: no cycles, all blocked_by ids exist, every task has a verify, ids
  unique. Fail loudly.
- Regenerate `.claude/issues/OVERVIEW.md` (generated — never hand-edited).
- Commit.

## Done when

Approved plan in docs/plans/ · valid DAG continuing the global id sequence ·
OVERVIEW.md regenerated · committed. Tell the user: run `wf-loop` from a
terminal (tmux recommended), not from this session.
