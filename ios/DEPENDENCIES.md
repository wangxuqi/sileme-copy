# iOS项目依赖说明

本项目使用Swift Package Manager (SPM)管理依赖。

## 依赖列表

### 1. Supabase Swift SDK

**作用**: 与Supabase后端服务交互，包括认证、数据库操作等

**版本**: 最新稳定版本

**安装方法**:

在Xcode中:
1. 打开项目: `File` > `Open` > 选择 `SileMe.xcodeproj`
2. 选择项目根节点（蓝色图标）
3. 选择 `SileMe` target
4. 点击 `Package Dependencies` 标签
5. 点击 `+` 按钮
6. 输入URL: `https://github.com/supabase/supabase-swift`
7. 选择 `Up to Next Major Version`
8. 点击 `Add Package`
9. 选择需要的产品：
   - Supabase
   - Auth
   - PostgREST
   - Realtime
   - Storage
10. 点击 `Add Package`

**或者通过命令行**:

```bash
cd ios/SileMe/SileMe
```

创建 `Package.swift` 文件（如果使用SPM作为独立包）:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SileMe",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SileMe",
            targets: ["SileMe"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "SileMe",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
            ]
        ),
    ]
)
```

## 依赖版本说明

| 依赖包 | 最低版本 | 推荐版本 | 说明 |
|-------|---------|---------|------|
| supabase-swift | 2.0.0 | 最新 | Supabase官方Swift SDK |

## 更新依赖

### 在Xcode中更新

1. 选择项目根节点
2. 选择 `Package Dependencies` 标签
3. 右键点击依赖包
4. 选择 `Update Package`

### 查看依赖版本

```bash
# 在项目根目录
swift package show-dependencies
```

## 常见问题

### 问题1: 依赖包无法下载

**原因**: 网络问题或GitHub访问受限

**解决**:
1. 检查网络连接
2. 配置代理（如果需要）
3. 尝试使用VPN
4. 清除SPM缓存:
   ```bash
   rm -rf ~/Library/Caches/org.swift.swiftpm
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

### 问题2: 编译错误

**原因**: 依赖版本不兼容

**解决**:
1. 更新Xcode到最新版本
2. 清理构建: `Product` > `Clean Build Folder`
3. 重新解析依赖: `File` > `Packages` > `Reset Package Caches`
4. 重新构建项目

### 问题3: Module 'Supabase' not found

**原因**: 依赖未正确链接

**解决**:
1. 确认Package Dependencies中已添加Supabase
2. 确认target的Frameworks中包含Supabase
3. 清理并重新构建

## 最佳实践

1. **锁定版本**: 在生产环境使用固定版本，避免意外更新
2. **定期更新**: 关注依赖包的更新日志，及时修复安全问题
3. **最小化依赖**: 仅添加必要的依赖包
4. **测试升级**: 升级依赖后进行完整测试

## 依赖分析

### Supabase Swift SDK包含的模块

- **Auth**: 认证功能（匿名认证、邮箱认证等）
- **PostgREST**: RESTful API客户端，用于数据库操作
- **Realtime**: 实时订阅功能（本项目未使用）
- **Storage**: 文件存储功能（本项目未使用）

### 本项目实际使用的模块

- ✅ Auth: 用于匿名认证
- ✅ PostgREST: 用于数据库CRUD操作
- ❌ Realtime: 未使用
- ❌ Storage: 未使用

## 无需额外依赖的功能

本项目充分利用SwiftUI原生组件，无需额外UI库：

- **UI框架**: SwiftUI (iOS原生)
- **网络请求**: URLSession (iOS原生)
- **本地存储**: UserDefaults (iOS原生)
- **日期处理**: Foundation (iOS原生)
- **Safari浏览器**: SafariServices (iOS原生)

## 许可证

所有依赖包的许可证信息：

| 依赖包 | 许可证 | 链接 |
|-------|-------|------|
| supabase-swift | MIT | https://github.com/supabase/supabase-swift/blob/main/LICENSE |

## 安全性

### 依赖包安全检查

定期检查依赖包是否存在安全漏洞：

```bash
# 使用GitHub Dependabot自动检查
# 或手动查看GitHub Security Advisories
```

### API Key安全

⚠️ **重要**: 不要将Supabase Keys硬编码在代码中

- ✅ 使用Configuration文件（不提交到Git）
- ✅ 使用Xcode Build Configuration
- ✅ 使用环境变量
- ❌ 不要硬编码在源代码中

## 技术支持

- Supabase Swift SDK文档: https://github.com/supabase/supabase-swift
- Supabase官方文档: https://supabase.com/docs
- Swift Package Manager文档: https://swift.org/package-manager/
