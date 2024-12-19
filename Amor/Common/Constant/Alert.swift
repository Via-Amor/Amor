//
//  AlertText.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation

enum AlertButtonType {
    case oneButton
    case twoButton
}

enum AlertButtonText: String {
    case confirm = "확인"
    case cancel = "취소"
}

enum AlertType {
    case deleteSpace
    case changeDisabled
    case changeEnalbled(String)
    case exitSpace(isAdmin: Bool)
    case joinChannel(channelName: String)
    case deleteChannel
    case exitChannel(isAdmin: Bool)
    case disableChangeAdmin
    case confirmChangeAdmin(nickname: String)
    case enterChannelChat(channelName: String)
    
    var title: String {
        switch self {
        case .deleteSpace:
            return "라운지 삭제"
        case .changeDisabled:
            return "라운지 소유주 변경 불가"
        case .changeEnalbled(let member):
            return "\(member)님을 소유주로 변경하시겠습니까?"
        case .exitSpace:
            return "라운지 나가기"
        case .joinChannel:
            return "채널 참여"
        case .deleteChannel:
            return "채널 삭제"
        case .exitChannel:
            return "채널에서 나가기"
        case .disableChangeAdmin:
            return "채널 관리자 변경 불가"
        case .confirmChangeAdmin(let nickname):
            return "\(nickname) 님을 관리자로 지정하시겠습니까?"
        case .enterChannelChat:
            return "채널 참여"
        }
    }
    
    var subtitle: String {
        switch self {
        case .exitSpace(let isAdmin):
            if isAdmin {
                return "회원님은 라운지 소유주입니다. 라운지 소유주를 다른 멤버로 변경한 후 나갈 수 있습니다."
            } else {
                return "정말 이 라운지를 떠나시겠습니까?"
            }
        case .deleteSpace:
            return "정말 이 라운지를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 라운지 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        case .joinChannel(let channelName):
            return "[\(channelName)] 채널에 참여하시겠습니까?"
        case .deleteChannel:
            return "정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등 채널 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        case .exitChannel(let isAdmin):
            if isAdmin {
                return "회원님은 채널 관리자입니다. 채널 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
            } else {
                return "나가기를 하면 채널 목록에서 삭제됩니다."
            }
        case .disableChangeAdmin:
            return "채널 멤버가 없어 관리자 변경을 할 수 없습니다."
        case .confirmChangeAdmin:
            return
"""
채널 관리자는 다음과 같은 권한이 있습니다.
﹒채널 이름 또는 설명 변경
﹒채널 삭제
"""
        case .changeDisabled:
            return "라운지 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 라운지에 초대해보세요."
        case .changeEnalbled:
            return
"""
라운지 소유주는 다음과 같은 권한이 있습니다.

﹒라운지 이름 또는 설명 변경
﹒라운지 삭제
﹒라운지 멤버 초대
"""
        case .enterChannelChat(channelName: let channelName):
            return "[\(channelName)] 채널에 참여하시겠습니까?"
        }
    }
    
    var button: AlertButtonType {
        switch self {
        case .deleteSpace:
            return .twoButton
        case .changeDisabled:
            return .oneButton
        case .changeEnalbled:
            return .twoButton
        case .joinChannel:
            return .twoButton
        case .deleteChannel:
            return .twoButton
        case .exitChannel(let isAdmin):
            return isAdmin ? .oneButton : .twoButton
        case .disableChangeAdmin:
            return .oneButton
        case .confirmChangeAdmin:
            return .twoButton
        case .exitSpace(isAdmin: let isAdmin):
            return isAdmin ? .oneButton : .twoButton
        case .enterChannelChat:
            return .twoButton
        }
    }
}
