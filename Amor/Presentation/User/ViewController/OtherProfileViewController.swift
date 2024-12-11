//
//  OtherProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit

final class OtherProfileViewController: BaseVC<OtherProfileView> {
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.User.profile
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    override func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
