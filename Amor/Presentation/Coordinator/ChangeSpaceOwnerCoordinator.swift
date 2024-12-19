//
//  ChangeSpaceOwnerCoordinator.swift
//  Amor
//
//  Created by 김상규 on 12/19/24.
//

import UIKit

final class ChangeSpaceOwnerCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc: ChangeSpaceOwnerViewController = DIContainer.shared.resolve()
        vc.coordinator = self
        customModalPresent(vc)
    }
    
    func customModalPresent(_ viewController: UIViewController) {
        modalNavigationController = UINavigationController(
            rootViewController: viewController
        )
        
        if let sheet = modalNavigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(modalNavigationController, animated: true)
    }
    
    func showDisableChangeOwnerAlert(completionHandler: @escaping () -> Void) {
        
        let alertVC = CustomAlertController(
            alertType: .changeDisabled,
            confirmHandler: completionHandler,
            cancelHandler: { }
        )

        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func showAbleChangeOwnerAlert(memberNickname: String, completionHandler: @escaping () -> Void) {
        
        let alertVC = CustomAlertController(
            alertType: .changeEnalbled(memberNickname),
            confirmHandler: completionHandler,
            cancelHandler: { }
        )
        
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func dismissSheetFlow(isCreated: Bool = false) {
        
        if isCreated {
            if let homeView = navigationController.viewControllers.first as? HomeViewController {
                homeView.coordinator?.dismissSideSpaceMenuFlow()
                homeView.fetchHomeDefaultTrigger.accept(())
            }
        }
        
        navigationController.dismiss(animated: true)
    }
    
    func dismissAlertFlow(isChanges: Bool = false) {
        if isChanges {
            if let homeView = navigationController.viewControllers.first as? HomeViewController {
                homeView.fetchHomeDefaultTrigger.accept(())
            }
        }
        
        navigationController.dismiss(animated: true)
    }
}
