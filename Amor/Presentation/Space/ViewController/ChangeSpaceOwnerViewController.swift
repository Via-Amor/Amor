//
//  ChangeSpaceOwnerViewController.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeSpaceOwnerViewController: BaseVC<ChangeSpaceOwnerView> {
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.changeSpaceOwner
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Design.Icon.xmark, style: .plain, target: self, action: nil)
    }
    
    override func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
