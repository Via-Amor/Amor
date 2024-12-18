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
        let searchChannelVC = UINavigationController(
            rootViewController: SearchChannelViewController(
                viewModel: SearchChannelViewModel(
                    useCase: DefaultChannelUseCase(
                        channelRepository: DefaultChannelRepository(NetworkManager.shared),
                        channelChatDatabase: ChannelChatStorage()
                    )
                )
            )
        )
        searchChannelVC.modalPresentationStyle = .fullScreen
        navigationController.present(searchChannelVC, animated: true)
    }
    
}
