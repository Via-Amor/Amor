//
//  ChatCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/25/24.
//

import UIKit

final class ChatCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
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
        let channelSettingVC: ChannelSettingViewController = DIContainer.shared.resolve(arg: channelID)
        channelSettingVC.coordinator = self
        navigationController.pushViewController(
            channelSettingVC,
            animated: true
        )
    }
    
    func showEditChannel(editChannel: EditChannel) {
        let editChatcoordinator = EditChannelCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(editChatcoordinator)
        editChatcoordinator.parentCoordinator = self
        editChatcoordinator.showEditChat(editChannel: editChannel)
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
