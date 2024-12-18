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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchChannelVC = SearchChannelViewController(
            viewModel: SearchChannelViewModel(
                useCase: DefaultChannelUseCase(
                    channelRepository: DefaultChannelRepository(NetworkManager.shared),
                    channelChatDatabase: ChannelChatStorage()
                )
            )
        )
        searchChannelVC.coordinator = self
        let searchChannelNav = UINavigationController(
            rootViewController: searchChannelVC
        )
        searchChannelNav.modalPresentationStyle = .fullScreen
        navigationController.present(searchChannelNav, animated: true)
    }
    
    func showChannelChat(channel: Channel) {
        if let parentCoordinator = parentCoordinator as? HomeCoordinator {
            parentCoordinator.showChatFlow(channel: channel)
            parentCoordinator.childDidFinish(self)
        }
    }
    
}
