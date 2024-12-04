//
//  EditChannelViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/3/24.
//

import UIKit
import SnapKit

final class EditChannelViewController: BaseVC<EditChannelView> {
    var coordinator: Coordinator?
    let viewModel: EditChannelViewModel
    
    init(viewModel: EditChannelViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.editChannel
    }
    
    override func bind() {
        let input = EditChannelViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in },
            nameText: baseView.nameInputView.textField.rx
                .text.orEmpty,
            descriptionText: baseView.descriptionInputView.textField.rx
                .text.orEmpty,
            completeButtonTap: baseView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.presentChannelInfo
            .emit(with: self) { owner, channelInfo in
                owner.baseView.nameInputView.textField.text = channelInfo.name
                owner.baseView.descriptionInputView.textField.text = channelInfo.description
                owner.baseView.completeButton.configuration?.baseBackgroundColor = .themeGreen
                owner.baseView.completeButton.isUserInteractionEnabled = true
            }
            .disposed(by: disposeBag)
        
        output.completeButtonActive
            .drive(with: self) { owner, isActive in
                let color: UIColor = isActive ? .themeGreen : .themeInactive
                owner.baseView.completeButton.configuration?.baseBackgroundColor = color
                owner.baseView.completeButton.isUserInteractionEnabled = isActive
            }
            .disposed(by: disposeBag)
    }
    
}
