# Project Profile Detection

Detect the project type, toolchain, and conventions before generating any template files.

## Pass 1: File Existence Scan

Check for signal files in this priority order. Stop at the first match:

| Signal File | Project Type | Notes |
|---|---|---|
| `project.godot` | Godot | GDScript/C#, scene-based, no npm/pip |
| `Cargo.toml` | Rust | cargo test, cargo clippy, cargo fmt |
| `go.mod` | Go | go test, go vet |
| `pyproject.toml` + `package.json` | Python+Node fullstack | Full devops scripts suite |
| `pyproject.toml` only | Python | Backend-only scripts |
| `package.json` only | Node/TypeScript | Frontend or Node backend |
| `pom.xml` / `build.gradle` | Java/JVM | Maven or Gradle |
| Multiple `package.json` in subdirs | Monorepo | Detect workspaces/turborepo/nx |

If no signal file matches, ask the user to specify the project type.

## Pass 2: Detail Extraction

Based on the detected project type, read these files to resolve variables:

| Variable | Detection Source | Fallback |
|---|---|---|
| `PROJECT_NAME` | Directory name (kebab-case), or `name` field in package.json / pyproject.toml / project.godot | Directory name |
| `PROJECT_TYPE` | From Pass 1 | Ask user |
| `PRIMARY_LANGUAGE` | File extension count (.gd, .py, .ts, .rs, .go, .java) | Ask user |
| `FRAMEWORK` | Dependencies in config files | None |
| `TEST_COMMAND` | `scripts.test` in package.json, `[tool.pytest]` in pyproject.toml, Makefile targets | "Not detected" |
| `LINT_COMMAND` | ESLint config, Ruff config, clippy, go vet | "Not detected" |
| `FORMAT_COMMAND` | Prettier config, black config, `cargo fmt`, `gofmt` | "Not detected" |
| `TYPECHECK_COMMAND` | `tsconfig.json`, `mypy.ini`, pyright config | "Not detected" |
| `BUILD_COMMAND` | Build scripts, `cargo build`, `go build`, Godot export | "Not detected" |
| `DEV_START_COMMAND` | `scripts.dev`/`scripts.start` in package.json, Godot editor, `uvicorn` | "Not detected" |
| `PACKAGE_MANAGER` | Lockfile: `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `uv.lock`, `requirements.txt` | Ask user |
| `CI_PLATFORM` | `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/` | Ask user |
| `HAS_TESTS` | Test runner detected + test directory exists | false |
| `DOMINANT_LANGUAGE` | Analyze language of files in `docs/`, `README*`, `AGENTS.md` | English |
| `EXISTING_SKILLS` | Scan `.claude/skills/*/SKILL.md` frontmatter | Empty list |
| `HAS_AGENTS_MD` | `AGENTS.md` exists at project root | false |
| `HAS_CLAUDE_MD` | `CLAUDE.md` exists at project root | false |
| `HAS_SCRIPTS_DIR` | `scripts/` directory exists | false |
| `HAS_HUSKY` | `.husky/` directory exists | false |
| `HAS_GITIGNORE` | `.gitignore` exists at project root | false |

## Existing Skill Scanning

For each file matching `.claude/skills/*/SKILL.md`:

1. Read the YAML frontmatter.
2. Extract `name` and `description`.
3. Append to `EXISTING_SKILLS` list.

The generated skill routing table will reference each discovered skill.

## AGENTS.md Existing Content Analysis

If `AGENTS.md` exists:

1. Parse section headings (lines starting with `#` or `##`).
2. Classify each section:
   - **Domain section**: Project Overview, Repository Structure, Architecture Rules, Code Style, Game Systems, Physics Layers, Data-Driven Patterns, etc.
   - **Dispatcher section**: Agent Operating Protocol, Skill Routing, Hard Rules, Definition of Done, Command Cheat Sheet.
3. Plan the merge:
   - Keep all domain sections in their current order.
   - Insert dispatcher sections after the first domain section (usually Project Overview).
   - If a dispatcher section already exists, update it with the template content.
   - If a domain section exists but is thin (single line), enrich it while preserving intent.

## DOMINANT_LANGUAGE Detection

1. List files in `docs/` directory.
2. Read first 50 lines of each `.md` file.
3. Check for CJK characters (Unicode range `\p{Han}`, `\p{Hiragana}`, `\p{Katakana}`).
4. If >50% of non-code content contains CJK characters, set `DOMINANT_LANGUAGE` to that language (Chinese, Japanese, Korean).
5. Otherwise, default to English.

## Detection Output Format

Present the detected profile to the user as:

```
## Detected Project Profile

| Property | Value |
|---|---|
| Project Name | <name> |
| Project Type | <type> |
| Primary Language | <language> |
| Test Command | <command or "Not detected"> |
| Lint Command | <command or "Not detected"> |
| Format Command | <command or "Not detected"> |
| Typecheck Command | <command or "Not detected"> |
| Build Command | <command or "Not detected"> |
| Dev Start Command | <command or "Not detected"> |
| Package Manager | <manager> |
| CI Platform | <platform or "Not detected"> |
| Has Tests | <true/false> |
| Dominant Language | <language> |
| Existing Skills | <comma-separated list> |
| Existing Files | <list of files that would be affected> |
```

If any variable resolved to "Not detected" and the user did not provide it, ask (max 5 questions, batched together).
