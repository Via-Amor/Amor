//
//  MyProfileView.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import SnapKit

final class MyProfileView: BaseView {
    lazy var profileCollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: .setProfileCollectionViewLayout
        )
        cv.register(
            ProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier
        )
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        
        return cv
    }()
    
    override func configureHierarchy() {
        addSubview(profileCollectionView)
    }
    
    override func configureLayout() {
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(20)
        }
    }
}
