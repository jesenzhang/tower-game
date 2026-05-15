# Skill Routing Table Template

This template generates `docs/agents/skill-routing.md`.

## Generation Rules

1. The "Installed Skills" table is populated from scanning `.claude/skills/*/SKILL.md`.
2. The "Routing Table" is static but "Availability" column is adapted.
3. Translate prose to `DOMINANT_LANGUAGE` if needed. Keep skill names in English.
4. Add a note at the top about installing mattpocock/skills if core skills are missing.

## Template

```markdown
# Skill Routing

When AGENTS.md routes a task, use this table to determine the correct behavior.

> **Note:** Skills marked "Emulated inline" are not installed. For full functionality, run `npx skills add mattpocock/skills` to install the complete mattpocock/skills package.

## Routing Table

### Core Workflow Skills (from mattpocock/skills)

| Signal | Route To | Behavior | Availability |
|--------|----------|----------|--------------|
| Vague idea / unclear requirement | grill-me | Ask probing questions until requirement is clear | {{INSTALLED_OR_EMULATED}} |
| Product requirement | to-prd | Generate PRD from conversation context | {{INSTALLED_OR_EMULATED}} |
| Large feature | to-issues | Split into vertical slices, create issues | {{INSTALLED_OR_EMULATED}} |
| Bug / failing behavior | diagnose | Disciplined diagnosis: reproduce → minimise → hypothesise → fix → regression-test | {{INSTALLED_OR_EMULATED}} |
| Bug triage | triage | Triage issues through a state machine of roles | {{INSTALLED_OR_EMULATED}} |
| Implementation | tdd | Red-green-refactor loop, one vertical slice at a time | {{INSTALLED_OR_EMULATED}} |
| Architecture degradation | improve-codebase-architecture | Find deepening opportunities | {{INSTALLED_OR_EMULATED}} |
| Repeated team process | write-a-skill | Create reusable skill with proper structure | {{INSTALLED_OR_EMULATED}} |
| Plan validation against docs | grill-with-docs | Challenge plan against domain model, update CONTEXT.md/ADRs | {{INSTALLED_OR_EMULATED}} |
| Prototype / design exploration | prototype | Build throwaway prototype to flesh out a design | {{INSTALLED_OR_EMULATED}} |
| Need broader context | zoom-out | Get higher-level perspective on unfamiliar code | {{INSTALLED_OR_EMULATED}} |

### Safety & Setup Skills (from mattpocock/skills)

| Signal | Route To | Behavior | Availability |
|--------|----------|----------|--------------|
| Pre-commit hooks needed | setup-pre-commit | Configure Husky with lint-staged, Prettier, type checking, tests | {{INSTALLED_OR_EMULATED}} |
| Dangerous git commands | git-guardrails-claude-code | Block push, reset --hard, clean, etc. via hooks | {{INSTALLED_OR_EMULATED}} |
| Initial repo setup | setup-matt-pocock-skills | Scaffold per-repo config (issue tracker, labels, domain doc layout) | {{INSTALLED_OR_EMULATED}} |

### Utility Skills

| Signal | Route To | Behavior | Availability |
|--------|----------|----------|--------------|
| Token-saving communication | caveman | Ultra-compressed mode, ~75% fewer tokens | {{INSTALLED_OR_EMULATED}} |
| Agent handoff | handoff | Compact conversation into handoff document | {{INSTALLED_OR_EMULATED}} |
| Code quality review | simplify | Review for reuse, quality, efficiency | {{INSTALLED_OR_EMULATED}} |
| DevOps / operation scripts | generate-devops-scripts | Generate project scripts | {{INSTALLED_OR_EMULATED}} |
| Repository agent rules | generate-agents-md | Generate/update AGENTS.md | {{INSTALLED_OR_EMULATED}} |
| Project template setup | bootstrap-agentic-workflow | Bootstrap agentic workflow infrastructure | {{INSTALLED_OR_EMULATED}} |
| Behavioral guidelines | karpathy-guidelines | Reduce common LLM coding mistakes | {{INSTALLED_OR_EMULATED}} |

## Availability Values

- **Installed** — A skill file exists in `.claude/skills/<name>/SKILL.md`. Use it directly.
- **Installed (platform)** — The skill is built into Claude Code. Invoke via the Skill tool.
- **Emulated inline** — No skill file exists. The agent should follow the behavior described below without invoking a named skill.

## Installed Skills

{{INSTALLED_SKILLS_TABLE}}

## Behavior Descriptions (for emulated skills)

### grill-me (Emulated)

When a request is vague or ambiguous:
1. Do not start coding.
2. Ask the user 5-10 targeted questions covering: scope, edge cases, error handling, dependencies, acceptance criteria.
3. Iterate until the requirement is testable.
4. Proceed to Phase 2.

### to-prd (Emulated)

When a product-level requirement is clear:
1. Create `docs/prd/prd-<feature-name>.md`.
2. Include: Background, Goals, Non-Goals, Acceptance Criteria, Affected Systems, Dependencies.
3. Optionally create a GitHub Issue linking to the PRD.

### to-issues (Emulated)

When a PRD is ready:
1. Break the PRD into vertical slices.
2. Each slice delivers one small, runnable piece of value.
3. Create issues using the template from `issue-lifecycle.md`.
4. Mark dependencies between issues.

### tdd (Emulated)

When implementing a task:
1. **Red:** Write a test that fails and describes expected behavior.
2. **Green:** Write minimum code to make the test pass.
3. **Refactor:** Clean up while keeping tests green.
4. Repeat until the issue's acceptance criteria are met.

### diagnose (Emulated)

When a bug or failing behavior is reported:
1. Reproduce the issue.
2. Minimize the reproduction case.
3. Form a hypothesis about root cause.
4. Add instrumentation if needed.
5. Fix and verify.
6. Create a regression test.

### triage (Emulated)

When triaging an issue:
1. Investigate the issue by exploring the codebase.
2. Determine: Is this a bug? Feature request? Documentation gap?
3. Find the root cause or affected module.
4. Create a new issue with TDD fix plan if it's a bug.
```

## INSTALLED_SKILLS_TABLE Generation

For each file in `.claude/skills/*/SKILL.md`:

```markdown
| Skill | Location | Trigger |
|-------|----------|---------|
| {{name}} | `.claude/skills/{{name}}/` | {{description (first sentence)}} |
```

## Availability Determination

For each routing entry:
1. Check if a skill with that exact name exists in `.claude/skills/`.
2. If yes: "Installed".
3. If no, check if the skill is built into Claude Code (platform-level). If listed in the system's available skills: "Installed (platform)".
4. Otherwise: "Emulated inline".
