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
        let viewModel: ChatViewModel = DIContainer.shared.resolve(arg: chatType)
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
    
    // 채팅 -> 채널 설정
    func showChannelSetting(channel: Channel) {
        let channelSettingVC: ChannelSettingViewController = DIContainer.shared.resolve(arg: channel)
        channelSettingVC.coordinator = self
        navigationController.pushViewController(
            channelSettingVC,
            animated: true
        )
    }
    
    // 채널 설정 -> 채널 편집
    func showEditChannel(editChannel: EditChannel) {
        let editChatCoordinator = EditChannelCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(editChatCoordinator)
        editChatCoordinator.parentCoordinator = self
        editChatCoordinator.showEditChat(editChannel: editChannel)
    }
    
    // 채널 설정 -> 채널 관리자 변경
    func showChangeAdmin(channelID: String) {
        let changeAdminCoordinator = ChangeAdminCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(changeAdminCoordinator)
        changeAdminCoordinator.parentCoordinator = self
        changeAdminCoordinator.showChangeAdmin(channelID: channelID)
    }
    
    // 채널 설정 -> 채널 삭제
    func showDeleteChannelAlert(confirmHandler: @escaping () -> Void) {
        let deleteAlertVC = CustomAlertController(
            title: "채널 삭제",
            subtitle: "정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등 채널 내의 모든 정보가 삭제되며 복구할 수 없습니다.",
            confirmHandler: confirmHandler,
            cancelHandler: { },
            alertType: .twoButton
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
