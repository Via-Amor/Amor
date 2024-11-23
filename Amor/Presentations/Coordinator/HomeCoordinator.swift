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
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home_unselected"), selectedImage: UIImage(named: "Home_selected"))
        
        navigationController.pushViewController(homeVC, animated: true)
    }
}
