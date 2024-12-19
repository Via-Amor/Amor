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
    var sideMenuViewController: SideSpaceMenuViewController?
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC: HomeViewController = DIContainer.shared.resolve()
        homeVC.tabBarItem = UITabBarItem(
            title: Literal.TabTitle.home,
            image: .homeUnselected,
            selectedImage: .homeSelected
        )
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
 
    func showChatFlow(channel: Channel) {
        let chatCoordinator = ChatCoordinator(
            navigationController: navigationController,
            chatType: .channel(channel)
        )
        chatCoordinator.parentCoordinator = self
        chatCoordinator.start()
    }
    
    func updateHomeDefaultChannel() {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.updateChannelTrigger.accept(())
        }
    }
    
    func showChatFlow(dmRoomInfo: DMRoomInfo) {
        let chatCoordinator = ChatCoordinator(
            navigationController: navigationController,
            chatType: .dm(dmRoomInfo)
        )
        chatCoordinator.parentCoordinator = self
        chatCoordinator.start()
    }
    
    func showAddChannelFlow() {
        let coordinator = AddChannelCoordinator(navigationController: navigationController)
        coordinator.delegate = navigationController.viewControllers.first(where: { $0 is HomeViewController }) as? AddChannelDelegate
        coordinator.start()
    }
    
    func showSearchChannelFlow() {
        let coordinator = SearchChannelCoordinator(
            navigationController: navigationController
        )
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func presentSideMenuFlow() {
        let coordinator = SideSpaceMenuCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showLoginFlow() {
        if let tabCoordinator = parentCoordinator as? TabCoordinator, let appCoordinator = tabCoordinator.parentCoordinator as? AppCoordinator {
            appCoordinator.childCoordinators.removeAll(where: { $0 is TabCoordinator })
            appCoordinator.showUserFlow()
        }
    }
    
    func showDMTabFlow() {
        if let tabBarController = navigationController.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func dismissSideSpaceMenuFlow() {
        if let sideSpaceMenuCoordinator = childCoordinators.first as? SideSpaceMenuCoordinator {
            sideSpaceMenuCoordinator.dismissSideSpaceMenuFlow()
            childCoordinators.removeAll()
        }
    }
    
    func showInviteMemberFlow() {
        let coordinator = AddMemberCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func presentSpaceActiveFlow() {
        let coordinator = SpaceActiveCoordinator(navigationController: navigationController, viewType: .create(nil))
        coordinator.start()
    }
    
    func customModalPresent(_ viewController: UIViewController) {
        modalNavigationController = UINavigationController(
            rootViewController: viewController
        )
        
        if let sheet = modalNavigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(modalNavigationController, animated: true)
    }
}
