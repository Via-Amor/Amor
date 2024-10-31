//
//  SpaceInitialViewController.swift
//  Amor
//
//  Created by 홍정민 on 10/29/24.
//

import UIKit
import SnapKit

final class SpaceInitialViewController: UIViewController {
    let spaceInitialView = SpaceInitialView()
    
    override func loadView() {
        self.view = spaceInitialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeGray
    }
}
