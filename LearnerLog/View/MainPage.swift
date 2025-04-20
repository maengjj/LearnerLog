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
    
    @Query var userProfiles: [UserProfile]
    @Query var profiles: [LearnerProfile]
    
    var currentUserNickname: String? {
        userProfiles.first?.nickName
    }

    var filteredProfiles: [LearnerProfile] {
        if searchText.isEmpty {
            return profiles.filter { $0.nickName != currentUserNickname }
        } else {
            return profiles.filter { $0.nickName.localizedCaseInsensitiveContains(searchText) && $0.nickName != currentUserNickname }
        }
    }

    let baseNicknames = ["Air", "Alex", "Angle", "Anne", "Ari", "Avery", "Baba", "Bear", "Berry", "Bin", "Bob", "Bota", "Brandnew", "Cerin", "Cherry", "Cheshire", "Chloe", "Coulson", "Daniely", "Dean", "Demian", "Dewy", "Dodin", "Echo", "Eddey", "Eifer", "Elena", "Elian", "Ell", "Ella", "Elphie", "Emma", "Enoch", "Erin", "Ethan", "Evan", "Excellenty", "Fine", "Finn", "Frank", "Gabi", "Gigi", "Gil", "Glowny", "Go", "Green", "Gus", "Gyeong", "Hama", "Happyjay", "Hari", "Henry", "Heggy", "Herry", "Hevyn", "Hidy", "Hong", "Hyun", "Ian", "il", "Isa", "Isla", "Ito", "Ivy", "J", "Jack", "Jacob", "Jaeryong", "Jam", "Jeje", "Jenki", "Jenna", "Jeong", "Jerry", "Jin", "Jina", "Joid", "Jomi", "Jooni", "Joy", "Judyj", "Julianne", "Jun", "Jung", "Junia", "Kadan", "Kaia", "Karyn", "Kave", "Ken", "Kinder", "Kirby", "Kon", "Kwangro", "Lemon", "Leo", "leon", "Libby", "Lina", "Loa", "Lucas", "Luka", "Luke", "Martin", "Mary", "May", "Min", "Minbol", "Mingky", "Mini", "Miru", "Monica", "Moo", "Mosae", "Mumin", "Murphy", "My", "Nayl", "Nell", "Nika", "Nike", "Noah", "Noter", "Nyx", "Oliver", "One", "Onething", "Paidion", "Paran", "Paduck", "Peppr", "Pherd", "Powel", "Pray", "Presence", "Rama", "Ria", "Riel", "Rohd", "Romak", "Root", "Rundo", "Sally", "Sana", "Sandeul", "Sena", "Seo", "Sera", "Simi", "Singsing", "Sky", "Skyler", "Snow", "Soop", "Ssol", "Steve", "Taeni", "Taki", "Ted", "Tether", "Theo", "Three", "Velko", "Viera", "Wade", "Weaver", "Wendy", "Way", "Wish", "Wonjun", "Woody", "Yan", "Yeony", "Yoon", "Yoshi", "Yuha", "Yuu", "Zani", "Zhen", "Zigu"]
    
    var filteredBaseNicknames: [String] {
        if searchText.isEmpty {
            return baseNicknames.filter { $0 != currentUserNickname }
        } else {
            return baseNicknames.filter { name in
                name != currentUserNickname &&
                name.localizedCaseInsensitiveContains(searchText) &&
                filteredProfiles.contains(where: { $0.nickName == name })
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(filteredBaseNicknames, id: \.self) { name in
                            let matchedProfile = filteredProfiles.first { $0.nickName == name }
                            Button {
                                if let profile = matchedProfile {
                                    selectedProfile = profile
                                }
                            } label: {
                                if let profile = matchedProfile {
                                    LearnerCircleView(profile: profile)
                                } else {
                                    LockedCircleView(nickName: name)
                                }
                            }
                            .buttonStyle(.plain)
                            .transition(.scale)
                        }
                        
                        ForEach(filteredProfiles.filter { !baseNicknames.contains($0.nickName) }) { profile in
                            Button {
                                selectedProfile = profile
                            } label: {
                                LearnerCircleView(profile: profile)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale)
                        }
                    }
                    .animation(.spring(), value: filteredProfiles)
                    
                    if filteredBaseNicknames.isEmpty && filteredProfiles.filter({ !baseNicknames.contains($0.nickName) }).isEmpty {
                        VStack {
                            Text("검색된 러너가 없어요")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        }
                    }
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

struct LockedCircleView: View {
    let nickName: String

    var body: some View {
        VStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 95, height: 95)
                .overlay(
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                )
            Text("???")
                .font(.subheadline)
                .fontWeight(.bold)
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
