---
name: yolo-build
description: Autonomously build an entire project end-to-end from a yolo-grill contract (SPEC.md + TODO.md + DECISIONS.md in the working directory) with zero questions to the user. Trigger on "/yolo-build", "build the contract", "full-send it", "run the yolo build", "resume the build", or whenever the user asks to build/continue a project in a directory containing a SPEC.md and TODO.md contract. Also triggers for resuming — a TODO.md with some items already checked means continue from the first unchecked item. Do NOT trigger for projects without a contract on disk (run yolo-grill first), or for work/high-stakes projects (use Superpowers). This skill never asks the user anything — it decides, logs the decision, and keeps building.
---

# yolo-build

Phase two of the funsies pipeline. A contract exists on disk. Your job: make every TODO item checked, verified, and committed — without asking the user a single question, ever.

## The prime directive

**You never ask the user anything.** Every fork in the road, you decide, log one dated line with rationale in DECISIONS.md, and keep moving. If a decision feels too big to make alone, that is not an exception — that is exactly the decision DECISIONS.md exists for. The user reads it in the morning; that's the deal.

The only legitimate reason to stop early is a broken contract: no SPEC.md/TODO.md present, or a TODO item whose done-criteria are genuinely uninterpretable. Then say precisely what's missing and stop. (An *ambiguous* item is not broken — interpret it, log the interpretation, build it.)

## Startup sequence

1. Read SPEC.md, TODO.md, DECISIONS.md in full. Skim issues/.
2. **Resume check:** any `- [x]` items in TODO.md means this is a resume. Confirm the checked items actually hold (spot-run their verification if fast), note "resumed" in DECISIONS.md, and continue from the first unchecked item. Never redo checked work; never ask what happened.
3. If SPEC.md changed since decisions were logged (user hand-edited it overnight), the spec wins. Reconcile: log what changed and what you're reworking, adjust TODO.md, proceed.
4. If this is a fresh start: `git init` if needed, scaffold the project (your choice of stack unless SPEC.md hard-constrains it — log the choice), first commit.

## Size the job, pick the mode

Make one judgment call up front and log it:

**In-session mode** (default for small prototypes): build right here, item by item, until TODO.md is empty. Use subagents where available to implement in fresh context and review with clean eyes; you stay orchestrator.

**Loop mode** (when the TODO clearly exceeds what one session can finish — lots of content items, big surface area): write two files and hand off to the shell:

`PROMPT.md`:
```
Read SPEC.md, TODO.md, DECISIONS.md. Take the FIRST unchecked TODO item only.
Implement it. Verify it per its stated method. Check it off. Log any decisions
in DECISIONS.md. Commit with a message naming the item. If you notice an
unrelated bug, file it in issues/ and do NOT fix it. If all TODO items are
checked, triage issues/: fix P0s one per iteration, then output DONE.
```

`loop.sh`:
```bash
#!/usr/bin/env bash
while :; do
  claude -p "$(cat PROMPT.md)" --dangerously-skip-permissions
done
```

Then your final message: tell the user to run `./loop.sh` in a git worktree or container (skip-permissions demands isolation — say so plainly), and that the build will take it from there. That ends your involvement.

## Per-item discipline (both modes)

For each TODO item, in order:

1. **Implement** the item and only the item. Scope creep goes to TODO.md as a new unchecked item or to issues/, not into this diff.
2. **Verify per the item's stated method — no honor system.**
   - UI/interaction: drive it with Playwright (simulate the actual keypresses/clicks), assert state, take a screenshot, and *look at the screenshot* — judge whether it visually matches the spec, not just whether selectors exist.
   - Logic: automated test that fails before the change and passes after.
   - If verification fails, fix and re-verify before touching the checkbox.
3. **Check it off** in TODO.md.
4. **Commit** — one commit per item, message names the item. Browsable history over one 4,000-line diff, always.
5. **Log** any decisions made along the way in DECISIONS.md (dated, one line + rationale each).

Bugs found that aren't the current item: `issues/NNN-short-name.md` with repro and severity (P0 = breaks core experience, P1 = annoying, P2 = cosmetic). Then back to the current item. Drive-by fixes are how autonomous builds unravel.

## Definition of done

All of:
- Every TODO.md item checked, each verified by its stated method
- The SPEC.md "Definition of done" holds (typically: one command serves the running project locally)
- No open P0 in issues/
- DECISIONS.md reads as a complete story of the build
- A short `README.md` exists: what it is, how to run it, one screenshot if applicable

Everything stays local. No deployment, no publishing, no external services beyond what SPEC.md demands.

## Closing message

When done (in-session mode), the final message is short: how to run it, item count completed, open P1/P2 count, and "DECISIONS.md has the story." No walkthrough of the code, no asking whether they'd like changes — if they want changes, they'll edit SPEC.md and run you again.
