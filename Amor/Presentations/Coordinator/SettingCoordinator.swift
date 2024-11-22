//
//  SettingCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit

final class SettingCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingVC = SettingViewController()
        
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "Setting_unselected"), selectedImage: UIImage(named: "Setting_selected"))
        
        navigationController.pushViewController(settingVC, animated: true)
    }
}
