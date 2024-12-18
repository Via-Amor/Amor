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
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: .setHomeCollectionViewLayout()
        )
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        cv.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionHeaderView.identifier)
        cv.isScrollEnabled = true
        
        return cv
    }()
    let floatingButton = FloatingButton()
    
    let emptyTitleLabel = {
        let label = UILabel()
        label.text = "워크스페이스를 찾을 수 없어요."
        label.font = .title1
        label.textAlignment = .center
        
        return label
    }()
    let emptySubtitleLabel = {
        let label = UILabel()
        label.text = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 워크스페이스를 생성해주세요."
        label.numberOfLines = 2
        label.font = .body
        label.textAlignment = .center
        
        return label
    }()
    let emptyImageView = UIImageView()
    let createSpaceButton = CommonButton(title: "스페이스 생성", foregroundColor: .themeWhite, backgroundColor: .themeGreen)
    
    override func configureHierarchy() {
        addSubview(dividerLine)
        addSubview(homeCollectionView)
        addSubview(floatingButton)
        addSubview(emptyTitleLabel)
        addSubview(emptySubtitleLabel)
        addSubview(emptyImageView)
        addSubview(createSpaceButton)
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
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(30)
        }
        
        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(emptyImageView.snp.width)
        }
        
        createSpaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutSubviews() {
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = navBar.myProfileButton.bounds.width / 2
        navBar.myProfileButton.clipsToBounds = true
    }
    
    func showEmptyView(show: Bool) {
        homeCollectionView.isHidden = show
        floatingButton.isHidden = show
        emptyTitleLabel.isHidden = !show
        emptySubtitleLabel.isHidden = !show
        emptyImageView.isHidden = !show
        createSpaceButton.isHidden = !show
        floatingButton.isHidden = show
        emptyImageView.image = show ? .onboarding : nil
    }
}
