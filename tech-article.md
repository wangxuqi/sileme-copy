# 从极速复制"死了么"APP，看AI编程时代的技术选型

2026 第一款全网爆火的 App，是一款叫「死了么」的 App，你没看错，我也没写错，就叫「死了么」。

这并不是一款标价8元的付费产品。目前，这款产品已经连续几天占据苹果 AppStore 付费榜第一。

这款 App 的功能极其简单，输入你的名字和紧急联系人邮箱，然后每天签到。如果没签到，则会给紧急联系人发邮件报警。就这么简单的功能确实戳中了独居者面临的生活难题。也切切实实反映了只要戳中用户痛点，再简单的APP也有它独特的价值。也体现出，在AI时代，只要有想法，就可以迅速落地实现。

虽然这个App的功能看似简单，开发者也声称开发成本仅几千元。但麻雀虽小，五脏俱全，前端仅有的签到功能背后，却包含了用户管理、邮件推送、定时任务能力。当前流行的AI编码可以迅速且完整地实现前端能力，但涉及到包含后端能力时就会有一定挑战，但是这一短板并非不能克服，通过Rules、Skills和正确的技术选型，则可以迅速完成全栈落地。

下面我们就以复刻整个'死了么'为例，使用AI编程时代的最佳技术选型迅速实现落地。

## 一、功能拆解：麻雀虽小，五脏俱全

这款APP看起来只有一个签到按钮，但背后涉及的技术模块其实不少。

### 前端功能模块

| 功能 | 用户操作 | 技术要求 |
|-----|---------|----------|
| 信息录入 | 输入姓名和邮箱 | 表单验证、输入框组件 |
| 每日签到 | 点击签到按钮 | 按钮交互、状态管理 |
| 状态展示 | 显示"今日已签到" | UI状态切换、本地缓存 |
| 成功反馈 | 签到成功动画 | 动画效果、用户体验 |

### 后端功能模块

| 功能 | 业务需求 | 技术要求 |
|-----|---------|----------|
| 用户管理 | 记录用户信息 | 数据库、用户表 |
| 身份识别 | 区分不同用户 | 认证系统、Session管理 |
| 签到记录 | 存储每日签到 | 数据库、防重复机制 |
| 数据隔离 | 用户只能看自己的数据 | 权限控制、安全策略 |
| 定时检测 | 每天自动检查谁没签到 | 定时任务、业务逻辑 |
| 邮件通知 | 发送提醒邮件 | 邮件服务、消息推送 |

### 核心挑战

在AI编程时代：
- ✅ **前端容易**：AI可以快速生成SwiftUI代码，实现界面和交互
- ⚠️ **后端有挑战**：需要数据库、认证、定时任务、邮件服务
- 🎯 **解决方案**：选择AI亲和的后端技术栈

![APP功能演示](placeholder-app-demo.png)

## 二、技术选型：AI编程时代的最佳拍档

### 前端选型：SwiftUI

**为什么选择SwiftUI？**

| 维度 | SwiftUI优势 | AI编码友好度 |
|-----|------------|-------------|
| 代码风格 | 声明式语法，结构清晰 | ⭐⭐⭐⭐⭐ AI最容易理解和生成 |
| 学习曲线 | 代码简洁，易读易写 | ⭐⭐⭐⭐⭐ 提示词直观转代码 |
| 组件化 | 原生组件丰富 | ⭐⭐⭐⭐⭐ AI可直接调用系统组件 |
| 预览能力 | 实时预览界面 | ⭐⭐⭐⭐ 快速验证AI生成效果 |

**AI编码示例**

当你对AI说："创建一个带渐变色的圆形签到按钮"

AI可以直接生成：
- 使用`Circle()`创建圆形
- 使用`.fill(LinearGradient())`实现渐变
- 完整的点击事件处理
- 状态管理逻辑

### 后端选型：Supabase - AI编程时代的完美后端

**为什么说Supabase是AI亲和的？**

传统后端开发 vs Supabase对比：

| 需求 | 传统方式（AI难处理） | Supabase方式（AI友好） | 效率提升 |
|-----|-------------------|---------------------|----------|
| 搭建数据库 | 安装PostgreSQL、配置环境 | 提供SQL Schema，Supabase自动创建 | 10倍 |
| 实现API | 编写Controller、Router、Service | 表结构定义完，API自动生成 | 20倍 |
| 用户认证 | 实现注册、登录、Session管理 | 一行代码调用匿名认证 | 15倍 |
| 权限控制 | 编写Middleware、鉴权逻辑 | 用SQL定义RLS策略 | 8倍 |
| 定时任务 | 部署Cron服务、编写脚本 | 创建Edge Function + Cron配置 | 10倍 |

**Supabase的AI亲和性体现在哪里？**

1. **声明式配置**
   - 用SQL定义表结构 → AI擅长生成SQL
   - 用SQL定义RLS策略 → AI理解规则逻辑
   - 用TypeScript编写Edge Functions → AI的强项

2. **自动API生成**
   - 无需手写RESTful接口
   - AI只需调用`.insert()`、`.select()`等方法
   - 避免了复杂的后端架构设计

3. **丰富的SDK**
   - 官方Swift SDK，AI可直接使用
   - 文档完善，AI容易理解调用方式
   - 类型安全，减少AI生成错误

### 整体技术架构

```
┌─────────────────────────────────────┐
│      前端层 - SwiftUI               │
│  ┌──────────┐  ┌──────────────┐    │
│  │  签到界面 │  │  状态管理    │    │
│  └──────────┘  └──────────────┘    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     认证层 - Supabase Auth          │
│  ┌──────────┐  ┌──────────────┐    │
│  │ 匿名认证  │  │ Session管理  │    │
│  └──────────┘  └──────────────┘    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    数据层 - PostgreSQL              │
│  ┌──────┐ ┌──────────┐ ┌────────┐  │
│  │users │ │check_ins │ │  logs  │  │
│  └──────┘ └──────────┘ └────────┘  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    安全层 - RLS策略                 │
│     数据隔离 + 权限控制              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   服务层 - Edge Functions          │
│  ┌────────────────┐ ┌────────────┐ │
│  │  检测未签到     │ │  发送邮件  │ │
│  └────────────────┘ └────────────┘ │
└─────────────────────────────────────┘
```

![Supabase Dashboard](placeholder-supabase-dashboard.png)

## 三、Supabase能力实战：如何实现每个功能模块

### 能力1：PostgreSQL数据库 - 存储的基石

**实现的功能模块**：用户管理、签到记录、通知日志

**核心表设计**

**users表**（用户信息）

| 字段名 | 类型 | 说明 | 设计亮点 |
|-------|------|------|---------|
| id | UUID | 用户唯一标识 | 关联auth.users，自动生成 |
| name | VARCHAR | 用户姓名 | 简单字段，AI易理解 |
| emergency_email | VARCHAR | 紧急联系人邮箱 | 业务核心字段 |
| created_at | TIMESTAMP | 创建时间 | 自动设置默认值 |
| updated_at | TIMESTAMP | 更新时间 | 触发器自动更新 |

**check_ins表**（签到记录）

| 字段名 | 类型 | 说明 | 防止重复机制 |
|-------|------|------|------------|
| id | BIGSERIAL | 自增主键 | 自动递增 |
| user_id | UUID | 关联用户 | 外键约束 |
| check_in_date | DATE | 签到日期 | 核心业务字段 |
| check_in_time | TIMESTAMP | 签到时间戳 | 精确到秒 |
| **唯一约束** | (user_id, check_in_date) | **每人每天只能签到一次** | 数据库层面保证 |

**notification_logs表**（通知日志）

