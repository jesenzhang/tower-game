# CLAUDE.md Template

CLAUDE.md is the Claude Code specific entry point. It is intentionally minimal because the real routing intelligence lives in AGENTS.md.

## Template

```markdown
# CLAUDE.md

Read [AGENTS.md](AGENTS.md) first. It contains the agent operating protocol, architecture rules, and project commands.

## Installed Skills

| Skill | Purpose |
|-------|---------|
{{SKILL_TABLE_ROWS}}
```

## Generation Rules

1. **SKILL_TABLE_ROWS**: For each skill found in `.claude/skills/*/SKILL.md`, extract `name` and `description` from frontmatter. Format as `| name | description |`.

2. **Keep it short**: CLAUDE.md should never exceed 30 lines. Everything substantial belongs in AGENTS.md.

3. **If CLAUDE.md already exists**: Merge the installed skills table and the AGENTS.md reference. Preserve any user-specific instructions (preferences, memory paths, etc.).

4. **If the user has a global `~/.claude/CLAUDE.md`**: Do not duplicate its content. The project CLAUDE.md is project-specific and supplements the global one.

## Example Output

```markdown
# CLAUDE.md

Read [AGENTS.md](AGENTS.md) first. It contains the agent operating protocol, architecture rules, and project commands.

## Installed Skills

| Skill | Purpose |
|-------|---------|
| karpathy-guidelines | Behavioral guidelines to reduce common LLM coding mistakes |
| improve-codebase-architecture | Find deepening opportunities informed by domain language |
| generate-agents-md | Generate or update repository-specific AGENTS.md |
| generate-devops-scripts | Generate complete set of project operation scripts |
| bootstrap-agentic-workflow | Bootstrap a project with full agentic coding workflow |
```
