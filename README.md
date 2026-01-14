# 一键打卡 (SileMe Check-in App)

一款简洁的iOS签到应用，帮助用户通过每日签到保持活跃状态。当用户连续2天未签到时，系统将通知其紧急联系人。

## 项目结构

```
sileme/
├── ios/                          # iOS应用代码
│   └── SileMe/
│       └── SileMe/
│           ├── SileMeApp.swift           # 应用入口
│           ├── Models/                    # 数据模型
│           │   └── Models.swift
│           ├── ViewModels/                # 视图模型
│           │   └── CheckInViewModel.swift
│           ├── Views/                     # 视图
│           │   ├── ContentView.swift      # 主界面
│           │   └── Components/            # UI组件
│           │       ├── CustomTextField.swift
│           │       ├── CheckInButton.swift
│           │       └── InfoBox.swift
│           ├── Services/                  # 服务层
│           │   ├── LocalStorageService.swift
│           │   └── SupabaseService.swift
│           └── Utilities/                 # 工具类
│               └── Configuration.swift
│
├── supabase/                     # Supabase后端配置
│   ├── schema.sql                         # 数据库表结构
│   ├── rls_policies.sql                   # RLS策略
│   └── functions/                         # Edge Functions
│       ├── check-missed-check-ins/        # 检测未签到函数
│       │   └── index.ts
│       └── send-notification-email/       # 发送邮件函数
│           └── index.ts
│
└── README.md                     # 项目说明文档
```

## 功能特性

### 核心功能
- ✅ 用户信息管理（姓名、紧急联系人邮箱）
- ✅ 每日签到功能
- ✅ 签到状态实时反馈
- ✅ 本地数据缓存
- ✅ 自动检测连续未签到
- ✅ 邮件通知紧急联系人

### 技术特性
- SwiftUI原生UI框架
- MVVM架构设计
- Supabase后端服务（BaaS）
- 匿名认证机制
- Row Level Security数据隔离
- Edge Functions定时任务

## 部署指南

### 1. Supabase后端部署

#### 1.1 创建Supabase项目

