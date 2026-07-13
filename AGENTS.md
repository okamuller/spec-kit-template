# AGENTS.md

## Repository purpose

This repository uses Spec-Driven Development. GitHub is the source of truth for requirements, specifications, implementation, validation, and review.

## Required reading

Before making a non-trivial change:

1. Read this file completely.
2. Read `.specify/memory/constitution.md` when it exists.
3. Identify the active feature directory under `specs/`.
4. Read its `spec.md`, `plan.md`, and `tasks.md` when present.
5. Read any more specific `AGENTS.md` in the target directory.

## Standard commands

Use the repository commands below instead of inventing alternatives:

- Setup: `./scripts/setup.sh` or `make setup`
- Static checks: `./scripts/check.sh` or `make check`
- Tests: `./scripts/test.sh` or `make test`
- Full validation: `./scripts/ci.sh` or `make ci`

If a standard script lacks support for the project stack, improve the script in the same change.

## Spec-driven workflow

Use Spec Kit for new features, architectural changes, multi-file behavioral changes, public API changes, data-model changes, security-sensitive work, and changes with ambiguous acceptance criteria.

Preferred sequence for Codex Skills mode:

1. `$speckit-constitution`
2. `$speckit-specify`
3. `$speckit-clarify`
4. `$speckit-plan`
5. `$speckit-tasks`
6. `$speckit-analyze`
7. `$speckit-implement`
8. `$speckit-converge`

Do not implement a non-trivial feature until:

- `spec.md` contains testable acceptance criteria.
- Material ambiguities are resolved or recorded as explicit assumptions.
- `plan.md` exists and describes the technical approach.
- `tasks.md` exists and has an executable order.
- The specification, plan, and tasks are mutually consistent.

Small documentation corrections, formatting-only changes, dependency-only maintenance, and narrowly scoped bug fixes may be implemented directly when the intended behavior is already unambiguous.

## Artifact discipline

- Requirements belong in `spec.md`, not only in chat or an Issue comment.
- Technical decisions belong in `plan.md` or an architecture decision record.
- Executable work belongs in `tasks.md`.
- Update specifications intentionally when behavior changes.
- Never rewrite a specification silently merely to match an incorrect implementation.
- Keep Spec Kit tooling upgrades separate from product-feature changes.

## GitHub workflow

For non-trivial features, use:

- One GitHub Issue describing the goal and constraints.
- One feature branch.
- One feature directory under `specs/`.
- One Draft PR linked to the Issue.

The PR must describe:

- What changed and why.
- The relevant specification directory.
- Implemented user stories and acceptance criteria.
- Validation commands and results.
- Known deviations, assumptions, and remaining tasks.

## Safety and scope

- Never commit credentials, access tokens, private keys, production data, or generated secrets.
- Do not modify unrelated files.
- Do not weaken tests, linters, or type checks merely to make CI pass.
- Do not access external systems unless the task requires it and authorization is clear.
- Prefer deterministic tests and local fakes over live external APIs.
- Preserve backward compatibility unless the specification explicitly authorizes a breaking change.

## Completion criteria

A change is complete only when:

- The requested behavior is implemented.
- Relevant specifications and tasks are current.
- `make ci` passes, or every failure is reported with evidence.
- The diff contains no unrelated changes or secrets.
- The PR summary is sufficient for review without reconstructing the agent conversation.
