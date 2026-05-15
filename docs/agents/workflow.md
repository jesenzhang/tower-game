# AI 辅助开发：6 阶段工作流

本文档描述项目中的 AI 辅助开发标准工作流。Agent 根据 `skill-routing.md` 中的路由规则自动遵循此工作流。

关于就绪定义和完成定义，见 `dor-dod.md`。
关于 Issue 创建和生命周期，见 `issue-lifecycle.md`。

---

## Phase 0：安全网与环境

在 AI 接触代码之前，建立防护栏。

**检查清单：**
- [ ] Pre-commit 钩子已配置（`.husky/pre-commit` -> `scripts/agent-check.sh`）
- [ ] Git 防护栏已激活（`scripts/agent-guard.sh`）
- [ ] 质量门禁脚本已存在（`scripts/agent-check.sh`）
- [ ] `.gitignore` 已配置项目生成文件

**状态：** 已生成

**备注：**
Godot 会生成 `.godot/` 和 `.import` 文件，必须在 .gitignore 中排除。
Pre-commit 钩子应检查是否意外暂存了 `.import` 文件。

---

## Phase 1：领域知识同步与需求对齐

消除沟通障碍，达成设计共识。

**流程：**
1. 如果请求模糊或不清晰，使用 **grill-me** 行为：提出探究性问题直到完全理解需求。
2. 对于新领域或概念，使用 **ubiquitous-language** 行为：从对话中提取 DDD 风格词汇表。
3. 在继续之前确认共识。

**输出：** 清晰、可测试的需求陈述。

---

## Phase 2：生成目标文档与任务拆分

将共识转化为可执行任务。永远不要一次性实现所有内容。

**流程：**
1. 使用 **to-prd** 行为：从对话上下文生成产品需求文档。存放在 `docs/prd/prd-<feature-name>.md`。
2. 使用 **to-issues** 行为：将 PRD 拆分为垂直切片。每个切片是一个小型、可运行的特性，贯穿所有层级。
3. 按照 `issue-lifecycle.md` 中的模板创建 issue。

**关键原则：** 垂直切片，而非水平分层。
- 错误："实现所有敌人类型"（水平）
- 正确："实现史莱姆敌人：数据定义、行为逻辑、生成触发和视觉效果"（垂直）

**输出：** PRD 文档 + 带依赖关系的 issue 列表。

---

## Phase 3：架构与接口设计

在实现之前规划模块接口。AI 在有明确边界的情况下表现更好。

**流程：**
1. 新模块：使用 **design-an-interface** 行为。生成多个接口方案，选择一个。
2. 现有代码：使用 **improve-codebase-architecture** 行为。发现深化机会。
3. 如果需要大型重构：生成多步骤重构计划，使用小型提交。

**输出：** 接口规格或架构改进计划。

---

## Phase 4：自动化开发与测试循环

使用严格的 TDD 执行实现。人类可以在此阶段离开。

**流程：**
1. 从 backlog 中选取一个 issue。
2. **TDD 循环（Red-Green-Refactor）：**
   - **Red：** 编写一个描述预期行为的失败测试。
   - **Green：** 编写使测试通过的最小实现。
   - **Refactor：** 在保持测试通过的同时清理代码。
3. 运行质量门禁：`./scripts/agent-check.sh`
4. 使用描述性消息提交。
5. 进入下一个 issue。

**备注：**
GDScript 测试在 Godot 4.x 中有限。TDD 循环适配：
- 如果安装了 GUT 或 GdUnit4：使用标准 red-green-refactor。
- 如果没有测试运行器：将预期行为写成注释，实现后通过运行场景手动验证。
- 修改后始终验证 JSON 数据文件。

---

## Phase 5：人工验收与 Bug 诊断

人类以全新视角审查 AI 输出。

**流程：**
1. **人工 QA：** UI/UX 测试、游戏手感、视觉打磨 —— AI 无法判断的事情。
2. **Bug 分类：** 如果发现 bug，使用 **triage** 行为。Agent 调查、找到根因、创建带 TDD 修复计划的新 issue。
3. 将修复 issue 路由回 Phase 4。

**输出：** 已验证的特性或分类后的 bug issue。

---

## Phase 6：范式自我演进

随时间改进工作流本身。

**流程：**
1. 当识别到重复的团队模式时，使用 **write-a-skill** 行为将其捕获为可复用技能。
2. 如果流程演进，更新此工作流文档。
3. 如果添加了新技能，更新路由表。