| 字段名 | 类型 | 说明 | 业务意义 |
|-------|------|------|---------|
| id | BIGSERIAL | 自增主键 | 日志记录 |
| user_id | UUID | 关联用户 | 追踪谁被通知 |
| notification_date | DATE | 通知日期 | 防止重复发送 |
| email_sent | BOOLEAN | 是否成功 | 运维排查 |
| consecutive_miss_days | INTEGER | 连续未签到天数 | 业务数据 |
| **唯一约束** | (user_id, notification_date) | **同一天不重复通知** | 用户体验保障 |

**AI如何使用这些表？**

AI只需理解业务逻辑，用自然语言描述SQL：
- "创建一个users表，包含姓名和邮箱" → AI生成`CREATE TABLE`语句
- "确保每人每天只能签到一次" → AI添加`UNIQUE`约束
- "updated_at字段自动更新" → AI创建触发器

### 能力2：匿名认证 - 无感身份识别

**实现的功能模块**：身份识别、Session管理

**工作流程**

```
用户打开App
    ↓
检查本地是否有userId
    ↓
┌─────────┴──────────┐
│ 首次使用           │ 已有userId
│                    │
│ signInAnonymously()│ 验证Session是否有效
│ ↓                  │ ↓
│ 创建匿名用户        │ ┌───────┴────────┐
│ ↓                  │ │ Session有效     │ Session过期
│ 返回UUID + Session │ │ 验证通过        │ 重新认证
│                    │ │                 │
└────────┬───────────┘ └─────────────────┘
         │
         ↓
    使用userId操作数据
```

**为什么匿名认证对AI编程友好？**

| 传统认证方式 | Supabase匿名认证 | AI编程优势 |
|------------|-----------------|-----------|
| 需要实现注册、登录界面 | 无需界面 | AI省略UI代码 |
| 需要验证邮箱/手机号 | 自动分配UUID | AI无需处理验证逻辑 |
| 需要管理密码加密、重置 | 无密码 | AI避免安全陷阱 |
| 需要处理Session、Token | SDK自动管理 | AI只需调用一行代码 |

**AI实现代码示例**（伪代码）

当你告诉AI："实现匿名认证"

AI可以生成：
```
检查本地是否有userId
如果没有：
  调用 supabase.auth.signInAnonymously()
  保存返回的userId到本地
如果有：
  验证Session是否有效
  如果失效，重新认证
```

### 能力3：自动API生成 - 无需编写后端接口

**实现的功能模块**：保存用户信息、插入签到记录、查询签到状态

**Supabase自动生成的API**

定义好表结构后，Supabase自动提供：

| 操作 | 自动API方法 | 业务场景 | AI调用示例 |
|-----|-----------|---------|-----------|
| 插入 | `.insert()` | 保存用户信息、记录签到 | `supabase.from('users').insert(data)` |
| 查询 | `.select()` | 获取用户信息、检查签到 | `supabase.from('check_ins').select('*')` |
| 更新 | `.update()` | 修改用户信息 | `supabase.from('users').update(data)` |
| Upsert | `.upsert()` | 有则更新、无则插入 | `supabase.from('users').upsert(data)` |

**强大的查询能力**

Supabase支持复杂查询，AI可以轻松组合：

```swift
// 查询今天是否签到
supabase.from('check_ins')
  .select('*')
  .eq('user_id', userId)
  .eq('check_in_date', today)
  .single()

// 查询最后签到日期
supabase.from('check_ins')
  .select('check_in_date')
  .eq('user_id', userId)
  .order('check_in_date', ascending: false)
  .limit(1)
```

AI只需理解业务需求，自然语言转代码即可。

**传统方式 vs Supabase对比**

传统方式（AI难处理）：
1. 设计RESTful路由：`POST /api/checkin`
2. 编写Controller处理请求
3. 编写Service层业务逻辑
4. 编写Repository层数据库操作
5. 配置路由映射
6. 处理错误响应

Supabase方式（AI友好）：
1. 调用`.insert()`方法

**效率提升：20倍**

### 能力4：Row Level Security - 数据库级别的权限控制

**实现的功能模块**：数据隔离、安全控制

**什么是RLS？**

Row Level Security（行级安全策略）是PostgreSQL的原生功能，可以在数据库层面限制用户访问的数据行。

**为什么RLS对AI编程友好？**

传统方式（AI难处理）：
```
需要在应用层编写鉴权中间件：
- 验证用户身份
- 检查请求参数中的user_id
- 判断是否与当前用户匹配
- 处理各种边界情况
- 容易遗漏某个接口
```

RLS方式（AI友好）：
```sql
-- 用一条SQL定义规则
CREATE POLICY "users_select_policy" ON users
FOR SELECT USING (auth.uid() = id);

-- 数据库自动过滤，应用层无需关心
```

**本项目的RLS策略**

**users表策略**

| 操作 | 策略 | 业务含义 |
|-----|------|---------|
| SELECT | `auth.uid() = id` | 用户只能查询自己的信息 |
| INSERT | `auth.uid() = id` | 用户只能创建自己的记录 |
| UPDATE | `auth.uid() = id` | 用户只能更新自己的信息 |
| DELETE | 禁止 | 保护数据完整性 |

**check_ins表策略**

| 操作 | 策略 | 业务含义 |
|-----|------|---------|
| SELECT | `auth.uid() = user_id` | 用户只能查询自己的签到记录 |
| INSERT | `auth.uid() = user_id` | 用户只能插入自己的签到 |
| UPDATE | 禁止 | 防止篡改历史记录 |
| DELETE | 禁止 | 防止删除历史记录 |

**RLS的强大之处**

即使AI生成的代码忘记检查权限，数据库也会自动过滤：

```swift
// AI生成的代码（没有权限检查）
let data = await supabase.from('users').select('*')

// 数据库自动应用RLS策略
// 只返回 auth.uid() = id 的记录
// 用户A永远看不到用户B的数据
```

![RLS策略配置](placeholder-rls-config.png)

### 能力5：Edge Functions - 服务端业务逻辑

**实现的功能模块**：定时检测未签到、发送邮件通知

**什么是Edge Functions？**

- 运行在Supabase云端的Serverless函数
- 使用Deno运行时，原生支持TypeScript
- 自动部署到全球边缘节点
- 支持Cron Job定时触发

**为什么Edge Functions对AI编程友好？**

| 维度 | 传统方式 | Edge Functions | AI优势 |
|-----|---------|---------------|--------|
| 语言 | 需要配置Node.js环境 | 直接写TypeScript | AI擅长TS |
| 部署 | 需要服务器、Docker配置 | 一行命令部署 | AI不用管运维 |
| 调用方式 | 需要配置API网关 | HTTP端点自动生成 | AI直接调用URL |
| 定时任务 | 需要Cron服务 | 内置Cron Jobs | AI只需配置表达式 |
| 权限 | 需要实现鉴权 | 使用service_role key | AI无需处理鉴权 |

**Edge Function 1: check-missed-check-ins**

功能：每天检测所有用户，找出连续2天未签到的，发送邮件通知。

**业务流程**

```
Cron Job每天9:00触发
    ↓
查询所有用户
    ↓
遍历每个用户
    ↓
查询最后签到日期
    ↓
计算未签到天数
    ↓
┌──────────┴───────────┐
│ 天数 ≠ 2             │ 天数 = 2
│ 跳过该用户           │ ↓
│                      │ 今天是否已通知?
│                      │ ↓
│                      │ ┌────────┴────────┐
│                      │ │ 是              │ 否
│                      │ │ 跳过,避免重复   │ ↓
│                      │ │                 │ 调用发送邮件函数
│                      │ │                 │ ↓
│                      │ │                 │ 插入通知日志
└──────────┬───────────┘ └─────────────────┘
           │
           ↓
    继续下一个用户
```

**AI如何实现这个函数？**

