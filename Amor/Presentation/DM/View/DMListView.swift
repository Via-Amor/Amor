//
//  DMView.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit

final class DMListView: BaseView {
    let navBar = SpaceNavigationBarView()
    let navigationDivider = DividerView()
    let dmUserCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .setDMUserCollectionViewLayout
    )
    let dividerLine2 = DividerView()
    let dmRoomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .setListCollectionViewLayout()
    )
    let memberEmptyView = DMMemberEmptyView()
    
    override func configureHierarchy() {
        addSubview(navigationDivider)
        addSubview(dmUserCollectionView)
        addSubview(dividerLine2)
        addSubview(dmRoomCollectionView)
        addSubview(memberEmptyView)
    }
    
    override func configureLayout() {
        navigationDivider.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmUserCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationDivider.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(dmUserCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmRoomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        memberEmptyView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        navBar.configureNavTitle(Navigation.DM.main)
        navBar.spaceTitleButton.isUserInteractionEnabled = false
        
        dmUserCollectionView.register(
            DMUserCollectionViewCell.self,
            forCellWithReuseIdentifier: DMUserCollectionViewCell.identifier
        )
        dmUserCollectionView.alwaysBounceVertical = false
        
        dmRoomCollectionView.register(
            DMListCollectionViewCell.self,
            forCellWithReuseIdentifier: DMListCollectionViewCell.identifier
        )
        dmRoomCollectionView.showsVerticalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = 8
        navBar.myProfileButton.clipsToBounds = true
    }
    
    func configureEmptyLayout(isEmpty: Bool) {
        if isEmpty {
            memberEmptyView.isHidden = false
        } else {
            memberEmptyView.isHidden = true
        }
    }
}
