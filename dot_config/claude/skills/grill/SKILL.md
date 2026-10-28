---
name: grill
description: Interview me until the idea is a buildable spec, then write SPEC.md.
disable-model-invocation: true
---

Interview me about what I want built until nothing a builder would guess at is left open.

- One question at a time. Give 2-3 options and your pick, then wait
- Answer your own question from the codebase or the web before asking me
- Push on what's expensive to undo: data shapes, boundaries, storage, interfaces
- Skip what I won't care about. I judge outcomes (does it work, does it look good), not architecture
- Ask for keys, accounts and downloads up front so the build never stops for them

When nothing's open, write SPEC.md:
1. What it is, in 3 sentences
2. Decisions, one line each with the reason
3. Out of scope
4. Setup the build needs (keys, services)
5. Ordered TODO checklist, each item with a one-line "done when" a test or command can check

Then stop. Never start building.
