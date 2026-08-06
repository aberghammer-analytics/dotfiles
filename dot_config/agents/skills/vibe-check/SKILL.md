---
name: vibe-check
description: >
  Rapid go/no-go feasibility check for a new project idea, before any repo exists.
  Use when the user floats a new idea and wants to know if it's worth building —
  trigger phrases include "vibe check", "/vibe-check", or any new project idea pitched without an existing repo.
  A ~15-minute structured brainstorm producing docs/VIBE.md with a verdict, any non-development costs (LLM, API, cloud, etc.),
---

# Vibe Check

You are running Go/No-Go Gate #0: a fast, disposable feasibility read on a new idea.
No code. No repo yet. The output is a verdict, VIBE.md, optionally RESEARCH.md, optionally a repo.

## Posture

Peer-level brainstorm, not an interrogation — one question at a time, and skip any question the user has already answered in passing. You are expected to disagree: "this already exists and the incumbent is free" or "this is three ideas wearing a trenchcoat" are valid outputs. A rubber-stamp vibe check is worthless.

Never estimate development effort or timeline — the build is agent-executed, so effort is not a decision input. Costs mean run-costs only: LLM/API calls, cloud, storage, metered third-party services.

## Process

### 1. Pitch

User states the idea in 2-3 sentences. Restate it in one plain-language sentence;
iterate until your restatement doesn't surprise them.

### 2. Purpose fork

Ask why this should exist. Three answers (mixes allowed — treat a mix as the most
demanding component):

- **product** — someone other than the user should want this → landscape scan runs.
- **fun** — building it is the point → skip the landscape scan entirely; do not
  drag the user through market questions for a toy.
- **learning** — the point is what the user absorbs → skip the market scan, but add
  one question: what specifically do you want to learn, and does building THIS
  actually exercise that?

### 3. Landscape scan (product purpose only)

Time-boxed: 3-6 web searches, fetch the 2-3 most load-bearing pages. Hunt for:

- Direct competitors and closest existing tools (commercial and open-source).
- Their pricing, and whether a good-enough free/OSS option exists.
- The gap: what would this do that they don't? Is the gap real or cosmetic?

Summarize findings to the user in a compact table BEFORE the verdict discussion —
the entire point is that they decide informed. Do not silently fold research into
the verdict. If the scan surfaced substantive material (real alternatives, pricing,
links worth keeping), write `RESEARCH.md` (template below); if it was thin, a
summary section in VIBE.md alone is fine — do not create an empty shell document.

### 4. Feasibility interview (all purposes)

Adaptive, drawing from:

- Deployment shape: what has to be running for this to be useful? (local CLI,
  self-hosted, cloud service, static site…)
- Run-cost drivers: LLM/API calls per use, GPU, storage, metered APIs. Ballpark
  monthly cost at hobby scale and at "it worked" scale.
- Are there any risky technical assumptions? If so, can it
  be tested in under an hour? (This seeds the MVP definition in riff.)
- What is the smallest thing-that-proves-it?

### 5. Pre-mortem

"Three months from now this is abandoned — what happened?" Generate 2-3 candidate
failure modes yourself and have the user react. For learning projects, the honest
variant is "you stopped because you'd learned the thing / because the project
outlived the lesson" — that can be fine, and can even argue for smaller scope.

### 6. Verdict

State go / no-go with reasoning, tuned by purpose:

- product: feasibility + cost + does the landscape leave room worth occupying.
- fun: feasibility + cost + will it actually be fun to have (not just to start).
- learning: feasibility + cost + does building this teach the target lesson.

Cost band: low <$10/mo · medium <$100/mo · high = real money. Disagree if warranted.

### 7. Write VIBE.md (and RESEARCH.md if earned)

Templates below. VIBE.md stays under a page — it is disposable by design.

### 8. Repo creation (Go verdict only — always confirm first)

Ask: "Create the repo? Proposed name: <kebab-case-name>." Never create without an
explicit yes. Check if it should exist in the current working directory or if a new
directory should be created. On approval, local-first then publish:

    mkdir <name> && cd <name>
    git init
    mkdir docs && <write docs/VIBE.md, docs/RESEARCH.md if any, copy SCHEMA.md in>
    git add -A && git commit -m "vibe-check: initial planning docs"
    gh repo create <name> --private --source=. --push

Docs only — no language scaffold (that happens at grill, after the stack is
decided). If the user declines or wants to defer publishing, leave the committed
local repo (or just the files in cwd if they decline even that) and print the
exact `gh repo create --source=. --push` command for later. Either way, end by
telling them: `cd <name>` and run `/riff` when ready.

On a No-Go, write VIBE.md to the current directory as a record and stop.

## VIBE.md template

    ---
    stage: vibe-check
    status: final
    created: <date>
    schema_version: 1
    purpose: product | fun | learning
    verdict: go | no-go
    est_cost_band: low | medium | high
    ---
    # <Project> — Vibe Check
    ## The idea (one sentence)
    ## Why it should exist (purpose)
    ## Landscape summary            <- product only; 3-5 lines + pointer to RESEARCH.md if present
    ## Deployment shape
    ## Run-cost drivers
    ## Riskiest assumption (and the <1hr test for it)
    ## Pre-mortem: likeliest causes of death
    ## Verdict & reasoning

## RESEARCH.md template (only when the scan earned it)

    ---
    stage: vibe-check
    status: living
    created: <date>
    schema_version: 1
    ---
    # <Project> — Research
    > Living document. Seeded at vibe-check; riff/grill and later work may append.
    ## Landscape
    | Name | What it is | Pricing | Why it isn't this project |
    |---|---|---|---|
    ## The gap / our angle
    ## Evidence of demand
    ## Links worth keeping
    ## Open research questions

## Exit condition

VIBE.md written with all frontmatter keys (purpose, verdict, est_cost_band);
RESEARCH.md iff the scan produced substance; repo created iff go AND user
confirmed. User pointed at `/riff`.
