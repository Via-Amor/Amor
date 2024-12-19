//
//  ActionSheetText.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation

enum ActionSheetText {
    enum SpaceActionSheetText: String {
        case exit = "라운지 나가기"
        case edit = "라운지 편집"
        case changeOwner = "라운지 소유주 변경"
        case delete = "라운지 삭제"
        case cancel = "취소"
    }
    
    enum ChannelActionSheetText: String {
        case add = "채널 추가"
        case search = "채널 탐색"
        case cancel = "취소"
    }
}
