//
//  HomeCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = TabbarViewController()
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
