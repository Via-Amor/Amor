//
//  SearchCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchVC = SearchViewController()
        
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search_unselected"), selectedImage: UIImage(named: "Search_selected"))
        
        navigationController.pushViewController(searchVC, animated: true)
    }
}
