//
//  MainPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData

struct MainPage: View {
    @State private var isPresentingAddLearner = false
    @State private var navigateToMyPage = false
    @State private var searchText = ""
    
    @Query var profiles: [LearnerProfile]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                // Removed HStack containing the logo and icons

                // 스크롤뷰
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(profiles) { profile in
                            LearnerCircleView(profile: profile)
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

struct LearnerCircleView: View {
    var profile: LearnerProfile

    var body: some View {
        VStack {
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80)
                .overlay(
                    Group {
                        if let data = profile.profileImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .padding(15)
                        }
                    }
                )
            Text(profile.nickName)
                .font(.caption)
        }
    }
}

#Preview {
    NavigationStack {
        MainPage()
    }
}
