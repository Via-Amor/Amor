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
        let dmVC: DMViewController = DIContainer.shared.resolve()
        
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: UIImage(named: "DM_unselected"), selectedImage: UIImage(named: "DM_selected"))
        
        navigationController.pushViewController(dmVC, animated: true)
    }
}
