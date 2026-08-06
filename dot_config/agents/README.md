# agentic-workflow

A plan-first, agent-executed development pipeline. Human judgment concentrates at the
edges — design going in, review coming out — and a bounded orchestrator runs the middle.
This repo is the whole system: the skills that shape planning sessions, the toolbelt
that enforces execution invariants, and the templates that define the contracts. It is
harness-agnostic by construction and portable by symlink: clone it, run `./install.sh`,
and every machine behaves the same.

The operating philosophy, in one paragraph: own the judgment layers (skills, schema,
orchestration policy) and adopt the plumbing (lavish for HTML review, herdr for agent
panes, gh for GitHub, codex as the second-vendor reviewer, treehouse later for parallel
worktrees). Agents get judgment without reach — every consequential action (status
flips, ledger writes, verify runs, merges) happens only through `bin/` scripts, so the
orchestrator cannot lie to the ledger even on a bad day. Trust is earned per phase and
evidenced by the run ledger, never assumed.

## The pipeline

```
/vibe-check ──► /riff ──► /grill ──► /spec ──► /send-it ──► /review ──► PR
 go/no-go      diverge    converge   sequence   execute      gate
                                       ▲                       │
                                       └── every later slice ──┘
```

| Stage          | What it is                                                                                                                                                        | You do                                                     | It produces                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| **vibe-check** | ~15-min go/no-go on a new idea; purpose fork (product / fun / learning); landscape web-scan for product ideas; run-costs only, never effort                       | answer questions, react to research, confirm repo creation | `docs/VIBE.md`, optional `RESEARCH.md`, the git repo (docs-only)                        |
| **riff**       | divergent design: options with tradeoffs, drafts everything                                                                                                       | react to 2-3 candidate shapes per decision                 | draft `PRD.md`, `ARCHITECTURE.md`, `PLAN.md`, `CLAUDE.md` stub                          |
| **grill**      | adversarial convergence: closes every OPEN decision, scaffolds the repo. **Decides; zero steps**                                                                  | get interrogated; pick when forced                         | final docs, green `just verify` baseline, real `CLAUDE.md`, per-phase autonomy defaults |
| **spec**       | sequences ONE slice into an executable plan. **Sequences; zero decisions.** Asks 1-3 scope questions only if the invocation is vague; design gaps escape to grill | review the lavish HTML gate, annotate, confirm             | approved plan in `docs/plans/`, issue DAG in `.claude/issues/`, `slice/<name>` branch   |
| **send-it**    | bounded orchestrator session: spawns headless workers per ticket, supervises via zero-token waits, handles retries/hints/parks, halts at checkpoints              | watch (or leave — it reconciles), respond when woken       | completed tickets, ledger lines, halted checkpoints                                     |
| **review**     | human gate: cross-model review + your read + lavish artifact; triage findings; release checkpoint or open the PR                                                  | annotate, disposition each finding, approve                | released checkpoint or `gh pr create` from the slice branch                             |

Everything human-facing is a CC session. The only non-session processes are the headless
ticket workers — and with herdr spawn mode, even those are visible panes.

## Day-to-day usage

**New project:** start a session in your projects directory (not inside a repo) and
pitch the idea — "sanity check this: a CLI that…" triggers vibe-check. On a Go it
creates the repo; `cd` in and continue through riff → grill. Grill can roll straight
into spec; spec ends with "run wf-loop / send-it". Open the run session inside herdr:
`/send-it`. When it halts at a checkpoint it offers to roll into review in-session.

**Existing project — the routing rule:** _does this work require any decision the
finalized docs don't already answer?_ No → `/spec <feature>` (put the scope in the
invocation and it goes straight to the draft). Yes → `/grill <what's being reopened>`
first (scoped re-grill, only the affected decisions), then spec. Default to spec when
unsure: a wrong guess self-corrects cheaply — spec grill-escapes in-session, the one
decision gets closed, spec resumes. Backlog grooming is the same door:
`/spec groom the backlog into a cleanup slice`.

**Mid-run:** kill the send-it session anytime; state lives on disk. A new `/send-it`
reconciles (`.claude/running/` pids checked, finished work collected, orphans re-spawned
or parked) and carries on. Fire-and-forget alternative: `wf-loop` from a terminal — the
headless rump runner, which is also the completeness check: if it can't run a DAG
without the agent, invariants have leaked into the send-it skill.

## The toolbelt (`bin/`)

