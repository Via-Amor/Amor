//
//  SearchChannelCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import UIKit

final class SearchChannelCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchChannelVC: SearchChannelViewController = DIContainer.shared.resolve()
        searchChannelVC.coordinator = self
        modalNavigationController = UINavigationController(
            rootViewController: searchChannelVC
        )
        modalNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(modalNavigationController, animated: true)
    }
    
    func showChannelChat(channel: Channel, isUpdate: Bool) {
        if let parentCoordinator = parentCoordinator as? HomeCoordinator {
            parentCoordinator.showChatFlow(channel: channel, isUpdate: isUpdate)
            parentCoordinator.childDidFinish(self)
        }
    }
    
    func showChatEnterAlert(
        channel: Channel,
        confirmHandler: @escaping () -> Void
    ) {
        let enterChannelAlert = CustomAlertController(
            alertType: .enterChannelChat(channelName: channel.name),
            confirmHandler: confirmHandler,
            cancelHandler: { }
        )
        modalNavigationController.present(enterChannelAlert, animated: true)
    }
    
}
