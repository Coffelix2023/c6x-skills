# Rust 指令与 TS 交互最佳实践

## Rust 端实现 (带初学者中文注释)

```rust
// 这是一个普通的 Rust 函数，通过 #[tauri::command] 宏将其暴露给前端
#[tauri::command]
pub fn greet(name: &str) -> String {
    format!("你好, {}! 欢迎使用 Tauri!", name)
}

// 如果函数可能失败，应该返回 Result 类型
#[tauri::command]
pub fn save_data(data: String) -> Result<String, String> {
    if data.is_empty() {
        return Err("数据不能为空".into());
    }
    Ok("成功保存数据".into())
}

// 在 lib.rs 或 main.rs 中注册这些指令
/*
tauri::Builder::default()
    .invoke_handler(tauri::generate_handler![greet, save_data])
    .run(tauri::generate_context!())
    .expect("运行 Tauri 应用程序时出错");
*/
```

## 系统托盘与全局事件协同 (Tray & Events)

系统托盘是桌面应用的“备用驾驶舱”。在 Tauri v2 中，推荐通过 Rust 端定义菜单并利用 `.emit()` 与前端进行异步通信。

### 1. Rust 托盘创建 (src-tauri/src/tray.rs)

```rust
use tauri::{menu::{Menu, MenuItem, Submenu}, tray::TrayIconBuilder, Emitter, Manager, Runtime};

pub fn create_tray<R: Runtime>(app: &tauri::AppHandle<R>) -> tauri::Result<()> {
    // 1. 定义菜单项
    let quit = MenuItem::with_id(app, "quit", "退出", true, None::<&str>)?;
    let theme_menu = Submenu::with_id_and_items(app, "theme", "主题设置", true, &[
        &MenuItem::with_id(app, "dark_mode", "🌙 深色模式", true, None::<&str>)?
    ])?;

    let menu = Menu::with_items(app, &[&theme_menu, &quit])?;

    // 2. 构建托盘并绑定事件
    TrayIconBuilder::with_id("tray")
        .menu(&menu)
        .on_menu_event(|app, event| {
            match event.id.as_ref() {
                "quit" => { app.exit(0); }
                "dark_mode" => { 
                    // 发送全局广播，前端监听此事件并更新状态
                    let _ = app.emit("tray-toggle-theme", "dark"); 
                }
                _ => {}
            }
        })
        .icon(app.default_window_icon().unwrap().clone())
        .build(app)?;
    Ok(())
}
```

### 2. Frontend 监听实战 (Vue)

```typescript
import { listen } from "@tauri-apps/api/event";

onMounted(async () => {
  // 监听来自托盘的广播
  const unlisten = await listen<string>("tray-toggle-theme", (event) => {
    console.log("收到托盘指令:", event.payload);
    // 执行业务逻辑...
  });
});
```

## TypeScript 前端调用

```typescript
import { invoke } from "@tauri-apps/api/core";

// 调用普通指令
async function handleGreet() {
  try {
    const response = await invoke<string>("greet", { name: "Felix" });
    console.log(response); 
  } catch (error) {
    console.error("调用指令出错:", error);
  }
}
```

## 高级交互: OS 级窗口平滑定位动画 (V2)

在 Tauri v2 中实现丝滑的窗口移动动画，需要考虑 **Retina/高分屏适配** 以及基于 `requestAnimationFrame` 的补间逻辑。

### 1. 坐标与像素适配 (Retina/scaleFactor)

```typescript
import { PhysicalPosition } from "@tauri-apps/api/dpi";
import { getCurrentWindow, currentMonitor } from "@tauri-apps/api/window";

async function smoothMoveTo(targetLayout: string) {
  const appWindow = getCurrentWindow();
  const monitor = await currentMonitor();
  if (!monitor) return;

  // 获取缩放因子 (Retina 屏通常为 2.0)
  const scaleFactor = await appWindow.scaleFactor();
  const startPos = await appWindow.outerPosition(); // 返回 PhysicalPosition
  
  // 计算目标物理坐标 (Physical Pixels)...
  let targetX = ...; 
  let targetY = ...;

  const duration = 1000; // 1秒动画
  const startTime = performance.now();

  const animate = (time: number) => {
    const elapsed = time - startTime;
    const progress = Math.min(elapsed / duration, 1);
    
    // 使用 ease-out quint 曲线实现高级减速感
    const ease = 1 - Math.pow(1 - progress, 5);
    
    const curX = Math.round(startPos.x + (targetX - startPos.x) * ease);
    const curY = Math.round(startPos.y + (targetY - startPos.y) * ease);
    
    // 设置物理坐标 (需通过 capabilities 授权核心窗口权限)
    void appWindow.setPosition(new PhysicalPosition(curX, curY));

    if (progress < 1) requestAnimationFrame(animate);
  };
  requestAnimationFrame(animate);
}
```

## 核心概念解释

1. **指令 (Command)**: 本质上是 Rust 函数，被 Tauri 包装后可以跨进程通信 (IPC) 被前端调用。
2. **Result 类型**: Rust 的错误处理机制。
3. **IPC**: Inter-Process Communication。Tauri 的前端 Webview 和 Rust 后端运行在不同的进程中。
4. **Physical vs Logical 像素**: Physical 是屏幕实际像素；Logical 是系统缩放后的抽象像素。在高分屏上，`setPosition` 必须使用 Physical 坐标才能实现精确补间动画。
