//
//  LearnerLogApp.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData

@main
struct LearnerLogApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
                .modelContainer(for: [UserProfile.self, LearnerProfile.self])
        }
    }
}
