//
//  SideSpaceMenuView.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import SnapKit

final class SideSpaceMenuView: BaseView {
    let topNavigationView = UIView()
    let addWorkSpaceButton = UIButton()
    
    override func configureHierarchy() {
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        backgroundColor = .white
        
        layer.cornerRadius = 25
        layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        clipsToBounds = true
    }
}
