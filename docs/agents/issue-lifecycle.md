# Issue 生命周期

## 标签

使用以下标签追踪 issue 所在的阶段：

| 标签 | 含义 | 颜色 |
|------|------|------|
| `phase-0` | 安全/环境设置 | 灰色 |
| `phase-1` | 需求对齐 | 蓝色 |
| `phase-2` | PRD/任务拆分 | 紫色 |
| `phase-3` | 架构/接口设计 | 黄色 |
| `phase-4` | 实现（TDD） | 绿色 |
| `phase-5` | 人工验收 | 橙色 |
| `bug` | 需要修复 Bug | 红色 |
| `refactor` | 架构改进 | 青色 |
| `vertical-slice` | 完整的小型特性 | 亮绿 |
| `blocked` | 等待其他任务 | 暗红 |

## 垂直切片要求

每个实现 issue 必须是垂直切片：

- 它交付**一个小型、可运行的价值片段**。
- 它可以**独立**实现和测试。
- 它**不是**按层拆分的（跨层特性不能有"仅前端"或"仅后端"的 issue）。
- 它贯穿所有相关层级以交付可工作的功能。

### 示例

**错误（水平）：** "实现所有敌人类型"
**正确（垂直）：** "实现史莱姆敌人：数据定义、行为逻辑、生成触发和视觉效果"

**错误（水平）：** "构建整个 UI 框架"
**正确（垂直）：** "添加阵法放置按钮到 HUD：图标、点击处理器和放置模式"

## Issue 模板

创建 issue 时，使用此模板：

```markdown
## Goal
<此任务交付什么 —— 一句话>

## Acceptance Criteria
- [ ] <可测试的标准 1>
- [ ] <可测试的标准 2>
- [ ] <可测试的标准 3>

## Affected Systems
- <系统/模块列表>

## Dependencies
- <Blocked by: #issue> 或 "None"

## Quality Gate
- [ ] 测试通过（或手动验证已文档化）
- [ ] `./scripts/agent-check.sh` 通过
- [ ] 没有无关变更
```

## Issue 状态流

```
New -> Phase 1 (如果不清晰则 grill-me)
     -> Phase 2 (to-prd，然后 to-issues)
         -> Phase 3 (如果是新模块则设计接口)
             -> Phase 4 (TDD 实现)
                 -> Phase 5 (人工审查)
                     -> Done
                     -> 发现 Bug -> 新 Phase 4 issue
```

## PRD 模板位置

PRD 存放在 `docs/prd/` 目录中，命名规则：`prd-<feature-name>.md`。

### PRD 模板

```markdown
# PRD: <Feature Name>

## Background
<为什么需要此功能>

## Goals
- <目标 1>
- <目标 2>

## Non-Goals
- <明确排除的范围>

## Acceptance Criteria
- [ ] <标准 1>
- [ ] <标准 2>

## Affected Systems
- <系统列表>

## Dependencies
- <外部依赖或阻塞 issue>

## Open Questions
- <未解决的问题，或 "None">
```
