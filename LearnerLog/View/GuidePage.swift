//
//  GuidePage.swift
//  LearnerLog
//
//  Created by JiJooMaeng on 4/16/25.
//

import SwiftUI

struct GuidePage: View {
    @State private var isNavigating = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 40)
                
                Image("MainTitle")
                
                VStack(alignment: .leading, spacing: 22) {
                    (Text("러너로그")
                        .foregroundColor(.accent)
                     + Text("을 이용하려면,")
                    )
                    .font(.title3)
                    .bold()
                    
                    (Text("내 프로필을 ")
                     + Text("등록")
                        .foregroundColor(.accent)
                     + Text("해야 합니다.")
                    )
                    .font(.title3)
                    .bold()
                }
                .padding(.horizontal)
                .padding(.top, 52)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
                
                Button(action: {
                    isNavigating = true
                }) {
                    Text("프로필 등록하기")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $isNavigating) {
                    RegisterMyPage()
                }
            }
        }
    }
}

#Preview {
    GuidePage()
}
