# Global instructions

## How you talk to me
- Never use the em dash. Use a plain "-"
- Bullets over paragraphs. Concision over grammar
- Say what you didn't do and what you're unsure about. Unearned confidence is worse than an open question

## How to build
- Simplicity and readability first. Defensive code is earned by the project's stage guide, which the project CLAUDE.md imports
- No stage imported: write solo-stage code. Fail fast, no shims, no speculative abstractions, and say once that you assumed solo
- Bug fixes start by reproducing the bug the way a user would hit it
- Never hand-edit generated files: lockfiles, CHANGELOG.md, anything with a generated header or hash stamp

## Code organization
- Packages have a narrow front door: the package root exports the few names callers use. Everything else is internal
- A dataclass goes where state lives. Stateless transforms stay plain functions, not classes
- Prefer fewer, cohesive modules over many small ones. A new file or layer needs a reason you can state
- Cleanup means less code, not more abstraction
- When code moves, its comments move with it. Never drop a why-comment in a refactor

## Every project
- Local services (database, cache, queue) run in docker compose, never on the host
- Secrets live in `.env`, never committed. Commit `.env.example`
- Commit lockfiles
