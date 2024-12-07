//
//  DMCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit

final class DMCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dmVC: DMListViewController = DIContainer.shared.resolve()
        dmVC.coordinator = self
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: Design.TabImage.dmUnselected, selectedImage: Design.TabImage.dmSelected)
        
        navigationController.pushViewController(dmVC, animated: true)
    }
    
    func showChatFlow(dmRoom: DMRoom) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController, chatType: .dm(dmRoom))
        chatCoordinator.parentCoordinator = self
        chatCoordinator.start()
    }
}
