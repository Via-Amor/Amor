//
//  ProfileElementEnum.swift
//  Amor
//
//  Created by 김상규 on 11/8/24.
//

import Foundation

enum ProfileElementEnum: String, CaseIterable {
    case profileImage
    case sesacCoin
    case nickname
    case phone
    case email
    case provider
    case logOut
    
    var element: String {
        switch self {
        case .profileImage:
            "프로필"
        case .sesacCoin:
            "새싹 코인"
        case .nickname:
            "닉네임"
        case .phone:
            "연락처"
        case .email:
            "이메일"
        case .provider:
            "연결된 계정"
        case .logOut:
            "로그아웃"
        }
    }
}
