# AGENTS.md

## Project Overview

修仙题材 Roguelike 塔防游戏（Survivor-like + Build 构筑），基于 Godot 4.x 开发。
核心体验为灵脉经营 + 阵法 Build 构筑 + 法宝自动战斗，白天探索经营、夜晚抵御妖潮、战后三选一成长。
Steam 单机买断制，分阶段开发，当前处于 Phase 1 核心验证阶段。

## Repository Structure

```txt
tower-game/
├── docs/                      # 设计文档与世界观资料
└── game/                      # Godot 4.x 工程目录
    ├── project.godot          # 项目配置（Godot 4.2+）
    ├── autoload/              # 全局单例（GameManager, EventBus）
    ├── systems/               # 核心系统（Tags, Buff, Ability）
    ├── spirit_vein/           # 灵脉系统（资源核心）
    ├── formation/             # 阵法系统（核心战斗）
    ├── artifact/              # 法宝系统（自动攻击/进化/套装）
    ├── cultivation/           # 修仙系统（境界/功法/灵根）
    ├── enemy/                 # 敌人系统（普通/精英/Boss）
    ├── battle/                # 战斗管理（波次/Boss调度）
    ├── roguelike/             # Roguelike 成长系统（三选一）
    ├── world/                 # 世界地图（探索/灵石开采）
    ├── ui/                    # UI 管理（HUD/成长面板）
    ├── data/                  # JSON 数据表（阵法/法宝/敌人/修仙）
    ├── scenes/                # Godot 场景文件（.tscn）
    ├── resources/             # Godot 资源文件（.tres）
    ├── effect/                # 特效
    └── assets/                # 美术/音效/字体/着色器
        ├── sprites/
        ├── audio/
        ├── fonts/
        └── shaders/
```

## Environment Requirements

- Godot 4.2+（项目使用 Forward+ 渲染器）
- GDScript 为主，后期性能模块可用 C#
- 数据驱动：JSON

### Tool Paths

| Tool | Path |
|------|------|
| Godot Editor | `D:\Program Files\Godot\Godot_v4.6.2-stable_win64.exe` |
| Godot Console | `D:\Program Files\Godot\Godot_v4.6.2-stable_win64_console.exe` |

## Quick Start

用 Godot 编辑器打开 `game/` 目录：

```powershell
& "D:\Program Files\Godot\Godot_v4.6.2-stable_win64.exe" --path "F:\Workspace\tower-game\game"
```

或在 Godot 编辑器中扫描并导入 `game/` 文件夹。

## Architecture Rules

- Autoload 全局单例仅用于跨系统通信（GameManager 管理游戏阶段，EventBus 管理事件）。
- `systems/` 中的系统（Tags, Buff, Ability）供功能模块调用，功能模块不应反向依赖。
- 游戏数据存储在 `data/` 的 JSON 文件中，运行时由对应系统加载，不在脚本中硬编码数值。
- 阵法（formation）、法宝（artifact）、敌人（enemy）均继承各自基类，扩展时创建子脚本。
- 2D 物理层已定义：1=formation, 2=enemy, 3=projectile, 4=spirit_vein, 5=pickup，新建节点必须使用正确的层。

## Development Conventions

- 采用分阶段开发，Phase 1 仅实现核心验证（1张地图、5种阵法、10分钟流程）。
- 设计文档在编码前完成，存放于 `docs/`。
- 资源文件按类型分类存放（sprites/audio/fonts/shaders）。
- 每个阶段完成后进行代码审查。
- 视口分辨率 1280x720，使用 canvas_items 拉伸模式。

## Code Style

- GDScript 遵循 Godot 官方风格指南。
- 使用静态类型提示（`var x: float`，`func _process(delta: float)`）。
- 信号命名用蛇形命名法（snake_case）。
- 导出变量使用 `@export` 注解。
- 保持脚本功能单一，基类提供接口，子类实现具体行为。
- 不在脚本中硬编码数值，从 JSON 数据文件读取。

## Game System Dependencies

系统间依赖关系：

```txt
TagSystem (systems/tags.gd)
  └── BuffSystem (systems/buff_system.gd)
  └── AbilitySystem (systems/ability_system.gd)
        └── FormationBase (formation/formation_base.gd)
        └── ArtifactBase (artifact/artifact_base.gd)
        └── EnemyBase (enemy/enemy_base.gd)

SpiritVeinNetwork (spirit_vein/spirit_vein_network.gd)
  └── FormationBase (formation/formation_base.gd)  # 消耗灵气

GrowthSystem (roguelike/growth_system.gd)
  └── FormationBase / ArtifactBase / CultivationSystem

BattleManager (battle/battle_manager.gd)
  └── EnemyBase

CultivationSystem (cultivation/cultivation_system.gd)
  └── Technique / Realm / SpiritRoot
```

## Safety Rules

- 不要删除或覆盖 `docs/` 中的设计文档。
- 不要修改 `project.godot` 中的 autoload 注册，除非有明确需求。
- 不要硬编码游戏数值，保持 JSON 数据驱动。
- 不要在 `game/` 目录外创建游戏代码文件。
- 不要提交 `.godot/` 缓存目录或 `*.import` 文件。

## Git Workflow Rules

- 提交前运行 `rtk git status` 检查变更范围。
- 不要提交 `.godot/` 目录（应已在 `.gitignore` 中）。
- 不要运行 `git reset --hard` 或其他破坏性 git 命令。
- 除非用户明确要求，否则不要自动提交。

## Definition of Done

一个任务完成需要满足：

- 请求的功能或修复已实现。
- 如果涉及数据，对应的 JSON 文件已更新。
- 如果涉及新系统，在对应模块目录中创建了脚本。
- 代码遵循项目约定（静态类型、数据驱动、正确物理层）。
- 最终响应说明：
  - 改了什么。
  - 改了哪些文件。
  - 有哪些已知风险或后续工作。
