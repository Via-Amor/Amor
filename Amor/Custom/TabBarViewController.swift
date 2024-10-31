//
//  TabBar.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import RxSwift

final class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let dmVC = UINavigationController(rootViewController: DMViewController(viewModel: DMViewModel()))
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home_unselected"), selectedImage: UIImage(named: "Home_selected"))
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: UIImage(named: "DM_unselected"), selectedImage: UIImage(named: "DM_selected"))
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search_unselected"), selectedImage: UIImage(named: "Search_selected"))
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "Setting_unselected"), selectedImage: UIImage(named: "Setting_selected"))
        
        setViewControllers([homeVC, dmVC, searchVC, settingVC], animated: true)
        
        tabBar.backgroundColor = .backgroundSecondary
        tabBar.tintColor = .textPrimary
    }
}
