//
//  UserCoordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class UserCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController(
            viewModel: LoginViewModel(
                useCase: DefaultUserUseCase(
                    repository: DefaultUserRepository(NetworkManager.shared)
                )
            )
        )
        navigationController.pushViewController(loginViewController, animated: true)
    }
}
