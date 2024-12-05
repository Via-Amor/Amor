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
        case changeDisabled
        case changeEnalbled(String)
        
        var title: String {
            switch self {
            case .changeDisabled:
                return "워크스페이스 관리자 변경 불가"
            case .changeEnalbled(let member):
                return "\(member)님을 관리자로 변경하시겠습니까?"
            }
        }
        
        var description: String {
            switch self {
            case .changeDisabled:
                return "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요."
            case .changeEnalbled:
                return
"""
워크스페이스 관리자는 다음과 같은 권한이 있습니다.

﹒워크스페이스 이름 또는 설명 변경
﹒워크스페이스 삭제
﹒워크스페이스 멤버 초대
"""
            }
        }
    }
}
