//
//  DMView.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit

final class DMView: BaseView {
    let navBar = SpaceNavigationBarView()
    let dividerLine = DividerView()
    lazy var dmUserCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.spaceMember))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        
        return cv
    }()
    let dividerLine2 = DividerView()
    lazy var dmRoomCollectionView = {
        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.dmRoom))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    let emptyPrimaryLabel = {
        let label = UILabel()
        label.text = "워크스페이스에 멤버가 없어요"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .title1
        
        return label
    }()
    let emptySubLabel = {
        let label = UILabel()
        label.text = "새로운 팀원을 초대해보세요"
        label.textAlignment = .center
        label.font = .body
        
        return label
    }()
    let emptyButton = CommonButton(title: "팀원 초대하기", foregroundColor: .themeWhite, backgroundColor: .themeGreen)
    
    override func configureHierarchy() {
        addSubview(dividerLine)
        addSubview(dmUserCollectionView)
    }
    
    override func configureLayout() {
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    func configureEmptyLayout(isEmpty: Bool) {
        dmUserCollectionView.isHidden = isEmpty
        dividerLine2.isHidden = isEmpty
        dmRoomCollectionView.isHidden = isEmpty
        emptyPrimaryLabel.isHidden = !isEmpty
        emptySubLabel.isHidden = !isEmpty
        emptyButton.isHidden = !isEmpty
        
        if isEmpty {
            addSubview(emptyPrimaryLabel)
            addSubview(emptySubLabel)
            addSubview(emptyButton)
            configureIsEmptyView()
        } else {
            addSubview(dmUserCollectionView)
            addSubview(dividerLine2)
            addSubview(dmRoomCollectionView)
            configureisNotEmptyView()
        }
    }
    
    private func configureisNotEmptyView() {
        dmUserCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(85)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(dmUserCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmRoomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureIsEmptyView() {
        emptySubLabel.snp.remakeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(18)
        }
        
        emptyPrimaryLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(emptySubLabel.snp.top).offset(-5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(80)
            make.height.equalTo(60)
        }
        
        emptyButton.snp.remakeConstraints { make in
            make.top.equalTo(emptySubLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(80)
        }
    }
    
    override func configureView() {
        super.configureView()
        navBar.configureNavTitle(.dm)
        navBar.spaceTitleButton.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        navBar.spaceImageView.layer.cornerRadius = 8
        navBar.spaceImageView.clipsToBounds = true
        
        navBar.myProfileButton.layer.cornerRadius = navBar.myProfileButton.bounds.width / 2
        navBar.myProfileButton.clipsToBounds = true
    }
}
