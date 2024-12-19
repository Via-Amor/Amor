//
//  Navigation.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import Foundation

enum Navigation {
    enum User {
        static let login = "로그인"
        static let profile = "프로필"
        static let editProfile = "내 정보 수정"
    }
    
    enum Space {
        case home(spaceName: String)
        case changeAdmin
        case inviteMember
        case noSpace
        
        var title: String {
            switch self {
            case .home(let spaceName):
                return spaceName
            case .changeAdmin:
                return "라운지 관리자 변경"
            case .inviteMember:
                return "팀원 초대"
            case .noSpace:
                return "No Space"
            }
        }
    }
    
    enum Channel {
        static let add = "채널 생성"
        static let search = "채널 탐색"
        static let setting = "채널 설정"
        static let edit = "채널 편집"
        static let changeAdmin = "채널 관리자 변경"
    }
    
    enum DM {
        static let main = "Direct Message"
    }
}
