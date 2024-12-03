//
//  EditChannelViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/3/24.
//

import UIKit
import SnapKit

final class EditChannelViewController: BaseVC<EditChannelView> {
    var coordinator: Coordinator?
    
    override func configureNavigationBar() {
        navigationItem.title = "채널 편집"
    }
    
}
