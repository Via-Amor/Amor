//
//  MyProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import RxCocoa

final class MyProfileViewController: BaseVC<MyProfileView> {
    override func configureNavigationBar() {
        navigationItem.title = "내 정보 수정"
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
