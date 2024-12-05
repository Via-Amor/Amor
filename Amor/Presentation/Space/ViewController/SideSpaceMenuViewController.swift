//
//  SideSpaceMenuViewController.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SideSpaceMenuDelegate: AnyObject {
    func updateSpace(spaceSimpleInfo: SpaceSimpleInfo)
    func updateHome(spaceID: String)
}

final class SideSpaceMenuViewController: BaseVC<SideSpaceMenuView> {
    var coordinator: SideSpaceMenuCoordinator?
    private let space = PublishRelay<SpaceSimpleInfo?>()
    private let viewModel: SideSpaceMenuViewModel
    var delegate: SideSpaceMenuDelegate?
    
    init(viewModel: SideSpaceMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func bind() {
        let trigger = BehaviorSubject<Void>(value: ())
        let input = SideSpaceMenuViewModel.Input(trigger: trigger, space: space)
        let output = viewModel.transform(input)
        
        output.mySpaces
            .bind(to: baseView.spaceCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell(item: item)
                
                cell.tapMoreButton()
                    .map { item }
                    .bind(with: self) { owner, value in
                        owner.showSpaceActionSheet(spaceSimpleInfo: value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        baseView.spaceCollectionView.rx.modelSelected(SpaceSimpleInfo.self)
            .bind(with: self) { owner, value in
                if UserDefaultsStorage.spaceId != value.workspace_id {
                    UserDefaultsStorage.spaceId = value.workspace_id
                    
                    if let visibleCells = owner.baseView.spaceCollectionView.visibleCells as? [SpaceCollectionViewCell] {
                        visibleCells.forEach { cell in
                            if let indexPath = owner.baseView.spaceCollectionView.indexPath(for: cell) {
                                
                                let cellItem = output.mySpaces.value[indexPath.item]
                                
                                cell.configureisCurrentSpaceCell(isCurrentSpace: cellItem.isCurrentSpace)
                            }
                        }
                    }
                    
                    owner.delegate?.updateHome(spaceID: UserDefaultsStorage.spaceId)
                }
            }
            .disposed(by: disposeBag)
        
        baseView.addWorkSpaceButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.presentSpaceActiveFlow(viewType: .create(nil))
            }
            .disposed(by: disposeBag)
    }
}

extension SideSpaceMenuViewController {
    private func showSpaceActionSheet(spaceSimpleInfo: SpaceSimpleInfo) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let leaveAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.leave.rawValue, style: .default, handler: { [weak self] _ in
            if UserDefaultsStorage.userId == spaceSimpleInfo.owner_id {
                self?.coordinator?.showAlertFlow(title: ActionSheetText.SpaceActionSheetText.leave.rawValue, subtitle: ActionSheetText.SpaceActionSheetText.leave.alertDescription, alertType: .oneButton)
            } else {
                print("스페이스 나가기 실행")
            }
        })
        
        let editAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.edit.rawValue, style: .default, handler: { [weak self] _ in
            self?.coordinator?.presentSpaceActiveFlow(viewType: .edit(spaceSimpleInfo))
        })
        
        let changeOwnerAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.changeOwner.rawValue, style: .default, handler: { [weak self] _ in
            self?.coordinator?.presentChangeSpaceOwnerViewFlow()
        })
        
        let deleteAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.delete.rawValue, style: .destructive, handler: { [weak self] _ in
            self?.coordinator?.showAlertFlow(title: ActionSheetText.SpaceActionSheetText.delete.rawValue, subtitle: ActionSheetText.SpaceActionSheetText.delete.alertDescription, alertType: .twoButton)
        })
        
        if spaceSimpleInfo.owner_id == UserDefaultsStorage.userId {
            actionSheet.addAction(editAction)
            actionSheet.addAction(leaveAction)
            actionSheet.addAction(changeOwnerAction)
            actionSheet.addAction(deleteAction)
        } else {
            actionSheet.addAction(leaveAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: ActionSheetText.SpaceActionSheetText.cancel.rawValue, style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SideSpaceMenuViewController: SpaceActiveViewDelegate {
    func actionComplete(spaceSimpleInfo: SpaceSimpleInfo) {
        space.accept(spaceSimpleInfo)
        if spaceSimpleInfo.isCurrentSpace {
            delegate?.updateSpace(spaceSimpleInfo: spaceSimpleInfo)
        }
    }
}