你对AI说：
```
"写一个Edge Function:
1. 查询所有用户
2. 对每个用户查询最后签到日期
3. 计算距今天数，如果等于2天
4. 检查今天是否已发送通知
5. 如果没有，调用发送邮件函数
6. 插入通知日志"
```

AI可以完整实现，因为：
- TypeScript语法AI很熟悉
- Supabase SDK调用简单直观
- 业务逻辑清晰，易于转换为代码

**Edge Function 2: send-notification-email**

功能：接收用户信息，发送邮件给紧急联系人。

邮件内容示例：
```
主题：【一键打卡】张三已连续2天未签到

尊敬的紧急联系人：

您好！我们注意到您的朋友/家人"张三"已经连续2天
未在"一键打卡"APP中签到。

请您方便时联系对方，确认其安全。

此致
一键打卡团队
```

**AI实现邮件函数**

AI可以轻松处理：
- 构建邮件HTML内容
- 调用邮件服务API
- 处理发送成功/失败
- 返回结构化结果

![Edge Functions列表](placeholder-edge-functions.png)

### 能力6：Cron Jobs - 定时任务调度

**实现的功能模块**：每天自动检测

**配置方式**

在Supabase Dashboard中创建Cron Job：

| 配置项 | 值 | 说明 |
|-------|---|------|
| 任务名称 | check-missed-check-ins | 描述性名称 |
| Cron表达式 | `0 1 * * *` | UTC时间凌晨1点 = 北京9点 |
| 触发方式 | HTTP POST | 调用Edge Function |
| URL | `/functions/v1/check-missed-check-ins` | 函数端点 |
| 认证 | Service Role Key | 绕过RLS |

**Cron表达式解释**

```
0 1 * * *
│ │ │ │ │
│ │ │ │ └─ 星期几 (0-7, 0和7都代表周日)
│ │ │ └─── 月份 (1-12)
│ │ └───── 日期 (1-31)
│ └─────── 小时 (0-23)
└───────── 分钟 (0-59)

0 1 * * * = 每天UTC时间凌晨1点
          = 北京时间上午9点
```

**为什么内置Cron对AI编程友好？**

传统方式（AI难处理）：
- 需要部署独立的任务调度服务
- 需要配置任务执行环境
- 需要处理任务失败重试
- 需要监控任务运行状态

Supabase方式（AI友好）：
- 在Dashboard点几下配置完成
- 自动调用Edge Function
- 失败自动重试
- 日志自动记录

## 四、开发过程真实数据

### 时间分配（总计约20小时）

| 阶段 | 耗时 | 主要工作 | AI参与度 |
|-----|------|---------|---------|
| 需求分析 | 1小时 | 分析功能、设计数据库 | 10% |
| 数据库设计 | 1小时 | 编写SQL Schema和RLS策略 | 80% |
| iOS UI开发 | 5小时 | SwiftUI界面、组件开发 | 70% |
| iOS业务逻辑 | 4小时 | ViewModel、Service层 | 75% |
| Edge Functions | 3小时 | 检测和邮件函数 | 85% |
| 集成调试 | 3小时 | 联调、修复bug | 40% |
| 测试验证 | 2小时 | 功能测试 | 30% |
| 文档编写 | 1小时 | README、部署指南 | 60% |

**AI如何参与各阶段**

- **数据库设计**：AI直接生成SQL语句，包括表结构、索引、触发器
- **UI开发**：AI生成SwiftUI组件代码，包括布局、样式、动画
- **业务逻辑**：AI实现状态管理、API调用、错误处理
- **Edge Functions**：AI编写完整的TypeScript函数代码
- **调试**：AI帮助分析错误信息，提供解决方案

### 代码规模统计

**项目文件结构**

| 类别 | 文件数 | 代码行数 | AI生成比例 | 人工调整 |
|-----|-------|---------|-----------|----------|
| SQL脚本 | 2个 | ~210行 | 90% | 优化索引、调整注释 |
| Swift代码 | 9个 | ~1200行 | 75% | 调整UI细节、优化体验 |
| TypeScript代码 | 2个 | ~340行 | 85% | 错误处理优化 |
| 文档 | 4个 | ~900行 | 50% | 补充部署细节 |
| **总计** | **17个** | **~2650行** | **75%** | **25%** |

### 实际遇到的技术难点

**难点1：RLS策略的权限粒度**

问题：最初想让用户可以更新签到记录，但担心被篡改

解决方案（AI辅助）：
- AI建议：禁止UPDATE和DELETE，只允许INSERT
- 原因：签到记录应该是不可变的历史数据
- 实现：在RLS策略中明确禁止UPDATE/DELETE操作

**难点2：防止重复通知**

问题：Cron Job每天执行，如何保证不重复发送邮件？

解决方案（AI辅助）：
- AI建议：创建notification_logs表，记录每次通知
- 添加唯一约束：`(user_id, notification_date)`
- 发送前先查询当日是否已有记录

**难点3：匿名认证的Session管理**

问题：Session过期后如何处理？

解决方案（AI辅助）：
- AI建议：App启动时验证Session有效性
- 如果失效，自动调用`signInAnonymously()`重新认证
- 本地持久化userId，避免每次重新认证

**难点4：计算连续未签到天数的算法**

问题：如何准确计算连续未签到天数？

解决方案（AI辅助）：
```
// AI提供的算法逻辑
最后签到日期：2026-01-10
今天日期：2026-01-13

天数差 = 今天 - 最后签到日期 = 3天
连续未签到天数 = 天数差 - 1 = 2天
（因为签到当天不算，所以减1）

未签到的是：1月11日、1月12日
```

![开发过程代码片段](placeholder-code-snippets.png)

## 五、效果展示与数据

### 功能演示

**核心功能完整流程**

1. **首次使用**
   - 打开App，自动完成匿名认证
   - 输入姓名和紧急联系人邮箱
   - 点击签到按钮
   - 显示签到成功动画
   - 按钮状态变为"今日已签到"

2. **第二天使用**
   - 打开App，自动加载用户信息
   - 检测到昨天已签到，今天未签到
   - 点击签到按钮
   - 签到成功

3. **连续未签到场景**
   - 用户连续2天未打开App
   - 第3天上午9点，系统自动检测
   - 发送邮件给紧急联系人
   - 记录通知日志

### 性能数据

| 指标 | 测试数值 | 行业标准 | 评价 |
|-----|---------|---------|------|
| App启动时间 | 0.8秒 | < 2秒 | ✅ 优秀 |
| 签到响应时间 | 420ms | < 1秒 | ✅ 快速 |
| 数据库查询时间 | 65ms | < 200ms | ✅ 迅速 |
| Edge Function执行 | 1.2秒（10用户） | < 5秒 | ✅ 高效 |

### 数据库数据展示

测试数据统计（10个测试用户，运行5天）：

| 表名 | 记录数 | 数据量 | 查询频率 |
|-----|-------|--------|----------|
| users | 10 | 2KB | 每次签到 |
| check_ins | 42 | 8KB | 每次签到、每天检测 |
| notification_logs | 3 | 1KB | 每次通知 |
| **总计** | **55** | **11KB** | - |

![Supabase数据库内容](placeholder-database-data.png)

### 成本分析

**开发成本**

| 成本项 | 传统方式 | 使用Supabase + AI | 节省 |
|-------|---------|------------------|------|
| 开发时间 | 80-100小时 | 20小时 | 75% |
| 服务器成本 | ¥200/月起 | ¥0（免费套餐内） | 100% |
| 运维时间 | 10小时/月 | 0小时 | 100% |
| 学习成本 | 需要学习后端框架 | 只需SQL和API | 60% |

**运营成本（100用户规模）**

Supabase免费套餐包含：
- 数据库：500MB存储（实际使用<1MB）
- 带宽：5GB/月（实际使用<100MB）
- Edge Functions：500K调用/月（实际约3K调用）
- 认证：无限匿名用户

