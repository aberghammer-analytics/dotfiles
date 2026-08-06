---
name: review
description: >
  Human review gate for autonomous build runs: gathers the diff since the last
  checkpoint, runs the cross-model reviewer (wf-review), presents diff +
  findings + disagreements as a lavish artifact for annotation, and on approval
  releases the checkpoint or opens the PR from the slice branch. Use when a run
  has halted at a checkpoint, a cruise review FAILed, or a slice is complete
  and the user wants the pre-PR review — trigger phrases include "review",
  "/review", "review the checkpoint", "what did the loop build", "review the
  slice", "let's look at what it did", "ready to PR this". Reviews and gates
  only — NEVER fixes code (fixes become tickets or backlog lines). Do NOT use
  for reviewing plans (that's spec's gate) or for general code questions.
---

# Review

You review and gate. You never fix: every finding becomes a blocking fix
ticket, a BACKLOG.md line, or an explicit acceptance. If you are editing
source code, stop.

## Preflight

- No active run (`.claude/running/` empty or all pids dead; no run.lock).
- Identify the waiting checkpoint (type: checkpoint, status != done, blockers
  done). None waiting + slice complete = pre-PR mode.
- Range: last `wf: checkpoint` commit (else merge-base with main) → HEAD.
- Read the slice plan (docs/plans/), the issues in range, ledger lines for the
  run, and any existing wf-review output in .claude/reviews/ (a cruise FAIL
  arrives with one already written — don't re-run, read it).

## Process

1. Ensure a cross-model review exists for the range: run `wf-review` if none.
2. Form your own read of the diff. Note where you and the cross-model reviewer
   disagree — disagreements are the highest-value items to surface.
3. Build a lavish artifact (playbooks: plan, table, diagram as applicable) at
   `.claude/review/<checkpoint-id>.html`: diff summary by issue, findings
   table (severity, file:line, yours vs cross-model), disagreements
   highlighted, ledger stats (cost, attempts, interventions, failures).
   Open with `npx -y lavish-axi`, then poll.
4. Triage each finding with the user: blocking / backlog / accept.
   - Backlog → one line each in docs/BACKLOG.md.
   - Blocking → checkpoint stays closed; write fix issue(s) continuing the
     global id sequence, added to the checkpoint's blocked_by. Tell the user
     to re-run /send-it.
   - Structural (wrong architecture, wrong scope) → grill escape.
5. On approval with nothing blocking:
   - Mid-slice checkpoint: status → done, commit (`wf: checkpoint <id>`),
     point back at /send-it.
   - Slice end / pre-PR: status → done, commit, then offer
     `gh pr create --base main --head slice/<name>` with a body summarizing
     the slice plan, findings and their dispositions, and ledger stats.
     User confirms before any PR is created.

## Done when

Checkpoint released (or PR opened) with every finding dispositioned — fixed-
via-ticket, backlogged, or explicitly accepted — and zero code edited by you.
