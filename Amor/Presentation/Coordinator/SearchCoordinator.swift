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
        let searchVC: SearchViewController = DIContainer.shared.resolve()
        searchVC.coordinator = self
        
        searchVC.tabBarItem = UITabBarItem(
            title: Literal.TabTitle.search,
            image: .searchUnselected,
            selectedImage: .searchSelected
        )
        
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func showProfileFlow(member: SpaceMember) {
        let otherProfileViewController = OtherProfileViewController(viewModel: OtherProfileViewModel(otherProfile: member))
        navigationController.pushViewController(otherProfileViewController, animated: true)
    }
    
    func showJoinChannelAlertFlow(channelName: String, completionHandler: @escaping () -> Void) {
        let alert = CustomAlertController(
            alertType: .joinChannel(channelName: channelName),
            confirmHandler: completionHandler,
            cancelHandler: { }
        )
        
        navigationController.present(alert, animated: true)
    }
}
