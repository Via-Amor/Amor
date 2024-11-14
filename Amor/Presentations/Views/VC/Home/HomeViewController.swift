//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: BaseVC<HomeView> {
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
