//
//  SideSpaceMenuViewController.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SideSpaceMenuViewController: BaseVC<SideSpaceMenuView> {
    var coordinator: SideSpaceMenuCoordinator?
    private let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    
    override func bind() {
        
        Observable.just(Array(repeating: "", count: 10))
            .bind(to: baseView.spaceCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell()
                
                if UserDefaultsStorage.spaceId == item {
                    cell.contentView.backgroundColor = .themeGray
                }
            }
            .disposed(by: disposeBag)
        
        baseView.spaceCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                if let previousIndexPath = owner.selectedIndexPath.value {
                    if let previousCell = owner.baseView.spaceCollectionView.cellForItem(at: previousIndexPath) as? SpaceCollectionViewCell {
                        previousCell.contentView.backgroundColor = .white
                    }
                }
                
                owner.selectedIndexPath.accept(indexPath)
                
                if let selectedCell = owner.baseView.spaceCollectionView.cellForItem(at: indexPath) as? SpaceCollectionViewCell {
                    selectedCell.contentView.backgroundColor = .themeGray
                }
            }
            .disposed(by: disposeBag)
    }
}