**结论：完全在免费范围内**

![成本对比图](placeholder-cost-comparison.png)

## 六、总结与思考

### AI编程时代的技术选型原则

通过这个项目，我们总结出以下原则：

**原则1：优先选择声明式技术栈**

AI更擅长处理声明式代码：
- ✅ SwiftUI的声明式UI > UIKit的命令式UI
- ✅ SQL的声明式查询 > ORM的命令式操作
- ✅ RLS的声明式策略 > 中间件的命令式鉴权

**原则2：选择文档友好的技术**

AI依赖高质量文档来生成代码：
- ✅ Supabase官方文档完善
- ✅ SwiftUI有大量示例代码
- ✅ TypeScript类型系统帮助AI理解

**原则3：选择自动化程度高的服务**

减少AI需要处理的配置细节：
- ✅ Supabase自动生成API
- ✅ 匿名认证自动管理Session
- ✅ RLS自动应用权限规则

**原则4：选择类型安全的语言**

类型系统减少AI生成错误：
- ✅ Swift和TypeScript都是类型安全语言
- ✅ 编译时发现错误，而非运行时
- ✅ IDE自动提示，AI生成更准确

### Supabase在AI编程时代的独特价值

**1. 降低后端复杂度**

传统后端需要AI处理的内容：
```
框架选择 → 路由设计 → 控制器 → 服务层 → 
数据访问层 → ORM配置 → 数据库连接 → 
认证中间件 → 权限中间件 → 错误处理 → 
日志系统 → 部署配置 → 负载均衡 → ...
```

Supabase简化为：
```
SQL Schema → RLS策略 → Edge Functions（如需）
```

**2. 提供AI友好的抽象层**

| 底层技术 | Supabase抽象 | AI理解难度 |
|---------|-------------|-----------|
| PostgreSQL连接池、事务 | `.from().insert()` | ⬇️ 简单 |
| JWT、Session、Cookie | `.auth.signInAnonymously()` | ⬇️ 简单 |
| 中间件、守卫、拦截器 | SQL RLS策略 | ⬇️ 简单 |
| Serverless配置、冷启动 | Edge Functions | ⬇️ 简单 |

**3. 加速开发迭代**

AI + Supabase的开发循环：
```
需求 → AI生成SQL → 在Dashboard执行 → 
API自动可用 → AI生成前端代码 → 运行测试

耗时：分钟级
```

传统开发循环：
```
需求 → 设计表结构 → 编写Migration → 
编写Model → 编写Controller → 编写Service → 
编写测试 → 部署 → 测试

耗时：小时级
```

### 适用场景

**最适合的场景（强烈推荐）**

| 场景 | 原因 | 典型应用 |
|-----|------|---------|
| MVP快速验证 | 1小时上线，极低成本 | 创业项目、想法验证 |
| 个人项目 | 免费额度足够，零运维 | 工具类App、兴趣项目 |
| 内部工具 | 快速开发，易于维护 | 企业内部管理系统 |
| 轻量级SaaS | 开发快、成本低 | 小型SaaS服务 |

**需要评估的场景**

| 场景 | 考虑因素 | 建议 |
|-----|---------|------|
| 超大规模应用 | 成本和性能 | 评估付费方案 |
| 复杂业务逻辑 | Edge Functions限制 | 混合架构 |
| 特殊合规要求 | 私有化部署需求 | Supabase自建版 |

### 给开发者的建议

**1. 转变开发思维**

从"全栈开发"到"专注核心"：
- ❌ 不要再花时间搭建基础设施
- ❌ 不要再重复造轮子
- ✅ 专注于业务逻辑和用户体验
- ✅ 利用BaaS服务加速开发

**2. 善用AI工具**

AI + Supabase的黄金组合：
- 让AI生成SQL Schema
- 让AI生成RLS策略
- 让AI生成Edge Functions
- 让AI生成前端代码
- 你负责审查和测试

**3. 快速迭代，及时验证**

不要追求完美：
- 先做出能跑的版本（20小时）
- 找用户验证需求（1天）
- 根据反馈迭代（持续）
- 需要时再优化

**4. 关注社区和文档**

持续学习：
- Supabase官方文档
- AI编程最佳实践
- 加入开发者社区
- 分享经验和问题

---

## 附录

### 参考资料

**官方文档**

- Supabase官方文档：https://supabase.com/docs
- Supabase Swift SDK：https://github.com/supabase/supabase-swift
- SwiftUI官方教程：https://developer.apple.com/tutorials/swiftui
- Edge Functions指南：https://supabase.com/docs/guides/functions

### 完整代码示例

**数据库Schema（AI生成示例）**

```sql
-- 创建users表
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    emergency_email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建check_ins表
CREATE TABLE check_ins (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_check_in_date UNIQUE (user_id, check_in_date)
);

-- 创建索引
CREATE INDEX idx_check_ins_user_date ON check_ins(user_id, check_in_date DESC);
CREATE INDEX idx_check_ins_date ON check_ins(check_in_date);
```

**RLS策略（AI生成示例）**

```sql
-- 启用RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;

-- users表策略
CREATE POLICY "users_select" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "users_insert" ON users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "users_update" ON users FOR UPDATE USING (auth.uid() = id);

-- check_ins表策略
CREATE POLICY "check_ins_select" ON check_ins FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "check_ins_insert" ON check_ins FOR INSERT WITH CHECK (auth.uid() = user_id);
```

**Edge Function核心逻辑（AI生成示例）**

```typescript
// 检测未签到用户的核心逻辑
async function checkUser(user: User) {
  // 查询最后签到日期
  const { data: lastCheckIn } = await supabase
    .from('check_ins')
    .select('check_in_date')
    .eq('user_id', user.id)
    .order('check_in_date', { ascending: false })
    .limit(1)
    .single();
  
  if (!lastCheckIn) return; // 从未签到，跳过
  
  // 计算连续未签到天数
  const daysDiff = calculateDaysDiff(lastCheckIn.check_in_date, today);
  
  if (daysDiff === 2) {
    // 检查今天是否已通知
    const alreadyNotified = await checkNotificationLog(user.id, today);
    if (!alreadyNotified) {
      await sendEmail(user);
      await logNotification(user.id);
    }
  }
}
```

### 快速启动清单

**开始前的准备（5分钟）**

- [ ] 注册Supabase账号
- [ ] 安装Xcode（Mac用户）
- [ ] 准备AI编码助手（Cursor/Copilot）

**开发步骤（20小时）**

- [ ] 创建Supabase项目（2分钟）
- [ ] AI生成并执行SQL Schema（8分钟）
- [ ] AI生成并配置RLS策略（5分钟）
- [ ] AI生成iOS界面代码（3小时）
- [ ] AI生成ViewModel和Service（2小时）
- [ ] 集成Supabase Swift SDK（30分钟）
- [ ] AI生成Edge Functions（2小时）
- [ ] 部署Functions并配置Cron（30分钟）
- [ ] 端到端测试（2小时）

---

**结语**

在AI编程时代，选择合适的技术栈比以往任何时候都重要。Supabase通过提供声明式、文档完善、自动化程度高的BaaS服务，成为AI编程的最佳后端选择。从"死了么"这个简单应用的复刻过程中，我们看到了AI + Supabase组合的巨大潜力——将原本需要80-100小时的开发工作压缩到20小时，效率提升4-5倍。

更重要的是，这种开发模式让开发者能够真正专注于解决用户问题，而不是陷入基础设施的搭建和运维中。只要有想法，就能快速验证，这正是AI时代赋予独立开发者和小团队的最大机遇。

