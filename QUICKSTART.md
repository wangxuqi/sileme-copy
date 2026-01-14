# 快速启动指南

本文档帮助您快速部署和运行"一键打卡"应用。

## 快速部署步骤

### 步骤1: Supabase后端配置（10分钟）

1. **创建Supabase项目**
   ```
   访问: https://supabase.com
   点击: New Project
   填写项目名称并等待创建完成
   ```

2. **执行数据库SQL**
   ```
   进入: SQL Editor
   复制并执行: supabase/schema.sql
   复制并执行: supabase/rls_policies.sql
   ```

3. **启用匿名认证**
   ```
   进入: Authentication > Providers
   启用: Anonymous
   保存设置
   ```

4. **记录配置信息**
   ```
   进入: Settings > API
   记录: Project URL
   记录: anon public key
   记录: service_role key (用于Edge Functions)
   ```

### 步骤2: iOS应用配置（5分钟）

1. **更新配置文件**
   
   打开 `ios/SileMe/SileMe/Utilities/Configuration.swift`
   
   ```swift
   struct Configuration {
       // 替换为您的Supabase配置
       static let supabaseURL = "https://xxxxx.supabase.co"
       static let supabaseAnonKey = "your-anon-key"
       
       // 替换为您的协议链接（可暂时使用示例链接）
       static let termsOfServiceURL = "https://example.com/terms"
       static let privacyPolicyURL = "https://example.com/privacy"
   }
   ```

2. **添加Supabase依赖**
   
   在Xcode中:
   ```
   File > Add Packages...
   输入: https://github.com/supabase/supabase-swift
   点击: Add Package
   ```

3. **取消SupabaseService注释**
   
   打开 `ios/SileMe/SileMe/Services/SupabaseService.swift`
   
   - 取消 `import Supabase` 的注释
   - 取消客户端初始化代码的注释
   - 取消所有函数中的实际实现代码
   - 删除所有 `throw SupabaseError.notImplemented`

### 步骤3: 运行应用（3分钟）

1. **在Xcode中打开项目**
   ```bash
   open ios/SileMe/SileMe.xcodeproj
   ```

2. **选择模拟器或真机**
   ```
   Xcode顶部选择: iPhone 15 Pro (或其他设备)
   ```

3. **运行应用**
   ```
   快捷键: Command + R
   或点击: ▶️ 播放按钮
   ```

4. **测试基本功能**
   - 输入姓名和邮箱
   - 点击签到按钮
   - 验证签到成功提示

## Edge Functions部署（可选）

**注意**: Edge Functions需要部署后才能实现自动邮件通知功能。如果暂时不需要此功能，可以跳过这一步。

### 前提条件

1. **安装Supabase CLI**
   ```bash
   npm install -g supabase
   ```

2. **登录Supabase**
   ```bash
   supabase login
   ```

### 部署步骤

1. **链接项目**
   ```bash
   cd /Users/xuqi/WebstormProjects/sileme
   supabase link --project-ref your-project-ref
   ```
   
   提示: `project-ref` 在Project Settings > General中找到

2. **部署Edge Functions**
   ```bash
   # 部署检测函数
   supabase functions deploy check-missed-check-ins
   
   # 部署邮件函数
   supabase functions deploy send-notification-email
   ```

3. **配置环境变量**
   
   在Supabase Dashboard:
   ```
   进入: Edge Functions > Settings
   添加环境变量:
     - SMTP_HOST: smtp.gmail.com (或其他SMTP服务器)
     - SMTP_PORT: 587
     - SMTP_USER: your-email@gmail.com
     - SMTP_PASSWORD: your-app-password
     - FROM_EMAIL: noreply@sileme.app
     - FROM_NAME: 一键打卡团队
   ```

4. **配置Cron Job**
   
   在Supabase Dashboard:
   ```
   进入: Database > Cron Jobs
   创建新任务:
     - 名称: check-missed-check-ins
     - 时间: 0 1 * * * (每天UTC 1:00，北京时间9:00)
     - SQL:
       SELECT net.http_post(
         url:='https://your-project.supabase.co/functions/v1/check-missed-check-ins',
         headers:='{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
       );
   ```

