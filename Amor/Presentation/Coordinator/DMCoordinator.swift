//
//  DMCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit
import RxSwift

final class DMCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dmVC: DMListViewController = DIContainer.shared.resolve(arg: ChatType.dm(nil))
        dmVC.coordinator = self
        dmVC.tabBarItem = UITabBarItem(
            title: Literal.TabTitle.dm,
            image: .dmUnselected,
            selectedImage: .dmSelected
        )
        
        navigationController.pushViewController(dmVC, animated: true)
    }
    
    func showChatFlow(dmRoomInfo: DMRoomInfo) {
        let chatCoordinator = ChatCoordinator(
            navigationController: navigationController,
            chatType: .dm(dmRoomInfo)
        )
        chatCoordinator.parentCoordinator = self
        chatCoordinator.start()
    }
    
    func showInviteMemberFlow() {
        let coordinator = AddMemberCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
