-- 一键打卡应用 Row Level Security (RLS) 策略
-- 创建时间: 2026-01-12

-- ==============================================
-- 启用RLS
-- ==============================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_logs ENABLE ROW LEVEL SECURITY;

-- ==============================================
-- users表RLS策略
-- ==============================================

-- 用户可以查看自己的记录
CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

-- 用户可以插入自己的记录
CREATE POLICY "Users can insert own profile"
    ON users FOR INSERT
    WITH CHECK (auth.uid() = id);

-- 用户可以更新自己的记录
CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- ==============================================
-- check_ins表RLS策略
-- ==============================================

-- 用户可以查看自己的签到记录
CREATE POLICY "Users can view own check-ins"
    ON check_ins FOR SELECT
    USING (auth.uid() = user_id);

-- 用户可以插入自己的签到记录
CREATE POLICY "Users can insert own check-ins"
    ON check_ins FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- 禁止更新和删除签到记录（通过不创建UPDATE和DELETE策略来实现）

-- ==============================================
-- notification_logs表RLS策略
-- ==============================================

-- notification_logs表仅供系统Edge Function使用
-- 不创建任何用户访问策略，确保普通用户无法读写

-- 创建服务角色策略（service_role可以绕过RLS，但这里明确定义）
-- 注意: Edge Functions使用service_role key时会自动绕过RLS

-- ==============================================
-- 辅助函数：检查用户是否已签到
-- ==============================================
CREATE OR REPLACE FUNCTION has_checked_in_today(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM check_ins
        WHERE user_id = p_user_id
          AND check_in_date = CURRENT_DATE
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================
-- 辅助函数：获取用户最后签到日期
-- ==============================================
CREATE OR REPLACE FUNCTION get_last_check_in_date(p_user_id UUID)
RETURNS DATE AS $$
BEGIN
    RETURN (
        SELECT check_in_date
        FROM check_ins
        WHERE user_id = p_user_id
        ORDER BY check_in_date DESC
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================
-- 辅助函数：计算连续未签到天数
-- ==============================================
CREATE OR REPLACE FUNCTION calculate_consecutive_miss_days(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
    last_check_in DATE;
    days_diff INTEGER;
BEGIN
    -- 获取最后签到日期
    last_check_in := get_last_check_in_date(p_user_id);
    
    -- 如果从未签到，返回-1
    IF last_check_in IS NULL THEN
        RETURN -1;
    END IF;
    
    -- 计算日期差
    days_diff := CURRENT_DATE - last_check_in;
    
    -- 返回连续未签到天数（差值减1）
    -- 例如: 最后签到2026-01-10，今天2026-01-13，差值3天，连续未签到2天
    RETURN GREATEST(days_diff - 1, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================
-- 注释说明
-- ==============================================
COMMENT ON POLICY "Users can view own profile" ON users IS '用户只能查看自己的信息';
COMMENT ON POLICY "Users can insert own profile" ON users IS '用户只能插入自己的信息';
COMMENT ON POLICY "Users can update own profile" ON users IS '用户只能更新自己的信息';

COMMENT ON POLICY "Users can view own check-ins" ON check_ins IS '用户只能查看自己的签到记录';
COMMENT ON POLICY "Users can insert own check-ins" ON check_ins IS '用户只能插入自己的签到记录';

COMMENT ON FUNCTION has_checked_in_today(UUID) IS '检查用户今天是否已签到';
COMMENT ON FUNCTION get_last_check_in_date(UUID) IS '获取用户最后一次签到日期';
COMMENT ON FUNCTION calculate_consecutive_miss_days(UUID) IS '计算用户连续未签到天数';
