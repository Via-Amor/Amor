//
//  SideSpaceMenuViewController.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SideSpaceMenuDelegate {
    func updateSpace(spaceSimpleInfo: SpaceSimpleInfo)
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
                
                UserDefaultsStorage.spaceId = value.workspace_id
                
                if let visibleCells = owner.baseView.spaceCollectionView.visibleCells as? [SpaceCollectionViewCell] {
                    visibleCells.forEach { cell in
                        if let indexPath = owner.baseView.spaceCollectionView.indexPath(for: cell) {
                            if let cellItem = try? output.mySpaces.value()[indexPath.item] {
                                cell.configureisCurrentSpaceCell(isCurrentSpace: cellItem.isCurrentSpace)
                            }
                        }
                    }
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
        
        let leaveAction = UIAlertAction(title: "스페이스 나가기", style: .default, handler: { [weak self] _ in
            self?.showAlert(title: "스페이스 나가기", subtitle: "회원님은 워크스페이스 관리자입니다. 스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.", toastType: .oneButton, confirmButtonText: "확인")
        })
        
        let editAction = UIAlertAction(title: "스페이스 편집", style: .default, handler: { [weak self] _ in
            self?.presentSpaceActiveFlow(viewType: .edit(spaceSimpleInfo))
        })
        
        let changeOwnerAction = UIAlertAction(title: "스페이스 관리자 변경", style: .default, handler: { [weak self] _ in

        })
        
        let deleteAction = UIAlertAction(title: "스페이스 삭제", style: .destructive, handler: { [weak self] _ in
            self?.showAlert(title: "스페이스 삭제", subtitle: "정말 이 스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", toastType: .twoButton, confirmButtonText: "확인")
        })
        
        if spaceSimpleInfo.owner_id == UserDefaultsStorage.userId {
            actionSheet.addAction(editAction)
            actionSheet.addAction(leaveAction)
            actionSheet.addAction(changeOwnerAction)
            actionSheet.addAction(deleteAction)
        } else {
            actionSheet.addAction(leaveAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SideSpaceMenuViewController {
    func showAlert(title: String, subtitle: String, toastType: CustomAlert.ToastType, confirmButtonText: String) {
        let alertVC = CustomAlertController(title: title, subtitle: subtitle, toastType: toastType, confirmButtonText: confirmButtonText)
        
        present(alertVC, animated: true)
    }
    
    func presentSpaceActiveFlow(viewType: SpaceActiveViewType) {
        let vc = SpaceActiveViewController(viewModel: SpaceActiveViewModel(viewType: viewType, useCase: DefaultHomeUseCase(channelRepository: DefaultChannelRepository(), spaceRepository: DefaultSpaceRepository(), dmRepository: DefaultDMRepository())))
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}

extension SideSpaceMenuViewController: SpaceActiveViewDelegate {
    func actionComplete(spaceSimpleInfo: SpaceSimpleInfo) {
        space.accept(spaceSimpleInfo)
        switch spaceSimpleInfo.isCurrentSpace {
        case true:
            delegate?.updateSpace(spaceSimpleInfo: spaceSimpleInfo)
        case false:
            break
        }
    }
}