| Script                    | Job                                                                                                                   | Invariant it owns                                             |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `wf-lib.py`               | frontmatter parse/mutate, ready-set, schema check                                                                     | only code path that touches issue frontmatter                 |
| `wf-next`                 | dispatchable set: blockers done, minus footprint overlaps with live workers                                           | dispatch eligibility                                          |
| `wf-spawn <id> [--hint]`  | bump attempts, launch headless worker (herdr pane or background), write running-file                                  | launch shape; hints recorded, never laundered                 |
| `wf-wait`                 | block (zero tokens) until: `ticket-exit` / `stalled` / `checkpoint-ready` / `dispatch-ready` / `blocked` / `run-done` | supervision without polling                                   |
| `wf-collect <id>`         | run verify independently, flip status, commit, write ledger; close checkpoints                                        | truth: the ONLY writer of verify results, ledger, done/parked |
| `wf-review [--since ref]` | diff → second-vendor reviewer → `VERDICT: PASS/FAIL`, exit code; fail-closed                                          | independent cross-model review                                |
| `wf-status`               | DAG + ledger + run summary                                                                                            | human/skill-readable state                                    |
| `wf-loop`                 | sequential rump over the primitives                                                                                   | toolbelt completeness                                         |

Workers never commit, never edit frontmatter, never grade themselves — `wf-collect`
runs verify independently and commits `wf: complete issue <id>` / `wf: checkpoint <id>`
(wf-review greps that prefix for its default range).

## Review: three layers

Per-ticket: the issue's `verify` command (format/lint/tests), run by the worker to
iterate and by wf-collect to grade — twice, independently. End-of-slice: the slice-end
checkpoint's verify is `wf-review` — a different vendor reviews the whole-slice diff
against the approved plan; BLOCKER ⇒ FAIL, MAJOR/MINOR recorded but non-gating.
Human: `/review` before the PR — runs the same engine, adds its own read, renders
findings and disagreements via lavish, and every finding gets dispositioned: blocking
(new fix tickets added to the checkpoint's blocked_by), backlog (one line in
BACKLOG.md), or explicitly accepted. Review never fixes code.

Driver vs cruise changes only _who closes the gate_ — the cross-model review runs
either way. Promote a phase to cruise only when the ledger argues for it; coached
passes (`intervention: retry-with-hint`) are distinguishable from clean ones for
exactly this reason.

## Contracts and layout

`templates/SCHEMA.md` is the treaty: repo layout, artifact frontmatter, the issue
schema, ledger format, git conventions, config vars. The master lives here; a pinned
copy lands in every project at creation so repos self-describe. Scripts don't read it —
they embody it and enforce only `schema_version` (refuse loudly on mismatch). The
discipline: any format change bumps the version in both `wf-lib.py` and the doc, with
a migration note.

This repo: `bin/` (toolbelt) · `skills/` (the six, symlinked into the Claude config
skills dir) · `templates/` (SCHEMA.md and CLAUDE.stub.md get copied into projects;
ticket-prompt.md and review-prompt.md are runtime fallbacks — project overrides at
`.claude/ticket-prompt.md` / `.claude/review-prompt.md` win) · `languages/` (per-stack
scaffold recipes grill applies: init, lint/format config, test stub, the `just verify`
recipe) · `AGENTS.md` (the real file; `~/.config/claude/CLAUDE.md` symlinks to it —
keep its content global-scope, since every session everywhere inherits it).

In each project: `docs/` is human-audience prose (PRD, ARCHITECTURE, PLAN, VIBE,
BACKLOG, `plans/` for approved slice plans); `.claude/` is machine state (issues,
ledger, reviews — committed; logs, running, review artifacts, run.lock — gitignored).
Committed state is what makes any clone resumable and the trust evidence portable.

## Install & config

```
git clone <this repo> ~/.config/agents && cd ~/.config/agents && ./install.sh
```

Symlink-only and idempotent: skills → Claude config skills dir, bin → `~/.local/bin`
(edits here are live everywhere); `--uninstall` removes only its own links. Sanity:
`command -v wf-loop`, then say "sanity check this idea: …" in a fresh session and
confirm vibe-check fires without the slash command.

Config is env, never code: `WF_CLAUDE_BIN` / `WF_CLAUDE_FLAGS` (worker harness —
note the default includes `--dangerously-skip-permissions`; that's a deliberate choice
for local worktree use), `WF_REVIEW_BIN` (must be a different vendor than the worker),
`WF_SPAWN_MODE=herdr|background`, `WF_CAP` (1 until treehouse lands), `WF_STALL_SECS`.

Dependencies: Claude Code · codex CLI · `gh` (authenticated) · `just` · lavish-axi
(via npx; install the skill once: `npx skills add kunchenguid/lavish-axi --skill
lavish -g`) · herdr (optional; background mode is the fallback) · python3 + bash only
for the toolbelt — no pip deps, ever.

## Roadmap and standing risks

v1 is sequential (`WF_CAP=1`) with the primitives already parallel-shaped: v2 is
raising the cap + adopting treehouse worktrees, plus smart backlog triage and
cruise-promotion tooling over the ledger. v1.5 is plugin packaging (marketplace.json
draft exists) — after dogfooding, not before.

Watch for: judgment leaking into the box (every new orchestrator capability must
arrive as a script — the wf-loop rump must always be able to run a DAG alone);
schema drift (version-bump discipline); ledger fiction (only wf-collect writes it);
two writers on one tree (the orchestrator session is read-only during runs).
