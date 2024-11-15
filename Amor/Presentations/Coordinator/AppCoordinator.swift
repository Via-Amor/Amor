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
        if UserDefaultsStorage.token.isEmpty {
            showUserFlow()
        } else {
            showHomeFlow()
        }
    }
    
    func showUserFlow() {
        let userCoordinator = UserCoordinator(navigationController: navigationController)
        userCoordinator.parentCoordinator = self
        childCoordinators.append(userCoordinator)
        userCoordinator.start()
    }
    
    func showHomeFlow() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

