//
//  HomeView.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import UIKit

final class HomeView: BaseView {
    let navBar = SpaceNavigationBarView()
    
    override func configureView() {
        super.configureView()
        
        navBar.configureNavTitle(.home("하안녕하세요"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = navBar.myProfileButton.bounds.width / 2
        navBar.myProfileButton.clipsToBounds = true
    }
}
