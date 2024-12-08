//
//  ChangeAdminViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/8/24.
//

import UIKit
import SnapKit

final class ChangeAdminViewController: BaseVC<ChangeAdminView> {
    var coordinator: ChangeAdminCoordinator?
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.changeChannelAdmin
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Design.Icon.xmark,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .themeBlack
    }
    
}

