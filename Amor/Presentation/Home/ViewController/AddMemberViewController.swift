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
    var coordinator: AddMemberCoordinator?
    let viewModel: AddMemberViewModel
    
    init(viewModel: AddMemberViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        self.navigationItem.title = Navigation.Space.inviteMember.title
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .xmark,
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .themeBlack
    }
    
    override func bind() {
        let input = AddMemberViewModel.Input(emailText: baseView.emailTextFieldText(), addButtonClicked: baseView.addMemberButtonClicked())
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismissAddChannelFlow()
            }
            .disposed(by: disposeBag)
        
        output.addButtonEnabled
            .bind(with: self) { owner, value in
                owner.baseView.addMemberConfiguration(isEnabled: value)
            }
            .disposed(by: disposeBag)
        
        output.addComplete
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismissAddChannelFlow(isAdd: true)
            }
            .disposed(by: disposeBag)
    }
}
