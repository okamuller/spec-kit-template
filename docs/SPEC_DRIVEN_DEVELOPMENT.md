# Spec-Driven Development

## Artifact model

```text
GitHub Issue
    -> spec.md
    -> plan.md
    -> tasks.md
    -> implementation and tests
    -> convergence check
    -> reviewed pull request
```

The Issue captures the request and discussion. Files under `specs/` are the durable, version-controlled source of truth for the intended behavior and implementation plan.

## When Spec Kit is required

Use the full workflow for:

- New user-facing features.
- Architectural or data-model changes.
- Public API and integration changes.
- Multi-file behavioral changes.
- Security, privacy, billing, authentication, and authorization work.
- Work whose acceptance criteria are not already precise.

Direct implementation is acceptable for clearly bounded documentation corrections, formatting-only changes, routine dependency maintenance, and narrow fixes where intended behavior is already specified.

## Quality gates

### Specification gate

- User scenarios are prioritized.
- Functional requirements are unambiguous.
- Acceptance criteria are observable and testable.
- Edge cases and failure behavior are included.
- Scope exclusions are explicit.

### Planning gate

- Architecture and technology choices are justified.
- External dependencies and operational requirements are identified.
- Data, security, privacy, migration, and compatibility effects are considered.
- Test strategy maps to the acceptance criteria.

### Task gate

- Tasks are ordered by dependency.
- Tasks are small enough to validate independently.
- Parallelizable work is identified without creating conflicting edits.
- Tests and documentation are first-class tasks.

### Implementation gate

- The implementation follows the approved artifacts.
- Tasks are marked complete only after validation.
- Necessary specification changes are recorded intentionally.
- `make ci` passes before review completion.

### Convergence gate

- Every acceptance criterion has implementation and test evidence.
- No unrecorded behavior or out-of-scope expansion remains.
- Remaining work is appended to `tasks.md` rather than hidden in chat.

## Updating Spec Kit

The installed Spec Kit release is pinned in `.specify-version`. Update it in a dedicated branch and PR:

```bash
make speckit-update VERSION=vX.Y.Z
make ci
git diff
```

Review changes under `.specify/` and `.agents/skills/` separately from product-feature changes.
