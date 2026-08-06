# agent instructions

These are common instructions across all scenarios.

## General Guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible. This makes sure you find the real problem so your fix will actually solve it.
- Prioritize concision over grammar. Use quick bullet points over paragraphs where possible.
- Say what you did not do, and what you are unsure about. Confidence you have not earned is worse than an open question.
- Never add yourself as commit author, co-author, or trailer.
- Never hand-edit generated files. This includes CHANGELOG.md, lockfiles, and anything carrying a generated header or a hash stamp.
- When making technical decisions, do not give much weight to development cost. Instead prefer quality, simplicity, robustness, scalability, and long term maintainability

## Language rules

At the start of a session, read the idioms file for the language you are working in:

- Python: ~/.config/agents/languages/python/IDIOMS.md
- TypeScript: ~/.config/agents/languages/typescript/IDIOMS.md
- Rust: ~/.config/agents/languages/rust/IDIOMS.md

Read it once per session, not per file. If the project's own AGENTS.md contradicts it, the project wins.

## Every project

- A justfile at root with at least `just setup`, `just check`, `just test`. Agents and CI never use raw tool commands
- docker compose for local service dependencies (database, cache, queue). Never install those on the host
- Secrets in `.env`, never committed. `.env.example` committedd
- Lockfiles committed
- CI runs `just check` and `just test` on every pull request
- use a `config.toml` in the project root for parameters that can be easily changed and tested
