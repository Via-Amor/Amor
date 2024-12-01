//
//  HomeCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class TabCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController = TabbarViewController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        
        let dmNav = UINavigationController()
        let dmCoordinator = DMCoordinator(navigationController: dmNav)
        
        let searchNav = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        
        let settingNav = UINavigationController()
        let settingCoordinator = SettingCoordinator(navigationController: settingNav)
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(dmCoordinator)
        childCoordinators.append(searchCoordinator)
        childCoordinators.append(settingCoordinator)
        
        homeCoordinator.parentCoordinator = self
        dmCoordinator.parentCoordinator = self
        searchCoordinator.parentCoordinator = self
        settingCoordinator.parentCoordinator = self
        
        homeCoordinator.start()
        dmCoordinator.start()
        searchCoordinator.start()
        settingCoordinator.start()
        
        tabBarController.viewControllers = [homeNav, dmNav, searchNav, settingNav]
        navigationController.viewControllers = [tabBarController]
    }
    
    func navigationBarHidden() {
        self.navigationController.isNavigationBarHidden = true
    }
}
