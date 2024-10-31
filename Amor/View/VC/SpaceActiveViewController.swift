//
//  SpaceActiveViewController.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit

final class SpaceActiveViewController: UIViewController {
    let spaceActiveView = SpaceActiveView()
    
    override func loadView() {
        self.view = spaceActiveView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeGray
    }
}
