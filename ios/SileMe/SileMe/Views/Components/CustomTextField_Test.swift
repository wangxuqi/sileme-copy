//
//  CustomTextField_Test.swift
//  SileMe
//
//  测试用 - 验证键盘弹出问题
//

import SwiftUI

struct CustomTextField_TestView: View {
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("键盘测试")
                .font(.title)
            
            // 测试1: 原生 TextField（对照组）
            TextField("原生输入框", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // 测试2: CustomTextField
            CustomTextField(placeholder: "自定义输入框", text: $email)
            
            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    CustomTextField_TestView()
}
