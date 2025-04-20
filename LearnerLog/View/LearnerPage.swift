//
//  LearnerPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/19/25.
//

import SwiftUI
import SwiftData
import UIKit

struct LearnerPage: View {
    var profile: LearnerProfile
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
    
    @State private var isAddingCustomField = false
    @State private var newLabel: String = ""
    @State private var newValue: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

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
                    
                    List {
                        Section(header: Text("로그 더하기")) {
                            ForEach(profile.customFields.indices, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    Text(profile.customFields[index].label)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(profile.customFields[index].value)
                                        .font(.body)
                                }
                            }
                            .onDelete(perform: isEditing ? { indexSet in
                                profile.customFields.remove(atOffsets: indexSet)
                            } : nil)

                            if isAddingCustomField {
                                VStack {
                                    HStack {
                                        TextField("GQ", text: $newLabel)
                                        TextField("GA", text: $newValue)
                                    }
                                    HStack {
                                        Spacer()
                                        Button("저장") {
                                            guard !newLabel.isEmpty && !newValue.isEmpty else { return }
                                            profile.customFields.append(LearnerProfile.CustomField(label: newLabel, value: newValue))
                                            newLabel = ""
                                            newValue = ""
                                            isAddingCustomField = false
                                        }
                                        .buttonStyle(.borderedProminent)
                                        Spacer()

                                        Button("취소") {
                                            isAddingCustomField = false
                                            newLabel = ""
                                            newValue = ""
                                        }
                                        .buttonStyle(.bordered)
                                        Spacer()
                                    }
                                }
                            }

                            if isEditing {
                                Button(action: {
                                    isAddingCustomField = true
                                }) {
                                    Label("항목 추가", systemImage: "plus.circle")
                                }
                            }
                        }
                    }
                    .frame(minHeight: CGFloat(200 + profile.customFields.count * 60))
                    .scrollDisabled(true)
                    .padding(.horizontal, 0)

                    if isEditing {
                        HStack {
                            Spacer()
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                Text("삭제하기")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.trailing, 20)
                                    .padding(.top, 8)
                            }
                            .alert("\(nickName)와(과)의 추억이 사라집니다. 정말 삭제하시겠습니까?", isPresented: $showDeleteConfirmation) {
                                Button("취소", role: .cancel) {}
                                Button("삭제", role: .destructive) {
                                    modelContext.delete(profile)
                                    dismiss()
                                }
                            }
                            
                        }
                    }
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "완료" : "수정") {
                        if isEditing {
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
                    Text("러너 프로필")
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
    LearnerPage(profile: LearnerProfile(
        profileImageData: nil,
        nickName: "미리보기",
        realName: "홍길동",
        session: "봄",
        field: "iOS",
        mbti: nil,
        socialStyle: nil
    ))
    .modelContainer(for: LearnerProfile.self)
}
