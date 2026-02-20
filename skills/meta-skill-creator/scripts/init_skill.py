#!/usr/bin/env python3
"""
技能初始化器 - 从模板创建一个新的技能

用法:
    init_skill.py <skill-name> --path <path>

示例:
    init_skill.py my-new-skill --path skills/public
    init_skill.py my-api-helper --path skills/private
    init_skill.py custom-skill --path /custom/location
"""

import sys
from pathlib import Path


SKILL_TEMPLATE = """---
name: {skill_name}
description: [TODO: 完整且具有描述性的说明,解释该技能的作用以及何时使用.包含触发该技能的具体场景、文件类型或任务.]
---

# {skill_title}

## 概述 (Overview)

[TODO: 用 1-2 句话解释该技能启用的功能]

## 结构化该技能 (Structuring This Skill)

[TODO: 选择最适合该技能目的的结构.常见模式:]

**1. 基于工作流** (最适合顺序流程)
- 当有清晰的分步过程时效果最佳
- 结构: ## 概述 → ## 工作流决策树 → ## 步骤 1 → ## 步骤 2...

**2. 基于任务** (最适合工具集)
- 当技能提供不同的操作/能力时效果最佳
- 结构: ## 概述 → ## 快速开始 → ## 任务类别 1 → ## 任务类别 2...

**3. 参考/指南** (最适合标准或规范)
- 适用于品牌指南、编码标准或需求
- 结构: ## 概述 → ## 指南 → ## 规范 → ## 用法...

**4. 基于能力** (最适合集成系统)
- 当技能提供多个相互关联的功能时效果最佳
- 结构: ## 概述 → ## 核心能力 → ### 1. 功能 → ### 2. 功能...

## 资源 (Resources)

此技能包含示例资源目录,演示如何组织不同类型的捆绑资源:

### scripts/
可以直接运行以执行特定操作的可执行代码 (Python/Bash 等).

### references/
旨在根据需要加载到上下文中以辅助过程和思维的文档和参考资料.

### assets/
不打算加载到上下文中,而是用于输出的文件 (模板、图像、字体等).

---

**可以删除任何不需要的目录.** 并非每个技能都需要所有三种类型的资源.
"""

EXAMPLE_SCRIPT = '''#!/usr/bin/env python3
"""
{skill_name} 的示例辅助脚本

这是一个可以直接执行的占位符脚本.
替换为实际实现,如果不需要则删除.
"""

def main():
    print("这是 {skill_name} 的示例脚本")
    # TODO: 在此处添加实际脚本逻辑

if __name__ == "__main__":
    main()
'''

EXAMPLE_REFERENCE = """# {skill_title} 的参考文档

这是详细参考文档的占位符.
替换为实际参考内容,如果不需要则删除.

## 结构建议

### API 参考示例
- 概述
- 认证
- 带示例的端点
- 错误代码

### 工作流指南示例
- 前提条件
- 分步说明
- 常见模式
- 故障排除
"""

EXAMPLE_ASSET = """# 示例资源文件

此占位符表示存储资源文件的位置.
替换为实际资源文件 (模板、图像、字体等),如果不需要则删除.

资源文件不打算加载到上下文中,而是在输出中使用.
"""


def title_case_skill_name(skill_name):
    """将连字符连接的技能名称转换为标题格式以供显示."""
    return ' '.join(word.capitalize() for word in skill_name.split('-'))


def init_skill(skill_name, path):
    """
    使用模板 SKILL.md 初始化新的技能目录.

    参数:
        skill_name: 技能名称
        path: 创建技能目录的路径
    """
    # 确定技能目录路径
    skill_dir = Path(path).resolve() / skill_name

    # 检查目录是否已存在
    if skill_dir.exists():
        print(f"❌ 错误: 技能目录已存在: {skill_dir}")
        return None

    # 创建技能目录
    try:
        skill_dir.mkdir(parents=True, exist_ok=False)
        print(f"✅ 已创建技能目录: {skill_dir}")
    except Exception as e:
        print(f"❌ 创建目录时出错: {e}")
        return None

    # 从模板创建 SKILL.md
    skill_title = title_case_skill_name(skill_name)
    skill_content = SKILL_TEMPLATE.format(
        skill_name=skill_name,
        skill_title=skill_title
    )

    skill_md_path = skill_dir / 'SKILL.md'
    try:
        skill_md_path.write_text(skill_content)
        print("✅ 已创建 SKILL.md")
    except Exception as e:
        print(f"❌ 创建 SKILL.md 时出错: {e}")
        return None

    # 创建带有示例文件的资源目录
    try:
        # 创建 scripts/ 目录及示例脚本
        scripts_dir = skill_dir / 'scripts'
        scripts_dir.mkdir(exist_ok=True)
        example_script = scripts_dir / 'example.py'
        example_script.write_text(EXAMPLE_SCRIPT.format(skill_name=skill_name))
        example_script.chmod(0o755)
        print("✅ 已创建 scripts/example.py")

        # 创建 references/ 目录及示例参考文档
        references_dir = skill_dir / 'references'
        references_dir.mkdir(exist_ok=True)
        example_reference = references_dir / 'api_reference.md'
        example_reference.write_text(EXAMPLE_REFERENCE.format(skill_title=skill_title))
        print("✅ 已创建 references/api_reference.md")

        # 创建 assets/ 目录及示例资源占位符
        assets_dir = skill_dir / 'assets'
        assets_dir.mkdir(exist_ok=True)
        example_asset = assets_dir / 'example_asset.txt'
        example_asset.write_text(EXAMPLE_ASSET)
        print("✅ 已创建 assets/example_asset.txt")
    except Exception as e:
        print(f"❌ 创建资源目录时出错: {e}")
        return None

    # 打印后续步骤
    print(f"\\n✅ 技能 '{skill_name}' 已在 {skill_dir} 初始化成功")
    print("\\n后续步骤:")
    print("1. 编辑 SKILL.md 以完成 TODO 项目并更新说明")
    print("2. 自定义或删除 scripts/、references/ 和 assets/ 中的示例文件")
    print("3. 准备好后运行验证器以检查技能结构")

    return skill_dir


def main():
    if len(sys.argv) < 4 or sys.argv[2] != '--path':
        print("用法: init_skill.py <skill-name> --path <path>")
        sys.exit(1)

    skill_name = sys.argv[1]
    path = sys.argv[3]

    print(f"🚀 正在初始化技能: {skill_name}")
    print(f"   位置: {path}")
    print()

    result = init_skill(skill_name, path)

    if result:
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
