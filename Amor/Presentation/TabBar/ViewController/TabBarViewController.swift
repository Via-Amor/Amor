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
        tabBar.backgroundColor = .backgroundSecondary
        tabBar.tintColor = .textPrimary
    }
}
