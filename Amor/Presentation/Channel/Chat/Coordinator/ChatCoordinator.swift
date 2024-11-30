//
//  ChatCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/25/24.
//

import UIKit
import PhotosUI

final class ChatCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private let channel: Channel
    
    init(navigationController: UINavigationController, channel: Channel) {
        self.navigationController = navigationController
        self.channel = channel
    }
    
    func start() {
        let viewModel: ChatViewModel = DIContainer.shared.resolve(arg: channel)
        let chatVC = ChatViewController(viewModel: viewModel)
        chatVC.coordinator = self
        navigationController.pushViewController(
            chatVC,
            animated: true
        )
    }
    
    func showChannelSetting(channelID: String) {
        let channelSettingVC = ChannelSettingViewController(
            viewModel: ChannelSettingViewModel(
                useCase: DefaultHomeUseCase(
                    channelRepository: DefaultChannelRepository(),
                    spaceRepository: DefaultSpaceRepository(),
                    dmRepository: DefaultDMRepository()
                ),
                channelID: channelID
            )
        )
        channelSettingVC.coordinator = self
        navigationController.pushViewController(
            channelSettingVC,
            animated: true
        )
    }
}
