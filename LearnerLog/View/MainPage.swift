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
    @State private var selectedProfile: LearnerProfile?
    
    @Query var profiles: [LearnerProfile]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(profiles) { profile in
                            Button {
                                selectedProfile = profile
                            } label: {
                                LearnerCircleView(profile: profile)
                            }
                            .buttonStyle(.plain)
                        }
                    }
//                    .padding()
                }
                
            }
            
            .sheet(isPresented: $isPresentingAddLearner) {
                AddLearnerPage()
            }
            .sheet(item: $selectedProfile) { profile in
                LearnerPage(profile: profile)
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
                .frame(width: 95, height: 95)
                .overlay(
                    Group {
                        if let data = profile.profileImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 95, height: 95)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
//                                .padding(15)
                        }
                    }
                )
            Text(profile.nickName)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    NavigationStack {
        MainPage()
    }
}
