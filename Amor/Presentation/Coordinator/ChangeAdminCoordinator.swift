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
    
    func dismiss() {
        navigationController.dismiss(animated: true)
        if let parentCoordinator = parentCoordinator as? ChatCoordinator {
            parentCoordinator.childDidFinish(self)
        }
    }
    
    func dismiss(with newAdminID: String) {
        navigationController.dismiss(animated: true)
        if let parentCoordinator = parentCoordinator as? ChatCoordinator, 
            let channelSettingVC = parentCoordinator.navigationController.topViewController as? ChannelSettingViewController {
            channelSettingVC.changeAdminTrigger.accept(newAdminID)
            parentCoordinator.childDidFinish(self)
        }
    }
}

extension ChangeAdminCoordinator {
    // 채널 관리자 변경 -> 관리자 변경 불가 Alert
    func showDisableChangeAdminAlert(confirmHandler: @escaping () -> Void) {
        let disableAdminAlertVC = CustomAlertController(
            alertType: AlertType.disableChangeAdmin,
            confirmHandler: confirmHandler,
            cancelHandler: { }
        )
        modalNavigationController.present(disableAdminAlertVC, animated: true)
    }
    
    // 채널 관리자 변경 -> 관리자 변경 확인 Alert
    func showConfirmChangeAdminAlert(nickname: String, confirmHandler: @escaping () -> Void) {
        let confirmChangeAdminAlertVC = CustomAlertController(
            alertType: AlertType.confirmChangeAdmin(nickname: nickname),
            confirmHandler: confirmHandler,
            cancelHandler: { }
        )
        modalNavigationController.present(confirmChangeAdminAlertVC, animated: true)
    }
}