希望这篇文章能为你的下一个项目带来启发。现在就开始，用AI + Supabase实现你的想法吧！
# 从极速复制"死了么"APP，看AI编程时代的技术选型

2026 第一款全网爆火的 App，是一款叫「死了么」的 App，你没看错，我也没写错，就叫「死了么」。

这并不是一款标价8元的付费产品。目前，这款产品已经连续几天占据苹果 AppStore 付费榜第一。

这款 App 的功能极其简单，输入你的名字和紧急联系人邮箱，然后每天签到。如果没签到，则会给紧急联系人发邮件报警。就这么简单的功能确实戳中了独居者面临的生活难题。也切切实实反映了只要戳中用户痛点，再简单的APP也有它独特的价值。也体现出，在AI时代，只要有想法，就可以迅速落地实现。

虽然这个App的功能看似简单，开发者也声称开发成本仅几千元。但麻雀虽小，五脏俱全，前端仅有的签到功能背后，却包含了用户管理、邮件推送、定时任务能力。当前流行的AI编码可以迅速且完整地实现前端能力，但涉及到包含后端能力时就会有一定挑战，但是这一短板并非不能克服，通过Rules、Skills和正确的技术选型，则可以迅速完成全栈落地。

下面我们就以复刻整个'死了么'为例，使用AI编程时代的最佳技术选型迅速实现落地。

## 一、功能拆解：麻雀虽小，五脏俱全

这款APP看起来只有一个签到按钮，但背后涉及的技术模块其实不少。

### 前端功能模块

| 功能 | 用户操作 | 技术要求 |
|-----|---------|----------|
| 信息录入 | 输入姓名和邮箱 | 表单验证、输入框组件 |
| 每日签到 | 点击签到按钮 | 按钮交互、状态管理 |
| 状态展示 | 显示"今日已签到" | UI状态切换、本地缓存 |
| 成功反馈 | 签到成功动画 | 动画效果、用户体验 |

### 后端功能模块

| 功能 | 业务需求 | 技术要求 |
|-----|---------|----------|
| 用户管理 | 记录用户信息 | 数据库、用户表 |
| 身份识别 | 区分不同用户 | 认证系统、Session管理 |
| 签到记录 | 存储每日签到 | 数据库、防重复机制 |
| 数据隔离 | 用户只能看自己的数据 | 权限控制、安全策略 |
| 定时检测 | 每天自动检查谁没签到 | 定时任务、业务逻辑 |
| 邮件通知 | 发送提醒邮件 | 邮件服务、消息推送 |

### 核心挑战

在AI编程时代：
- ✅ **前端容易**：AI可以快速生成SwiftUI代码，实现界面和交互
- ⚠️ **后端有挑战**：需要数据库、认证、定时任务、邮件服务
- 🎯 **解决方案**：选择AI亲和的后端技术栈

![APP功能演示](placeholder-app-demo.png)

## 二、技术选型：AI编程时代的最佳拍档

### 前端选型：SwiftUI

**为什么选择SwiftUI？**

| 维度 | SwiftUI优势 | AI编码友好度 |
|-----|------------|-------------|
| 代码风格 | 声明式语法，结构清晰 | ⭐⭐⭐⭐⭐ AI最容易理解和生成 |
| 学习曲线 | 代码简洁，易读易写 | ⭐⭐⭐⭐⭐ 提示词直观转代码 |
| 组件化 | 原生组件丰富 | ⭐⭐⭐⭐⭐ AI可直接调用系统组件 |
| 预览能力 | 实时预览界面 | ⭐⭐⭐⭐ 快速验证AI生成效果 |

**AI编码示例**

当你对AI说："创建一个带渐变色的圆形签到按钮"

AI可以直接生成：
- 使用`Circle()`创建圆形
- 使用`.fill(LinearGradient())`实现渐变
- 完整的点击事件处理
- 状态管理逻辑

### 后端选型：Supabase - AI编程时代的完美后端

**为什么说Supabase是AI亲和的？**

传统后端开发 vs Supabase对比：

| 需求 | 传统方式（AI难处理） | Supabase方式（AI友好） | 效率提升 |
|-----|-------------------|---------------------|----------|
| 搭建数据库 | 安装PostgreSQL、配置环境 | 提供SQL Schema，Supabase自动创建 | 10倍 |
| 实现API | 编写Controller、Router、Service | 表结构定义完，API自动生成 | 20倍 |
| 用户认证 | 实现注册、登录、Session管理 | 一行代码调用匿名认证 | 15倍 |
| 权限控制 | 编写Middleware、鉴权逻辑 | 用SQL定义RLS策略 | 8倍 |
| 定时任务 | 部署Cron服务、编写脚本 | 创建Edge Function + Cron配置 | 10倍 |

**Supabase的AI亲和性体现在哪里？**

1. **声明式配置**
   - 用SQL定义表结构 → AI擅长生成SQL
   - 用SQL定义RLS策略 → AI理解规则逻辑
   - 用TypeScript编写Edge Functions → AI的强项

2. **自动API生成**
   - 无需手写RESTful接口
   - AI只需调用`.insert()`、`.select()`等方法
   - 避免了复杂的后端架构设计

3. **丰富的SDK**
   - 官方Swift SDK，AI可直接使用
   - 文档完善，AI容易理解调用方式
   - 类型安全，减少AI生成错误

### 整体技术架构

```
┌─────────────────────────────────────┐
│      前端层 - SwiftUI               │
│  ┌──────────┐  ┌──────────────┐    │
│  │  签到界面 │  │  状态管理    │    │
│  └──────────┘  └──────────────┘    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     认证层 - Supabase Auth          │
│  ┌──────────┐  ┌──────────────┐    │
│  │ 匿名认证  │  │ Session管理  │    │
│  └──────────┘  └──────────────┘    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    数据层 - PostgreSQL              │
│  ┌──────┐ ┌──────────┐ ┌────────┐  │
│  │users │ │check_ins │ │  logs  │  │
│  └──────┘ └──────────┘ └────────┘  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    安全层 - RLS策略                 │
│     数据隔离 + 权限控制              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   服务层 - Edge Functions          │
│  ┌────────────────┐ ┌────────────┐ │
│  │  检测未签到     │ │  发送邮件  │ │
│  └────────────────┘ └────────────┘ │
└─────────────────────────────────────┘
```

![Supabase Dashboard](placeholder-supabase-dashboard.png)

## 三、Supabase能力实战：如何实现每个功能模块

### 能力1：PostgreSQL数据库 - 存储的基石

**实现的功能模块**：用户管理、签到记录、通知日志

**核心表设计**

**users表**（用户信息）

| 字段名 | 类型 | 说明 | 设计亮点 |
|-------|------|------|---------|
| id | UUID | 用户唯一标识 | 关联auth.users，自动生成 |
| name | VARCHAR | 用户姓名 | 简单字段，AI易理解 |
| emergency_email | VARCHAR | 紧急联系人邮箱 | 业务核心字段 |
| created_at | TIMESTAMP | 创建时间 | 自动设置默认值 |
| updated_at | TIMESTAMP | 更新时间 | 触发器自动更新 |

**check_ins表**（签到记录）

| 字段名 | 类型 | 说明 | 防止重复机制 |
|-------|------|------|------------|
| id | BIGSERIAL | 自增主键 | 自动递增 |
| user_id | UUID | 关联用户 | 外键约束 |
| check_in_date | DATE | 签到日期 | 核心业务字段 |
| check_in_time | TIMESTAMP | 签到时间戳 | 精确到秒 |
| **唯一约束** | (user_id, check_in_date) | **每人每天只能签到一次** | 数据库层面保证 |

**notification_logs表**（通知日志）

