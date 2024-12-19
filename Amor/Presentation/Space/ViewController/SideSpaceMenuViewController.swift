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
    func updateSpace()
    func updateHomeAndSpace()
}

final class SideSpaceMenuViewController: BaseVC<SideSpaceMenuView> {
    var coordinator: SideSpaceMenuCoordinator?
    var delegate: SideSpaceMenuDelegate?
    
    private let viewModel: SideSpaceMenuViewModel
    private let changedSpace = PublishRelay<SpaceSimpleInfo?>()
    private let exitSpaceId  = PublishRelay<String>()
    private let deleteSpaceId = PublishRelay<String>()
    private let trigger = BehaviorRelay<Void>(value: ())
    
    init(viewModel: SideSpaceMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func bind() {
        let input = SideSpaceMenuViewModel.Input(trigger: trigger, changedSpace: changedSpace, deleteSpaceId: deleteSpaceId, exitSpaceId: exitSpaceId)
        let output = viewModel.transform(input)
        
        output.showEmptyView
            .bind(with: self) { owner, show in
                owner.baseView.showEmptyView(show: show)
            }
            .disposed(by: disposeBag)
        
        output.mySpaces
            .bind(to: baseView.spaceCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell(item: item)
                
                cell.tapMoreButton()
                    .map { item }
                    .bind(with: self) { owner, value in
                        owner.showSpaceActionSheet(spaceSimpleInfo: value)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.configureisCurrentSpaceCell(isCurrentSpace: item.isCurrentSpace)
            }
            .disposed(by: disposeBag)
        
        baseView.spaceCollectionView.rx.modelSelected(SpaceSimpleInfo.self)
            .bind(with: self) { owner, value in
                if UserDefaultsStorage.spaceId != value.workspace_id {
                    UserDefaultsStorage.spaceId = value.workspace_id
                    owner.delegate?.updateHomeAndSpace()
                }
            }
            .disposed(by: disposeBag)
        
        baseView.addWorkSpaceButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.presentSpaceActiveFlow(viewType: .create(nil))
            }
            .disposed(by: disposeBag)
        
        baseView.spaceEmptyView.inviteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.presentSpaceActiveFlow(viewType: .create(nil))
            }
            .disposed(by: disposeBag)
        
        output.afterAction
            .bind(with: self) { owner, value in
                owner.delegate?.updateHomeAndSpace()
            }
            .disposed(by: disposeBag)
        
        output.isEmptyMySpace
            .bind(with: self) { owner, _ in
                owner.delegate?.updateHomeAndSpace()
            }
            .disposed(by: disposeBag)
    }
}

extension SideSpaceMenuViewController {
    private func showSpaceActionSheet(spaceSimpleInfo: SpaceSimpleInfo) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let exitAction = UIAlertAction(title: ActionSheetText.SpaceActionSheetText.exit.rawValue, style: .default, handler: { [weak self] _ in
            if UserDefaultsStorage.userId == spaceSimpleInfo.owner_id {
                self?.coordinator?.showIsSpaceOwnerAlertFlow()
            } else {
                self?.coordinator?.showExitAlertFlow {
                    self?.coordinator?.dismissSideSpaceMenuFlow()
                    self?.exitSpaceId.accept(spaceSimpleInfo.workspace_id)
                }
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
                self?.coordinator?.dismissSideSpaceMenuFlow()
                self?.deleteSpaceId.accept(spaceSimpleInfo.workspace_id)
            }
        })
        
        if spaceSimpleInfo.owner_id == UserDefaultsStorage.userId {
            actionSheet.addAction(editAction)
            actionSheet.addAction(exitAction)
            actionSheet.addAction(changeOwnerAction)
            actionSheet.addAction(deleteAction)
        } else {
            actionSheet.addAction(exitAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: ActionSheetText.SpaceActionSheetText.cancel.rawValue, style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SideSpaceMenuViewController: SpaceActiveViewDelegate {
    func createComplete() {
        trigger.accept(())
        delegate?.updateHomeAndSpace()
    }
}

extension SideSpaceMenuViewController: ChangeSpaceOwnerDelegate {
    func changeOwnerCompleteAction() {
        trigger.accept(())
        delegate?.updateSpace()
    }
}
