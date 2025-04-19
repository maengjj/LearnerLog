//
//  MyPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData
import UIKit

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

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if let profile = profiles.first {
                    let nickname = profile.nickName
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
                        if isEditing {
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                Text("프로필 삭제")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            .alert("\(nickname)(이/가) 러너들과 함께 쌓아온 로그들이 사라집니다. 이대로 괜찮으시겠습니까?", isPresented: $showDeleteConfirmation) {
                                Button("취소", role: .cancel) { }
                                Button("삭제", role: .destructive) {
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
