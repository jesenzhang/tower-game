# 游戏设计情报系统设计文档

> 面向类 Vampire Survivors / Roguelike / 塔防 / 自动战斗品类的竞品情报与玩家反馈分析系统。

## 1. 项目定位

本系统定位为“游戏设计情报系统”，用于持续收集、整理、分析 TapTap、Steam 等平台上与当前游戏项目相关的高好评游戏信息，从玩家评论、游戏机制、版本演进和社区讨论中提炼可复用的玩法创意、设计风险、改进建议与成功原因。

系统目标不是简单采集数据，而是沉淀为可长期复用的“玩家认知数据库”和“竞品设计知识库”。

## 2. 核心目标

- 发现高潜力玩法方向
- 理解玩家真正喜欢的体验来源
- 识别高频差评中的结构性问题
- 对比成功游戏的玩法设计模式
- 为当前项目提供设计决策依据
- 生成高信息密度、可交互、可归档的单文件 HTML 情报报告

## 3. 重点研究问题

### 3.1 玩家为什么沉迷

- 爽感来源是什么？
- 成长曲线哪里最上头？
- 为什么会产生“再来一局”的冲动？
- 哪些机制带来长期复玩？
- 哪些奖励节奏最容易让玩家持续投入？

### 3.2 玩家为什么弃坑

- 后期是否重复？
- Build 是否太少？
- Meta 是否固化？
- 数值是否膨胀？
- UI 是否混乱？
- 是否过肝？
- 是否过度依赖随机？
- 是否缺少长期目标？

### 3.3 玩家最认可什么

- 战斗反馈
- 美术表现
- 音效反馈
- Build 多样性
- 局外成长
- 联机体验
- Mod 生态
- 操作手感
- 高频奖励
- 角色差异

### 3.4 玩家最痛恨什么

- 数值膨胀
- 后期无聊
- 强制 Grind
- 随机性失控
- 平衡性差
- UI 信息密度低
- 移动端操作差
- 新手引导差
- 内容重复
- 局外成长碾压局内策略

## 4. 信息源设计

## 4.1 Steam

Steam 是最重要的信息来源之一。

重点收集：

- 游戏基础信息
- 用户评价数量
- 好评率
- 标签
- 评论内容
- 评论时间
- 玩家游戏时长
- 好评 / 差评
- 更新前后评论变化

Steam 评论特别适合分析：

- 深度玩家反馈
- 高时长玩家差评
- 构筑系统问题
- 平衡性问题
- 后期重复问题
- 版本更新影响

## 4.2 TapTap

TapTap 适合分析国内移动端玩家反馈。

重点收集：

- 评分
- 评论内容
- 玩家吐槽
- 移动端适配问题
- 氪金反馈
- 数值压力
- 操作问题
- 性能问题
- 国内玩家表达习惯

TapTap 对当前项目的价值在于：

- 识别手游化风险
- 提前判断商业化接受度
- 发现操作与 UI 问题
- 观察国内玩家对 Roguelike / 塔防 / 割草玩法的偏好

## 4.3 Reddit / Discord / Bilibili / YouTube

作为第二阶段扩展数据源。

适合分析：

- Meta 玩法讨论
- Build 分享
- 高级玩家观点
- UP 主评测
- 视频评论
- 社区争议
- 版本趋势
- 传播点

## 5. 竞品谱系

不要只分析《Vampire Survivors》，而应该建立完整竞品谱系。

### 5.1 核心生存割草类

- Vampire Survivors
- Brotato
- Halls of Torment
- Soulstone Survivors
- Death Must Die

### 5.2 塔防融合类

- Rogue Tower
- The Last Spell
- Nordhold
- Orcs Must Die 系列

### 5.3 自动战斗 / 构筑类

- Backpack Battles
- Loop Hero
- Auto Chess 类游戏
- Super Auto Pets

### 5.4 高成长反馈类

- Risk of Rain 2
- Slay the Spire
- Hades
- Dead Cells

## 6. 分析维度体系

## 6.1 玩法层

- Build Diversity
- Combo Depth
- Meta Progression
- Skill Expression
- Randomness
- Difficulty Curve
- Run Pacing
- Reward Frequency
- Enemy Variety
- Boss Design
- Tower Synergy
- Character Differentiation

## 6.2 体验层

