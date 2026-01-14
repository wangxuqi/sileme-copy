// Edge Function: check-missed-check-ins
// 功能: 检测连续2天未签到的用户，并发送邮件通知
// 触发: Cron Job每天上午9:00（UTC+8）执行

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface User {
  id: string
  name: string
  emergency_email: string
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 创建Supabase客户端（使用service_role key以绕过RLS）
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('开始检测未签到用户...')

    // 1. 查询所有用户
    const { data: users, error: usersError } = await supabase
      .from('users')
      .select('id, name, emergency_email')

    if (usersError) {
      throw new Error(`查询用户失败: ${usersError.message}`)
    }

    if (!users || users.length === 0) {
      console.log('没有用户需要检查')
      return new Response(
        JSON.stringify({ message: '没有用户需要检查', processed: 0 }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )
    }

    console.log(`找到 ${users.length} 个用户`)

    let processedCount = 0
    let notifiedCount = 0
    const results = []

    // 2. 遍历每个用户，检查签到状态
    for (const user of users as User[]) {
      try {
        // 获取用户最后签到日期
        const { data: lastCheckIn, error: checkInError } = await supabase
          .from('check_ins')
          .select('check_in_date')
          .eq('user_id', user.id)
          .order('check_in_date', { ascending: false })
          .limit(1)
          .single()

        // 如果从未签到，跳过（处理empty response）
        if (checkInError) {
          if (checkInError.code === 'PGRST116' || checkInError.message.includes('0 rows')) {
            console.log(`用户 ${user.name} (${user.id}) 从未签到，跳过`)
            results.push({ user_id: user.id, status: 'never_checked_in', action: 'skipped' })
            processedCount++
            continue
          }
          throw new Error(`查询用户 ${user.id} 签到记录失败: ${checkInError.message}`)
        }

        // 计算连续未签到天数
        const lastCheckInDate = new Date(lastCheckIn.check_in_date)
        const today = new Date()
        today.setHours(0, 0, 0, 0)
        lastCheckInDate.setHours(0, 0, 0, 0)

        const daysDiff = Math.floor((today.getTime() - lastCheckInDate.getTime()) / (1000 * 60 * 60 * 24))
        const consecutiveMissDays = Math.max(daysDiff - 1, 0)

        console.log(`用户 ${user.name}: 最后签到 ${lastCheckIn.check_in_date}, 连续未签到 ${consecutiveMissDays} 天`)

        // 3. 如果连续未签到2天，检查今天是否已发送通知
        if (consecutiveMissDays === 2) {
          const todayStr = today.toISOString().split('T')[0]

          const { data: existingLog, error: logError } = await supabase
            .from('notification_logs')
            .select('id')
            .eq('user_id', user.id)
            .eq('notification_date', todayStr)
            .single()

          // 如果今天已发送，跳过
          if (existingLog) {
            console.log(`用户 ${user.name} 今天已发送通知，跳过`)
            results.push({ user_id: user.id, status: 'already_notified', action: 'skipped' })
            processedCount++
            continue
          }

          // 4. 调用发送邮件函数
          console.log(`准备发送邮件给 ${user.name} 的紧急联系人 ${user.emergency_email}`)

          const emailResponse = await fetch(`${supabaseUrl}/functions/v1/send-notification-email`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${supabaseServiceKey}`,
            },
            body: JSON.stringify({
              user_id: user.id,
              user_name: user.name,
              emergency_email: user.emergency_email,
              consecutive_miss_days: consecutiveMissDays,
            }),
          })

          const emailResult = await emailResponse.json()

          if (!emailResponse.ok) {
            throw new Error(`发送邮件失败: ${emailResult.error || '未知错误'}`)
          }

          console.log(`成功发送邮件给 ${user.emergency_email}`)
          notifiedCount++
          results.push({ 
            user_id: user.id, 
            status: 'notified', 
            action: 'email_sent',
            email: user.emergency_email
          })
        } else {
          results.push({ 
            user_id: user.id, 
            status: 'ok', 
            action: 'no_action_needed',
            consecutive_miss_days: consecutiveMissDays
          })
        }

        processedCount++
      } catch (userError) {
        console.error(`处理用户 ${user.id} 时出错:`, userError)
        results.push({ 
          user_id: user.id, 
          status: 'error', 
          action: 'failed',
          error: userError instanceof Error ? userError.message : String(userError)
        })
      }
    }

    console.log(`检测完成: 处理 ${processedCount} 个用户, 发送 ${notifiedCount} 封通知邮件`)

    return new Response(
      JSON.stringify({
        message: '检测完成',
        total_users: users.length,
        processed: processedCount,
        notified: notifiedCount,
        results: results,
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }, 
        status: 200 
      }
    )
  } catch (error) {
    console.error('检测未签到用户时发生错误:', error)
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
