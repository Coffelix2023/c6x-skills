# Tauri 桌面应用设计系统 (Luxury Design)

为了打造具有“高级感”的桌面应用，我们总结了 V3 架构中的核心 UI/UX 设计规范。

## 1. 玻璃拟态 (Glassmorphism) 规范

在 macOS/Windows 上实现通透的毛玻璃效果：

```css
.luxury-container {
    background: rgba(255, 255, 255, 0.72); /* 半透明底色 */
    backdrop-filter: blur(12px) saturate(180%); /* 关键：模糊与饱和度 */
    -webkit-backdrop-filter: blur(12px) saturate(180%); /* 兼容性 */
    border: 1px solid rgba(0, 0, 0, 0.08); /* 极细边框增加精致感 */
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    border-radius: 12px;
}

/* 深色模式适配 */
.dark .luxury-container {
    background: rgba(30, 30, 30, 0.65);
    border: 1px solid rgba(255, 255, 255, 0.1);
}
```

## 2. 嵌入式下拉菜单 (Details Dropdown)

放弃传统的弹出式侧边栏（Drawer），采用嵌入式的 `<details>` 菜单，减少层级深度，提升专注度。

### HTML 结构

```html
<details class="dropdown">
    <summary class="btn">
        <!-- 图标 (如 Heroicons) -->
        <svg>...</svg>
    </summary>
    <div class="dropdown-menu">
        <button class="item">选项 A</button>
        <button class="item">选项 B</button>
    </div>
</details>
```

### 核心样式 (CSS)

```css
.dropdown summary::-webkit-details-marker { display: none; } /* 隐藏默认箭头 */
.dropdown[open] .dropdown-menu { display: block; } /* 展开逻辑 */
```

## 3. 全局主题过渡动画

确保在切换深色/浅色模式时，界面色彩能够平滑过渡，避免瞬间闪烁带来的不适感。

```css
/* 应用于核心组件或 Body */
.theme-aware-component {
    transition: background 1.0s cubic-bezier(0.4, 0, 0.2, 1), 
                color 1.0s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 1.0s ease;
}
```

## 4. 颜色系统 (Macaron Palette)

推荐使用具有亲和力的马卡龙色系。

| 色名 | 浅色代码 | 深色代码 |
| :--- | :--- | :--- |
| 樱花粉 | `#FFD1DC` | `#FFB7C5` |
| 薄荷绿 | `#B2F2BB` | `#8CE99A` |
| 柠檬黄 | `#FFF9DB` | `#FFF3BF` |

> [!TIP]
> 字体建议：优先使用系统默认字体（如苹方、Segoe UI），并提供程序员友好的等宽字体（如 Maple Mono）作为候选项。