5. **测试Edge Function**
   ```bash
   # 手动触发测试
   curl -X POST \
     https://your-project.supabase.co/functions/v1/check-missed-check-ins \
     -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
   ```

## 邮件服务配置

### 使用Gmail（开发测试）

1. **开启两步验证**
   ```
   访问: https://myaccount.google.com/security
   启用: 两步验证
   ```

2. **生成应用专用密码**
   ```
   访问: https://myaccount.google.com/apppasswords
   选择: 邮件
   选择: 其他（自定义名称）
   生成并复制密码
   ```

3. **配置SMTP**
   ```
   SMTP_HOST: smtp.gmail.com
   SMTP_PORT: 587
   SMTP_USER: your-email@gmail.com
   SMTP_PASSWORD: 生成的16位密码
   ```

### 使用专业邮件服务（生产环境推荐）

**Resend** (推荐):
```typescript
// 修改 supabase/functions/send-notification-email/index.ts
const resendApiKey = Deno.env.get('RESEND_API_KEY')
const response = await fetch('https://api.resend.com/emails', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${resendApiKey}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    from: 'SileMe <noreply@your-domain.com>',
    to: emergency_email,
    subject: emailSubject,
    text: emailBody,
  }),
})
```

**SendGrid**:
```typescript
const sendgridApiKey = Deno.env.get('SENDGRID_API_KEY')
const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${sendgridApiKey}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    personalizations: [{to: [{email: emergency_email}]}],
    from: {email: fromEmail, name: fromName},
    subject: emailSubject,
    content: [{type: 'text/plain', value: emailBody}]
  }),
})
```

## 常见问题排查

### 问题1: Supabase客户端初始化失败

**错误**: `SupabaseError.notImplemented`

**解决**:
1. 确认已添加supabase-swift依赖
2. 确认已取消SupabaseService.swift中的注释
3. 清理构建: `Product > Clean Build Folder`
4. 重新构建: `Command + B`

### 问题2: 签到失败

**错误**: "签到失败: 网络错误"

**检查**:
1. Supabase URL和Key是否正确
2. 匿名认证是否已启用
3. RLS策略是否已正确配置
4. 检查Supabase Dashboard的Logs

### 问题3: Edge Function调用失败

**错误**: "401 Unauthorized"

**解决**:
1. 确认使用的是Service Role Key（不是Anon Key）
2. 检查Authorization header格式
3. 验证函数已成功部署: `supabase functions list`

### 问题4: 邮件发送失败

**错误**: "SMTP配置不完整"

**检查**:
1. 环境变量是否已正确配置
2. SMTP凭据是否有效
3. 查看Edge Function日志: Dashboard > Edge Functions > Logs

## 验证清单

完成部署后，请验证以下功能：

- [ ] 应用成功启动
- [ ] 可以输入姓名和邮箱
- [ ] 点击签到按钮显示成功动画
- [ ] 再次点击提示"今天已签到"
- [ ] 用户信息自动保存到本地
- [ ] 数据同步到Supabase（在Dashboard查看users和check_ins表）
- [ ] Edge Function可以手动触发
- [ ] Cron Job按时执行
- [ ] 邮件通知正常发送

## 下一步

1. **准备隐私政策和用户协议**
   - 创建网页版文档
   - 更新Configuration中的链接

2. **测试完整流程**
   - 测试连续签到
   - 测试跳过2天后的邮件通知
   - 验证邮件内容正确

3. **准备App Store发布**
   - 截图和描述
   - 测试版本发布到TestFlight
   - 邀请用户测试

4. **监控和优化**
   - 查看Supabase Dashboard的使用统计
   - 收集用户反馈
   - 修复发现的问题

## 获取帮助

- 查看完整文档: `README.md`
- Supabase文档: https://supabase.com/docs
- SwiftUI教程: https://developer.apple.com/tutorials/swiftui

---

**祝您部署顺利！** 🎉
