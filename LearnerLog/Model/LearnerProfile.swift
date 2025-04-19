//  LearnerProfile.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/18/25.
//

import SwiftUI
import SwiftData

@Model
class LearnerProfile: Identifiable {
    var id: UUID
    var profileImageData: Data?
    var nickName: String
    var realName: String
    var session: String?
    var field: String
    var mbti: String?
    var socialStyle: String?
    var customFields: [CustomField]

    struct CustomField: Codable, Hashable {
        var label: String
        var value: String
    }

    init(profileImageData: Data?, nickName: String, realName: String, session: String?, field: String, mbti: String?, socialStyle: String?, customFields: [CustomField] = []) {
        self.id = UUID()
        self.profileImageData = profileImageData
        self.nickName = nickName
        self.realName = realName
        self.session = session
        self.field = field
        self.mbti = mbti
        self.socialStyle = socialStyle
        self.customFields = customFields
    }
}

struct LearnerDetailView: View {
    let profile: LearnerProfile

    var body: some View {
        VStack(spacing: 16) {
            if let data = profile.profileImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }

            Text(profile.nickName)
                .font(.title)

            if !profile.realName.isEmpty {
                Text("본명: \(profile.realName)")
            }
            if let session = profile.session {
                Text("세션: \(session)")
            }
            if !profile.field.isEmpty {
                Text("희망분야: \(profile.field)")
            }
            if let mbti = profile.mbti {
                Text("MBTI: \(mbti)")
            }
            if let style = profile.socialStyle {
                Text("소셜 스타일: \(style)")
            }

            ForEach(profile.customFields, id: \.self) { field in
                VStack(alignment: .leading) {
                    Text(field.label)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(field.value)
                }
            }

            Spacer()
        }
        .padding()
    }
}
