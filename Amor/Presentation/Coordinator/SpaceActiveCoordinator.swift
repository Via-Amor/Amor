//
//  SpaceActiveCoordinator.swift
//  Amor
//
//  Created by 김상규 on 12/19/24.
//

import UIKit

final class SpaceActiveCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var modalNavigationController = UINavigationController()
    
    var viewType: SpaceActiveViewType
    
    init(navigationController: UINavigationController, viewType: SpaceActiveViewType) {
        self.navigationController = navigationController
        self.viewType = viewType
    }
    
    func start() {
        let vc: SpaceActiveViewController = DIContainer.shared.resolve(arg: viewType)
        vc.coordinator = self
        customModalPresent(vc)
    }
    
    private func customModalPresent(_ viewController: UIViewController) {
        modalNavigationController = UINavigationController(
            rootViewController: viewController
        )
        
        if let sheet = modalNavigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(modalNavigationController, animated: true)
    }
    
    func dismissSheetFlow(isCreated: Bool = false) {
        if isCreated {
            switch viewType {
            case .create:
                if let homeView = navigationController.viewControllers.first as? HomeViewController {
                    homeView.coordinator?.dismissSideSpaceMenuFlow()
                    homeView.fetchHomeDefaultTrigger.accept(())
                    
                    navigationController.view.makeToast(ToastText.createSpace)
                }
            case .edit:
                if let homeView = navigationController.viewControllers.first as? HomeViewController {
                    homeView.fetchHomeDefaultTrigger.accept(())
                }
            }
        }
        
        navigationController.dismiss(animated: true)
    }
}
