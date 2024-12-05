//
//  AlertText.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation

enum AlertText {
    enum AlertButtonText: String {
        case confirm = "확인"
        case cancel = "취소"
    }
    
    enum ChangeSpaceOwnerAlertText {
        static let title = "워크스페이스 관리자 변경 불가"
        static let description = "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요."
    }
}
