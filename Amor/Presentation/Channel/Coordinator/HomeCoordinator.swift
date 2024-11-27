//
//  HomeCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC: HomeViewController = DIContainer.shared.resolve()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "Home_unselected"),
            selectedImage: UIImage(named: "Home_selected")
        )
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func showChatFlow(channel: Channel) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController, channel: channel)
        chatCoordinator.start()
    }
    
    func showAddChannelFlow() {
        let coordinator = AddChannelCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}

final class AddChannelCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var addChannelViewController: AddChannelViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AddChannelViewController(viewModel: AddChannelViewModel(useCase: DefaultHomeUseCase(channelRepository: DefaultChannelRepository(), spaceRepository: DefaultSpaceRepository(), dmRepository: DefaultDMRepository())))
        self.addChannelViewController = vc
        addChannelViewController?.coordinator = self
        
        if let addChannelViewController = self.addChannelViewController {
            let nav = UINavigationController(rootViewController: addChannelViewController)
            navigationController.present(nav, animated: true)
        }
    }
    
    func dismissAddChannelFlow() {
        addChannelViewController?.dismiss(animated: true)
    }
}