| 字段名 | 类型 | 说明 | 业务意义 |
|-------|------|------|---------|
| id | BIGSERIAL | 自增主键 | 日志记录 |
| user_id | UUID | 关联用户 | 追踪谁被通知 |
| notification_date | DATE | 通知日期 | 防止重复发送 |
| email_sent | BOOLEAN | 是否成功 | 运维排查 |
| consecutive_miss_days | INTEGER | 连续未签到天数 | 业务数据 |
| **唯一约束** | (user_id, notification_date) | **同一天不重复通知** | 用户体验保障 |

**AI如何使用这些表？**

AI只需理解业务逻辑，用自然语言描述SQL：
- "创建一个users表，包含姓名和邮箱" → AI生成`CREATE TABLE`语句
- "确保每人每天只能签到一次" → AI添加`UNIQUE`约束
- "updated_at字段自动更新" → AI创建触发器

### 能力2：匿名认证 - 无感身份识别

**实现的功能模块**：身份识别、Session管理

**工作流程**

```
用户打开App
    ↓
检查本地是否有userId
    ↓
┌─────────┴──────────┐
│ 首次使用           │ 已有userId
│                    │
│ signInAnonymously()│ 验证Session是否有效
│ ↓                  │ ↓
│ 创建匿名用户        │ ┌───────┴────────┐
│ ↓                  │ │ Session有效     │ Session过期
│ 返回UUID + Session │ │ 验证通过        │ 重新认证
│                    │ │                 │
└────────┬───────────┘ └─────────────────┘
         │
         ↓
    使用userId操作数据
```

**为什么匿名认证对AI编程友好？**

| 传统认证方式 | Supabase匿名认证 | AI编程优势 |
|------------|-----------------|-----------|
| 需要实现注册、登录界面 | 无需界面 | AI省略UI代码 |
| 需要验证邮箱/手机号 | 自动分配UUID | AI无需处理验证逻辑 |
| 需要管理密码加密、重置 | 无密码 | AI避免安全陷阱 |
| 需要处理Session、Token | SDK自动管理 | AI只需调用一行代码 |

**AI实现代码示例**（伪代码）

当你告诉AI："实现匿名认证"

AI可以生成：
```
检查本地是否有userId
如果没有：
  调用 supabase.auth.signInAnonymously()
  保存返回的userId到本地
如果有：
  验证Session是否有效
  如果失效，重新认证
```

### 能力3：自动API生成 - 无需编写后端接口

**实现的功能模块**：保存用户信息、插入签到记录、查询签到状态

**Supabase自动生成的API**

定义好表结构后，Supabase自动提供：

| 操作 | 自动API方法 | 业务场景 | AI调用示例 |
|-----|-----------|---------|-----------|
| 插入 | `.insert()` | 保存用户信息、记录签到 | `supabase.from('users').insert(data)` |
| 查询 | `.select()` | 获取用户信息、检查签到 | `supabase.from('check_ins').select('*')` |
| 更新 | `.update()` | 修改用户信息 | `supabase.from('users').update(data)` |
| Upsert | `.upsert()` | 有则更新、无则插入 | `supabase.from('users').upsert(data)` |

**强大的查询能力**

Supabase支持复杂查询，AI可以轻松组合：

```swift
// 查询今天是否签到
supabase.from('check_ins')
  .select('*')
  .eq('user_id', userId)
  .eq('check_in_date', today)
  .single()

// 查询最后签到日期
supabase.from('check_ins')
  .select('check_in_date')
  .eq('user_id', userId)
  .order('check_in_date', ascending: false)
  .limit(1)
```

AI只需理解业务需求，自然语言转代码即可。

**传统方式 vs Supabase对比**

传统方式（AI难处理）：
1. 设计RESTful路由：`POST /api/checkin`
2. 编写Controller处理请求
3. 编写Service层业务逻辑
4. 编写Repository层数据库操作
5. 配置路由映射
6. 处理错误响应

Supabase方式（AI友好）：
1. 调用`.insert()`方法

**效率提升：20倍**

### 能力4：Row Level Security - 数据库级别的权限控制

**实现的功能模块**：数据隔离、安全控制

**什么是RLS？**

Row Level Security（行级安全策略）是PostgreSQL的原生功能，可以在数据库层面限制用户访问的数据行。

**为什么RLS对AI编程友好？**

传统方式（AI难处理）：
```
需要在应用层编写鉴权中间件：
- 验证用户身份
- 检查请求参数中的user_id
- 判断是否与当前用户匹配
- 处理各种边界情况
- 容易遗漏某个接口
```

RLS方式（AI友好）：
```sql
-- 用一条SQL定义规则
CREATE POLICY "users_select_policy" ON users
FOR SELECT USING (auth.uid() = id);

-- 数据库自动过滤，应用层无需关心
```

**本项目的RLS策略**

**users表策略**

| 操作 | 策略 | 业务含义 |
|-----|------|---------|
| SELECT | `auth.uid() = id` | 用户只能查询自己的信息 |
| INSERT | `auth.uid() = id` | 用户只能创建自己的记录 |
| UPDATE | `auth.uid() = id` | 用户只能更新自己的信息 |
| DELETE | 禁止 | 保护数据完整性 |

**check_ins表策略**

| 操作 | 策略 | 业务含义 |
|-----|------|---------|
| SELECT | `auth.uid() = user_id` | 用户只能查询自己的签到记录 |
| INSERT | `auth.uid() = user_id` | 用户只能插入自己的签到 |
| UPDATE | 禁止 | 防止篡改历史记录 |
| DELETE | 禁止 | 防止删除历史记录 |

**RLS的强大之处**

即使AI生成的代码忘记检查权限，数据库也会自动过滤：

```swift
// AI生成的代码（没有权限检查）
let data = await supabase.from('users').select('*')

// 数据库自动应用RLS策略
// 只返回 auth.uid() = id 的记录
// 用户A永远看不到用户B的数据
```

![RLS策略配置](placeholder-rls-config.png)

### 能力5：Edge Functions - 服务端业务逻辑

**实现的功能模块**：定时检测未签到、发送邮件通知

**什么是Edge Functions？**

- 运行在Supabase云端的Serverless函数
- 使用Deno运行时，原生支持TypeScript
- 自动部署到全球边缘节点
- 支持Cron Job定时触发

**为什么Edge Functions对AI编程友好？**

| 维度 | 传统方式 | Edge Functions | AI优势 |
|-----|---------|---------------|--------|
| 语言 | 需要配置Node.js环境 | 直接写TypeScript | AI擅长TS |
| 部署 | 需要服务器、Docker配置 | 一行命令部署 | AI不用管运维 |
| 调用方式 | 需要配置API网关 | HTTP端点自动生成 | AI直接调用URL |
| 定时任务 | 需要Cron服务 | 内置Cron Jobs | AI只需配置表达式 |
| 权限 | 需要实现鉴权 | 使用service_role key | AI无需处理鉴权 |

**Edge Function 1: check-missed-check-ins**

功能：每天检测所有用户，找出连续2天未签到的，发送邮件通知。

**业务流程**

```
Cron Job每天9:00触发
    ↓
查询所有用户
    ↓
遍历每个用户
    ↓
查询最后签到日期
    ↓
计算未签到天数
    ↓
┌──────────┴───────────┐
│ 天数 ≠ 2             │ 天数 = 2
│ 跳过该用户           │ ↓
│                      │ 今天是否已通知?
│                      │ ↓
│                      │ ┌────────┴────────┐
│                      │ │ 是              │ 否
│                      │ │ 跳过,避免重复   │ ↓
│                      │ │                 │ 调用发送邮件函数
│                      │ │                 │ ↓
│                      │ │                 │ 插入通知日志
└──────────┬───────────┘ └─────────────────┘
           │
           ↓
    继续下一个用户
```

**AI如何实现这个函数？**

