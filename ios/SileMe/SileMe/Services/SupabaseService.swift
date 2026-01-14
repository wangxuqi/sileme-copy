//
//  SupabaseService.swift
//  SileMe
//
//  Supabase服务层 - 封装所有Supabase API调用
//
//  注意: 此文件需要安装 supabase-swift 依赖包
//  通过 Xcode -> File -> Add Packages -> https://github.com/supabase/supabase-swift
//

import Foundation
import Supabase

enum SupabaseError: Error {
    case notImplemented
    case authenticationFailed
    case networkError(String)
    case dataError(String)
}

class SupabaseService {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: Configuration.supabaseURL)!,
            supabaseKey: Configuration.supabaseAnonKey,
            options: SupabaseClientOptions(
                auth: SupabaseClientOptions.AuthOptions(
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
    
    // MARK: - Authentication
    
    /// 匿名认证
    func signInAnonymously() async throws -> (userId: String, sessionToken: String) {
        let session = try await client.auth.signInAnonymously()
        return (userId: session.user.id.uuidString, sessionToken: session.accessToken)
    }
    
    /// 验证Session有效性
    func validateSession() async throws -> Bool {
        let session = try await client.auth.session
        return session.accessToken.isEmpty == false
    }
    
    // MARK: - User Management
    
    /// 获取用户信息
    func getUser(userId: String) async throws -> User {
        let response: User = try await client
            .from("users")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        return response
    }
    
    /// 创建或更新用户信息
    func upsertUser(userId: String, name: String, emergencyEmail: String) async throws {
        let user = User(
            id: userId,
            name: name,
            emergencyEmail: emergencyEmail,
            createdAt: nil,
            updatedAt: nil
        )
        
        try await client
            .from("users")
            .upsert(user)
            .execute()
    }
    
    // MARK: - Check-in Management
    
    /// 检查今天是否已签到
    func hasCheckedInToday(userId: String) async throws -> Bool {
        let todayString = DateFormatter.dateOnlyFormatter.string(from: Date())
        
        let response: [CheckIn] = try await client
            .from("check_ins")
            .select()
            .eq("user_id", value: userId)
            .eq("check_in_date", value: todayString)
            .execute()
            .value
        return !response.isEmpty
    }
    
    /// 执行签到
    func checkIn(userId: String) async throws {
        let todayString = DateFormatter.dateOnlyFormatter.string(from: Date())
        
        let checkIn = CheckIn(
            id: nil,
            userId: userId,
            checkInDate: todayString,
            checkInTime: Date(),
            createdAt: nil
        )
        
        try await client
            .from("check_ins")
            .insert(checkIn)
            .execute()
    }
    
    /// 获取最后一次签到日期
    func getLastCheckInDate(userId: String) async throws -> Date? {
        let response: [CheckIn] = try await client
            .from("check_ins")
            .select()
            .eq("user_id", value: userId)
            .order("check_in_date", ascending: false)
            .limit(1)
            .execute()
            .value
        
        guard let lastCheckIn = response.first else {
            return nil
        }
        
        return DateFormatter.dateOnlyFormatter.date(from: lastCheckIn.checkInDate)
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
