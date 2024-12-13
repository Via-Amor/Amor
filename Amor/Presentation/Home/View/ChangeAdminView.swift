//
//  ChangeAdminView.swift
//  Amor
//
//  Created by 홍정민 on 12/8/24.
//

import UIKit
import SnapKit

final class ChangeAdminView: BaseView {
    lazy var memberCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .setListCollectionViewLayout()
    )
    
    override func configureHierarchy() {
        addSubview(memberCollectionView)
    }
    
    override func configureLayout() {
        memberCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backgroundColor = .themeWhite
        memberCollectionView.register(
            SpaceCollectionViewCell.self,
            forCellWithReuseIdentifier: SpaceCollectionViewCell.identifier
        )
    }
    
    
}
