//
//  LaunchView.swift
//  SileMe
//
//  启动加载页面
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            // 绿色背景
            Color(red: 0.0, green: 0.65, blue: 0.35)
                .ignoresSafeArea()
            
            // 幽灵图标
            VStack {
                Spacer()
                
                if let _ = UIImage(named: "GhostIcon") {
                    Image("GhostIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                } else {
                    Text("👻")
                        .font(.system(size: 100))
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    LaunchView()
}
