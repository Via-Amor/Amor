//
//  SideSpaceMenuCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit

final class SideSpaceMenuCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var sideMenuViewController: SideSpaceMenuViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {

    }
}
