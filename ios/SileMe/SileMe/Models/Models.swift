//
//  Models.swift
//  SileMe
//
//  数据模型定义
//

import Foundation

// MARK: - User Model

struct User: Codable {
    let id: String
    let name: String
    let emergencyEmail: String
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case emergencyEmail = "emergency_email"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CheckIn Model

struct CheckIn: Codable {
    let id: Int?
    let userId: String
    let checkInDate: String  // yyyy-MM-dd格式
    let checkInTime: Date?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case checkInDate = "check_in_date"
        case checkInTime = "check_in_time"
        case createdAt = "created_at"
    }
}

// MARK: - NotificationLog Model

struct NotificationLog: Codable {
    let id: Int
    let userId: String
    let notificationDate: String
    let emailSent: Bool
    let consecutiveMissDays: Int
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case notificationDate = "notification_date"
        case emailSent = "email_sent"
        case consecutiveMissDays = "consecutive_miss_days"
        case createdAt = "created_at"
    }
}

// MARK: - Auth Response Model

struct AuthResponse: Codable {
    let user: AuthUser
    let session: Session
}

struct AuthUser: Codable {
    let id: String
    let email: String?
}

struct Session: Codable {
    let accessToken: String
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
