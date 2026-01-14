//
//  ContentView.swift
//  SileMe
//
//  主界面 - 一键打卡
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @StateObject private var viewModel = CheckInViewModel()
    @State private var showSafari = false
    @State private var safariURL: URL?
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isInitialized = false
    
    var body: some View {
        ZStack {
            // 背景渐变（更白）
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.97, green: 0.98, blue: 0.97),
                    Color(red: 0.95, green: 0.96, blue: 0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 用户信息输入
                    VStack(spacing: 16) {
                        CustomTextField(
                            placeholder: "你的姓名",
                            text: $viewModel.userName,
                            onCommit: {
                                Task {
                                    await viewModel.saveUserInfo()
                                }
                            }
                        )
                        
                        CustomTextField(
                            placeholder: "紧急联系人邮箱",
                            text: $viewModel.emergencyEmail,
                            keyboardType: .emailAddress,
                            onCommit: {
                                Task {
                                    await viewModel.saveUserInfo()
                                }
                            },
                            validate: { email in
                                // 验证邮箱格式
                                if email.isEmpty {
                                    return (true, nil)  // 允许空值
                                }
                                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                                let isValid = emailPredicate.evaluate(with: email)
                                if !isValid {
                                    // 验证失败时显示 Toast
                                    toastMessage = "请输入正确邮箱"
                                    showToast = true
                                    // 2秒后自动隐藏
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showToast = false
                                    }
                                }
                                return (isValid, isValid ? nil : "")
                            }
                        )
                    }
                    .padding(.top, 20)
                    
                    // 签到按钮
                    CheckInButton(
                        isCheckedIn: viewModel.hasCheckedInToday,
                        isEnabled: viewModel.canCheckIn,
                        action: {
                            Task {
                                await viewModel.performCheckIn()
                            }
                        }
                    )
                    .padding(.vertical, 30)
                    
                    // 提示信息
                    InfoBox(message: "2日未签到，系统将以你的名义，在次日邮件通知你的紧急联系人")
                    
                    // 用户协议
                    AgreementLinks(
                        onTermsTap: {
                            safariURL = URL(string: Configuration.termsOfServiceURL)
                            showSafari = true
                        },
                        onPrivacyTap: {
                            safariURL = URL(string: Configuration.privacyPolicyURL)
                            showSafari = true
                        }
                    )
                    .padding(.top, 16)
                    
                    Spacer(minLength: 40)
                }
            }
            
            // 加载指示器
            if viewModel.isLoading {
                LoadingOverlay()
            }
            
            // 成功动画
            if viewModel.showSuccessAnimation {
                SuccessAnimation()
            }
            
            // Toast 提示
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showToast)
                    .zIndex(999)
            }
        }
        .alert("提示", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("确定", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $showSafari) {
            if let url = safariURL {
                SafariView(url: url)
            }
        }
        .onAppear {
            if !isInitialized {
                Task {
                    await viewModel.initialize()
                    isInitialized = true
                }
            }
        }
    }
}

// MARK: - Agreement Links

struct AgreementLinks: View {
    let onTermsTap: () -> Void
    let onPrivacyTap: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text("签到即同意")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Button(action: onTermsTap) {
                Text("用户协议")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
            
            Text("和")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Button(action: onPrivacyTap) {
                Text("隐私政策")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
        }
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
        }
    }
}

// MARK: - Success Animation

struct SuccessAnimation: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("✓")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("签到成功")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - Toast View

struct ToastView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.85))
                )
                .padding(.top, 60)  // 距离顶部的边距
            
            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Safari View

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

#Preview {
    ContentView()
}