- 爽感
- 疲劳感
- 重复感
- 压力感
- 沉浸感
- 操作负担
- 节奏拖沓
- 成就感
- 失败成本
- 再开一局欲望

## 6.3 内容层

- 敌人种类
- 武器数量
- 地图变化
- 随机事件
- Boss 机制
- 成长系统
- 局外养成
- 角色数量
- 关卡变化
- 长期目标

## 6.4 工程层

- 优化
- 卡顿
- 崩溃
- 移动端适配
- UI 可读性
- 手柄支持
- 存档问题
- 多语言问题
- 网络问题

## 7. 差评分析策略

差评是系统中最重要的数据资产之一。

尤其需要重点分析：

### 7.1 高时长差评

例如：

> 玩家游玩 50 小时、100 小时后给出差评。

这类评论说明：

- 玩家曾经认可游戏
- 问题通常出现在中后期
- 反馈价值远高于低时长情绪化差评

重点提取：

- 后期内容耗尽
- Build 固化
- 成长停滞
- Boss 缺乏变化
- 数值膨胀
- Meta 失衡
- 重复性过高

### 7.2 高频负面主题

需要自动聚类：

- 后期重复
- 内容不足
- 数值失控
- 平衡差
- UI 混乱
- 操作不适
- 新手引导弱
- 更新方向错误
- 商业化反感
- 性能问题

## 8. AI 分析架构

建议采用：

```text
评论采集 → 文本清洗 → 标签抽取 → 向量化 → 聚类 → 摘要 → 设计建议生成 → HTML 报告输出
```

## 8.1 核心 AI 能力

### 自动提炼

- 玩家喜欢什么
- 玩家讨厌什么
- 哪些机制被反复称赞
- 哪些问题反复出现

### 自动发现

- 高频玩法机制
- 潜在趋势
- 高风险设计模式
- 高复玩机制组合

### 自动对比

- 为什么 A 游戏比 B 游戏成功
- 两个游戏的核心爽点差异
- 同类机制在不同游戏中的表现差异

### 自动总结

- 品类最佳实践
- 设计禁忌
- 当前项目可借鉴点
- 当前项目应避免的问题

## 9. 数据模型设计

### 9.1 game

```text
id
name
platform
tags
release_date
price
rating
review_count
positive_rate
store_url
intelligence_score
```

### 9.2 review

```text
id
game_id
platform
author
playtime
language
score
content
created_at
is_positive
helpful_count
version_context
```

### 9.3 extracted_insight

```text
id
game_id
type
topic
summary
evidence
confidence
priority
created_at
```

### 9.4 gameplay_mechanic

```text
id
mechanic
category
positive_mentions
negative_mentions
related_games
example_reviews
design_implication
```

### 9.5 design_recommendation

```text
id
priority
recommendation
reason
evidence_games
related_reviews
risk_level
implementation_hint
```

## 10. 系统架构

推荐结构：

```text
collector/
├── steam/
├── taptap/
├── reddit/
├── bilibili/
└── youtube/

pipeline/
├── crawler/
├── cleaner/
├── tagger/
├── embedding/
├── clustering/
├── summarizer/
└── analyzer/

storage/
├── raw/
├── parsed/
├── vector/
└── reports/

dashboard/
├── html-generator/
├── templates/
└── assets/
```

## 11. 技术选型建议

## 11.1 后端

建议使用 Rust + Python 混合方案。

Rust 负责：

- 任务调度
- 数据采集
- 数据清洗管线编排
- 报告生成
- 本地工具封装

Python 负责：

- NLP
- Embedding
- Topic Modeling
- 聚类
- LLM 摘要
- 评论情绪分析

## 11.2 数据库

推荐：

- PostgreSQL
- pgvector
- SQLite 作为本地 MVP
- DuckDB 用于分析型查询

第一阶段可以直接使用：

```text
SQLite + JSON 文件 + 单文件 HTML 报告
```

## 12. 单文件 HTML Dashboard 设计

## 12.1 定位

单文件 HTML 不是普通报告，而是一个：

```text
游戏设计情报控制台
```

核心要求：

- 高信息密度
- 可视化强
- 可交互
- 可离线打开
- 可归档
- 适合 AI 自动生成
- 不依赖复杂构建工具

## 12.2 技术方案

推荐：

```text
HTML + CSS + Vanilla JS + 内嵌 JSON 数据
```

