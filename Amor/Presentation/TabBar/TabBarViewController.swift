//
//  TabBar.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import RxSwift

final class TabbarViewController: UITabBarController {
    var dimmingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        
        view.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.size.equalTo(self.view)
        }
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.isHidden = true
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .backgroundSecondary
        tabBar.tintColor = .textPrimary
    }
}
