//
//  SpaceNavigationBarView.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SpaceNavigationBarView: UIView {
    let spaceImageView = RoundImageView()
    let spaceTitleButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .themeBlack
        configuration.titleAlignment = .leading
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = configuration
        
        return button
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
            make.size.equalTo(32)
        }
        
        spaceTitleButton.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
        }
        
        myProfileButton.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
    }
    
    func configureSpaceImageView(image: String?) {
        if let imageURL = image, let url = URL(string: apiUrl + imageURL) {
            spaceImageView.kf.setImage(with: url)
        } else {
            spaceImageView.image = .workspace
        }
    }
    
    func configureMyProfileImageView(image: String?) {
        if let imageURL = image, let url = URL(string: apiUrl + imageURL) {
            myProfileButton.imageView?.kf.setImage(with: url)
        } else {
            myProfileButton.setImage(.userGreen, for: .normal)
        }
    }
    
    func configureNavTitle(_ navBarTitle: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = .title1
        
        spaceTitleButton.configuration?.attributedTitle = AttributedString(
            navBarTitle,
            attributes: titleContainer
        )
    }
}
