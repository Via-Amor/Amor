//
//  ActionSheetText.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation

enum ActionSheetText {
    enum SpaceActionSheetText: String {
        case exit = "스페이스 나가기"
        case edit = "스페이스 편집"
        case changeOwner = "스페이스 관리자 변경"
        case delete = "스페이스 삭제"
        case cancel = "취소"
    }
    
    enum ChannelActionSheetText: String {
        case add = "채널 추가"
        case search = "채널 탐색"
        case cancel = "취소"
    }
}