1. 访问 [ADB Supabase官网](https://help.aliyun.com/zh/analyticdb/analyticdb-for-postgresql/user-guide/supabase/)
2. 注册/登录账号
3. 创建新项目
4. 记录以下信息：
   - Project URL: `https://xxxxx.opentrust.net`
   - Anon Key: `your-anon-key`
   - Service Role Key: `your-service-role-key`

#### 1.2 创建数据库表

在Supabase Dashboard的SQL Editor中执行以下SQL：

```bash
# 依次执行以下SQL文件
1. supabase/schema.sql         # 创建数据表
2. supabase/rls_policies.sql   # 配置RLS策略
```

#### 1.3 配置匿名认证

1. 进入 `Authentication` -> `Providers`
2. 启用 `Anonymous` 认证
3. 保存设置

#### 1.4 部署Edge Functions

[在supabase Dashboard上部署functions](https://help.aliyun.com/zh/analyticdb/analyticdb-for-postgresql/user-guide/using-edge-functions-in-analyticdb-supabase?spm=a2c4g.11186623.help-menu-92664.d_2_0_4.745670c1AXSQYe&scm=20140722.H_2990452._.OR_help-T_cn~zh-V_1)
在Supabase Dashboard -> Edge Functions -> Deploy

#### 1.5 配置环境变量

在Supabase Dashboard -> Edge Functions -> Settings中配置：

| 变量名 | 说明 | 示例值 |
|-------|------|-------|
| `SMTP_HOST` | SMTP服务器地址 | smtp.gmail.com |
| `SMTP_PORT` | SMTP端口 | 587 |
| `SMTP_USER` | SMTP用户名 | your-email@gmail.com |
| `SMTP_PASSWORD` | SMTP密码 | your-app-password |
| `FROM_EMAIL` | 发件人邮箱 | noreply@sileme.app |
| `FROM_NAME` | 发件人名称 | 一键打卡团队 |

**注意**: 
- 建议使用专业的邮件服务（如SendGrid、AWS SES、Resend等）
- 需要修改 `send-notification-email/index.ts` 集成真实邮件服务

#### 1.6 配置Cron Job

在Supabase Dashboard -> Database -> Cron Jobs中创建定时任务：

```sql
SELECT cron.schedule(
  'check-missed-check-ins',
  '0 1 * * *',  -- 每天UTC时间凌晨1点（北京时间上午9点）
  'SELECT net.http_post(
    url:=''https://your-project-ref.supabase.co/functions/v1/check-missed-check-ins'',
    headers:=''{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}''::jsonb
  );'
);
```

### 2. iOS应用部署

#### 2.1 配置Supabase信息

修改 `ios/SileMe/SileMe/Utilities/Configuration.swift`:

```swift
struct Configuration {
    static let supabaseURL = "https://xxxxx.supabase.co"  // 替换为您的项目URL
    static let supabaseAnonKey = "your-anon-key"           // 替换为您的Anon Key
    
    // 配置用户协议和隐私政策链接
    static let termsOfServiceURL = "https://your-domain.com/terms"
    static let privacyPolicyURL = "https://your-domain.com/privacy"
}
```

#### 2.2 添加Supabase依赖

1. 打开 `SileMe.xcodeproj` 在Xcode中
2. `File` -> `Add Packages...`
3. 输入: `https://github.com/supabase/supabase-swift`
4. 选择最新版本并添加

#### 2.3 取消SupabaseService注释

修改 `ios/SileMe/SileMe/Services/SupabaseService.swift`:

1. 取消 `import Supabase` 的注释
2. 取消所有函数中实际实现代码的注释
3. 删除 `throw SupabaseError.notImplemented` 占位代码

#### 2.4 配置应用信息

在Xcode中设置：
- Bundle Identifier
- Team (开发者账号)
- Display Name: 一键打卡
- Version: 1.0.0

#### 2.5 准备隐私政策和用户协议

**重要**: App Store审核要求提供隐私政策和用户协议

1. 创建网页版隐私政策和用户协议
2. 更新Configuration中的URL
3. 确保链接可以正常访问

#### 2.6 构建和测试

```bash
# 在Xcode中
1. 选择目标设备（真机或模拟器）
2. Command + B 编译
3. Command + R 运行
4. 测试签到功能
```

#### 2.7 TestFlight测试

1. 在Xcode中: `Product` -> `Archive`
2. 上传到App Store Connect
3. 在TestFlight中邀请测试用户
4. 收集反馈并修复问题

#### 2.8 App Store发布

1. 准备应用截图（iPhone和iPad）
2. 编写应用描述
3. 提交审核
4. 等待审核通过
5. 发布应用

## 数据库表结构

### users（用户信息表）
| 字段 | 类型 | 说明 |
|-----|------|------|
| id | UUID | 用户唯一标识 |
| name | VARCHAR(100) | 用户姓名 |
| emergency_email | VARCHAR(255) | 紧急联系人邮箱 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### check_ins（签到记录表）
| 字段 | 类型 | 说明 |
|-----|------|------|
| id | BIGSERIAL | 签到记录ID |
| user_id | UUID | 关联用户ID |
| check_in_date | DATE | 签到日期 |
| check_in_time | TIMESTAMP | 签到时间 |
| created_at | TIMESTAMP | 记录创建时间 |

### notification_logs（通知日志表）
| 字段 | 类型 | 说明 |
|-----|------|------|
| id | BIGSERIAL | 日志ID |
| user_id | UUID | 关联用户ID |
| notification_date | DATE | 通知触发日期 |
| email_sent | BOOLEAN | 邮件是否发送成功 |
| consecutive_miss_days | INTEGER | 连续未签到天数 |
| created_at | TIMESTAMP | 记录创建时间 |

## API说明

### Edge Functions

#### 1. check-missed-check-ins
**URL**: `https://your-project.supabase.co/functions/v1/check-missed-check-ins`  
**方法**: POST  
**认证**: Service Role Key  
**功能**: 检测所有用户的签到状态，发送通知给连续2天未签到的用户

**响应示例**:
```json
{
  "message": "检测完成",
  "total_users": 10,
  "processed": 10,
  "notified": 2,
  "results": [...]
}
```

#### 2. send-notification-email
**URL**: `https://your-project.supabase.co/functions/v1/send-notification-email`  
**方法**: POST  
**认证**: Service Role Key  
**功能**: 发送邮件通知给紧急联系人

**请求体**:
```json
{
  "user_id": "uuid",
  "user_name": "张三",
  "emergency_email": "emergency@example.com",
  "consecutive_miss_days": 2
}
```

**响应示例**:
```json
{
  "success": true,
  "message": "邮件发送成功",
  "recipient": "emergency@example.com",
  "user_name": "张三"
}
```

## 安全性说明

### Row Level Security (RLS)

- **users表**: 用户只能访问自己的记录
- **check_ins表**: 用户只能插入和查询自己的签到记录，禁止更新和删除
- **notification_logs表**: 仅Edge Functions有写入权限，用户无读写权限

### 数据加密

- 所有网络请求使用HTTPS/TLS加密
- Session Token安全存储在本地
- 紧急联系人邮箱仅用于通知，不对外暴露

### 匿名认证

- 使用Supabase匿名认证，每个设备生成唯一UUID
- 不收集手机号、身份证等敏感信息
- 用户可通过清除应用数据删除本地信息

## 常见问题

### Q1: 为什么需要匿名认证？
A: 匿名认证为每个设备分配唯一ID，确保数据隔离和安全性，同时无需用户注册登录。

### Q2: 如何修改通知发送时间？
A: 修改Cron Job的cron表达式，例如 `0 2 * * *` 表示UTC时间凌晨2点。

### Q3: 邮件发送失败怎么办？
A: 检查SMTP配置是否正确，建议使用专业邮件服务（SendGrid、AWS SES、Resend等）。

### Q4: 如何支持多设备同步？
A: 当前设计基于设备本地存储。如需多设备同步，需要实现邮箱/手机号登录替代匿名认证。

### Q5: 用户数据如何备份？
A: Supabase自动备份数据库。建议定期导出check_ins表数据作为额外备份。

## 开发说明

### 本地开发环境

**要求**:
- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+
- Node.js 18+ (用于Supabase CLI)

### 目录结构说明

- `Models/`: 数据模型，定义User、CheckIn等结构
- `ViewModels/`: 业务逻辑和状态管理
- `Views/`: SwiftUI视图组件
- `Services/`: 服务层，封装Supabase和本地存储操作
- `Utilities/`: 工具类和配置文件

### 代码风格

- 使用SwiftUI声明式语法
- 遵循MVVM架构模式
- async/await处理异步操作
- @MainActor确保UI更新在主线程

## 后续扩展

### 计划功能
- [ ] 签到统计展示
- [ ] 连续签到天数记录
- [ ] 签到提醒推送通知
- [ ] 多紧急联系人支持
- [ ] 自定义通知时间
- [ ] 数据导出功能

### 技术优化
- [ ] 离线签到队列
- [ ] 数据备份恢复
- [ ] 性能监控
- [ ] 错误日志收集

## 许可证

MIT License

## 联系方式

如有问题或建议，请联系开发团队。

---

**重要提示**: 
1. 务必替换Configuration.swift中的Supabase配置
2. 配置真实的SMTP邮件服务
3. 准备隐私政策和用户协议文档
4. 测试所有功能后再发布到App Store
