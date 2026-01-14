# 项目目录结构

```
sileme/
│
├── README.md                          # 项目主文档
├── QUICKSTART.md                      # 快速启动指南
├── PROJECT_SUMMARY.md                 # 项目实施总结
├── .gitignore                         # Git忽略配置
│
├── ios/                               # iOS应用
│   ├── DEPENDENCIES.md                # 依赖管理说明
│   └── SileMe/
│       ├── SileMe.xcodeproj/          # Xcode项目文件
│       │   └── project.pbxproj
│       └── SileMe/                    # 应用源代码
│           ├── SileMeApp.swift        # 应用入口
│           │
│           ├── Models/                # 数据模型层
│           │   └── Models.swift       # User, CheckIn, NotificationLog等模型
│           │
│           ├── ViewModels/            # 视图模型层（业务逻辑）
│           │   └── CheckInViewModel.swift  # 签到ViewModel
│           │
│           ├── Views/                 # 视图层
│           │   ├── ContentView.swift  # 主界面
│           │   └── Components/        # UI组件
│           │       ├── CustomTextField.swift   # 自定义输入框
│           │       ├── CheckInButton.swift     # 签到按钮
│           │       └── InfoBox.swift           # 提示信息框
│           │
│           ├── Services/              # 服务层
│           │   ├── LocalStorageService.swift   # 本地存储服务
│           │   └── SupabaseService.swift       # Supabase API服务
│           │
│           └── Utilities/             # 工具类
│               └── Configuration.swift         # 配置管理
│
└── supabase/                          # Supabase后端配置
    ├── schema.sql                     # 数据库表结构
    ├── rls_policies.sql               # Row Level Security策略
    └── functions/                     # Edge Functions
        ├── check-missed-check-ins/    # 检测未签到函数
        │   └── index.ts
        └── send-notification-email/   # 发送邮件函数
            └── index.ts
```

## 文件说明

### 根目录文件

| 文件 | 说明 |
|-----|------|
| `README.md` | 完整的项目文档，包含功能介绍、部署指南、API说明等 |
| `QUICKSTART.md` | 快速启动指南，帮助快速部署和运行 |
| `PROJECT_SUMMARY.md` | 项目实施总结，记录完成情况和技术细节 |
| `.gitignore` | Git版本控制忽略配置，保护敏感信息 |

### iOS应用文件

#### 核心文件

| 文件 | 行数 | 说明 |
|-----|------|------|
| `SileMeApp.swift` | 11 | SwiftUI应用入口 |
| `ContentView.swift` | 221 | 主界面，集成所有组件 |

#### Models（数据模型）

| 文件 | 行数 | 说明 |
|-----|------|------|
| `Models.swift` | 87 | User、CheckIn、NotificationLog、AuthResponse等数据模型 |

#### ViewModels（业务逻辑）

| 文件 | 行数 | 说明 |
|-----|------|------|
| `CheckInViewModel.swift` | 184 | 管理应用状态和业务逻辑，包括认证、签到、数据保存等 |

#### Views/Components（UI组件）

| 文件 | 行数 | 说明 |
|-----|------|------|
| `CustomTextField.swift` | 40 | 自定义输入框，支持占位符和键盘类型 |
| `CheckInButton.swift` | 96 | 签到按钮，支持多种状态（未签到、已签到、禁用） |
| `InfoBox.swift` | 36 | 提示信息框，显示签到规则等信息 |

#### Services（服务层）

| 文件 | 行数 | 说明 |
|-----|------|------|
| `LocalStorageService.swift` | 119 | UserDefaults封装，管理本地数据持久化 |
| `SupabaseService.swift` | 170 | Supabase API封装，包括认证、用户管理、签到等 |

#### Utilities（工具类）

| 文件 | 行数 | 说明 |
|-----|------|------|
| `Configuration.swift` | 29 | 应用配置，包括Supabase URL/Key、协议链接、存储键等 |

### Supabase后端文件

#### SQL脚本

| 文件 | 行数 | 说明 |
|-----|------|------|
| `schema.sql` | 83 | 创建数据库表、索引、触发器、注释 |
| `rls_policies.sql` | 127 | 配置Row Level Security策略和辅助函数 |

#### Edge Functions

| 文件 | 行数 | 说明 |
|-----|------|------|
| `check-missed-check-ins/index.ts` | 192 | 检测所有用户签到状态，触发邮件通知 |
| `send-notification-email/index.ts` | 148 | 发送邮件给紧急联系人，记录通知日志 |

