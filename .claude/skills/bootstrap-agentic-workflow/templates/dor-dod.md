# Definition of Ready / Definition of Done Template

This template generates `docs/agents/dor-dod.md`.

## Generation Rules

1. Translate to `DOMINANT_LANGUAGE` if needed.
2. Adapt the "tests" requirement based on `HAS_TESTS`.
3. Adapt the "quality gate" requirement based on whether `scripts/agent-check.sh` was generated.

## Template

```markdown
# Definition of Ready (DoR)

A task is ready for implementation when all of the following are true:

1. **Requirement is stated in clear, testable terms.** No ambiguity about what "done" looks like.
2. **Acceptance criteria are defined.** Each criterion is a boolean check (pass/fail).
3. **Affected modules/systems are identified.** The task lists which files or systems will change.
4. **Dependencies are resolved or explicitly noted.** Blocked tasks are marked with the blocking issue.
5. **The scope fits a vertical slice.** One small, runnable feature — not a horizontal layer.
6. **No open questions that would block a TDD cycle.** If unsure, route back to grill-me.

If any of these are missing, do not start implementation. Route back to:
- Phase 1 (grill-me) for unclear requirements.
- Phase 2 (to-prd / to-issues) for missing acceptance criteria or oversized scope.

---

# Definition of Done (DoD)

A task is done only when **all** of the following are true:

1. **Requested behavior is implemented.** The code does what the issue describes.
2. **Tests are added or updated.**
   {{TEST_REQUIREMENT}}
3. **Quality gate passes.** `./scripts/agent-check.sh` exits with code 0.
   {{QUALITY_GATE_FALLBACK}}
4. **No unrelated files were modified.** The diff contains only changes relevant to the task.
5. **Documentation is updated** when behavior, commands, or architecture changed.
6. **The final response summarizes:**
   - What changed and why.
   - Which files changed.
   - Which commands were run and their results.
   - Any known risks or follow-up work.

---

## Quality Gate Override

If `scripts/agent-check.sh` does not exist or cannot run:

1. Run available checks manually (lint, test, format) as individual commands.
2. Report which checks passed and which were skipped.
3. Note in the commit message or PR description that the quality gate was not available.
```

## Adaptation: TEST_REQUIREMENT

### If HAS_TESTS is true:
```
- Every new behavior has a corresponding test.
- Every modified behavior has an updated test.
- All tests pass.
```

### If HAS_TESTS is false:
```
- Manual verification steps are documented in the commit message.
- The expected behavior is described as a structured comment in the code.
- Consider adding a test framework to enable automated verification.
```

### Godot-specific:
```
- JSON data files are validated if modified.
- Scene files (.tscn) are verified to open without errors in the editor.
- If GUT/GdUnit4 is available: write GDScript unit tests.
- If no test runner: document manual verification steps.
```

## Adaptation: QUALITY_GATE_FALLBACK

### If scripts/agent-check.sh was generated:
```
If the quality gate fails, do not claim completion. Fix the issues and re-run.
```

### If scripts/agent-check.sh was NOT generated:
```
(Quality gate script not available. Run detected checks manually.)
```
