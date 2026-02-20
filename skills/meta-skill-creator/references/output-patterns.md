# 输出模式 (Output Patterns)

当技能需要生成一致且高质量的输出时, 请使用这些模式.

## 模板模式 (Template Pattern)

为输出格式提供模板. 根据需求匹配严格程度.

**针对严格要求 (如 API 响应或数据格式):**

```markdown
## 报告结构

始终使用以下准确的模板结构:

# [分析标题]

## 执行摘要
[对关键发现的一段概述]

## 关键发现
- 发现 1 及支持数据
- 发现 2 及支持数据
- 发现 3 及支持数据

## 建议
1. 具体的、可操作的建议
2. 具体的、可操作的建议
```

**针对灵活指导 (当适应性很有用时):**

```markdown
## 报告结构

这是一个合理的默认格式, 但请根据您的最佳判断进行调整:

# [分析标题]

## 执行摘要
[概述]

## 关键发现
[根据您的发现调整章节]

## 建议
[针对具体背景进行量身定制]

根据具体的分析类型, 按需调整章节.
```

## 示例模式 (Examples Pattern)

对于输出质量依赖于看到示例的技能, 请提供输入/输出对:

```markdown
## 提交信息格式

按照以下示例生成提交信息:

**示例 1:**
输入: Added user authentication with JWT tokens
输出:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**示例 2:**
输入: Fixed bug where dates displayed incorrectly in reports
输出:
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

遵循此风格: 类型(范围): 简短描述, 然后是详细解释.
```

示例比单纯的描述更能帮助代理清晰地理解所需的风格和详细程度.
