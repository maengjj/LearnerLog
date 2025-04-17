//
//  MyPage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI
import SwiftData

struct MyPage: View {
    @Query var profiles: [UserProfile]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        if let profile = profiles.first {
            VStack(spacing: 16) {
                if let data = profile.profileImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }

                Text("닉네임: \(profile.nickName)")
                Text("본명: \(profile.realName)")
                if let session = profile.session {
                    Text("세션: \(session)")
                }
                Text("희망분야: \(profile.field)")
                if let mbti = profile.mbti {
                    Text("MBTI: \(mbti)")
                }
                if let style = profile.socialStyle {
                    Text("소셜 스타일: \(style)")
                }
            }
            .padding()
        } else {
            Text("등록된 프로필이 없습니다.")
        }
    }
}

#Preview {
    MyPage()
}