可选图表库：

```text
ECharts CDN
Chart.js CDN
```

若要求完全离线：

```text
纯 SVG / Canvas 自绘图表
```

## 12.3 页面布局

采用三栏布局：

```text
┌──────────────────────────────────────────────┐
│ 顶部：项目状态 / 数据更新时间 / 筛选器       │
├───────────────┬────────────────┬─────────────┤
│ 左侧导航       │ 中央分析区       │ 右侧洞察区   │
│ 游戏列表       │ 图表 / 对比 / 表格│ AI结论       │
│ 标签筛选       │ 评论聚类         │ 设计建议     │
└───────────────┴────────────────┴─────────────┘
```

## 12.4 顶部 Header

展示：

- 游戏数量
- 评论数量
- 高频机制数量
- 正面洞察数量
- 负面风险数量
- 当前推荐优先级
- 数据更新时间

示例：

```text
分析游戏：24
评论样本：18,420
高频机制：126
主要机会点：塔防 + 自动构筑
最高风险：后期重复感
```

## 12.5 左侧竞品库

每个游戏卡片展示：

- 游戏名
- 平台
- 好评率
- 评论数
- 核心标签
- 情报价值评分

支持筛选：

- 平台：Steam / TapTap
- 类型：幸存者 / 塔防 / 肉鸽 / 自动战斗
- 评价：特别好评 / 多半好评
- 问题类型：重复 / 数值 / UI / 新手引导

## 12.6 中央分析区

### 模块 A：竞品矩阵

二维散点图：

- X 轴：玩法复杂度
- Y 轴：玩家爽感
- 气泡大小：评论数量
- 颜色：商业成功度 / 好评率

用于识别：

- 低复杂度高爽感
- 高复杂度高爽感
- 高复杂度低爽感
- 低复杂度低爽感

当前项目重点关注：

```text
低学习成本 + 高构筑深度 + 高频反馈
```

### 模块 B：玩法机制热力图

行：游戏  
列：机制

机制示例：

- 武器合成
- 局外成长
- 自动攻击
- 塔防建造
- 地图事件
- Boss 机制
- 装备词缀
- 角色差异
- 随机商店
- 天赋树

颜色表示：

```text
玩家正反馈强度
```

### 模块 C：玩家情绪雷达图

维度：

- 爽感
- 构筑深度
- 重复感控制
- 操作舒适度
- 内容量
- 长期目标
- 平衡性

支持选择 2 至 4 个游戏对比。

### 模块 D：好评 / 差评主题聚类

左右双栏：

- 好评主题 TOP10
- 差评主题 TOP10

每个主题展示：

- 主题名
- 出现次数
- 代表评论
- 关联机制
- 设计启示

### 模块 E：成功原因拆解

对每个成功游戏生成：

- 核心爽点
- 成长节奏
- Build 深度
- 视觉反馈
- 内容消耗速度
- 社区传播点
- 可借鉴设计

### 模块 F：对本项目的设计建议

按优先级显示：

- P0 必做
- P1 强烈建议
- P2 可实验
- P3 暂不建议

示例：

- P0：增加局内 30~45 秒一次的成长选择
- P0：塔防单位需要与角色 Build 产生联动
- P1：加入中后期地图事件，减少重复感
- P1：加入局外目标，但避免数值碾压
- P2：实验背包构筑或符文拼装系统

## 12.7 右侧 AI 洞察栏

展示压缩结论：

### 今日结论

```text
当前品类最大机会：塔防 + 幸存者 + 自动构筑的融合仍有空间。
```

### 最大风险

```text
如果塔防单位只是静态炮塔，玩家会觉得缺少成长爽感。
```

### 可借鉴机制

```text
Brotato：角色差异 + 武器标签
Vampire Survivors：超武进化
Rogue Tower：路线压力
Backpack Battles：空间构筑
```

### 禁忌清单

```text
不要让局外成长完全碾压局内选择
不要让后期只剩数值堆叠
不要让塔防建造和角色成长割裂
```

## 13. HTML 内嵌数据结构

单文件中直接内嵌 JSON：

