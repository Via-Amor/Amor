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
    private let viewModel: SideSpaceMenuViewModel
    
    init(viewModel: SideSpaceMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func bind() {
        let trigger = BehaviorSubject<Void>(value: ())
        let input = SideSpaceMenuViewModel.Input(trigger: trigger)
        let output = viewModel.transform(input)
        
        output.mySpaces
            .bind(to: baseView.spaceCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell(spaceSimpleInfo: item)
            }
            .disposed(by: disposeBag)
        
        baseView.spaceCollectionView.rx.modelSelected(SpaceSimpleInfo.self)
            .bind(with: self) { owner, value in
                
                UserDefaultsStorage.spaceId = value.workspace_id
                
                if let visibleCells = owner.baseView.spaceCollectionView.visibleCells as? [SpaceCollectionViewCell] {
                    visibleCells.forEach { cell in
                        if let indexPath = owner.baseView.spaceCollectionView.indexPath(for: cell) {
                            if let cellItem = try? output.mySpaces.value()[indexPath.item] {
                                cell.configureCellBackground(isCurrentSpace: cellItem.isCurrentSpace)
                            }
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
