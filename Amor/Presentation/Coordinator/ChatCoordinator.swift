//
//  ChatCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/25/24.
//

import UIKit
import PhotosUI

final class ChatCoordinator: Coordinator {
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
        let editViewModel = EditChannelViewModel(editChannel: editChannel)
        let editChannelVC = EditChannelViewController(
            viewModel: editViewModel
        )
        editChannelVC.coordinator = self
        
        let editChannelNav = UINavigationController(
            rootViewController: editChannelVC
        )
        if let sheet = editChannelNav.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(editChannelNav, animated: true)
    }
}
