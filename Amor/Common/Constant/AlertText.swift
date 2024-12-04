//
//  AlertText.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation

enum AlertButtonText: String {
    case confirm = "확인"
    case cancel = "취소"
}

enum ActionSheetType {
    case channel(SpaceActionSheetText)
    case space(ChannelActionSheetText)
}

enum SpaceActionSheetText: String {
    case leave = "스페이스 나가기"
    case edit = "스페이스 편집"
    case changeOwner = "스페이스 관리자 변경"
    case delete = "스페이스 삭제"
    case cancel = "취소"
    
    var alertDescription: String {
        switch self {
        case .leave:
            return "회원님은 워크스페이스 관리자입니다. 스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
        case .delete:
           return "정말 이 스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        case .edit, .changeOwner, .cancel:
            return ""
        }
    }
}

enum ChannelActionSheetText: String {
    case add = "채널 추가"
    case search = "채널 탐색"
    case cancel = "취소"
}
