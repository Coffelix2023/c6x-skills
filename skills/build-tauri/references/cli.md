# Tauri v2 CLI 快速参考 (pnpm 优先)

## 基础命令

| 功能 | 命令 |
| :--- | :--- |
| 初始化项目 | `pnpm create tauri-app` |
| 启动开发环境 | `pnpm tauri dev` |
| 构建发布包 | `pnpm tauri build` |
| 查看环境信息 | `pnpm tauri info` |

## 移动端开发 (Android/iOS)
>
> [!IMPORTANT]
> 在开始移动端开发前，需确保已通过 `pnpm tauri info` 检查 Rust 移动端工具链已安装。

### Android

- **初始化**: `pnpm tauri android init`
- **开发**: `pnpm tauri android dev`
- **构建**: `pnpm tauri android build`

### iOS

- **初始化**: `pnpm tauri ios init`
- **开发**: `pnpm tauri ios dev`
- **构建**: `pnpm tauri ios build`

## 插件管理

使用 `add` 命令会自动在 `Cargo.toml` 中添加相关依赖：

- **添加插件**: `pnpm tauri add <plugin-name>` (例如 `pnpm tauri add sql`)
- **移除插件**: `pnpm tauri remove <plugin-name>`

## 其他常用

- **生成图标**: `pnpm tauri icon <path-to-image>` (支持生成全平台图标)
- **版本检查**: `pnpm tauri --version`
