-- 一键打卡应用数据库表结构
-- 创建时间: 2026-01-12

-- ==============================================
-- 表1: users（用户信息表）
-- ==============================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    emergency_email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 为users表添加自动更新updated_at的触发器
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==============================================
-- 表2: check_ins（签到记录表）
-- ==============================================
CREATE TABLE IF NOT EXISTS check_ins (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_in_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_check_in_date UNIQUE (user_id, check_in_date)
);

-- 为check_ins表创建索引，提升查询性能
CREATE INDEX IF NOT EXISTS idx_check_ins_user_id ON check_ins(user_id);
CREATE INDEX IF NOT EXISTS idx_check_ins_check_in_date ON check_ins(check_in_date);
CREATE INDEX IF NOT EXISTS idx_check_ins_user_date ON check_ins(user_id, check_in_date DESC);

-- ==============================================
-- 表3: notification_logs（通知日志表）
-- ==============================================
CREATE TABLE IF NOT EXISTS notification_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    notification_date DATE NOT NULL,
    email_sent BOOLEAN DEFAULT FALSE,
    consecutive_miss_days INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_notification_date UNIQUE (user_id, notification_date)
);

-- 为notification_logs表创建索引
CREATE INDEX IF NOT EXISTS idx_notification_logs_user_id ON notification_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_logs_notification_date ON notification_logs(notification_date);

-- ==============================================
-- 注释说明
-- ==============================================
COMMENT ON TABLE users IS '用户信息表，存储用户基本信息';
COMMENT ON COLUMN users.id IS '用户唯一标识，关联auth.users表';
COMMENT ON COLUMN users.name IS '用户姓名';
COMMENT ON COLUMN users.emergency_email IS '紧急联系人邮箱';

COMMENT ON TABLE check_ins IS '签到记录表，记录用户每日签到';
COMMENT ON COLUMN check_ins.user_id IS '关联用户ID';
COMMENT ON COLUMN check_ins.check_in_date IS '签到日期（不含时间）';
COMMENT ON COLUMN check_ins.check_in_time IS '签到时间（含时分秒）';
COMMENT ON CONSTRAINT unique_user_check_in_date ON check_ins IS '确保每个用户每天只能签到一次';

COMMENT ON TABLE notification_logs IS '通知日志表，记录发送给紧急联系人的通知';
COMMENT ON COLUMN notification_logs.user_id IS '关联用户ID';
COMMENT ON COLUMN notification_logs.notification_date IS '通知触发日期';
COMMENT ON COLUMN notification_logs.email_sent IS '邮件是否发送成功';
COMMENT ON COLUMN notification_logs.consecutive_miss_days IS '连续未签到天数';
