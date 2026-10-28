# Stage: production

**Who consumes this code:** strangers. People the author will never talk to depend on its interfaces, run it in environments the author can't see, and feed it input the author didn't anticipate. This covers published libraries, services others build against, and anything with a public surface.

Optimize for stability and for failures being diagnosable without the author. This is the stage where defensive code earns its keep — but it still has to earn it.

## Errors and validation

- Validate at every public boundary and assume input is malformed. Internal functions past the boundary can trust their inputs; re-validating internally is noise.
- Report every problem in one pass wherever a human will be editing the input by hand (config, manifests, schemas). One round-trip per error is unacceptable when the user can't ask you what's wrong.
- Error types are part of the public API. Stable names, documented, catchable individually. A hierarchy is appropriate when callers need to catch at different granularities; keep it shallow and don't add levels speculatively.
- Every error message includes what happened, where (file, key, line, request ID), and what to do about it. Never leak secrets or internal paths into messages that cross the boundary.
- Retries, timeouts, and backoff on every external call, with limits. Idempotency on anything that can be retried.
- Never swallow exceptions. Log and re-raise, or handle and document why.

## Scope discipline

- Backwards compatibility is a policy, written down, and followed. Breaking changes are versioned and announced. Deprecation paths exist and have timelines.
- The public surface is deliberately small. Everything not explicitly public is private, and the code makes that visible. Adding to the public surface is a decision; removing from it is a breaking change.
- Configuration has documented precedence (defaults → file → env → flags, or whatever is chosen) in exactly one place, and the code follows it exactly.
- Complexity is still not free. Defensive code that handles a case no user can reach is still clutter; the test for a check is "what input triggers this," and the answer must be concrete.
- Tests cover contracts, edge cases at the boundary, failure modes, and every bug that has ever shipped. Regression tests are mandatory for fixes.

## What is worth getting right now

- Semantic versioning, a changelog, and a release process
- Docstrings and examples on every public interface
- Structured logging with correlation IDs where requests cross boundaries
- Health checks, metrics, or whatever the runtime environment needs to know the thing is alive
- Security posture for secrets, network egress, filesystem access, and deserialization of untrusted input
- Dependency pinning, lockfiles, and a policy for updating them
- Documentation that answers the questions the author would otherwise be asked
