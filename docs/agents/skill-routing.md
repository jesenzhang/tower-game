# 技能路由

当 AGENTS.md 路由任务时，使用此表确定正确的行为。

> **注意：** 标记为 "Installed (global)" 的技能安装在全局 `~/.claude/skills/` 目录中。标记为 "Installed (local)" 的技能安装在项目 `.claude/skills/` 目录中。标记为 "Installed (platform)" 的技能内置于 Claude Code。

## 路由表

### 核心工作流技能（来自 mattpocock/skills）

| 信号 | 路由到 | 行为 | 可用性 |
|------|--------|------|--------|
| 模糊想法 / 不清晰需求 | grill-me | 提出探究性问题直到需求清晰 | Installed (global) |
| 产品需求 | to-prd | 从对话上下文生成 PRD | Installed (global) |
| 大型功能 | to-issues | 拆分为垂直切片，创建 issue | Installed (global) |
| Bug / 失败行为 | diagnose | 纪律化诊断：复现 → 最小化 → 假设 → 修复 → 回归测试 | Installed (global) |
| Bug 分类 | triage | 通过状态机进行 issue 分类 | Installed (global) |
| 实现 | tdd | Red-green-refactor 循环，一次一个垂直切片 | Installed (global) |
| 架构退化 | improve-codebase-architecture | 发现深化机会 | Installed (local + global) |
| 重复团队流程 | write-a-skill | 创建可复用技能 | Installed (global) |
| 对照文档验证计划 | grill-with-docs | 挑战计划，更新 CONTEXT.md/ADR | Installed (global) |
| 原型 / 设计探索 | prototype | 构建一次性原型验证设计 | Installed (global) |
| 需要更广阔的上下文 | zoom-out | 获取不熟悉代码的更高层次视角 | Installed (global) |

### 安全与设置技能

| 信号 | 路由到 | 行为 | 可用性 |
|------|--------|------|--------|
| Pre-commit 钩子需求 | setup-pre-commit | 配置 Husky 与 lint-staged、Prettier、类型检查、测试 | Installed (platform) |
| 危险 git 命令 | git-guardrails-claude-code | 通过钩子阻止 push、reset --hard、clean 等 | Installed (platform) |

### 实用技能

| 信号 | 路由到 | 行为 | 可用性 |
|------|--------|------|--------|
| 省令牌沟通 | caveman | 超压缩模式，减少约 75% 令牌 | Installed (global) |
| Agent 交接 | handoff | 将对话压缩成交接文档 | Installed (global) |
| 代码质量审查 | simplify | 审查复用性、质量、效率 | Installed (platform) |
| DevOps / 运维脚本 | generate-devops-scripts | 生成项目脚本 | Installed (local) |
| 仓库 Agent 规则 | generate-agents-md | 生成/更新 AGENTS.md | Installed (local) |
| 项目模板设置 | bootstrap-agentic-workflow | 引导式工作流基础设施搭建 | Installed (local) |
| 行为指南 | karpathy-guidelines | 减少 LLM 常见编码错误 | Installed (local) |

## 可用性值说明

- **Installed (global)** — 技能安装在全局 `~/.claude/skills/<name>/` 目录中。
- **Installed (local)** — 技能安装在项目 `.claude/skills/<name>/` 目录中。
- **Installed (platform)** — 技能内置于 Claude Code。通过 Skill 工具调用。

## 已安装技能

### 项目本地（`.claude/skills/`）

| 技能 | 位置 | 触发条件 |
|------|------|----------|
| karpathy-guidelines | `.claude/skills/karpathy-guidelines/` | 编写、审查或重构代码时减少 LLM 常见编码错误 |
| improve-codebase-architecture | `.claude/skills/improve-codebase-architecture/` | 发现架构深化机会，提升可测试性和 AI 可导航性 |
| generate-agents-md | `.claude/skills/generate-agents-md/` | 创建、改进或审计 AGENTS.md |
| generate-devops-scripts | `.claude/skills/generate-devops-scripts/` | 生成项目运维脚本 |
| bootstrap-agentic-workflow | `.claude/skills/bootstrap-agentic-workflow/` | 引导式工作流基础设施搭建 |

### 全局（`~/.claude/skills/`）

| 技能 | 位置 | 触发条件 |
|------|------|----------|
| grill-me | `~/.claude/skills/grill-me/` | 需求不清晰时，通过探究性问题达成共识 |
| to-prd | `~/.claude/skills/to-prd/` | 从对话上下文生成 PRD |
| to-issues | `~/.claude/skills/to-issues/` | 将计划拆分为垂直切片 issue |
| tdd | `~/.claude/skills/tdd/` | 使用 Red-Green-Refactor 循环实现功能 |
| diagnose | `~/.claude/skills/diagnose/` | 纪律化 Bug 诊断循环 |
| triage | `~/.claude/skills/triage/` | 通过状态机进行 Bug 分类 |
| grill-with-docs | `~/.claude/skills/grill-with-docs/` | 对照领域模型和 ADR 验证计划 |
| write-a-skill | `~/.claude/skills/write-a-skill/` | 创建新的可复用技能 |
| prototype | `~/.claude/skills/prototype/` | 构建一次性原型验证设计 |
| zoom-out | `~/.claude/skills/zoom-out/` | 获取代码的更高层次视角 |
| caveman | `~/.claude/skills/caveman/` | 超压缩沟通模式 |
| handoff | `~/.claude/skills/handoff/` | 压缩对话为交接文档 |
