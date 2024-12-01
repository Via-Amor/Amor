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
    
    init(title: String, subtitle: String, toastType: CustomAlert.ToastType, confirmButtonText: String) {
        super.init(baseView: CustomAlert(toastType: toastType, confirmButtonText: confirmButtonText))
        
        baseView.configureView(title: title, subtitle: subtitle)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func bind() {
        baseView.cancelButtonTap()
            .bind(with: self) { owner, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        baseView.confirmButtonTap()
            .bind(with: self) { owner, _ in
            }
            .disposed(by: disposeBag)
    }
}