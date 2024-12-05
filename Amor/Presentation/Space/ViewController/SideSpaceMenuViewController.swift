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
                cell.configureCell(spaceSimpleInfo: item)
                
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
                owner.presentSpaceActiveFlow(viewType: .create(nil))
            }
            .disposed(by: disposeBag)
    }
}

extension SideSpaceMenuViewController {
    private func showSpaceActionSheet(spaceSimpleInfo: SpaceSimpleInfo) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let leaveAction = UIAlertAction(title: SpaceActionSheetText.leave.rawValue, style: .default, handler: { [weak self] _ in
            if UserDefaultsStorage.userId == spaceSimpleInfo.owner_id {
                self?.showAlert(title: SpaceActionSheetText.leave.rawValue, subtitle: SpaceActionSheetText.leave.alertDescription, alertType: .oneButton)
            } else {
                print("스페이스 나가기 실행")
            }
        })
        
        let editAction = UIAlertAction(title: SpaceActionSheetText.edit.rawValue, style: .default, handler: { [weak self] _ in
            self?.presentSpaceActiveFlow(viewType: .edit(spaceSimpleInfo))
        })
        
        let changeOwnerAction = UIAlertAction(title: SpaceActionSheetText.changeOwner.rawValue, style: .default, handler: { [weak self] _ in
            print("스페이스 관리자 변경")
        })
        
        let deleteAction = UIAlertAction(title: SpaceActionSheetText.delete.rawValue, style: .destructive, handler: { [weak self] _ in
            self?.showAlert(title: SpaceActionSheetText.delete.rawValue, subtitle: SpaceActionSheetText.delete.alertDescription, alertType: .twoButton)
        })
        
        if spaceSimpleInfo.owner_id == UserDefaultsStorage.userId {
            actionSheet.addAction(editAction)
            actionSheet.addAction(leaveAction)
            actionSheet.addAction(changeOwnerAction)
            actionSheet.addAction(deleteAction)
        } else {
            actionSheet.addAction(leaveAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: SpaceActionSheetText.cancel.rawValue, style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SideSpaceMenuViewController {
    func showAlert(title: String, subtitle: String, alertType: CustomAlert.AlertType) {
        let alertVC = CustomAlertController(
            title: title,
            subtitle: subtitle,
            confirmHandler: {},
            cancelHandler: {},
            alertType: alertType
        )
        present(alertVC, animated: true)
    }
    
    func presentSpaceActiveFlow(viewType: SpaceActiveViewType) {
        let vc: SpaceActiveViewController = DIContainer.shared.resolve(arg: viewType)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
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
