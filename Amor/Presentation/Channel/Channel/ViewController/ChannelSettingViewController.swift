//
//  ChannelSettingViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChannelSettingViewController: BaseVC<ChannelSettingView> {
    var coordinator: ChatCoordinator?
    let viewModel: ChannelSettingViewModel
    
    init(viewModel: ChannelSettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = ChannelSettingViewModel.Input()
        let output = viewModel.transform(input)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.channelSetting
    }
}
