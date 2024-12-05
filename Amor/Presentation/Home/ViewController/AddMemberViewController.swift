//
//  AddMemberViewController.swift
//  Amor
//
//  Created by 김상규 on 12/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddMemberViewController: BaseVC<AddMemberView> {
    var delegate: AddMemberDelegate?
    let viewModel: AddMemberViewModel
    
    init(viewModel: AddMemberViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        self.navigationItem.title = "팀원 초대"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Design.Icon.xmark, style: .plain, target: self, action: nil)
    }
    
    override func bind() {
        let input = AddMemberViewModel.Input(emailText: baseView.emailTextFieldText(), addButtonClicked: baseView.addMemberButtonClicked())
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.addButtonEnabled
            .bind(with: self) { owner, value in
                owner.baseView.addMemberConfiguration(isEnabled: value)
            }
            .disposed(by: disposeBag)
        
        output.addComplete
            .bind(with: self) { owner, _ in
                owner.delegate?.didAddMember()
            }
            .disposed(by: disposeBag)
    }
}
