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
    
    init(alertType: AlertType,
        confirmHandler: @escaping completionHandler,
        cancelHandler: @escaping completionHandler
    ) {
        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler
        super.init(baseView: CustomAlert(alertType: alertType))
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        baseView.configureContent(alertType: alertType)
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

