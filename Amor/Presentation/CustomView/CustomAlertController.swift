//
//  CustomAlertController.swift
//  Amor
//
//  Created by 김상규 on 11/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomAlertController: BaseVC<CustomAlert> {
    typealias completionHandler =  () -> Void
    let confirmHandler: completionHandler
    let cancelHandler: completionHandler
    
    init(
        title: String,
        subtitle: String,
        confirmHandler: @escaping completionHandler,
        cancelHandler: @escaping completionHandler,
        alertType: CustomAlert.AlertButtonType
    ) {
        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler
        super.init(baseView: CustomAlert(alertType: alertType))
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        baseView.configureContent(
            title: title,
            subtitle: subtitle
        )
    }
    
    override func bind() {
        baseView.cancelButtonTap()
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
                owner.cancelHandler()
            }
            .disposed(by: disposeBag)
        
        baseView.confirmButtonTap()
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
                owner.confirmHandler()
            }
            .disposed(by: disposeBag)
    }
}

enum AlertType {
    case deleteChannel
    case exitChannel(isAdmin: Bool)
    case disableChangeAdmin
    case confirmChangeAdmin(nickname: String)
    
    var title: String {
        switch self {
        case .deleteChannel:
            return "채널 삭제"
        case .exitChannel:
            return "채널에서 나가기"
        case .disableChangeAdmin:
            return "채널 관리자 변경 불가"
        case .confirmChangeAdmin(let nickname):
            return "\(nickname) 님을 관리자로 지정하시겠습니까?"
        }
    }
    
    var subtitle: String {
        switch self {
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
        }
    }
    
    var button: CustomAlert.AlertButtonType {
        switch self {
        case .deleteChannel:
            return .twoButton
        case .exitChannel(let isAdmin):
            if isAdmin {
                return .oneButton
            } else {
                return .twoButton
            }
        case .disableChangeAdmin:
            return .oneButton
        case .confirmChangeAdmin:
            return .twoButton
        }
    }
}
