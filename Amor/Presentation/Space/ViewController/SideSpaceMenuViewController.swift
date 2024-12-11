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
    var delegate: SideSpaceMenuDelegate?
    
    private let viewModel: SideSpaceMenuViewModel
    private let changedSpace = PublishRelay<SpaceSimpleInfo?>()
    private let deleteSpaceId = PublishRelay<String>()
    private let trigger = BehaviorSubject<Void>(value: ())
    
    init(viewModel: SideSpaceMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func bind() {
        let input = SideSpaceMenuViewModel.Input(trigger: trigger, changedSpace: changedSpace, deleteSpaceId: deleteSpaceId)
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
        
        output.afterDeleteAction
            .bind(with: self) { owner, value in
                owner.delegate?.updateHome(spaceID: UserDefaultsStorage.spaceId)
            }
            .disposed(by: disposeBag)
    }
}

extension SideSpaceMenuViewController {
    private func showSpaceActionSheet(spaceSimpleInfo: SpaceSimpleInfo) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let leaveAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.leave.rawValue, style: .default, handler: { [weak self] _ in
            if UserDefaultsStorage.userId == spaceSimpleInfo.owner_id {
                self?.coordinator?.showLeaveAlertFlow {
                    
                }
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
            self?.coordinator?.showDeleteAlertFlow {
                self?.deleteSpaceId.accept(spaceSimpleInfo.workspace_id)
            }
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
        changedSpace.accept(spaceSimpleInfo)
        if spaceSimpleInfo.isCurrentSpace {
            delegate?.updateSpace(spaceSimpleInfo: spaceSimpleInfo)
        }
    }
}

extension SideSpaceMenuViewController: ChangeSpaceOwnerDelegate {
    func changeOwnerCompleteAction(spaceSimpleInfo: SpaceSimpleInfo) {
        actionComplete(spaceSimpleInfo: spaceSimpleInfo)
        trigger.onNext(())
    }
}
