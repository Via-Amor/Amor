//
//  UserCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class UserCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController: LoginViewController = DIContainer.shared.resolve()
        loginViewController.coordinator = self
        navigationController.viewControllers = [loginViewController]
    }
    
    func login() {
        if let parent = parentCoordinator as? AppCoordinator {
            parent.showMainFlow()
            parent.childDidFinish(self)
        }
    }
    
    
}
