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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if let profile = profiles.first {
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
