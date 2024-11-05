//
//  MyProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import RxSwift

final class MyProfileViewController: BaseVC<MyProfileView> {
    let viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "내 정보 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron_left"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    override func bind() {
        let input = MyProfileViewModel.Input(trigger: BehaviorSubject(value: ()))
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.profileImage
            .bind(with: self) { owner, value in
                guard let image = value, let profileImage = UIImage(named: image)  else {
                    guard let image = UIImage(named: "User_bot") else { return }
                    owner.baseView.profileImageView.setBackgroundImage(image)
                    
                    return
                }
                owner.baseView.profileImageView.setBackgroundImage(profileImage)
            }
            .disposed(by: disposeBag)
    }
}
