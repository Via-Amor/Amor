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
                .map { _ in }
        )
        let output = viewModel.transform(input)
        
        output.presentChannelInfo
            .emit(with: self) { owner, channelInfo in
                owner.baseView.nameInputView.textField.text = channelInfo.name
                owner.baseView.descriptionInputView.textField.text = channelInfo.description
            }
            .disposed(by: disposeBag)
    }
    
}