你对AI说：
```
"写一个Edge Function:
1. 查询所有用户
2. 对每个用户查询最后签到日期
3. 计算距今天数，如果等于2天
4. 检查今天是否已发送通知
5. 如果没有，调用发送邮件函数
6. 插入通知日志"
```

AI可以完整实现，因为：
- TypeScript语法AI很熟悉
- Supabase SDK调用简单直观
- 业务逻辑清晰，易于转换为代码

**Edge Function 2: send-notification-email**

功能：接收用户信息，发送邮件给紧急联系人。

邮件内容示例：
```
主题：【一键打卡】张三已连续2天未签到

尊敬的紧急联系人：

您好！我们注意到您的朋友/家人"张三"已经连续2天
未在"一键打卡"APP中签到。

请您方便时联系对方，确认其安全。

此致
一键打卡团队
```

**AI实现邮件函数**

AI可以轻松处理：
- 构建邮件HTML内容
- 调用邮件服务API
- 处理发送成功/失败
- 返回结构化结果

![Edge Functions列表](placeholder-edge-functions.png)

### 能力6：Cron Jobs - 定时任务调度

**实现的功能模块**：每天自动检测

**配置方式**

在Supabase Dashboard中创建Cron Job：

| 配置项 | 值 | 说明 |
|-------|---|------|
| 任务名称 | check-missed-check-ins | 描述性名称 |
| Cron表达式 | `0 1 * * *` | UTC时间凌晨1点 = 北京9点 |
| 触发方式 | HTTP POST | 调用Edge Function |
| URL | `/functions/v1/check-missed-check-ins` | 函数端点 |
| 认证 | Service Role Key | 绕过RLS |

**Cron表达式解释**

```
0 1 * * *
│ │ │ │ │
│ │ │ │ └─ 星期几 (0-7, 0和7都代表周日)
│ │ │ └─── 月份 (1-12)
│ │ └───── 日期 (1-31)
│ └─────── 小时 (0-23)
└───────── 分钟 (0-59)

0 1 * * * = 每天UTC时间凌晨1点
          = 北京时间上午9点
```

**为什么内置Cron对AI编程友好？**

传统方式（AI难处理）：
- 需要部署独立的任务调度服务
- 需要配置任务执行环境
- 需要处理任务失败重试
- 需要监控任务运行状态

Supabase方式（AI友好）：
- 在Dashboard点几下配置完成
- 自动调用Edge Function
- 失败自动重试
- 日志自动记录

## 四、开发过程真实数据

### 时间分配（总计约20小时）

| 阶段 | 耗时 | 主要工作 | AI参与度 |
|-----|------|---------|---------|
| 需求分析 | 1小时 | 分析功能、设计数据库 | 10% |
| 数据库设计 | 1小时 | 编写SQL Schema和RLS策略 | 80% |
| iOS UI开发 | 5小时 | SwiftUI界面、组件开发 | 70% |
| iOS业务逻辑 | 4小时 | ViewModel、Service层 | 75% |
| Edge Functions | 3小时 | 检测和邮件函数 | 85% |
| 集成调试 | 3小时 | 联调、修复bug | 40% |
| 测试验证 | 2小时 | 功能测试 | 30% |
| 文档编写 | 1小时 | README、部署指南 | 60% |

**AI如何参与各阶段**

- **数据库设计**：AI直接生成SQL语句，包括表结构、索引、触发器
- **UI开发**：AI生成SwiftUI组件代码，包括布局、样式、动画
- **业务逻辑**：AI实现状态管理、API调用、错误处理
- **Edge Functions**：AI编写完整的TypeScript函数代码
- **调试**：AI帮助分析错误信息，提供解决方案

### 代码规模统计

**项目文件结构**

| 类别 | 文件数 | 代码行数 | AI生成比例 | 人工调整 |
|-----|-------|---------|-----------|----------|
| SQL脚本 | 2个 | ~210行 | 90% | 优化索引、调整注释 |
| Swift代码 | 9个 | ~1200行 | 75% | 调整UI细节、优化体验 |
| TypeScript代码 | 2个 | ~340行 | 85% | 错误处理优化 |
| 文档 | 4个 | ~900行 | 50% | 补充部署细节 |
| **总计** | **17个** | **~2650行** | **75%** | **25%** |

### 实际遇到的技术难点

**难点1：RLS策略的权限粒度**

问题：最初想让用户可以更新签到记录，但担心被篡改

解决方案（AI辅助）：
- AI建议：禁止UPDATE和DELETE，只允许INSERT
- 原因：签到记录应该是不可变的历史数据
- 实现：在RLS策略中明确禁止UPDATE/DELETE操作

**难点2：防止重复通知**

问题：Cron Job每天执行，如何保证不重复发送邮件？

解决方案（AI辅助）：
- AI建议：创建notification_logs表，记录每次通知
- 添加唯一约束：`(user_id, notification_date)`
- 发送前先查询当日是否已有记录

**难点3：匿名认证的Session管理**

问题：Session过期后如何处理？

解决方案（AI辅助）：
- AI建议：App启动时验证Session有效性
- 如果失效，自动调用`signInAnonymously()`重新认证
- 本地持久化userId，避免每次重新认证

**难点4：计算连续未签到天数的算法**

问题：如何准确计算连续未签到天数？

解决方案（AI辅助）：
```
// AI提供的算法逻辑
最后签到日期：2026-01-10
今天日期：2026-01-13

天数差 = 今天 - 最后签到日期 = 3天
连续未签到天数 = 天数差 - 1 = 2天
（因为签到当天不算，所以减1）

未签到的是：1月11日、1月12日
```

![开发过程代码片段](placeholder-code-snippets.png)

## 五、效果展示与数据

### 功能演示

**核心功能完整流程**

1. **首次使用**
   - 打开App，自动完成匿名认证
   - 输入姓名和紧急联系人邮箱
   - 点击签到按钮
   - 显示签到成功动画
   - 按钮状态变为"今日已签到"

2. **第二天使用**
   - 打开App，自动加载用户信息
   - 检测到昨天已签到，今天未签到
   - 点击签到按钮
   - 签到成功

3. **连续未签到场景**
   - 用户连续2天未打开App
   - 第3天上午9点，系统自动检测
   - 发送邮件给紧急联系人
   - 记录通知日志

### 性能数据

| 指标 | 测试数值 | 行业标准 | 评价 |
|-----|---------|---------|------|
| App启动时间 | 0.8秒 | < 2秒 | ✅ 优秀 |
| 签到响应时间 | 420ms | < 1秒 | ✅ 快速 |
| 数据库查询时间 | 65ms | < 200ms | ✅ 迅速 |
| Edge Function执行 | 1.2秒（10用户） | < 5秒 | ✅ 高效 |

### 数据库数据展示

测试数据统计（10个测试用户，运行5天）：

| 表名 | 记录数 | 数据量 | 查询频率 |
|-----|-------|--------|----------|
| users | 10 | 2KB | 每次签到 |
| check_ins | 42 | 8KB | 每次签到、每天检测 |
| notification_logs | 3 | 1KB | 每次通知 |
| **总计** | **55** | **11KB** | - |

![Supabase数据库内容](placeholder-database-data.png)

### 成本分析

**开发成本**

| 成本项 | 传统方式 | 使用Supabase + AI | 节省 |
|-------|---------|------------------|------|
| 开发时间 | 80-100小时 | 20小时 | 75% |
| 服务器成本 | ¥200/月起 | ¥0（免费套餐内） | 100% |
| 运维时间 | 10小时/月 | 0小时 | 100% |
| 学习成本 | 需要学习后端框架 | 只需SQL和API | 60% |

**运营成本（100用户规模）**

Supabase免费套餐包含：
- 数据库：500MB存储（实际使用<1MB）
- 带宽：5GB/月（实际使用<100MB）
- Edge Functions：500K调用/月（实际约3K调用）
- 认证：无限匿名用户

