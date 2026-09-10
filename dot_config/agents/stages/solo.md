# Stage: solo

**Who consumes this code:** the author, and only the author. Nobody else runs it, reads it, edits its config, or depends on its interfaces. The author is present for every failure and will fix the cause.

Optimize for readability and speed of iteration. The shape can still change; the error handling can wait until the shape stops moving.

## Errors and validation

- Fail fast on the first error with one clear message. No error aggregation, no "report every problem in one pass," no problem/report abstractions or modules dedicated to them.
- Use the exception the library already raises. A validation library's error already names the key, the type, and the location. No custom exception classes or hierarchies until a caller needs to catch one case and not another — and that caller doesn't exist yet.
- Before adding a defensive check, name the concrete scenario where the author hits it. "Someone might" is not a scenario. If the answer is "the author would have to do something they know not to do," don't add it.
- The one class of validation that earns its place now is anything that prevents _silent_ wrong output — a misspelled key that maps to the wrong resource, a path that resolves somewhere unexpected, a config that loads but means something different from what was written. Those fail loudly. Everything else is deferred.
- No retry, backoff, or graceful-degradation logic unless the author has already hit the flaky call. Let it crash; the author is watching.

## Scope discipline

- No backwards-compat shims, aliases, or deprecation paths for renamed things. Rename the callers.
- One mechanism per concern. One way to locate config, one way to load secrets, one way to override a value. No local-override overlays, no env-var-plus-file-plus-flag precedence chains.
- Don't build for hypothetical second users, second environments, second engines, or second platforms until the first one works end to end.
- Plumbing modules — config, logging, CLI wiring, app factory — should fit in roughly 100 lines. Past that, stop and ask whether the extra lines are shape or ceremony.
- Comments explain _why_, not which design-decision number they satisfy.
- Tests cover behavior the author would otherwise verify by hand every run. No test-for-the-sake-of-coverage on trivial paths.

## What is worth getting right now

Things that are expensive to change once code depends on them:

- Data model shapes and the boundaries between them
- Where secrets live (env, never config files) and where config lives
- Path resolution rules (relative to what?)
- Immutability and strictness of config objects (`frozen`, reject unknown keys)
- The function signatures other modules import
- Package/module layout and front doors

Spend effort here. Error ergonomics, packaging, and docs are additive later; these are not.
