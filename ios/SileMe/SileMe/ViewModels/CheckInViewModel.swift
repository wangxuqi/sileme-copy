//
//  CheckInViewModel.swift
//  SileMe
//
//  ViewModel - 管理签到界面的状态和业务逻辑
//

import Foundation
import SwiftUI

@MainActor
class CheckInViewModel: ObservableObject {
    // MARK: - Published Properties (状态)
    
    @Published var userName: String = ""
    @Published var emergencyEmail: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var hasCheckedInToday: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAnimation: Bool = false
    
    // MARK: - Dependencies
    
    private let storage = LocalStorageService.shared
    private let supabase = SupabaseService.shared
    
    // MARK: - Computed Properties
    
    var canCheckIn: Bool {
        return !hasCheckedInToday && !isLoading && isAuthenticated
    }
    
    var isUserInfoFilled: Bool {
        return !userName.isEmpty && !emergencyEmail.isEmpty
    }
    
    // MARK: - Initialization
    
    init() {
        loadLocalData()
        // 移除启动时的初始化，由 AppStateManager 控制
    }
    
    // MARK: - Initialization Methods
    
    /// 从本地存储加载数据
    private func loadLocalData() {
        userName = storage.userName ?? ""
        emergencyEmail = storage.emergencyEmail ?? ""
        isAuthenticated = storage.isAuthenticated()
    }
    
    /// 初始化应用状态
    func initialize() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. 检查或创建匿名认证
            if !storage.isAuthenticated() {
                try await authenticateAnonymously()
            } else {
                // 验证现有session
                let isValid = try await supabase.validateSession()
                if !isValid {
                    try await authenticateAnonymously()
                }
            }
            
            // 2. 检查本地签到状态（基于日期判断）
            if let lastCheckInDate = storage.lastCheckInDate {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let lastCheckIn = calendar.startOfDay(for: lastCheckInDate)
                hasCheckedInToday = (today == lastCheckIn)
            } else {
                hasCheckedInToday = false
            }
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "初始化失败: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Authentication
    
    /// 执行匿名认证
    private func authenticateAnonymously() async throws {
        let result = try await supabase.signInAnonymously()
        storage.userId = result.userId
        storage.sessionToken = result.sessionToken
        isAuthenticated = true
    }
    
    // MARK: - User Info Management
    
    /// 保存用户信息（仅在信息完整时保存，不显示错误提示）
    func saveUserInfo() async {
        // 如果信息不完整，静默返回，不显示错误
        guard !userName.isEmpty && !emergencyEmail.isEmpty else {
            return
        }
        
        guard isValidEmail(emergencyEmail) else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            guard let userId = storage.userId else {
                throw SupabaseError.authenticationFailed
            }
            
            // 保存到Supabase
            try await supabase.upsertUser(userId: userId, name: userName, emergencyEmail: emergencyEmail)
            
            // 保存到本地
            storage.saveUserInfo(name: userName, email: emergencyEmail)
            
            isLoading = false
        } catch {
            isLoading = false
            // 保存失败时也不显示错误，避免干扰用户输入
            print("保存用户信息失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Check-in
    
    /// 执行签到
    func performCheckIn() async {
        // 验证用户信息
        guard !userName.isEmpty && !emergencyEmail.isEmpty else {
            errorMessage = "请先填写您的姓名和紧急联系人邮箱"
            return
        }
        
        guard isValidEmail(emergencyEmail) else {
            errorMessage = "请输入有效的邮箱地址"
            return
        }
        
        guard !hasCheckedInToday else {
            errorMessage = "您今天已经签到过了"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            guard let userId = storage.userId else {
                throw SupabaseError.authenticationFailed
            }
            
            // 先保存用户信息（如果有变更）
            try await supabase.upsertUser(userId: userId, name: userName, emergencyEmail: emergencyEmail)
            storage.saveUserInfo(name: userName, email: emergencyEmail)
            
            // 执行签到
            try await supabase.checkIn(userId: userId)
            
            // 更新状态
            hasCheckedInToday = true
            storage.lastCheckInDate = Date()
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "签到失败: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Validation
    
    /// 验证邮箱格式
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
