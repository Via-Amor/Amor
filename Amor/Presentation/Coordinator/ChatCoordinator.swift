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
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension ChatCoordinator {
    // 채널 설정 -> 채널삭제 -> 홈
    func showHomeDefault() {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.updateChannelTrigger.accept(())
        }
        navigationController.popToRootViewController(animated: true)
        if let homeCoordinator = parentCoordinator as? HomeCoordinator {
            homeCoordinator.childDidFinish(self)
        }
    }
    
    // 채널 설정 -> 나가기 -> 홈
    func showHomeDefaultWithValue(channelList: [Channel]) {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.updateChannelValueTrigger.accept(channelList)
        }
        navigationController.popToRootViewController(animated: true)
        if let homeCoordinator = parentCoordinator as? HomeCoordinator {
            homeCoordinator.childDidFinish(self)
        }
    }
    
    // 채팅 -> 채널 설정
    func showChannelSetting(channelID: String) {
        let channelSettingVC: ChannelSettingViewController = DIContainer.shared.resolve(arg: channelID)
        channelSettingVC.coordinator = self
        navigationController.pushViewController(
            channelSettingVC,
            animated: true
        )
    }
    
    // 채널 설정 -> 채널 편집
    func showEditChannel(editChannel: EditChannel) {
        let editChatcoordinator = EditChannelCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(editChatcoordinator)
        editChatcoordinator.parentCoordinator = self
        editChatcoordinator.showEditChat(editChannel: editChannel)
    }
    
    // 채널 설정 -> 채널 삭제
    func showDeleteChannelAlert(confirmHandler: @escaping () -> Void) {
        let deleteAlertVC = CustomAlertController(
            title: AlertType.deleteChannel.title,
            subtitle: AlertType.deleteChannel.subtitle,
            confirmHandler: confirmHandler,
            cancelHandler: { },
            alertType: AlertType.deleteChannel.button
        )
        navigationController.present(deleteAlertVC, animated: true)
    }
    
    // 채널 설정 -> 채널 나가기
    func showExitChannelAlert(
        isAdmin: Bool,
        confirmHandler: @escaping () -> Void
    ) {
        let deleteAlertVC = CustomAlertController(
            title: AlertType.exitChannel(isAdmin: isAdmin).title,
            subtitle: AlertType.exitChannel(isAdmin: isAdmin).subtitle,
            confirmHandler: confirmHandler,
            cancelHandler: { },
            alertType: AlertType.exitChannel(isAdmin: isAdmin).button
        )
        navigationController.present(deleteAlertVC, animated: true)
    }
}
