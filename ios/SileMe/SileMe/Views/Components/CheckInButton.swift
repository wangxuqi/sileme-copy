//
//  CheckInButton.swift
//  SileMe
//
//  签到按钮组件
//

import SwiftUI

struct CheckInButton: View {
    let isCheckedIn: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if !isCheckedIn {
                    // 未签到时显示多层渐变圆圈
                    
                    // 最外层 - 淡绿色（最大圆）
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.7, green: 0.95, blue: 0.85).opacity(0.3),
                                    Color(red: 0.6, green: 0.9, blue: 0.8).opacity(0.15)
                                ]),
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                    
                    // 中外层 - 浅绿色
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.5, green: 0.9, blue: 0.7).opacity(0.4),
                                    Color(red: 0.4, green: 0.85, blue: 0.65).opacity(0.25)
                                ]),
                                center: .center,
                                startRadius: 40,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                    
                    // 中内层 - 中绿色
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.85, blue: 0.5).opacity(0.6),
                                    Color(red: 0.15, green: 0.8, blue: 0.45).opacity(0.4)
                                ]),
                                center: .center,
                                startRadius: 30,
                                endRadius: 90
                            )
                        )
                        .frame(width: 210, height: 210)
                }
                
                // 最内层 - 主按钮（鲜绿色/灰色）
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: isCheckedIn ? [
                                Color(red: 0.88, green: 0.88, blue: 0.88),
                                Color(red: 0.85, green: 0.85, blue: 0.85)
                            ] : [
                                Color(red: 0.0, green: 0.82, blue: 0.4),   // 鲜绿色中心
                                Color(red: 0.0, green: 0.75, blue: 0.35)   // 稍深的绿色边缘
                            ]),
                            center: .center,
                            startRadius: 1,
                            endRadius: 100
                        )
                    )
                    .frame(width: isCheckedIn ? 200 : 200, height: isCheckedIn ? 200 : 200)
                    .shadow(color: isCheckedIn ? Color.gray.opacity(0.2) : Color.green.opacity(0.3), radius: isCheckedIn ? 10 : 20, x: 0, y: isCheckedIn ? 5 : 10)
                
                // 图标和文字
                VStack(spacing: 12) {
                    if isCheckedIn {
                        // 签到成功显示✓
                        Text("✓")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    } else {
                        // 未签到显示幽灵图标（白色）
                        if let _ = UIImage(named: "GhostIcon") {
                            Image("GhostIcon")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)  // 白色幽灵
                                .frame(width: 60, height: 60)
                        } else {
                            Text("👻")
                                .font(.system(size: 50))
                        }
                    }
                    
                    Text(buttonText)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)  // 白色文字
                }
            }
            .frame(width: 300, height: 300)  // 固定整体容器大小，确保居中
        }
        .disabled(!isEnabled && !isCheckedIn)
        .scaleEffect((isEnabled || isCheckedIn) ? 1.0 : 0.95)
        .opacity((isEnabled || isCheckedIn) ? 1.0 : 0.6)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEnabled)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isCheckedIn)
    }
    
    // MARK: - Computed Properties
    
    private var buttonText: String {
        isCheckedIn ? "签到成功" : "今日签到"
    }
}

#Preview {
    VStack(spacing: 40) {
        CheckInButton(isCheckedIn: false, isEnabled: true, action: {})
        CheckInButton(isCheckedIn: true, isEnabled: true, action: {})
        CheckInButton(isCheckedIn: false, isEnabled: false, action: {})
    }
    .padding()
}
