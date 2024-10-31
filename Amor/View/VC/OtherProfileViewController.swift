//
//  OtherProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit

final class OtherProfileViewController: BaseVC<OtherProfileView> {
    
    override func configureNavigationBar() {
        navigationItem.title = "프로필"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    override func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
