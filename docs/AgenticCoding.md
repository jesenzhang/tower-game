可以实现你想要的形态，但要换个思路：

> **不要让你手动调用 Matt Pocock Skills。
> 而是把 Skills 变成项目模板里的“内部流程能力”，由 Agent 的总控协议自动调度。**

Matt Pocock 的仓库本身就是一套面向 Claude Code 的工程化 Skills，官方推荐用 `npx skills add mattpocock/skills` 安装，并通过 `/setup-matt-pocock-skills` 初始化仓库级配置，例如 issue tracker、triage label、领域文档布局等。([GitHub][1])

你真正需要的是这个结构：

```text
project-template/
├── AGENTS.md                    # Agent 总控协议
├── CLAUDE.md                    # Claude Code 专用入口，可引用 AGENTS.md
├── docs/
│   ├── agents/
│   │   ├── workflow.md           # 六阶段流程
│   │   ├── skill-routing.md      # 什么时候用哪个 skill
│   │   ├── definition-of-ready.md
│   │   ├── definition-of-done.md
│   │   └── issue-lifecycle.md
│   ├── prd/
│   ├── adr/
│   └── context/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/ci.yml
├── scripts/
│   ├── agent-check.sh            # 本地质量门禁
│   ├── agent-guard.sh            # 禁止危险命令/检查状态
│   └── create-task.sh
└── .husky/
    └── pre-commit
```

核心是 `AGENTS.md` 写成“调度器”，而不是说明文档。

最关键的一段应该类似这样：

```md
# Agent Operating Protocol

## Default behavior

When the user gives a feature request, bug report, refactor request, or vague idea, do not jump directly into coding.

Route the task through this workflow:

1. If the request is unclear, use grill-me behavior.
2. If the request is product-level, create or update a PRD.
3. If the work is larger than one small vertical slice, split it into issues.
4. If the work changes module boundaries, design the interface first.
5. If implementation is required, use TDD.
6. If debugging is required, diagnose or triage first.
7. Before completion, run the quality gate.

The user should not need to name a skill.
Choose the correct workflow automatically.
```

然后加一个路由表：

```md
## Skill routing

- Vague idea / unclear requirement:
  Use grill-me behavior.

- Product requirement:
  Use to-prd behavior.

- Large feature:
  Use to-issues behavior and split into vertical slices.

- New module / public API / boundary change:
  Use design-an-interface behavior before implementation.

- Bug / failing behavior:
  Use diagnose or triage behavior before editing code.

- Implementation:
  Use tdd behavior.

- Architecture degradation / messy module:
  Use improve-codebase-architecture behavior.

- Repeated team process:
  Use write-a-skill behavior.
```

再加硬约束：

```md
## Hard rules

- Never code before understanding the current task.
- Never implement a large feature in one pass.
- Never modify unrelated files.
- Never skip tests.
- Never claim completion without running ./scripts/agent-check.sh.
- Never run destructive git commands.
- Prefer vertical slices over horizontal layers.
- Prefer deep modules with small public interfaces.
- Prefer issue-driven work over chat-only work.
```

这样你提需求时，理想行为就是：

```text
你：我要加一个合同补充协议管理功能

Agent：
1. 判断这是产品级需求
2. 自动进入 grill-me / PRD 阶段
3. 生成 PRD
4. 拆成 Issues
5. 先设计接口
6. 每个 Issue 走 TDD
7. 跑 agent-check.sh
8. 输出变更摘要
```

你不需要说：

```text
/use grill-me
/use to-prd
/use to-issues
/use tdd
```

而是让 `AGENTS.md` 规定：

> 用户只提业务需求，Agent 自己判断流程。

不过要实事求是：**这仍然不能 100% 保证 Agent 永远遵守。**

所以必须靠脚本和 CI 兜底：

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Checking agent output..."

git diff --check

npm run format:check
npm run lint
npm run typecheck
npm test

echo "Agent quality gate passed."
```

CI 里也跑同样的东西：

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: ./scripts/agent-check.sh
```

最终你要构建的是：

> **Agent 项目启动模板，而不是单个 Skill。**

我建议你的模板分三层：

```text
第一层：AGENTS.md
负责告诉 Agent 如何思考、如何路由、如何禁止越界。

第二层：docs/agents/*
负责保存六阶段流程、PRD 模板、Issue 模板、DoR/DoD。

第三层：scripts + CI
负责强制验证，防止 Agent 口头遵守但实际乱改。
```

最终效果可以接近：

```text
用户只提需求
   ↓
Agent 自动判断任务类型
   ↓
自动选择 grill-me / PRD / issue / interface / TDD / triage
   ↓
按垂直切片执行
   ↓
测试和 CI 门禁兜底
   ↓
输出可审查结果
```

所以答案是：

> **可以做成“默认自动按框架执行”的项目模板。
> 但不要依赖 Agent 自觉，而要用 AGENTS.md 负责调度，用模板负责结构，用脚本和 CI 负责强制约束。**

[1]: https://github.com/mattpocock/skills?utm_source=chatgpt.com "mattpocock/skills: Skills for Real Engineers. Straight from ..."