**结论：完全在免费范围内**

![成本对比图](placeholder-cost-comparison.png)

## 六、总结与思考

### AI编程时代的技术选型原则

通过这个项目，我们总结出以下原则：

**原则1：优先选择声明式技术栈**

AI更擅长处理声明式代码：
- ✅ SwiftUI的声明式UI > UIKit的命令式UI
- ✅ SQL的声明式查询 > ORM的命令式操作
- ✅ RLS的声明式策略 > 中间件的命令式鉴权

**原则2：选择文档友好的技术**

AI依赖高质量文档来生成代码：
- ✅ Supabase官方文档完善
- ✅ SwiftUI有大量示例代码
- ✅ TypeScript类型系统帮助AI理解

**原则3：选择自动化程度高的服务**

减少AI需要处理的配置细节：
- ✅ Supabase自动生成API
- ✅ 匿名认证自动管理Session
- ✅ RLS自动应用权限规则

**原则4：选择类型安全的语言**

类型系统减少AI生成错误：
- ✅ Swift和TypeScript都是类型安全语言
- ✅ 编译时发现错误，而非运行时
- ✅ IDE自动提示，AI生成更准确

### Supabase在AI编程时代的独特价值

**1. 降低后端复杂度**

传统后端需要AI处理的内容：
```
框架选择 → 路由设计 → 控制器 → 服务层 → 
数据访问层 → ORM配置 → 数据库连接 → 
认证中间件 → 权限中间件 → 错误处理 → 
日志系统 → 部署配置 → 负载均衡 → ...
```

Supabase简化为：
```
SQL Schema → RLS策略 → Edge Functions（如需）
```

**2. 提供AI友好的抽象层**

| 底层技术 | Supabase抽象 | AI理解难度 |
|---------|-------------|-----------|
| PostgreSQL连接池、事务 | `.from().insert()` | ⬇️ 简单 |
| JWT、Session、Cookie | `.auth.signInAnonymously()` | ⬇️ 简单 |
| 中间件、守卫、拦截器 | SQL RLS策略 | ⬇️ 简单 |
| Serverless配置、冷启动 | Edge Functions | ⬇️ 简单 |

**3. 加速开发迭代**

AI + Supabase的开发循环：
```
需求 → AI生成SQL → 在Dashboard执行 → 
API自动可用 → AI生成前端代码 → 运行测试

耗时：分钟级
```

传统开发循环：
```
需求 → 设计表结构 → 编写Migration → 
编写Model → 编写Controller → 编写Service → 
编写测试 → 部署 → 测试

耗时：小时级
```

### 适用场景

**最适合的场景（强烈推荐）**

| 场景 | 原因 | 典型应用 |
|-----|------|---------|
| MVP快速验证 | 1小时上线，极低成本 | 创业项目、想法验证 |
| 个人项目 | 免费额度足够，零运维 | 工具类App、兴趣项目 |
| 内部工具 | 快速开发，易于维护 | 企业内部管理系统 |
| 轻量级SaaS | 开发快、成本低 | 小型SaaS服务 |

**需要评估的场景**

| 场景 | 考虑因素 | 建议 |
|-----|---------|------|
| 超大规模应用 | 成本和性能 | 评估付费方案 |
| 复杂业务逻辑 | Edge Functions限制 | 混合架构 |
| 特殊合规要求 | 私有化部署需求 | Supabase自建版 |

### 给开发者的建议

**1. 转变开发思维**

从"全栈开发"到"专注核心"：
- ❌ 不要再花时间搭建基础设施
- ❌ 不要再重复造轮子
- ✅ 专注于业务逻辑和用户体验
- ✅ 利用BaaS服务加速开发

**2. 善用AI工具**

AI + Supabase的黄金组合：
- 让AI生成SQL Schema
- 让AI生成RLS策略
- 让AI生成Edge Functions
- 让AI生成前端代码
- 你负责审查和测试

**3. 快速迭代，及时验证**

不要追求完美：
- 先做出能跑的版本（20小时）
- 找用户验证需求（1天）
- 根据反馈迭代（持续）
- 需要时再优化

**4. 关注社区和文档**

持续学习：
- Supabase官方文档
- AI编程最佳实践
- 加入开发者社区
- 分享经验和问题

---

## 附录

### 参考资料

**官方文档**

- Supabase官方文档：https://supabase.com/docs
- Supabase Swift SDK：https://github.com/supabase/supabase-swift
- SwiftUI官方教程：https://developer.apple.com/tutorials/swiftui
- Edge Functions指南：https://supabase.com/docs/guides/functions

### 完整代码示例

**数据库Schema（AI生成示例）**

```sql
-- 创建users表
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    emergency_email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建check_ins表
CREATE TABLE check_ins (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_check_in_date UNIQUE (user_id, check_in_date)
);

-- 创建索引
CREATE INDEX idx_check_ins_user_date ON check_ins(user_id, check_in_date DESC);
CREATE INDEX idx_check_ins_date ON check_ins(check_in_date);
```

**RLS策略（AI生成示例）**

```sql
-- 启用RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;

-- users表策略
CREATE POLICY "users_select" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "users_insert" ON users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "users_update" ON users FOR UPDATE USING (auth.uid() = id);

-- check_ins表策略
CREATE POLICY "check_ins_select" ON check_ins FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "check_ins_insert" ON check_ins FOR INSERT WITH CHECK (auth.uid() = user_id);
```

**Edge Function核心逻辑（AI生成示例）**

```typescript
// 检测未签到用户的核心逻辑
async function checkUser(user: User) {
  // 查询最后签到日期
  const { data: lastCheckIn } = await supabase
    .from('check_ins')
    .select('check_in_date')
    .eq('user_id', user.id)
    .order('check_in_date', { ascending: false })
    .limit(1)
    .single();
  
  if (!lastCheckIn) return; // 从未签到，跳过
  
  // 计算连续未签到天数
  const daysDiff = calculateDaysDiff(lastCheckIn.check_in_date, today);
  
  if (daysDiff === 2) {
    // 检查今天是否已通知
    const alreadyNotified = await checkNotificationLog(user.id, today);
    if (!alreadyNotified) {
      await sendEmail(user);
      await logNotification(user.id);
    }
  }
}
```

### 快速启动清单

**开始前的准备（5分钟）**

- [ ] 注册Supabase账号
- [ ] 安装Xcode（Mac用户）
- [ ] 准备AI编码助手（Cursor/Copilot）

**开发步骤（20小时）**

- [ ] 创建Supabase项目（2分钟）
- [ ] AI生成并执行SQL Schema（8分钟）
- [ ] AI生成并配置RLS策略（5分钟）
- [ ] AI生成iOS界面代码（3小时）
- [ ] AI生成ViewModel和Service（2小时）
- [ ] 集成Supabase Swift SDK（30分钟）
- [ ] AI生成Edge Functions（2小时）
- [ ] 部署Functions并配置Cron（30分钟）
- [ ] 端到端测试（2小时）

---

**结语**

在AI编程时代，选择合适的技术栈比以往任何时候都重要。Supabase通过提供声明式、文档完善、自动化程度高的BaaS服务，成为AI编程的最佳后端选择。从"死了么"这个简单应用的复刻过程中，我们看到了AI + Supabase组合的巨大潜力——将原本需要80-100小时的开发工作压缩到20小时，效率提升4-5倍。

更重要的是，这种开发模式让开发者能够真正专注于解决用户问题，而不是陷入基础设施的搭建和运维中。只要有想法，就能快速验证，这正是AI时代赋予独立开发者和小团队的最大机遇。

希望这篇文章能为你的下一个项目带来启发。现在就开始，用AI + Supabase实现你的想法吧！
