//
//  ChangeSpaceOwnerView.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import UIKit
import SnapKit

final class ChangeSpaceOwnerView: BaseView {
    lazy var spaceMemberCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: setSideSpaceMenuCollectionViewLayout())
        cv.register(SpaceCollectionViewCell.self, forCellWithReuseIdentifier: SpaceCollectionViewCell.identifier)
        
        return cv
    }()
    
    override func configureHierarchy() {
        addSubview(spaceMemberCollectionView)
    }
    
    override func configureLayout() {
        spaceMemberCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
