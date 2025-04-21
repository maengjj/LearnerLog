//
//  MyPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double

        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 1
            g = 1
            b = 1
        }

        self.init(red: r, green: g, blue: b)
    }
}

struct MyPage: View {
    @Query var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var nickName: String = ""
    @State private var realName: String = ""
    @State private var selectedSession: String? = nil
    @State private var selectedField: String = ""
    @State private var selectedMBTI: MBTI? = nil
    @State private var selectedSocialStyle: socialStyle? = nil
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    
    var collectionProgress: CGFloat {
        guard let profile = profiles.first else { return 0 }

        let baseNicknames: Set<String> = [
            "Air", "Alex", "Angle", "Anne", "Ari", "Avery", "Baba", "Bear", "Berry", "Bin", "Bob", "Bota", "Brandnew", "Cerin", "Cherry", "Cheshire", "Chloe", "Coulson", "Daniely", "Dean",
            "Demian", "Dewy", "Dodin", "Echo", "Eddey", "Eifer", "Elena", "Elian", "Ell", "Ella", "Elphie", "Emma", "Enoch",
            "Erin", "Ethan", "Evan", "Excellenty", "Fine", "Finn", "Frank", "Gabi", "Gigi", "Gil", "Glowny", "Go", "Green",
            "Gus", "Gyeong", "Hama", "Happyjay", "Hari", "Henry", "Heggy", "Herry", "Hevyn", "Hidy", "Hong", "Hyun", "Ian",
            "il", "Isa", "Isla", "Ito", "Ivy", "J", "Jack", "Jacob", "Jaeryong", "Jam", "Jeje", "Jenki", "Jenna", "Jeong",
            "Jerry", "Jin", "Jina", "Joid", "Jomi", "Jooni", "Joy", "Judyj", "Julianne", "Jun", "Jung", "Junia", "Kadan",
            "Kaia", "Karyn", "Kave", "Ken", "Kinder", "Kirby", "Kon", "Kwangro", "Lemon", "Leo", "leon", "Libby", "Lina",
            "Loa", "Lucas", "Luka", "Luke", "Martin", "Mary", "May", "Min", "Minbol", "Mingky", "Mini", "Miru", "Monica",
            "Moo", "Mosae", "Mumin", "Murphy", "My", "Nayl", "Nell", "Nika", "Nike", "Noah", "Noter", "Nyx", "Oliver", "One",
            "Onething", "Paidion", "Paran", "Paduck", "Peppr", "Pherd", "Powel", "Pray", "Presence", "Rama", "Ria", "Riel",
            "Rohd", "Romak", "Root", "Rundo", "Sally", "Sana", "Sandeul", "Sena", "Seo", "Sera", "Simi", "Singsing", "Sky",
            "Skyler", "Snow", "Soop", "Ssol", "Steve", "Taeni", "Taki", "Ted", "Tether", "Theo", "Three", "Velko", "Viera",
            "Wade", "Weaver", "Wendy", "Way", "Wish", "Wonjun", "Woody", "Yan", "Yeony", "Yoon", "Yoshi", "Yuha", "Yuu",
            "Zani", "Zhen", "Zigu"
        ]

        let learners = (try? modelContext.fetch(FetchDescriptor<LearnerProfile>())) ?? []

        var uniqueNames = Set(learners.map { $0.nickName })

        // Include current user
        uniqueNames.insert(profile.nickName)

        let matched = uniqueNames.intersection(baseNicknames)
        let total = baseNicknames.count

        return CGFloat(matched.count) / CGFloat(total)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if let profile = profiles.first {
                    let nickname = profile.nickName
                    let baseNicknames: Set<String> = ["Air", "Alex", "Angle", "Anne", "Ari", "Avery", "Baba", "Bear", "Berry", "Bin", "Bob", "Bota", "Brandnew", "Cerin", "Cherry", "Cheshire", "Chloe", "Coulson", "Daniely", "Dean",
                        "Demian", "Dewy", "Dodin", "Echo", "Eddey", "Eifer", "Elena", "Elian", "Ell", "Ella", "Elphie", "Emma", "Enoch",
                        "Erin", "Ethan", "Evan", "Excellenty", "Fine", "Finn", "Frank", "Gabi", "Gigi", "Gil", "Glowny", "Go", "Green",
                        "Gus", "Gyeong", "Hama", "Happyjay", "Hari", "Henry", "Heggy", "Herry", "Hevyn", "Hidy", "Hong", "Hyun", "Ian",
                        "il", "Isa", "Isla", "Ito", "Ivy", "J", "Jack", "Jacob", "Jaeryong", "Jam", "Jeje", "Jenki", "Jenna", "Jeong",
                        "Jerry", "Jin", "Jina", "Joid", "Jomi", "Jooni", "Joy", "Judyj", "Julianne", "Jun", "Jung", "Junia", "Kadan",
                        "Kaia", "Karyn", "Kave", "Ken", "Kinder", "Kirby", "Kon", "Kwangro", "Lemon", "Leo", "leon", "Libby", "Lina",
                        "Loa", "Lucas", "Luka", "Luke", "Martin", "Mary", "May", "Min", "Minbol", "Mingky", "Mini", "Miru", "Monica",
                        "Moo", "Mosae", "Mumin", "Murphy", "My", "Nayl", "Nell", "Nika", "Nike", "Noah", "Noter", "Nyx", "Oliver", "One",
                        "Onething", "Paidion", "Paran", "Paduck", "Peppr", "Pherd", "Powel", "Pray", "Presence", "Rama", "Ria", "Riel",
                        "Rohd", "Romak", "Root", "Rundo", "Sally", "Sana", "Sandeul", "Sena", "Seo", "Sera", "Simi", "Singsing", "Sky",
                        "Skyler", "Snow", "Soop", "Ssol", "Steve", "Taeni", "Taki", "Ted", "Tether", "Theo", "Three", "Velko", "Viera",
                        "Wade", "Weaver", "Wendy", "Way", "Wish", "Wonjun", "Woody", "Yan", "Yeony", "Yoon", "Yoshi", "Yuha", "Yuu",
                        "Zani", "Zhen", "Zigu"
                    ]
                    let learners = (try? modelContext.fetch(FetchDescriptor<LearnerProfile>())) ?? []
                    let allNicknames = Set(learners.map { $0.nickName } + [nickname])
                    let registeredCount = allNicknames.intersection(baseNicknames).count
                    ScrollView {
                        ProfileForm(
                            nickName: $nickName,
                            realName: $realName,
                            selectedSession: $selectedSession,
                            selectedField: $selectedField,
                            selectedMBTI: $selectedMBTI,
                            selectedSocialStyle: $selectedSocialStyle,
                            profileImage: $profileImage,
                            showingImagePicker: $showingImagePicker,
                            inputImage: $inputImage,
                            isEditing: isEditing
                        )
                        .onAppear {
                            nickName = profile.nickName
                            realName = profile.realName
                            selectedSession = profile.session
                            selectedField = profile.field
                            selectedMBTI = MBTI(rawValue: profile.mbti ?? "")
                            selectedSocialStyle = socialStyle(rawValue: profile.socialStyle ?? "")
                            if let data = profile.profileImageData,
                               let uiImage = UIImage(data: data) {
                                profileImage = Image(uiImage: uiImage)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 7) {
                            HStack {
                                Text("전체 러너 수집률")
                                    .bold()
                                    .font(.callout)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "F75A27"), Color(hex: "FFA98C")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                Spacer()
                                let allNicknames = Set(learners.map { $0.nickName } + [nickname])
                                let registeredCount = allNicknames.intersection(baseNicknames).count
                                Text("\(Int(collectionProgress * 100)) % (\(registeredCount)/\(baseNicknames.count))")
                                    .font(.caption)
                                    .foregroundStyle(.gray.opacity(0.9))
                            }
                            .frame(width: 300)

                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 300, height: 12)
                                    .foregroundStyle(.gray.opacity(0.2))

                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 300 * collectionProgress, height: 12)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "F75A27"), Color(hex: "FFA98C")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                        }
                        .padding(20)
                        .background(.white, in: .rect(cornerRadius: 16))
                        .padding(.top, 20)

