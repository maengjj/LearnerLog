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
    @State private var showNicknameAlert = false
    
    let fieldOptions = ["테크", "디자인", "비지니스", "기타"]
    let baseNicknames: [String] = ["Air", "Alex", "Angle", "Anne", "Ari", "Avery", "Baba", "Bear", "Berry", "Bin", "Bob", "Bota", "Brandnew", "Cerin", "Cherry", "Cheshire", "Chloe", "Coulson", "Daniely", "Dean", "Demian", "Dewy", "Dodin", "Echo", "Eddey", "Eifer", "Elena", "Elian", "Ell", "Ella", "Elphie", "Emma", "Enoch", "Erin", "Ethan", "Evan", "Excellenty", "Fine", "Finn", "Frank", "Gabi", "Gigi", "Gil", "Glowny", "Go", "Green", "Gus", "Gyeong", "Hama", "Happyjay", "Hari", "Henry", "Heggy", "Herry", "Hevyn", "Hidy", "Hong", "Hyun", "Ian", "il", "Isa", "Isla", "Ito", "Ivy", "J", "Jack", "Jacob", "Jaeryong", "Jam", "Jeje", "Jenki", "Jenna", "Jeong", "Jerry", "Jin", "Jina", "Joid", "Jomi", "Jooni", "Joy", "Judyj", "Julianne", "Jun", "Jung", "Junia", "Kadan", "Kaia", "Karyn", "Kave", "Ken", "Kinder", "Kirby", "Kon", "Kwangro", "Lemon", "Leo", "leon", "Libby", "Lina", "Loa", "Lucas", "Luka", "Luke", "Martin", "Mary", "May", "Min", "Minbol", "Mingky", "Mini", "Miru", "Monica", "Moo", "Mosae", "Mumin", "Murphy", "My", "Nayl", "Nell", "Nika", "Nike", "Noah", "Noter", "Nyx", "Oliver", "One", "Onething", "Paidion", "Paran", "Paduck", "Peppr", "Pherd", "Powel", "Pray", "Presence", "Rama", "Ria", "Riel", "Rohd", "Romak", "Root", "Rundo", "Sally", "Sana", "Sandeul", "Sena", "Seo", "Sera", "Simi", "Singsing", "Sky", "Skyler", "Snow", "Soop", "Ssol", "Steve", "Taeni", "Taki", "Ted", "Tether", "Theo", "Three", "Velko", "Viera", "Wade", "Weaver", "Wendy", "Way", "Wish", "Wonjun", "Woody", "Yan", "Yeony", "Yoon", "Yoshi", "Yuha", "Yuu", "Zani", "Zhen", "Zigu"]
    
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
                        if !baseNicknames.contains(nickName) {
                            showNicknameAlert = true
                        } else {
                            registerProfile()
                        }
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
            .alert("\(nickName)은(는) 4기 러너가 아니에요! 그래도 등록하시겠습니까?", isPresented: $showNicknameAlert) {
                Button("취소", role: .cancel) {}
                Button("등록", role: .destructive) {
                    registerProfile()
                }
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
    
    func registerProfile() {
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
    }
}


struct IdentifiableSourceType: Identifiable {
    let id = UUID()
    let type: UIImagePickerController.SourceType
}

#Preview {
    RegisterMyPage()
}
