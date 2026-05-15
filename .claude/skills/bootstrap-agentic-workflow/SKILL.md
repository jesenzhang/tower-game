---
name: bootstrap-agentic-workflow
description: >-
  Bootstrap a project with a full agentic coding workflow infrastructure.
  Generates AGENTS.md dispatcher with auto-routing, docs/agents/* workflow
  documents (6-phase paradigm), scripts/* quality gates, CI configuration,
  and CLAUDE.md — all adapted to the detected project type. Use when setting
  up a new project for AI-assisted development, initializing agent workflow
  infrastructure, or converting an existing project to use the agentic paradigm.
---

# Bootstrap Agentic Workflow

Generate the three-layer agentic coding infrastructure for any project:

- **Layer 1** — `AGENTS.md` as a dispatcher with hard rules and auto-routing
- **Layer 2** — `docs/agents/*` with workflow documents, DoR/DoD, issue lifecycle
- **Layer 3** — `scripts/` and CI configuration for quality gates

All generated content is adapted to the detected project type. No fabrication.

## When To Use

Use this skill when the user asks to:

- Init project template, bootstrap agentic project
- Set up agent workflow, create agent infrastructure
- Initialize AI development workflow
- Generate project scaffolding for AI-assisted dev
- Add the 6-phase workflow to a project

## Prerequisites

This skill relies on the **mattpocock/skills** package for core workflow skills: `grill-me`, `to-prd`, `to-issues`, `tdd`, `triage`, `diagnose`, `grill-with-docs`, `write-a-skill`, `setup-pre-commit`, `git-guardrails-claude-code`, `zoom-out`, `handoff`, and `caveman`.

If these skills are not installed, the skill routing table will mark them as "Emulated inline" (the agent mimics the behavior without the full skill file). For the best experience, install them before running this skill:

```bash
npx skills add mattpocock/skills
```

See https://github.com/mattpocock/skills for the full list and installation instructions.

## Core Principles

1. **Never overwrite existing files without explicit user confirmation.**
2. **Detect before generating.** Derive all values from the actual project.
3. **Adapt to project type.** Godot, Python+Node, Rust, Go — each gets different checks and sections.
4. **Integrate with existing skills.** Scan `.claude/skills/` and include in routing table.
5. **Prefer truth over completeness.** If a tool isn't detected, say so. Don't invent commands.
6. **Generate in phases.** Let the user review each layer before proceeding.
7. **Match the project's language.** If existing docs are Chinese, generate Chinese docs.
8. **Install mattpocock/skills when missing.** If core skills are absent, offer to install them.

---

## Operating Procedure

### Step 1: Detect Project Profile

Read [project-profile.md](detection/project-profile.md) for the full detection procedure.

1. Scan for project type signal files (project.godot, Cargo.toml, go.mod, pyproject.toml, package.json).
2. Resolve all template variables (TEST_COMMAND, LINT_COMMAND, etc.).
3. Scan `.claude/skills/*/SKILL.md` to catalog existing skills.
4. Check for existing files that would be affected (AGENTS.md, CLAUDE.md, docs/agents/*, scripts/*).
5. Determine `DOMINANT_LANGUAGE` from existing docs.

Present the detected profile to the user as a summary table. If any critical variable is "Not detected", ask the user (max 5 questions, batched).

### Step 2: Confirm Scope and Resolve Conflicts

1. If existing files would be overwritten, present the conflict list:
   - File path
   - What exists vs. what would be generated
   - Options: Skip / Overwrite / Merge
2. Confirm `DOMINANT_LANGUAGE` for generated docs.
3. Confirm CI platform if not detected.
4. Wait for user confirmation before generating anything.

### Step 3: Install mattpocock/skills (if needed)

Check whether the core workflow skills from mattpocock/skills are installed:

**Core skills needed:**
- `grill-me` — Requirement alignment
- `to-prd` — PRD generation
- `to-issues` — Task breakdown into vertical slices
- `tdd` — Test-driven development
- `triage` — Bug triage
- `diagnose` — Bug diagnosis loop
- `grill-with-docs` — Plan validation against domain model
- `write-a-skill` — Create new skills

**Safety skills needed:**
- `setup-pre-commit` — Husky pre-commit hooks
- `git-guardrails-claude-code` — Block dangerous git commands

**Procedure:**

1. Scan `.claude/skills/` for the skills listed above.
2. If any are missing:
   - Inform the user which skills are missing.
   - Ask: "Install mattpocock/skills now? This will run `npx skills add mattpocock/skills`."
   - If user agrees: run `npx skills add mattpocock/skills`.
   - If user declines: proceed. Missing skills will be marked "Emulated inline" in the routing table, and the agent will follow the inline behavior descriptions from `docs/agents/skill-routing.md`.
3. Re-scan `.claude/skills/` after installation to update the skill catalog.
4. If `npx skills` fails or is unavailable:
   - Note the failure.
   - Provide the manual installation command for the user to run later.
   - Proceed with emulation for missing skills.

### Step 4: Generate Layer 1 — AGENTS.md and CLAUDE.md

Read [agents-dispatcher.md](templates/agents-dispatcher.md) for the AGENTS.md template.
Read [agents-md-sections.md](templates/agents-md-sections.md) for project-type-specific sections.

1. **If existing AGENTS.md:**
   - Parse its section headings.
   - Classify: domain sections (preserve) vs. dispatcher sections (update).
   - Merge dispatcher sections into existing structure.
   - Preserve ALL domain-specific content (e.g., Godot system dependencies, physics layers).
   - Insert Agent Operating Protocol, Hard Rules, and routing references as new sections.
2. **If no existing AGENTS.md:**
   - Generate from the template, filling all placeholders from detection.
3. **Generate CLAUDE.md** using [claude-md.md](templates/claude-md.md):
   - Reference AGENTS.md as primary source.
   - List installed skills from scan.

Present both files to the user for review before writing.

### Step 5: Generate Layer 2 — docs/agents/* Workflow Documents

1. Create `docs/agents/` directory if it doesn't exist.
2. Generate each file from its template:

   | File | Template | Adaptation |
   |------|----------|------------|
   | `docs/agents/workflow.md` | [workflow.md](templates/workflow.md) | Project-type notes per phase |
   | `docs/agents/skill-routing.md` | [skill-routing.md](templates/skill-routing.md) | Populate with existing skills |
   | `docs/agents/dor-dod.md` | [dor-dod.md](templates/dor-dod.md) | Test availability |
   | `docs/agents/issue-lifecycle.md` | [issue-lifecycle.md](templates/issue-lifecycle.md) | Issue template |

3. Create stub directories: `docs/prd/`, `docs/adr/`, `docs/context/` (each with a `.gitkeep`).
4. Translate all generated doc content to `DOMINANT_LANGUAGE`.

Present generated files for review.

### Step 6: Generate Layer 3 — Scripts and CI

Read [quality-gates.md](templates/quality-gates.md) for script templates.

1. Generate scripts (both `.sh` and `.ps1` variants):
   - `scripts/agent-check.sh` / `scripts/agent-check.ps1` — Quality gate
   - `scripts/agent-guard.sh` / `scripts/agent-guard.ps1` — Pre-commit guard
   - `scripts/create-task.sh` — Branch + issue creation helper
2. If `.husky/` doesn't exist: generate `.husky/pre-commit`.
3. If `.github/` doesn't exist: generate `.github/workflows/ci.yml`.
4. If `.gitignore` doesn't exist: generate with project-appropriate entries.
5. If `scripts/` already has files: add alongside, do not overwrite.
6. Make `.sh` scripts executable if on a Unix-like system or note in final report.

Present all generated files for review.

### Step 7: Verify and Report

Run internal consistency checks:

1. Cross-references: Every `[link]` in generated files points to a file that exists.
2. Routing table: Every existing skill in `.claude/skills/` appears in the routing.
3. Commands: `agent-check.sh` only uses commands that were actually detected.
4. CI: Workflow runs `agent-check.sh`.
5. CLAUDE.md references AGENTS.md.
6. AGENTS.md references `docs/agents/*` files.

Present final summary:

```
## Generated Files

### Layer 1: Dispatcher
- AGENTS.md  [Generated / Updated / Skipped]
- CLAUDE.md  [Generated / Updated / Skipped]

### Layer 2: Workflow Documents
- docs/agents/workflow.md
- docs/agents/skill-routing.md
- docs/agents/dor-dod.md
- docs/agents/issue-lifecycle.md
- docs/prd/.gitkeep
- docs/adr/.gitkeep
- docs/context/.gitkeep

### Layer 3: Quality Gates
- scripts/agent-check.sh
- scripts/agent-check.ps1
- scripts/agent-guard.sh
- scripts/agent-guard.ps1
- scripts/create-task.sh
- .husky/pre-commit  [Generated / Skipped]
- .github/workflows/ci.yml  [Generated / Skipped]
- .gitignore  [Generated / Skipped]

## Manual Steps Required
- <List any actions the user needs to take>
```

---

## Existing File Conflict Policy

| Situation | Action |
|---|---|
| AGENTS.md exists with domain content | Merge: preserve domain, add dispatcher sections |
| AGENTS.md exists with dispatcher sections | Update dispatcher sections, preserve rest |
| CLAUDE.md exists | Merge: add AGENTS.md reference and skills table |
| docs/agents/* exists | Ask: overwrite, skip, or merge |
| scripts/* exists | Add new files alongside, never overwrite |
| .husky/pre-commit exists | Ask: overwrite or skip |
| .github/workflows/ci.yml exists | Ask: overwrite or skip |
| .gitignore exists | Append missing entries only |

---

## Integration with Existing Skills

This skill does **not** replace any existing skill. It generates infrastructure that references them:

### Project-Local Skills (`.claude/skills/`)

| Existing Skill | How It Integrates |
|---|---|
| `karpathy-guidelines` | Referenced in Hard Rules section of AGENTS.md |
| `improve-codebase-architecture` | Listed in routing table for architecture tasks |
| `generate-agents-md` | Distinct scope: that skill generates standalone AGENTS.md; this skill generates dispatcher-style AGENTS.md + workflow infrastructure |
| `generate-devops-scripts` | Distinct scope: that skill generates start/stop/service scripts; this skill generates quality gate scripts. They coexist in `scripts/`. |

### mattpocock/skills (External Dependency)

These skills provide the core workflow behaviors referenced in the routing table. They should be installed via `npx skills add mattpocock/skills` (handled in Step 3).

| Skill | Phase Used | Purpose |
|---|---|---|
| `grill-me` | Phase 1 | Requirement alignment through probing questions |
| `to-prd` | Phase 2 | Generate PRD from conversation context |
| `to-issues` | Phase 2 | Break PRD into vertical-slice issues |
| `tdd` | Phase 4 | Red-green-refactor implementation loop |
| `diagnose` | Phase 5 | Disciplined bug diagnosis loop |
| `triage` | Phase 5 | Bug triage through state machine |
| `grill-with-docs` | Phase 1/3 | Validate plan against domain model and ADRs |
| `write-a-skill` | Phase 6 | Create new reusable skills |
| `setup-pre-commit` | Phase 0 | Configure Husky pre-commit hooks |
| `git-guardrails-claude-code` | Phase 0 | Block dangerous git commands |
| `zoom-out` | Any | Get broader context on unfamiliar code |
| `handoff` | Any | Compact conversation for agent handoff |
| `caveman` | Any | Ultra-compressed communication mode |
| `prototype` | Phase 3 | Throwaway prototype for design exploration |

If any of these are not installed, the routing table marks them as "Emulated inline" and the agent follows the behavior descriptions in `docs/agents/skill-routing.md`.

---

## Quality Bar

The generated output must satisfy:

1. **Internal consistency**: Every cross-reference points to a generated file.
2. **Command accuracy**: Every command in scripts/CI was detected, not fabricated.
3. **Routing completeness**: Every existing skill appears in the routing table.
4. **Preservation**: No existing file content was lost during merge.
5. **Language match**: User-facing docs match `DOMINANT_LANGUAGE`.
6. **CI viability**: The CI config runs on the target platform.
7. **Script viability**: `agent-check.sh` and `agent-check.ps1` run without errors.

---

## Final Response Format

After all files are generated and verified:

```
Project template initialized for {{PROJECT_NAME}} ({{PROJECT_TYPE}}).

Generated {{file_count}} files across 3 layers:
- Layer 1 (Dispatcher): AGENTS.md, CLAUDE.md
- Layer 2 (Workflow): docs/agents/*
- Layer 3 (Quality Gates): scripts/*, CI config

{{MANUAL_STEPS_IF_ANY}}

The AGENTS.md is now your agent dispatcher. When you give a task,
the agent will auto-route through the 6-phase workflow without
needing to invoke skills by name.
```
