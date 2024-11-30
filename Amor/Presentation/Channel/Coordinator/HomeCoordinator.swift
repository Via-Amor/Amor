//
//  HomeCoordinator.swift
//  Amor
//
//  Created by 김상규 on 11/22/24.
//

import UIKit

protocol HomeDelegate: AnyObject {
    func presentSideMenu()
    func dismissSideMenu()
}

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var sideMenuViewController: SideSpaceMenuViewController?
    var delegate: HomeDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC: HomeViewController = DIContainer.shared.resolve()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "Home_unselected"),
            selectedImage: UIImage(named: "Home_selected")
        )
        homeVC.coordinator = self
        self.sideMenuViewController?.delegate = homeVC
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func showChatFlow(channel: Channel) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController, channel: channel)
        chatCoordinator.start()
    }
    
    func showAddChannelFlow() {
        let coordinator = AddChannelCoordinator(navigationController: navigationController)
        coordinator.delegate = navigationController.viewControllers.first(where: { $0 is HomeViewController }) as? AddChannelDelegate
        coordinator.start()
    }
    
    func presentSideMenuFlow() {
        self.sideMenuViewController = SideSpaceMenuViewController(viewModel: SideSpaceMenuViewModel(useCase: DefaultHomeUseCase(channelRepository: DefaultChannelRepository(), spaceRepository: DefaultSpaceRepository(), dmRepository: DefaultDMRepository())))
        
        guard let sideMenuViewController = self.sideMenuViewController else { return }
        navigationController.tabBarController?.navigationController?.addChild(sideMenuViewController)
        navigationController.tabBarController?.navigationController?.view.addSubview(sideMenuViewController.view)
        
        let menuWidth = self.navigationController.view.frame.width * 0.8
        let menuHeight = self.navigationController.view.frame.height
        
        sideMenuViewController.view.frame = CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight)
            sideMenuViewController.view.transform = CGAffineTransform(translationX: -menuWidth, y: 0)
        
        if let coordinator = self.parentCoordinator as? TabCoordinator {
            coordinator.tabBarController.dimmingView.isHidden = false
            coordinator.tabBarController.dimmingView.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                sideMenuViewController.view.transform = .identity
                coordinator.tabBarController.dimmingView.alpha = 0.5
            })
        }
    }
    
    func dismissSideMenuFlow() {
        guard let sideMenuViewController = self.sideMenuViewController else { return }
        
        if let coordinator = self.parentCoordinator as? TabCoordinator {
            UIView.animate(withDuration: 0.5, animations: {
                sideMenuViewController.view.transform = CGAffineTransform(translationX: -self.navigationController.view.frame.width, y: 0)
                    coordinator.tabBarController.dimmingView.alpha = 0
            }) { (finished) in
                
                sideMenuViewController.view.removeFromSuperview()
                sideMenuViewController.removeFromParent()
                coordinator.tabBarController.dimmingView.isHidden = true
            }
        }
    }
}
