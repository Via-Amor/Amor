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
    let spaceLabel = {
        let label = UILabel()
        label.text = "워크스페이스"
        label.font = .title1
        
        return label
    }()
    
    lazy var spaceCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: setSideSpaceMenuCollectionViewLayout())
        cv.register(SpaceCollectionViewCell.self, forCellWithReuseIdentifier: SpaceCollectionViewCell.identifier)
        
        return cv
    }()
    
    let addWorkSpaceButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.body
        configuration.attributedTitle = AttributedString("워크스페이스 추가", attributes: titleContainer)
        configuration.baseForegroundColor = .themeInactive
        let plusImage = Design.Icon.plus
        configuration.image = Design.Icon.plus.withTintColor(.themeInactive).withConfiguration(UIImage.SymbolConfiguration(pointSize: .init(12)))
        configuration.titleAlignment = .center
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -150, bottom: 0, trailing: 0)
        
        button.configuration = configuration
        
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(topNavigationView)
        topNavigationView.addSubview(spaceLabel)
        addSubview(spaceCollectionView)
        addSubview(addWorkSpaceButton)
    }
    
    override func configureLayout() {
        topNavigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(topNavigationView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(topNavigationView.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(30)
        }
        
        spaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topNavigationView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        addWorkSpaceButton.snp.makeConstraints { make in
            make.top.equalTo(spaceCollectionView.snp.bottom).offset(5)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(41)
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        clipsToBounds = true
        
        topNavigationView.backgroundColor = .backgroundPrimary
    }
}
