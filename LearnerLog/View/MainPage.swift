//
//  MainPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI

struct MainPage: View {
    @State private var isPresentingAddLearner = false
    @State private var navigateToMyPage = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                // Removed HStack containing the logo and icons

                // 스크롤뷰
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(0..<24) { index in
                            VStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(uiImage: UIImage(named: "defaultIcon") ?? UIImage())
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                    )
                                Text(index == 4 ? "Bob" : index == 11 ? "Dewy" : "???")
                                    .font(.caption)
                            }
                        }
                    }
//                    .padding()
                }
                
            }
            
            .sheet(isPresented: $isPresentingAddLearner) {
                AddLearnerPage()
            }
            .navigationDestination(isPresented: $navigateToMyPage) {
                MyPage()

            }
            .navigationBarBackButtonHidden(true)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "러너 검색하기"
            )
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image("MainTitle")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Image(systemName: "plus")
                        .onTapGesture {
                            isPresentingAddLearner = true
                        }
                    Image(systemName: "person.crop.circle")
                        .onTapGesture {
                            navigateToMyPage = true
                        }
                }
                .font(.title2)
                .foregroundColor(.accent)
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        MainPage()
    }
}
