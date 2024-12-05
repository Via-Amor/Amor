//
//  EditChannelCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 12/4/24.
//

import UIKit

final class EditChannelCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func showEditChat(editChannel: EditChannel) {
        let editChannelVC: EditChannelViewController = DIContainer.shared.resolve(arg: editChannel)
        editChannelVC.coordinator = self
        
        modalNavigationController = UINavigationController(
            rootViewController: editChannelVC
        )
        
        if let sheet = modalNavigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(modalNavigationController, animated: true)
    }
    
    func dismissEditChat(isUpdate: Bool) {
        if let editChannelVC = modalNavigationController.viewControllers.first
            as? EditChannelViewController {
            editChannelVC.dismiss(animated: true)
        }

        if let chatCoordinator = parentCoordinator as? ChatCoordinator,
           let channelSettingVC = chatCoordinator.navigationController.topViewController as? ChannelSettingViewController {
            channelSettingVC.channelUpdateTrigger.accept(isUpdate)
            chatCoordinator.childDidFinish(self)
        }
        
    }
    
}
