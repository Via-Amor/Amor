//
//  ProfileElementEnum.swift
//  Amor
//
//  Created by 김상규 on 11/8/24.
//

import Foundation

enum Profile: String, CaseIterable {
    case profileImage
    case sesacCoin
    case nickname
    case phone
    case email
    case provider
    case logOut
    
    var name: String {
        switch self {
        case .profileImage:
            "프로필 이미지"
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
    
    var placeholder: String {
        switch self {
        case .sesacCoin:
            return "코인샵"
        case .nickname:
            return "닉네임을 입력해주세요"
        case .phone:
            return "연락처를 입력해주세요"
        default:
            return ""
        }
    }
}
