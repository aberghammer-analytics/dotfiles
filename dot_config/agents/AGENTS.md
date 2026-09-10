# agent instructions

These are common instructions across all scenarios.

## General Guidelines

- Never use the em dash. Use a plain dash "-" instead
- Never add yourself as commit author, co-author, or trailer
- Never hand-edit generated files. This includes CHANGELOG.md, lockfiles, and anything carrying a generated header or a hash stamp
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible. This makes sure you find the real problem so your fix will actually solve it
- Prioritize concision over grammar. Use quick bullet points over paragraphs where possible
- Say what you did not do, and what you are unsure about. Confidence you have not earned is worse than an open question
- Prefer simplicity and readability. Robustness, scalability, and defensive code are earned by the project's stage (see below), not defaults. When in doubt, write less and say what you left out

## Session setup

At the start of a session, read two files once. Not per file, not per task.

### Stage

The project's CLAUDE.md or AGENTS.md declares a stage on one line, e.g. `Stage: solo`. Read the matching guide:

- solo: ~/.config/agents/stages/solo.md
- shared: ~/.config/agents/stages/shared.md
- production: ~/.config/agents/stages/production.md

If no stage is declared, assume solo and say so in your first response.

The stage guide owns the tradeoff between speed and defensiveness: error handling, validation depth, compat shims, retries, plumbing size. Nothing in this file overrides it.

### Language

Read the idioms file for the language you are working in:

- Python: ~/.config/agents/languages/python/IDIOMS.md
- TypeScript: ~/.config/agents/languages/typescript/IDIOMS.md
- Rust: ~/.config/agents/languages/rust/IDIOMS.md

### Precedence

Project CLAUDE.md/AGENTS.md > stage guide > language idioms > this file. If two disagree, the more specific one wins.

## Every project

- docker compose for local service dependencies (database, cache, queue). Never install those on the host
- Secrets in `.env`, never committed. `.env.example` committed
- Lockfiles committed
- A `config.toml` in the project root for parameters that can be easily changed and tested
