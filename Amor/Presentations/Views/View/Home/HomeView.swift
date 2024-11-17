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
    lazy var homeCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.setHomeCollectionViewLayout())
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        cv.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionHeaderView.identifier)
        cv.isScrollEnabled = true
        
        return cv
    }()
    let floatingButton = FloatingButton()
    
    override func configureView() {
        super.configureView()
        
        navBar.configureNavTitle(.home("하안녕하세요"))
    }
    
    override func configureHierarchy() {
        addSubview(dividerLine)
        addSubview(homeCollectionView)
        addSubview(floatingButton)
    }
    
    override func configureLayout() {
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        homeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func layoutSubviews() {
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = navBar.myProfileButton.bounds.width / 2
        navBar.myProfileButton.clipsToBounds = true
    }
}
