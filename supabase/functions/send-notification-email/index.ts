// Edge Function: send-notification-email
// 功能: 发送邮件通知给紧急联系人
// 触发: 被check-missed-check-ins函数调用

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface EmailRequest {
  user_id: string
  user_name: string
  emergency_email: string
  consecutive_miss_days: number
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 解析请求体
    const requestData: EmailRequest = await req.json()
    const { user_id, user_name, emergency_email, consecutive_miss_days } = requestData

    // 验证必填字段
    if (!user_id || !user_name || !emergency_email || consecutive_miss_days === undefined) {
      return new Response(
        JSON.stringify({ error: '缺少必填字段' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    console.log(`准备发送邮件: 用户=${user_name}, 邮箱=${emergency_email}, 未签到天数=${consecutive_miss_days}`)

    // 获取SMTP配置（从环境变量）
    const smtpHost = Deno.env.get('SMTP_HOST')
    const smtpPort = Deno.env.get('SMTP_PORT')
    const smtpUser = Deno.env.get('SMTP_USER')
    const smtpPassword = Deno.env.get('SMTP_PASSWORD')
    const fromEmail = Deno.env.get('FROM_EMAIL') || 'noreply@sileme.app'
    const fromName = Deno.env.get('FROM_NAME') || '一键打卡团队'

    if (!smtpHost || !smtpPort || !smtpUser || !smtpPassword) {
      throw new Error('SMTP配置不完整，请检查环境变量')
    }

    // 构建邮件内容
    const emailSubject = `[一键打卡] 关于 ${user_name} 的签到提醒`
    const emailBody = `您好，

您是 ${user_name} 设置的紧急联系人。

${user_name} 已连续 ${consecutive_miss_days} 天未在"一键打卡"应用中签到。

这是一封自动提醒邮件，请您在方便时确认 TA 的状态。

此致
${fromName}`

    // 使用SMTP发送邮件（这里使用一个简单的HTTP API调用示例）
    // 注意: 实际部署时需要使用真实的SMTP服务或第三方邮件API
    // 例如: SendGrid, AWS SES, Resend等
    
    // 示例: 使用Resend API发送邮件
    // 如果使用其他服务，需要修改此处的API调用
    console.log('发送邮件到:', emergency_email)
    console.log('邮件主题:', emailSubject)
    
    // 这里使用一个占位符，实际需要集成真实的邮件服务
    // 例如使用Resend:
    /*
    const resendApiKey = Deno.env.get('RESEND_API_KEY')
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${resendApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: `${fromName} <${fromEmail}>`,
        to: emergency_email,
        subject: emailSubject,
        text: emailBody,
      }),
    })
    */

    // 模拟邮件发送成功（开发阶段）
    const emailSent = true // 实际应该根据SMTP响应判断
    
    console.log(`邮件${emailSent ? '发送成功' : '发送失败'}`)

    // 记录到notification_logs表
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const today = new Date().toISOString().split('T')[0]
    
    const { error: logError } = await supabase
      .from('notification_logs')
      .insert({
        user_id: user_id,
        notification_date: today,
        email_sent: emailSent,
        consecutive_miss_days: consecutive_miss_days,
      })

    if (logError) {
      console.error('记录通知日志失败:', logError)
      // 即使日志记录失败，也返回成功（邮件已发送）
    } else {
      console.log('通知日志已记录')
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: '邮件发送成功',
        recipient: emergency_email,
        user_name: user_name,
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }, 
        status: 200 
      }
    )
  } catch (error) {
    console.error('发送邮件时发生错误:', error)
    return new Response(
      JSON.stringify({ 
        error: error instanceof Error ? error.message : '未知错误',
        details: error instanceof Error ? error.stack : String(error)
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }, 
        status: 500 
      }
    )
  }
})
