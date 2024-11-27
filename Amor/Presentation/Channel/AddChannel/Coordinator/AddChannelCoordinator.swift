//
//  AddChannelCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/27/24.
//

import UIKit

final class AddChannelCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var addChannelViewController: AddChannelViewController?
    var delegate: AddChannelDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AddChannelViewController(viewModel: AddChannelViewModel(useCase: DefaultHomeUseCase(channelRepository: DefaultChannelRepository(), spaceRepository: DefaultSpaceRepository(), dmRepository: DefaultDMRepository())))
        self.addChannelViewController = vc
        addChannelViewController?.coordinator = self
        
        if let addChannelViewController = self.addChannelViewController {
            let nav = UINavigationController(rootViewController: addChannelViewController)
            navigationController.present(nav, animated: true)
        }
    }
    
    func dismissAddChannelFlow(isAdd: Bool) {
        addChannelViewController?.dismiss(animated: true) {
            if isAdd {
                self.delegate?.didAddChannel()
            }
        }
    }
}
