//
//  RegisterMyPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import UIKit
import SwiftData


struct RegisterMyPage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var navigate = false
    @State private var backToGuide = false
    
    @State private var nickName: String = ""
    @State private var realName: String = ""
    @State private var selectedSession: String? = nil
    @State private var selectedField: String = ""
    @State private var selectedMBTI: MBTI? = nil  //해당없음
    @State private var selectedSocialStyle: socialStyle? = nil
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    let fieldOptions = ["테크", "디자인", "비지니스", "기타"]
    
    var isFormValid: Bool {
        !nickName.isEmpty &&
        !realName.isEmpty &&
        selectedSession != nil &&
        !selectedField.isEmpty &&
        selectedMBTI != nil &&
        selectedSocialStyle != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

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
                        isEditing: true
                    )

                    Button(action: {
                        let imageData = inputImage?.jpegData(compressionQuality: 0.8)
                        let profile = UserProfile(
                            profileImageData: imageData,
                            nickName: nickName,
                            realName: realName,
                            session: selectedSession,
                            field: selectedField,
                            mbti: selectedMBTI?.rawValue,
                            socialStyle: selectedSocialStyle?.rawValue
                        )
                        modelContext.insert(profile)
                        navigate = true
                    }) {
                        Text("등록")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(isFormValid ? Color.accentColor : Color.gray)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.automatic)
                    .disabled(!isFormValid)
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .navigationDestination(isPresented: $navigate) {
                MainPage()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("내 프로필")
                        .font(.title3)
                        .fontWeight(.bold)
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("등록") {
//                        let imageData = inputImage?.jpegData(compressionQuality: 0.8)
//                        let profile = UserProfile(
//                            profileImageData: imageData,
//                            nickName: nickName,
//                            realName: realName,
//                            session: selectedSession,
//                            field: selectedField,
//                            mbti: selectedMBTI?.rawValue,
//                            socialStyle: selectedSocialStyle?.rawValue
//                        )
//                        modelContext.insert(profile)
//                        navigate = true
//                    }
//                }
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


struct IdentifiableSourceType: Identifiable {
    let id = UUID()
    let type: UIImagePickerController.SourceType
}

#Preview {
    RegisterMyPage()
}
