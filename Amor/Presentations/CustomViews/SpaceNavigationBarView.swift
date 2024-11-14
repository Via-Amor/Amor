//
//  SpaceNavigationBarView.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import UIKit
import SnapKit

final class SpaceNavigationBarView: UIView {
    let spaceImageView = RoundImageView()
    let spaceTitleLabel = {
        let label = UILabel()
        label.font = .Size.title1
        
        return label
    }()
    
    let myProfileButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.themeBlack.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        spaceImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        myProfileButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
    
    func configureNavTitle(_ navBarType: NavigationBarType) {
        spaceTitleLabel.text = navBarType.title
    }
}
