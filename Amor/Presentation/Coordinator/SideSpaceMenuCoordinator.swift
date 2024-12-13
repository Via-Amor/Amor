//
//  SideSpaceMenuCoordinator.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import UIKit

final class SideSpaceMenuCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var sideSpaceMenuViewController: SideSpaceMenuViewController?
    var modalNavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.sideSpaceMenuViewController = DIContainer.shared.resolve()
        
        guard let sideSpaceMenuViewController = self.sideSpaceMenuViewController else { return }
        
        if let homeVC = self.navigationController.viewControllers.first as? HomeViewController {
            sideSpaceMenuViewController.delegate = homeVC
            sideSpaceMenuViewController.coordinator = self
        }

        navigationController.tabBarController?.navigationController?.addChild(sideSpaceMenuViewController)
        navigationController.tabBarController?.navigationController?.view.addSubview(sideSpaceMenuViewController.view)
        
        let menuWidth = self.navigationController.view.frame.width * 0.8
        let menuHeight = self.navigationController.view.frame.height
        
        sideSpaceMenuViewController.view.frame = CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight)
        sideSpaceMenuViewController.view.transform = CGAffineTransform(translationX: -menuWidth, y: 0)
        
        if let homeCoordinator = self.parentCoordinator as? HomeCoordinator, let tabCoordinator = homeCoordinator.parentCoordinator as? TabCoordinator  {
            tabCoordinator.tabBarController.dimmingView.isHidden = false
            tabCoordinator.tabBarController.dimmingView.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                sideSpaceMenuViewController.view.transform = .identity
                tabCoordinator.tabBarController.dimmingView.alpha = 0.5
            })
        }
    }
    
    func dismissSideSpaceMenuFlow() {
        guard let sideSpaceMenuViewController = self.sideSpaceMenuViewController else { return }
        
        if let homeCoordinator = self.parentCoordinator as? HomeCoordinator, let tabCoordinator = homeCoordinator.parentCoordinator as? TabCoordinator  {
            UIView.animate(withDuration: 0.5, animations: {
                sideSpaceMenuViewController.view.transform = CGAffineTransform(translationX: -self.navigationController.view.frame.width, y: 0)
                tabCoordinator.tabBarController.dimmingView.alpha = 0
            }) { (finished) in
                if finished {
                    sideSpaceMenuViewController.view.removeFromSuperview()
                    sideSpaceMenuViewController.removeFromParent()
                    tabCoordinator.tabBarController.dimmingView.isHidden = true
                }
            }
        }
    }
    
    func showDeleteAlertFlow(completionHandler: @escaping () -> Void) {
        let alertVC = CustomAlertController(
            title: ActionSheetText.SpaceActionSheetText.delete.rawValue,
            subtitle: ActionSheetText.SpaceActionSheetText.delete.alertDescription,
            confirmHandler: completionHandler,
            cancelHandler: { },
            alertType: .twoButton
        )
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func showOwnerLeaveAlertFlow(completionHandler: @escaping () -> Void) {
        let alertVC = CustomAlertController(
            title: ActionSheetText.SpaceActionSheetText.leave.rawValue,
            subtitle: ActionSheetText.SpaceActionSheetText.leave.alertDescription,
            confirmHandler: completionHandler,
            cancelHandler: { },
            alertType: .oneButton
        )
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func showLeaveAlertFlow(completionHandler: @escaping () -> Void) {
        let alertVC = CustomAlertController(
            title: ActionSheetText.SpaceActionSheetText.leave.rawValue,
            subtitle: "정말 이 워크스페이스를 떠나시겠습니까?",
            confirmHandler: completionHandler,
            cancelHandler: { },
            alertType: .twoButton
        )
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func dismissAlertFlow() {
        navigationController.dismiss(animated: true)
    }
    
    func presentSpaceActiveFlow(viewType: SpaceActiveViewType) {
        let vc: SpaceActiveViewController = DIContainer.shared.resolve(arg: viewType)
        vc.delegate = self.sideSpaceMenuViewController
        customModalPresent(vc)
    }
    
    func presentChangeSpaceOwnerViewFlow() {
        let vc: ChangeSpaceOwnerViewController = DIContainer.shared.resolve()
        vc.coordinator = self
        vc.delegate = self.sideSpaceMenuViewController
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
    
    func showAbleChangeOwnerAlert(memberNickname: String, completionHandler: @escaping () -> Void) {
        
        let alertVC = CustomAlertController(
            title: AlertText.ChangeSpaceOwnerAlertText.changeEnalbled(memberNickname).title,
            subtitle: AlertText.ChangeSpaceOwnerAlertText.changeEnalbled(memberNickname).description,
            confirmHandler: completionHandler,
            cancelHandler: { },
            alertType: .twoButton
        )
        
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
    
    func showDisableChangeOwnerAlert(completionHandler: @escaping () -> Void) {
        
        let alertVC = CustomAlertController(
            title: AlertText.ChangeSpaceOwnerAlertText.changeDisabled.title,
            subtitle: AlertText.ChangeSpaceOwnerAlertText.changeDisabled.description,
            confirmHandler: completionHandler,
            cancelHandler: { },
            alertType: .oneButton
        )
        
        navigationController.visibleViewController?.present(alertVC, animated: true)
    }
}
