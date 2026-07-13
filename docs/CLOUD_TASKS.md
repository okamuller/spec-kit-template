# Cloud task workflow

This guide provides copy-ready prompts for Codex cloud tasks started from ChatGPT on iPhone or another client.

## 1. Create specifications without implementation

```text
Work on Issue #123 using Spec-Driven Development.

Run $speckit-specify, $speckit-clarify, $speckit-plan, $speckit-tasks, and $speckit-analyze in that order.

Do not modify production code in this task. Resolve ordinary ambiguities with conservative assumptions and record each assumption explicitly. Stop and report only when a decision would materially change product scope, security, cost, or compatibility.

Completion criteria:
- A feature branch exists.
- specs/NNN-feature contains spec.md, plan.md, and tasks.md.
- Acceptance criteria are observable and testable.
- No material inconsistency remains across the artifacts.
- A Draft PR links Issue #123 and summarizes the assumptions.
```

## 2. Revise specifications from PR feedback

```text
Update the active specification from the unresolved PR feedback.

Revise spec.md first, then propagate the approved behavioral changes into plan.md and tasks.md. Do not implement production code. Do not silently change requirements merely to fit an existing implementation. Report any reviewer requests that conflict with each other or with the project constitution.
```

## 3. Implement an approved specification

```text
Implement the approved feature specification under specs/NNN-feature.

Use $speckit-implement. Follow tasks.md order and dependencies, mark completed tasks accurately, and keep the change within the approved scope. When implementation exposes a necessary specification change, record and justify it before changing behavior.

Run make ci and update the existing Draft PR with validation results, assumptions, deviations, and remaining work.
```

## 4. Converge implementation and specification

```text
Run $speckit-converge for specs/NNN-feature.

Compare the implementation with spec.md, plan.md, and tasks.md. Add missing work to tasks.md, fix in-scope discrepancies, and add or repair tests for uncovered acceptance criteria. Do not erase a valid requirement to make the implementation appear complete.

Run make ci and update the PR summary with the final convergence result.
```

## Recommended unit of work

Use one Issue, one feature branch, one `specs/NNN-feature/` directory, and one Draft PR for each non-trivial feature. Keep specification-only tasks separate from implementation tasks so the product intent can be reviewed before code is generated.
