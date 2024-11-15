//
//  HomeView.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    let navBar = SpaceNavigationBarView()
    let dividerLine = DividerView()
    
    override func configureView() {
        super.configureView()
        
        navBar.configureNavTitle(.home("하안녕하세요"))
    }
    
    override func configureHierarchy() {
        addSubview(dividerLine)
    }
    
    override func configureLayout() {
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    override func layoutSubviews() {
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = navBar.myProfileButton.bounds.width / 2
        navBar.myProfileButton.clipsToBounds = true
    }
}
