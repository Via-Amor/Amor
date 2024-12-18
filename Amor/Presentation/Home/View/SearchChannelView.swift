//
//  SearchChannelView.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import UIKit
import SnapKit

final class SearchChannelView: BaseView {
    let searchCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .setSearchChannelViewLayout
    )

    override func configureHierarchy() {
        addSubview(searchCollectionView)
    }
    
    override func configureLayout() {
        searchCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        searchCollectionView.register(
            SearchChannelCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchChannelCollectionViewCell.identifier
        )
    }
    
}
