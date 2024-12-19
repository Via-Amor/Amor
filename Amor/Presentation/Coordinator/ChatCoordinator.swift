//
//  ChatCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/25/24.
//

import UIKit

enum ChatType {
    case channel(Channel)
    case dm(DMRoomInfo?)
    
    var event: String {
        switch self {
        case .channel:
            return "channel"
        case .dm:
            return "dm"
        }
    }
}

final class ChatCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let chatType: ChatType
    
    init(navigationController: UINavigationController, chatType: ChatType) {
        self.navigationController = navigationController
        self.chatType = chatType
    }
    
    func start() {
        let chatVC: ChatViewController = DIContainer.shared.resolve(arg: chatType)
        chatVC.coordinator = self
        navigationController.pushViewController(
            chatVC,
            animated: true
        )
    }
    
    func showChannelSetting(channel: Channel) {
        let channelSettingVC: ChannelSettingViewController = DIContainer.shared.resolve(arg: channel)
        channelSettingVC.coordinator = self
        navigationController.pushViewController(
            channelSettingVC,
            animated: true
        )
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension ChatCoordinator {
    func showEditChannel(editChannel: EditChannel) {
        let editChatCoordinator = EditChannelCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(editChatCoordinator)
        editChatCoordinator.parentCoordinator = self
        editChatCoordinator.showEditChat(editChannel: editChannel)
    }
    
    func showChangeAdmin(channelID: String) {
        let changeAdminCoordinator = ChangeAdminCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(changeAdminCoordinator)
        changeAdminCoordinator.parentCoordinator = self
        changeAdminCoordinator.showChangeAdmin(channelID: channelID)
    }
    
    func showHomeDefault() {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.updateChannelTrigger.accept(())
        }
        navigationController.popToRootViewController(animated: true)
        if let homeCoordinator = parentCoordinator as? HomeCoordinator {
            homeCoordinator.childDidFinish(self)
        }
    }
    
    func showHomeDefaultWithValue(channelList: [Channel]) {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.updateChannelValueTrigger.accept(channelList)
        }
        navigationController.popToRootViewController(animated: true)
        if let homeCoordinator = parentCoordinator as? HomeCoordinator {
            homeCoordinator.childDidFinish(self)
        }
    }
    
    func showDeleteChannelAlert(confirmHandler: @escaping () -> Void) {
        let deleteAlertVC = CustomAlertController(
            alertType: .deleteChannel,
            confirmHandler: confirmHandler,
            cancelHandler: { }
        )
        navigationController.present(deleteAlertVC, animated: true)
    }
    
    func showExitChannelAlert(
        isAdmin: Bool,
        confirmHandler: @escaping () -> Void
    ) {
        let deleteAlertVC = CustomAlertController(
            alertType: .exitChannel(isAdmin: isAdmin),
            confirmHandler: confirmHandler,
            cancelHandler: { }
        )
        navigationController.present(deleteAlertVC, animated: true)
    }
}
