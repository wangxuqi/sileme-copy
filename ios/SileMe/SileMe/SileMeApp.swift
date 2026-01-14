//
//  SileMeApp.swift
//  SileMe
//
//  应用程序入口
//

import SwiftUI

@main
struct SileMeApp: App {
    @StateObject private var appState = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            if appState.isInitialized {
                ContentView()
            } else {
                LaunchView()
                    .onAppear {
                        Task {
                            await appState.initialize()
                        }
                    }
            }
        }
    }
}

@MainActor
class AppStateManager: ObservableObject {
    @Published var isInitialized = false
    
    func initialize() async {
        // 等待 ViewModel 初始化完成
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒最小显示时间
        
        isInitialized = true
    }
}
