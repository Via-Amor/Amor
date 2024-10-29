//
//  WorkSpaceInitialViewController.swift
//  Amor
//
//  Created by 홍정민 on 10/29/24.
//

import UIKit
import SnapKit

final class WorkSpaceInitialViewController: UIViewController {
    let workSpaceInitialView = WorkSpaceInitialView()
    
    override func loadView() {
        self.view = workSpaceInitialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeGray
    }
}