### 文档文件

| 文件 | 行数 | 说明 |
|-----|------|------|
| `README.md` | 385 | 主文档 |
| `QUICKSTART.md` | 318 | 快速启动 |
| `PROJECT_SUMMARY.md` | 358 | 项目总结 |
| `ios/DEPENDENCIES.md` | 191 | 依赖说明 |

## 代码统计总览

| 类别 | 文件数 | 总行数 | 说明 |
|-----|-------|--------|------|
| Swift源代码 | 11 | ~993 | iOS应用代码 |
| TypeScript代码 | 2 | ~340 | Edge Functions |
| SQL脚本 | 2 | ~210 | 数据库配置 |
| Markdown文档 | 4 | ~1,252 | 项目文档 |
| 配置文件 | 2 | ~150 | Xcode项目、Git配置 |
| **总计** | **21** | **~2,945** | |

## 项目规模

- **代码文件**: 15个
- **文档文件**: 4个
- **配置文件**: 2个
- **总文件数**: 21个
- **代码总行数**: ~1,543行
- **文档总行数**: ~1,252行

## 技术栈分布

### 前端（iOS）

```
SwiftUI (100%)
├── Views: 357 行 (36%)
├── ViewModels: 184 行 (19%)
├── Services: 289 行 (29%)
├── Models: 87 行 (9%)
└── Utilities: 76 行 (7%)
```

### 后端（Supabase）

```
TypeScript (62%) + SQL (38%)
├── Edge Functions: 340 行 (62%)
└── SQL Scripts: 210 行 (38%)
```

## 架构分层

```
Presentation Layer (表示层)
├── ContentView.swift
└── Components/
    ├── CustomTextField.swift
    ├── CheckInButton.swift
    └── InfoBox.swift

Business Logic Layer (业务逻辑层)
└── CheckInViewModel.swift

Data Layer (数据层)
├── Services/
│   ├── SupabaseService.swift
│   └── LocalStorageService.swift
└── Models/
    └── Models.swift

Configuration Layer (配置层)
└── Configuration.swift

Backend Layer (后端层)
├── Database (PostgreSQL)
│   ├── schema.sql
│   └── rls_policies.sql
└── Edge Functions (Deno)
    ├── check-missed-check-ins
    └── send-notification-email
```

## 依赖关系

```
ContentView
    └── CheckInViewModel
        ├── SupabaseService
        │   └── Supabase SDK (外部依赖)
        ├── LocalStorageService
        │   └── UserDefaults (iOS原生)
        └── Models

Edge Functions
    └── Supabase JS (外部依赖)
```

## 文件复杂度

| 文件 | 复杂度 | 说明 |
|-----|--------|------|
| `CheckInViewModel.swift` | 高 | 包含多个业务逻辑方法和状态管理 |
| `ContentView.swift` | 高 | 集成多个组件和交互逻辑 |
| `SupabaseService.swift` | 中 | API调用封装 |
| `check-missed-check-ins/index.ts` | 中 | 批量处理逻辑 |
| `CheckInButton.swift` | 中 | 多状态UI组件 |
| 其他文件 | 低 | 单一职责，逻辑简单 |

## 可扩展性

### 易于扩展的功能

- ✅ 新增UI组件（在Views/Components/）
- ✅ 新增数据模型（在Models/）
- ✅ 新增业务逻辑（在ViewModels/）
- ✅ 新增API服务（在Services/）
- ✅ 新增Edge Function（在supabase/functions/）

### 扩展点

1. **签到统计**: 新增StatisticsView和StatisticsViewModel
2. **多紧急联系人**: 修改Models.swift和数据库schema
3. **自定义通知时间**: 在users表增加notification_time字段
4. **签到提醒**: 新增NotificationService
5. **数据导出**: 新增ExportService和ExportView

## 维护建议

### 代码维护

- 定期更新依赖包（Supabase SDK）
- 关注Swift和SwiftUI新特性
- 保持代码注释的准确性
- 遵循SwiftUI最佳实践

### 文档维护

- 更新README.md反映新功能
- 保持QUICKSTART.md的准确性
- 记录重要变更到CHANGELOG.md

### 数据库维护

- 定期备份数据库
- 监控数据库性能
- 优化慢查询
- 定期清理过期数据

---

**最后更新**: 2026-01-12  
**项目版本**: 1.0.0  
**维护者**: 开发团队
