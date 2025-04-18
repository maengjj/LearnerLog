//
//  AppRootView.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/18/25.
//

import SwiftUI
import SwiftData

struct AppRootView: View {
    @Query var profiles: [UserProfile]
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack{
            Group {
                if profiles.isEmpty {
                    GuidePage()
                } else {
                    MainPage()
                }
            }
        }
    }
}
