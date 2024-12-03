//
//  AppCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    
    }
    
    func showUserFlow() {
        let userCoordinator = UserCoordinator(navigationController: navigationController)
        userCoordinator.parentCoordinator = self
        childCoordinators.append(userCoordinator)
        userCoordinator.start()
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator.parentCoordinator = self
        childCoordinators.append(tabCoordinator)
        tabCoordinator.navigationBarHidden()
        tabCoordinator.start()
    }
    
    func removeAllChild() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}

