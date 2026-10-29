# Stage: shared

**Who consumes this code:** a small, known group — teammates, a friend, a client — who run it, read it, and edit its config. The author still owns it and is reachable, but is not present for every failure. Someone else will hit the error first and read the message cold.

Optimize for other people being able to run it and understand it without asking. Interfaces stabilize; internals can still move.

## Errors and validation

- Messages a non-author can hit say what to do next — which key to fix, which env var to set, which command to run — not just what went wrong.
- Fail fast is still the default, but validate the whole config file before failing when the audience will be editing it by hand. Aggregated _config_ errors are worth it here; aggregated errors everywhere else are not.
- Custom exception types are allowed when a caller needs to distinguish cases. One or two named exceptions per boundary, not a hierarchy. Add them when the caller appears, not before.
- The "name the concrete scenario" test still applies, but the population of scenarios is larger: someone unfamiliar with the project, someone with a different environment, someone who skipped the README.
- Retries and graceful degradation for external calls that a user can't easily re-trigger (long renders, paid API calls). Still no retry logic for things the user can just run again.

## Scope discipline

- Public interfaces are stable. Renaming something others call means a deprecation note and a transition, not a silent rename. Internal helpers can still be renamed freely.
- Compat shims are permitted at the public boundary only, with a removal date in the comment.
- One mechanism per concern still holds, but a documented override path is reasonable (an env var pointing at an alternate config, say). Document the precedence in one place.
- Plumbing modules may grow past the solo budget to serve the above, but the growth should be traceable to a specific consumer need, not speculative.
- Tests cover the contracts other people rely on: the public API, the config schema, the file formats. A breaking change should fail a test before it reaches a consumer.

## What is worth getting right now

- README that gets a stranger from clone to first run
- Example config with every key present and commented
- Public API surface named and typed; the boundary between public and internal is visible in the code (naming, module layout, `__all__` or equivalent)
- Version pinning for dependencies; a lockfile committed
- Logging that a non-author can read to figure out what happened