                        if isEditing {
                            HStack {
                                Spacer()
                                Button(role: .destructive) {
                                    showDeleteConfirmation = true
                                } label: {
                                    Text("초기화하기")
                                        .foregroundColor(.red)
                                        .padding()
                                        .font(.footnote)
                                }
                            }
                            .alert("\(nickname)이(가) 러너들과 함께 쌓아온 로그들이 사라집니다. 이대로 괜찮으시겠습니까?", isPresented: $showDeleteConfirmation) {
                                Button("취소", role: .cancel) { }
                                Button("초기화", role: .destructive) {
                                    if let profile = profiles.first {
                                        if let learners = try? modelContext.fetch(FetchDescriptor<LearnerProfile>()) {
                                            learners.forEach { learner in
                                                modelContext.delete(learner)
                                            }
                                        }
                                        modelContext.delete(profile)
                                        try? modelContext.save()
                                        hasCompletedOnboarding = false
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("등록된 프로필이 없습니다.")
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "완료" : "수정") {
                            if isEditing, let profile = profiles.first {
                                profile.nickName = nickName
                                profile.realName = realName
                                profile.session = selectedSession
                                profile.field = selectedField
                                profile.mbti = selectedMBTI?.rawValue
                                profile.socialStyle = selectedSocialStyle?.rawValue
                                if let imageData = inputImage?.jpegData(compressionQuality: 0.8) {
                                    profile.profileImageData = imageData
                                }
                                try? modelContext.save()
                            }
                            isEditing.toggle()
                        }
                    }
                ToolbarItem(placement: .principal) {
                    Text("내 프로필")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
        }
    }
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }

}

#Preview {
    MyPage()
}
