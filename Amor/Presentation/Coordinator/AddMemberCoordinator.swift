//
//  AddMemberCoordinator.swift
//  Amor
//
//  Created by 김상규 on 12/16/24.
//

import UIKit

final class AddMemberCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc: AddMemberViewController = DIContainer.shared.resolve()
        vc.coordinator = self
        let nav = UINavigationController(rootViewController: vc)
        
        navigationController.present(nav, animated: true)
    }
    
    func dismissSheetFlow(isAdd: Bool = false) {
        if isAdd {
            if let dmListVC = navigationController.viewControllers.first as? DMListViewController {
                dmListVC.updateMemberTrigger.accept(())
            }
        }
        
        navigationController.dismiss(animated: true)
    }
}
