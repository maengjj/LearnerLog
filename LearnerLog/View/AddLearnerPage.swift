//
//  AddLearnerPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData


struct AddLearnerPage: View {
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 8) {
                        HStack {
                            Spacer()
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let image = profileImage {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 105, height: 105)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 105, height: 105)
                                            .overlay(
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.gray)
                                                    .padding(15)
                                            )
                                    }
                                }
                                .background(Circle().fill(Color(.systemGroupedBackground)))

                                Button {
                                    showingImagePicker = true
                                } label: {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.black)
                                        .clipShape(Circle())
                                }
                                .offset(x: 6, y: 6)
                            }
                            Spacer()
                        }
                        .padding(.top, 16)

                        List {
                            Section {
                                HStack {
                                    Text("닉네임")
                                    Spacer()
                                    TextField("닉네임을 입력하세요", text: $nickName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.gray)
                                }
                                HStack {
                                    Text("본명")
                                    Spacer()
                                    TextField("본명을 입력하세요", text: $realName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.gray)
                                }
                            }

                            Section {
                                HStack {
                                    Text("세션")
                                    Spacer()
                                    Picker("세션", selection: $selectedSession) {
                                        Text("오전").tag("오전")
                                        Text("오후").tag("오후")
                                    }
                                    .pickerStyle(.segmented)
                                    .frame(width: 120)
                                }
                                HStack {
                                    Text("희망분야")
                                    Spacer()
                                    Menu {
                                        ForEach(fieldOptions, id: \.self) { type in
                                            Button(action: {
                                                selectedField = type
                                            }) {
                                                Text(type)
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(selectedField.isEmpty ? "선택" : selectedField)
                                                .foregroundColor(selectedField.isEmpty ? .gray : .primary)
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                                HStack {
                                    Text("MBTI")
                                    Spacer()
                                    Menu {
                                        ForEach(MBTI.allCases) { type in
                                            Button(action: {
                                                selectedMBTI = type
                                            }) {
                                                Text(type.rawValue)
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(selectedMBTI?.rawValue ?? "선택")
                                                .foregroundColor(selectedMBTI == nil ? .gray : .primary)
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                                HStack {
                                    Text("소셜 스타일")
                                    Spacer()
                                    Menu {
                                        ForEach(socialStyle.allCases) { type in
                                            Button(action: {
                                                selectedSocialStyle = type
                                            }) {
                                                Text(type.rawValue)
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(selectedSocialStyle?.rawValue ?? "선택")
                                                .foregroundColor(selectedSocialStyle == nil ? .gray : .primary)
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            }
                        }
//                        .frame(height: 500)
                        .scrollDisabled(true)
                        .frame(height:380)

//                        Button(action: {
//                            navigate = true
//                        }) {
//                            Text("등록")
//                                .foregroundColor(.white)
//                                .font(.title3)
//                                .bold()
//                                .frame(maxWidth: .infinity, minHeight: 54)
//                                .background(Color.accent)
//                                .cornerRadius(10)
//                                .padding(.horizontal)
//                        }
//                        .buttonStyle(.automatic)
                    }
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("등록") {
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
    AddLearnerPage()
}
