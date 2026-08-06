---
name: riff
description: >
  Divergent design phase after a passed vibe-check. Explores the solution space,
  weighs architecture options, and drafts the core planning documents. Use when a
  repo contains docs/VIBE.md with verdict: go and the user wants to develop the
  idea — trigger phrases include "riff", "/riff". Produces DRAFT PRD.md, 
  ARCHITECTURE.md, PLAN.md and a CLAUDE.md stub — all explicitly marked draft in 
  the frontmatter to avoid anchoring before grill. Do NOT use if VIBE.md is
  missing or if PRD.md is already final.
---

# Riff

You are the generative, divergent phase. Vibe check said "worth building"; your job
is to figure out _what_ to build and _roughly how_ — producing drafts that grill
will attack. Breadth over premature precision.

## Preflight

Read `docs/VIBE.md`. Verify frontmatter: `verdict: go`. If
missing or no-go, stop and say why. Carry forward the deployment shape, cost
drivers, and riskiest assumption as design constraints, not open
questions to re-ask.

## Posture

Your task is to generate, compare, sketch. Offer options with real tradeoffs
rather than asking the user to conjure answers from nothing: "I see three shapes
this could take…" beats "what architecture do you want?". It's fine to leave
questions open — flag them as OPEN and move on; grill exists to close them. What is
NOT fine is fake certainty: every draft decision gets a one-line "why" so grill has
something to attack.

## Process

1. **Product sketch.** From VIBE.md + conversation: who uses this, the 3-5 core user
   stories, and explicitly what's OUT of scope for v1. → drives PRD.md.
2. **Architecture riff.** For each major decision (language/runtime, storage,
   API/interface shape, hosting, key libraries vs. build): present 2-3 candidates
   with pros/cons in a compact table, make a recommendation, get a reaction. Record
   decided vs. OPEN. → drives ARCHITECTURE.md.
3. **Phase sketch.** Phase 1 = MVP: the smallest coherent thing that exercises the
   riskiest assumption end to end. Phase 2 = first expansion. Phase 3+ = one line
   each, someday/maybe. Super high level — a phase is 3-6 bullets, not a task list.
   → drives PLAN.md.
4. **Write the four artifacts** (templates below). All carry `status: draft`.
5. **Hand off.** Summarize the OPEN questions count and the shakiest decisions. Prompt
   the user to call /grill next.

## Artifacts

- `docs/PRD.md` — frontmatter: stage: riff, status: draft, schema_version: 1.
  Sections: Problem / Users / Core user stories / Out of scope (v1) / Success
  criteria (how we'll know the MVP worked).
- `docs/ARCHITECTURE.md` — same frontmatter. Sections: Overview diagram (ascii is
  fine) / Decisions (table: area, choice, why, status: decided|OPEN) / Rejected
  alternatives (one line each — grill will re-litigate these, make it easy) / Cost
  notes carried from VIBE.md.
- `docs/PLAN.md` — same frontmatter, plus `phases:` list per SCHEMA.md — one entry
  per phase: `{id, name, autonomy: driver}`. Autonomy defaults to driver at this
  stage; grill sets the real values at plan approval. Body: one section per phase.
- `CLAUDE.md` (repo root) — STUB ONLY. Project one-liner, chosen stack (or leading
  candidate marked draft), architecture summary, and a visible marker:
  `<!-- STUB: workflow conventions and commands added by grill after scaffold -->`.
  Do not invent commands or conventions for a repo that has no code.

## Exit condition

All four artifacts written as drafts; OPEN questions flagged; user pointed at grill.
