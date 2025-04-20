//
//  ProfileForm.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/18/25.
//

import SwiftUI

struct ProfileForm: View {
    @Binding var nickName: String
    @Binding var realName: String
    @Binding var selectedSession: String?
    @Binding var selectedField: String
    @Binding var selectedMBTI: MBTI?
    @Binding var selectedSocialStyle: socialStyle?
    @Binding var profileImage: Image?
    @Binding var showingImagePicker: Bool
    @Binding var inputImage: UIImage?
    var isEditing: Bool

    let fieldOptions = ["테크", "디자인", "비지니스", "기타"]

    var body: some View {
        VStack(spacing: 16) {
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
                                )
                        }
                    }
                    .background(Circle().fill(Color(.systemGroupedBackground)))
                    
                    if isEditing {
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
                }
                Spacer()
            }
            .padding(.top, 16)
            
            List {
                Section {
                    HStack {
                        Text("닉네임")
                        Spacer()
                        if isEditing {
                            TextField("닉네임을 입력하세요", text: $nickName)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.gray)
                        } else {
                            Text(nickName)
                        }
                    }
                    HStack {
                        Text("본명")
                        Spacer()
                        if isEditing {
                            TextField("본명을 입력하세요", text: $realName)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.gray)
                        } else {
                            Text(realName)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("세션")
                        Spacer()
                        if isEditing {
                            Picker("세션", selection: $selectedSession) {
                                Text("오전").tag("오전")
                                Text("오후").tag("오후")
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 120)
                        } else {
                            Text((selectedSession == nil && isEditing) ? "선택" : (selectedSession ?? ""))
                        }
                    }
                    HStack {
                        Text("희망분야")
                        Spacer()
                        if isEditing {
                            Menu {
                                ForEach(fieldOptions.filter { $0 != "선택" }, id: \.self) { type in
                                    Button(action: {
                                        selectedField = type
                                    }) {
                                        Text(type)
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(selectedField.isEmpty && isEditing ? "선택" : selectedField)
                                        .foregroundColor((selectedField.isEmpty && isEditing) ? .gray : .primary)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        } else {
                            Text(selectedField)
                        }
                    }
                    HStack {
                        Text("MBTI")
                        Spacer()
                        if isEditing {
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
                                    Text(selectedMBTI?.rawValue ?? (isEditing ? "선택" : ""))
                                        .foregroundColor((selectedMBTI == nil && isEditing) ? .gray : .primary)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        } else {
                            Text(selectedMBTI?.rawValue ?? "")
                        }
                    }
                    HStack {
                        Text("소셜 스타일")
                        Spacer()
                        if isEditing {
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
                                    Text(selectedSocialStyle?.rawValue ?? (isEditing ? "선택" : ""))
                                        .foregroundColor((selectedSocialStyle == nil && isEditing) ? .gray : .primary)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        } else {
                            Text(selectedSocialStyle?.rawValue ?? "")
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(height: 360)
        }
    }
}
