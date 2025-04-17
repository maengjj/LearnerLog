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
    var body: some Scene {
        WindowGroup {
            GuidePage()
        }
        .modelContainer(for: UserProfile.self)
    }
}
