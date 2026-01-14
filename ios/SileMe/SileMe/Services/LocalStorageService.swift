//
//  LocalStorageService.swift
//  SileMe
//
//  本地存储服务 - 管理UserDefaults数据持久化
//

import Foundation

class LocalStorageService {
    static let shared = LocalStorageService()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - User ID
    
    var userId: String? {
        get {
            return defaults.string(forKey: Configuration.StorageKeys.userId)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Configuration.StorageKeys.userId)
            } else {
                defaults.removeObject(forKey: Configuration.StorageKeys.userId)
            }
        }
    }
    
    // MARK: - User Name
    
    var userName: String? {
        get {
            return defaults.string(forKey: Configuration.StorageKeys.userName)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Configuration.StorageKeys.userName)
            } else {
                defaults.removeObject(forKey: Configuration.StorageKeys.userName)
            }
        }
    }
    
    // MARK: - Emergency Email
    
    var emergencyEmail: String? {
        get {
            return defaults.string(forKey: Configuration.StorageKeys.emergencyEmail)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Configuration.StorageKeys.emergencyEmail)
            } else {
                defaults.removeObject(forKey: Configuration.StorageKeys.emergencyEmail)
            }
        }
    }
    
    // MARK: - Last Check-in Date
    
    var lastCheckInDate: Date? {
        get {
            return defaults.object(forKey: Configuration.StorageKeys.lastCheckInDate) as? Date
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Configuration.StorageKeys.lastCheckInDate)
            } else {
                defaults.removeObject(forKey: Configuration.StorageKeys.lastCheckInDate)
            }
        }
    }
    
    // MARK: - Session Token
    
    var sessionToken: String? {
        get {
            return defaults.string(forKey: Configuration.StorageKeys.sessionToken)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: Configuration.StorageKeys.sessionToken)
            } else {
                defaults.removeObject(forKey: Configuration.StorageKeys.sessionToken)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// 检查是否有用户信息
    func hasUserInfo() -> Bool {
        return userName != nil && emergencyEmail != nil
    }
    
    /// 检查是否已认证
    func isAuthenticated() -> Bool {
        return userId != nil && sessionToken != nil
    }
    
    /// 清除所有数据
    func clearAll() {
        userId = nil
        userName = nil
        emergencyEmail = nil
        lastCheckInDate = nil
        sessionToken = nil
    }
    
    /// 保存用户信息
    func saveUserInfo(name: String, email: String) {
        userName = name
        emergencyEmail = email
    }
}
