//
//  UserProfile.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/18/25.
//

import Foundation
import SwiftData

@Model
class UserProfile {
    var profileImageData: Data?
    var nickName: String
    var realName: String
    var session: String?
    var field: String
    var mbti: String?
    var socialStyle: String?

    init(profileImageData: Data?, nickName: String, realName: String, session: String?, field: String, mbti: String?, socialStyle: String?) {
        self.profileImageData = profileImageData
        self.nickName = nickName
        self.realName = realName
        self.session = session
        self.field = field
        self.mbti = mbti
        self.socialStyle = socialStyle
    }
}

enum socialStyle: String, CaseIterable, Identifiable {
    case 주도형, 표현형, 분석형, 우호형
    var id: String { self.rawValue }
}

enum MBTI: String, CaseIterable, Identifiable {
    case ESTJ, ESFJ, ENFJ, ENTJ
    case ESTP, ESFP, ENFP, ENTP
    case ISTJ, ISFJ, INFJ, INTJ
    case ISTP, ISFP, INFP, INTP
    
    var id: String { self.rawValue }
}
