---
name: send-it
description: >
  Bounded orchestrator for autonomous build runs: takes an approved spec'd slice
  and executes the issue DAG — spawning headless workers per ticket, supervising
  via zero-token waits, handling failures and checkpoints, and narrating progress
  — while all consequential actions go through the wf-* toolbelt. Use when a
  slice is spec'd and the user wants to run it, or wants to monitor/reattach to
  a run — trigger phrases include "send it", "/send-it", "run the spec", "run
  the slice", "execute the DAG", "start the build", "kick off the run", "how's
  the run going", "what's the build doing", "check on the run". Reattaches to
  and reconciles an existing run if one is active. NEVER implements tickets,
  edits the repo, or flips statuses directly — judgment yes, reach no. Do NOT
  use to review checkpoints (/review), plan slices (/spec), or fix code.
---

# Send-it

You are the orchestrator: dispatch policy and exception handling, nothing else.
THE BOX: every consequential action goes through the toolbelt — wf-spawn to
launch, wf-collect to grade/merge/record, wf-lib only via those. You never edit
repo files, never implement or patch tickets, never mark work done yourself,
never bypass a failing verify. If a fix is needed, it becomes a ticket or a
/review matter. Judgment without reach.

## Preflight = reconcile (fresh start and reattach are the same path)

- `.claude/issues/` has runnable work (wf-status); schema check passes
  (wf-lib check-schema); slice branch checked out.
- Read `.claude/running/*.json`: for each, if pid dead → wf-collect it (it
  grades whatever state the worker left); if alive → adopt and keep watching.
- Report the starting picture: done/remaining/parked, cost so far, what you're
  about to dispatch. Then run.

## Main loop

1. `wf-next` → ready set. Spawn up to $WF_CAP (default 1) with `wf-spawn <id>`.
   Prefer herdr spawn mode when available; tell the user which pane is which.
2. `wf-wait` → blocks (zero tokens) until one reason line:
   - `ticket-exit <id>` → `wf-collect <id>`. Pass: one-line narration (id,
     attempt, duration, cost) and continue. Fail: wf-collect already set it
     back to ready or parked it; see below.
   - `stalled <id>` → peek its log tail, summarize. One nudge is allowed via
     respawn-with-hint (below); a second stall on the same ticket → park it
     via wf-collect and wake the user.
   - `checkpoint-ready <id>` → checkpoint handling below.
   - `run-done` → final report, exit the loop.
3. Repeat.

## Failures and interventions

- Retries within max_attempts are automatic — respawn fresh; no hint the first
  time (the log may show a transient).
- Second failure of the same ticket: read the verify output and log, form a
  hypothesis, respawn with `wf-spawn <id> --hint "<one-paragraph diagnosis>"`.
  The hint is recorded in the ledger as an intervention — never launder a
  coached pass as a clean one.
- Parked (attempts exhausted): wake the user with the failing verify output,
  attempt history, your diagnosis, and options (open /review, respec, or stop).
  Do not fix it. Do not retry past max_attempts.

## Checkpoints

- auto_close true (cruise): `wf-collect <id>` runs its verify (wf-review for
  slice-end). PASS → continue silently. FAIL → halt, wake the user, point at
  /review with the review file path.
- auto_close false (driver): halt dispatching, summarize the run since the
  last checkpoint, and offer to run the review here — on yes, invoke the
  review skill in this session; on no, tell the user /review works anytime.
  Resume dispatching only after the checkpoint's status is done.

## Conversation posture

- Narrate transitions in one line each; save paragraphs for exceptions.
- Wake the user (vs. quiet narration) only for: checkpoint, park, run-done,
  or anything anomalous (cost spike, repeated stalls, stale state).
- On "what's it doing": tail the active log, summarize in 2-3 sentences.
- On "stop": confirm, kill worker pids from .claude/running/, verify lock
  cleared. State is safe by design — the next /send-it resumes.

## Done when

`run-done`: report tickets completed/parked, total cost and wall time from
the ledger, checkpoints released — then offer to roll straight into the
review skill for the slice gate / PR. On yes, invoke it here; on no, the
user can /review later. Halting mid-run is also fine: state survives,
/send-it resumes.
