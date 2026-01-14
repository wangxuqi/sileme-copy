//
//  CustomTextField.swift
//  SileMe
//
//  自定义输入框组件
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var onCommit: (() -> Void)? = nil
    var validate: ((String) -> (isValid: Bool, errorMessage: String?))? = nil
    
    @State private var editingText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $editingText, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.5)))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.blue : Color.clear, lineWidth: isFocused ? 2 : 0)
                )
            
            // 编辑图标（只在没有内容时显示）
            if editingText.isEmpty {
                HStack {
                    Spacer()
                    if let _ = UIImage(named: "EditorIcon") {
                        Image("EditorIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.gray.opacity(0.5))
                            .frame(width: 16, height: 16)
                    } else {
                        Text("✏️")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .padding(.trailing, 16)
                .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: 280)
        .onSubmit {
            if let validate = validate {
                let result = validate(editingText)
                if result.isValid {
                    text = editingText
                    onCommit?()
                    isFocused = false
                } else {
                    editingText = ""
                    text = ""
                }
            } else {
                text = editingText
                onCommit?()
                isFocused = false
            }
        }
        .onAppear {
            editingText = text
        }
        .onChange(of: isFocused) { oldValue, newValue in
            if newValue {
                editingText = text
            } else if oldValue && !newValue {
                editingText = text
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField(placeholder: "你的姓名", text: .constant(""))
        CustomTextField(placeholder: "紧急联系人邮箱", text: .constant(""))
    }
}
