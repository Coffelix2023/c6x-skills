# build-app-workflow（中文说明）

一个通用的软件交付工作流技能，核心方法是 `Skills + Shell + Compaction`。  
目标是把“对话建议”变成“可执行、可验证、可回滚”的工程闭环。

## 1. 适用场景

- 需要真实执行命令完成开发、修复、发布前验证。
- 任务跨多轮会话，需要上下文压缩策略保证连续性。
- 希望把团队流程沉淀为可复用 SOP，而不是临时提示词。

不适用：
- 纯讨论型问答（不改代码、不跑命令）。
- 单次文案任务（无构建/测试需求）。

## 2. 目录结构

```text
build-app-workflow/
├── SKILL.md
├── README.md
├── run-log.md
├── scripts/
│   ├── preflight.sh
│   ├── verify.sh
│   └── postmortem.sh
├── references/
│   ├── workflow.md
│   └── adapters/
│       ├── node-generic.md
│       ├── python-generic.md
│       └── tauri-vue-rust.md
└── templates/
    ├── acceptance-checklist.md
    └── agent-report.md
```

## 3. 快速开始

在仓库根目录执行：

```bash
bash skills/build-app-workflow/scripts/preflight.sh .
bash skills/build-app-workflow/scripts/verify.sh --stack auto --root .
```

如果验证失败，生成复盘模板：

```bash
bash skills/build-app-workflow/scripts/postmortem.sh task-001 .
```

## 4. verify.sh 参数说明

`verify.sh` 支持按技术栈运行：

```bash
bash scripts/verify.sh [--stack auto|node|python|rust] [--root <path>]
```

- `--stack auto`：自动探测 `package.json / pyproject.toml / Cargo.toml` 并执行对应检查（默认）。
- `--stack node`：仅跑 Node 流程（通常 `pnpm lint/test/build`）。
- `--stack python`：仅跑 Python 流程（`uv run pytest` 或 `pytest`）。
- `--stack rust`：仅跑 Rust 流程（`cargo fmt/clippy/test`）。
- `--root`：指定执行目录；默认当前目录。

说明：
- 当指定栈但缺少对应 manifest 时，脚本会给出告警并返回退出码 `2`。
- 当有检查失败时，退出码为 `1`。
- 全部通过时，退出码为 `0`。

## 5. 推荐执行策略

- 默认让 agent 使用 `--stack auto`。
- 你明确要求“只验证某层”时，切换到 `node|python|rust`。
- 发布/交付前建议跑全量（auto 或多次指定栈）并配合验收清单。

## 6. 验收与治理

- 项目级验收门槛：`docs/agent-acceptance.md`
- 稳定性与拆分策略：`docs/skill-lifecycle.md`
- 每次任务记录：`run-log.md`

## 7. 常见问题

1. `verify.sh` 提示无可用 manifest  
说明仓库未识别到 Node/Python/Rust 工程文件，或 `--root` 指向错误目录。

2. 只改了前端，为什么跑了 Rust？  
你用了 `--stack auto` 且仓库同时有 `Cargo.toml`；可改为 `--stack node`。

3. 为什么要 postmortem？  
用于把失败原因、修复动作、回滚路径固定成文档，避免重复踩坑。

## 8. 参考来源

- https://developers.openai.com/blog/skills-shell-tips
- https://developers.openai.com/api/docs/guides/tools-skills
- https://developers.openai.com/api/docs/guides/tools-shell
- https://developers.openai.com/api/docs/guides/context-management
