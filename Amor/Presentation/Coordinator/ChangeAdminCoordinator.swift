//
//  ChangeAdminCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 12/8/24.
//

import UIKit

final class ChangeAdminCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func showChangeAdmin(channelID: String) {
        let changeAdminViewModel: ChangeAdminViewModel = DIContainer.shared.resolve(arg: channelID)
        let changeAdminVC = ChangeAdminViewController(
            viewModel: changeAdminViewModel
        )
        changeAdminVC.coordinator = self
        
        modalNavigationController = UINavigationController(
            rootViewController: changeAdminVC
        )
        
        if let sheet = modalNavigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(modalNavigationController, animated: true)
    }
    
//    func dismissChangeAdmin(isUpdate: Bool) {
//        if let editChannelVC = modalNavigationController.viewControllers.first
//            as? EditChannelViewController {
//            editChannelVC.dismiss(animated: true)
//        }
//
//        if let chatCoordinator = parentCoordinator as? ChatCoordinator,
//           let channelSettingVC = chatCoordinator.navigationController.topViewController as? ChannelSettingViewController {
//            channelSettingVC.channelUpdateTrigger.accept(isUpdate)
//            chatCoordinator.childDidFinish(self)
//        }
//        
//    }
    
}
