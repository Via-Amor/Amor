//
//  AddChannelViewController.swift
//  Amor
//
//  Created by 김상규 on 11/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddChannelViewController: BaseVC<AddChannelView> {
    
    var coordinator: AddChannelCoordinator?
    let viewModel: AddChannelViewModel
    
    init(viewModel: AddChannelViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        self.navigationItem.title = Navigation.Channel.edit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .xmark,
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    override func bind() {
        let input = AddChannelViewModel.Input(channelNameText: baseView.channelTitleTextField.textField.rx.text.orEmpty, channelSubscriptionText: baseView.channelDescriptionTextField.textField.rx.text.orEmpty, addChannelButtonClicked: baseView.addChannelButton.rx.tap)
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismissAddChannelFlow(isAdd: false)
            }
            .disposed(by: disposeBag)
        
        output.addChannelButtonEnabled
            .bind(with: self) { owner, value in
                owner.baseView.addChannelButton.isEnabled = value
                
                if value {
                    owner.baseView.addChannelButton.configuration?.baseBackgroundColor = .themeGreen
                } else {
                    owner.baseView.addChannelButton.configuration?.baseBackgroundColor = .themeInactive
                }
            }
            .disposed(by: disposeBag)
        
        output.addChannelComplete
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismissAddChannelFlow(isAdd: true)
            }
            .disposed(by: disposeBag)
    }
}
