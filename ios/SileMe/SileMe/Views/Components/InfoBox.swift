//
//  InfoBox.swift
//  SileMe
//
//  提示信息框组件
//

import SwiftUI

struct InfoBox: View {
    let message: String
    var icon: String = "Ⓘ"
    var iconColor: Color = .green  // 默认绿色
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 24)  // 增加两侧边距，让信息框更窄
    }
}

#Preview {
    InfoBox(message: "2日未签到，系统将以你的名义，在次日邮件通知你的紧急联系人")
}