```html
<script id="data" type="application/json">
{
  "games": [
    {
      "id": "brotato",
      "name": "Brotato",
      "platform": "Steam",
      "rating": 97,
      "reviewCount": 84000,
      "tags": ["survivor-like", "build", "arena"],
      "mechanics": {
        "build_depth": 92,
        "meta_progression": 40,
        "weapon_synergy": 95,
        "tower_defense": 0,
        "auto_attack": 90
      },
      "sentiment": {
        "fun": 96,
        "depth": 90,
        "repetition": 38,
        "balance": 82,
        "content": 78
      },
      "positiveTopics": [
        {
          "topic": "Build 多样性",
          "count": 1260,
          "insight": "角色、武器和道具组合形成高复玩性。"
        }
      ],
      "negativeTopics": [
        {
          "topic": "后期重复",
          "count": 310,
          "insight": "高时长玩家认为后期目标不足。"
        }
      ],
      "successReasons": [
        "单局短",
        "选择频繁",
        "角色差异明显",
        "失败成本低"
      ]
    }
  ]
}
</script>
```

## 14. 可视化模块优先级

MVP 第一版只做 8 个区块：

1. 顶部概览 KPI
2. 游戏列表
3. 竞品矩阵气泡图
4. 机制热力图
5. 情绪雷达图
6. 好评主题 TOP10
7. 差评主题 TOP10
8. 对本项目的设计建议

这 8 个模块已经足够形成高价值情报报告。

## 15. 视觉风格

建议风格：

```text
深色情报面板 + 高密度卡片 + 霓虹强调色
```

参考气质：

- SteamDB
- Notion Dashboard
- Linear
- Grafana
- 游戏内科技树 UI

颜色建议：

```text
背景：#0B0F14
卡片：#111827
边框：#1F2937
主色：#7C3AED
正面：#22C55E
风险：#EF4444
警告：#F59E0B
信息：#38BDF8
```

## 16. 交互设计

MVP 阶段建议：

- 点击游戏卡片，更新右侧详情
- 点击机制标签，高亮相关游戏
- 点击差评主题，展示代表评论
- 切换平台筛选，重绘图表
- 对比模式，选择 2 至 4 个游戏
- 搜索框，搜索游戏 / 机制 / 评论主题
- 点击设计建议，查看证据来源

## 17. 输出形式

每次分析后输出：

```text
game-intelligence-report.html
```

文件包含：

- 内嵌样式
- 内嵌数据
- 内嵌 JavaScript
- 图表初始化逻辑
- AI 总结
- 设计建议

不依赖构建工具。

## 18. MVP 实施路线

### 阶段 1：静态情报报告

目标：分析 20 个 Steam / TapTap 游戏。

功能：

- 游戏信息录入
- 评论样本采集
- 好评 / 差评聚类
- 优点 TOP10
- 缺点 TOP10
- 游戏对比
- 单文件 HTML 报告输出

### 阶段 2：半自动采集与分析

功能：

- Steam 评论自动采集
- TapTap 评论半自动采集
- 评论清洗
- 标签提取
- 情绪分析
- 聚类分析
- AI 摘要

### 阶段 3：长期知识库

功能：

- PostgreSQL + pgvector
- 竞品数据库
- 玩家反馈知识库
- 向量检索
- AI 问答
- 每周自动报告
- 版本趋势分析

### 阶段 4：设计决策系统

功能：

- 自动生成设计建议
- 自动识别玩法机会
- 自动识别风险模式
- 对当前项目设计文档进行差距分析
- 输出玩法迭代建议

## 19. 最终产物形态

系统最终包含两个层级：

### 19.1 静态 HTML 情报报告

用于：

- 每周分析
- 竞品复盘
- 玩法决策会议
- 归档
- 分享

### 19.2 长期数据库系统

用于：

- 持续采集
- 评论入库
- 趋势分析
- AI 问答
- 设计建议生成

## 20. 核心结论

这个系统的核心价值不是“收集评论”，而是把玩家评论、竞品机制、成功原因、失败原因和设计建议压缩成可执行的设计情报。

最终目标是形成：

```text
玩家认知数据库 + 竞品机制知识库 + 设计决策辅助系统
```

对于当前类幸存者 / Roguelike / 塔防项目，最有价值的方向是：

```text
低学习成本 + 高频反馈 + 高构筑深度 + 塔防联动 + 中后期变化
```

最需要避免的问题是：

```text
后期重复、数值堆叠、Build 固化、塔防与角色成长割裂、局外成长碾压局内策略
```
